{{/* generate valid identifier from file path  */}}
{{- define "name.from.path" }}{{ regexReplaceAll "[_.]" (base .) "" | lower }}{{- end }}

{{/* dynamically configure volumes based on file resources  */}}
{{- define "dynamic.volumes" }}
      # ===================================================================
      # dynamically configured volumes for generated configMaps and secrets
{{- range $path, $_ :=  .Files.Glob  "{config/**,DPSApp/**,resources/**,DSApp/**,lowers-override/**}" }}
  {{- if contains "category" $path }}
      # category files excluded: {{ $path }}
  {{- else if or (contains "protection" $path) (contains "VibesimplejavaLinux" $path) }}
      #{{ $path }} : secret
      - name: {{ include "name.from.path" $path }}
        secret:
          secretName: {{ $.Values.name }}-{{ include "name.from.path" $path }}-secret
  {{- else }}
      #{{ $path }} : configMap
      - name: {{ include "name.from.path" $path }}
        configMap:
          name: {{ $.Values.name }}-{{ include "name.from.path" $path }}-cm
  {{- end }}
{{- end }}
{{- end }}

{{/* dynamically configure volume mounts based on file resources  */}}
{{- define "dynamic.mounts" }}
        #===================================================================
        # dynamically configured mounts for generated configMaps and secrets
{{- if eq true .Values.mqm.deploy }}
        # mount mqm generated bindings from nfs share
        - name: gatewaydir
          mountPath: "/u01/oracle/shared/resources/mqm/bindings/queue/.bindings"
          subPath: {{.Values.nfsGatewaySubPath}}/mqm/{{.Values.appType}}/queue/.bindings
        - name: gatewaydir
          mountPath: "/u01/oracle/shared/resources/mqm/bindings/connfactory/.bindings"
          subPath: {{.Values.nfsGatewaySubPath}}/mqm/{{.Values.appType}}/qcf/.bindings
{{- end }}
{{- range $path, $_ :=  .Files.Glob  "{config/**,DPSApp/**,resources/**,lowers-override/**}" }}
  {{- if contains "category" $path }}
# category files excluded: {{ $path }}
  {{- else if and (eq $.Values.mqm.deploy true) (contains "bindings" $path) }}
# mq bindings excluded because mqm deploy is true: {{ $path }}
  {{- else }}
        #{{ $path }}
        - name: {{ include "name.from.path" $path }}
          mountPath: "/u01/oracle/shared/{{ $path }}"
          subPath: {{ base $path }}
  {{- end }}
{{- end }}
{{- end }}