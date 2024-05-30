terraform {
  cloud {
    hostname     = "jlqpztfe01.onefiserv.net"
    organization = "fiserv-main"

    workspaces {
      name = "ocg_sql_iac_lowers"
    }
  }
}