function Get-NewCert-Func {
    $store = New-Object System.Security.Cryptography.X509Certificates.X509Store -ArgumentList "My", "LocalMachine"
    $store.Open("ReadOnly")
    $newCert = $store.Certificates | Where-Object {($_.Subject -eq "CN=$subjectName") -and ($_.SignatureAlgorithm.FriendlyName -eq "sha256RSA")} | Select-Object -First 1
    $store.Close()
    return $newCert
}

function Remove-OldCert-Func {
    $storeNames = @("My","CA")
    foreach ($storeName in $storeNames) {
        $store = New-Object System.Security.Cryptography.X509Certificates.X509Store -ArgumentList $storeName, "LocalMachine"
        $store.Open("ReadWrite")
        $oldCerts = $store.Certificates | Where-Object {$_.Subject -eq "CN=$subjectName"}
        foreach ($oldCert in $oldCerts) {
            $store.Remove($oldCert)
        }
        $store.Close()
    }
}

function New-SHA2Cert-Func {
    $name = New-Object -ComObject "X509Enrollment.CX500DistinguishedName.1"
    $name.Encode("CN=$subjectName", 0)
    $key = New-Object -ComObject "X509Enrollment.CX509PrivateKey.1"
    $key.ProviderName = "Microsoft Enhanced RSA and AES Cryptographic Provider"
    $key.KeySpec = 1
    $key.Length = 2048
    $key.MachineContext = 1
    $key.ExportPolicy = 1
    $key.Create()
    $ekuoids = New-Object -ComObject "X509Enrollment.CObjectIds.1"
    $serverauthoid = New-Object -ComObject "X509Enrollment.CObjectId.1"
    $serverauthoid.InitializeFromValue("1.3.6.1.5.5.7.3.1")
    $ekuoids.Add($serverauthoid)
    $ekuext = New-Object -ComObject "X509Enrollment.CX509ExtensionEnhancedKeyUsage.1"
    $ekuext.InitializeEncode($ekuoids)
    $cert = New-Object -ComObject "X509Enrollment.CX509CertificateRequestCertificate.1"
    $cert.InitializeFromPrivateKey(2, $key, "")
    $cert.Subject = $name
    $cert.Issuer = $cert.Subject
    $cert.NotBefore = Get-Date
    $cert.NotAfter = $cert.NotBefore.AddYears(10)
    $sigOID = New-Object -ComObject X509Enrollment.CObjectId
    $sigOID.InitializeFromValue(([Security.Cryptography.Oid]$algorithm).Value)
    [string[]] $alternativeName += $hostName
    $alternativeName += $hostFQDN
    $iAlternativeNames = New-Object -ComObject X509Enrollment.CAlternativeNames
    foreach ($aName in $alternativeName) {
        $altName = New-Object -ComObject X509Enrollment.CAlternativeName
        $altName.InitializeFromString(0x3,$aName)
        $iAlternativeNames.Add($altName)
    }
    $subjectAlternativeName = New-Object -ComObject X509Enrollment.CX509ExtensionAlternativeNames
    $subjectAlternativeName.InitializeEncode($iAlternativeNames)
    [String[]]$keyUsage = ("DataEncipherment", "KeyEncipherment")
    $keyUsageObj = New-Object -ComObject X509Enrollment.CX509ExtensionKeyUsage
    $keyUsageObj.InitializeEncode([int][Security.Cryptography.X509Certificates.X509KeyUsageFlags]($keyUsage))
    $keyUsageObj.Critical = $false
    $cert.X509Extensions.Add($keyUsageObj)
    $cert.X509Extensions.Add($ekuEXT)
    $cert.SignatureInformation.HashAlgorithm = $sigOID
    $cert.X509Extensions.Add($subjectAlternativeName)
    $cert.Encode()
    $enrollment = New-Object -ComObject "X509Enrollment.CX509Enrollment.1"
    $enrollment.InitializeFromRequest($cert)
    $certdata = $enrollment.CreateRequest(0)
    $enrollment.InstallResponse(2, $certdata, 0, "")
}

$hostName = $env:COMPUTERNAME
$os = Get-WmiObject -Class Win32_OperatingSystem
$caption = ($os.Caption).Replace(",", "").Replace("(R)", "").Replace("Microsoft ", "").Replace(" Edition", "").Replace("Datacenter", "DC").Replace("Standard", "Std").Replace("Enterprise", "Ent").Replace("without", "w/o").Replace("Windows ", "Win ").Replace("Server ", "Srv ").Trim()
$version = [version]$os.Version

if (-not (($version.Major -eq 6) -and ($version.Minor -eq 0))) {
    $hostFQDN = [System.Net.Dns]::GetHostByName(($hostName)).Hostname
    $subjectName = "$hostName WinRM-SSL"
    $algorithm = "SHA256"
    Remove-OldCert-Func
    New-SHA2Cert-Func
    $newCert = Get-NewCert-Func
    if ($newCert) {
        $rdpStore = "Personal"
        Enable-PSRemoting -Force
        & winrm delete winrm/config/Listener?Address=*+Transport=HTTPS
        New-Item -Path WSMan:\localhost\Listener -Transport HTTPS -Address * -CertificateThumbPrint ($newCert.Thumbprint) -Force
        Restart-Service -Name WinRM -Force
        $listeners = & winrm enumerate winrm/config/listener
        if ($listeners -match "CertificateThumbprint = $($newCert.Thumbprint)") {
            $result = "Success"
        } else {
            $result = "Failure (Could not bind new cert to WinRM)"
        }
    } else {
        $result = "Failure (Could not create new cert)"
    }
} else {
    $result = "Skipped (OS not supported)"
}

$output = "" | Select-Object `
@{n="Server";e={$hostName}}, 
@{n="Operating System";e={$caption}}, 
@{n="Result";e={$result}}, 
@{n="Store";e={$rdpStore}}, 
@{n="Common Name";e={$newCert.Subject -replace "CN=", ""}}, 
@{n="Issuer";e={$newCert.Issuer -replace "CN=", ""}}, 
@{n="Thumbprint";e={($newCert.Thumbprint).ToUpper() -replace """", ""}}, 
@{n="Creation";e={$newCert.NotBefore | Get-Date -Format "yyyy-MM-dd"}}, 
@{n="Expiration";e={$newCert.NotAfter | Get-Date -Format "yyyy-MM-dd"}}, 
@{n="Private Key";e={$newCert.HasPrivateKey}}, 
@{n="Algorithm";e={$newCert.SignatureAlgorithm.FriendlyName}}

