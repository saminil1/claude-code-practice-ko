# 인프라 정의가 함께 쓰는 값.

variable "region"         { default = "ap-northeast-2" }
variable "environment"    { default = "production" }
variable "owner_team"     { default = "인프라팀" }
variable "cost_center"    { default = "CC-3100" }
variable "retention_days" { default = 30 }

variable "web_instance_type"  { default = "t3.medium" }
variable "app_instance_type"  { default = "t3.large" }
variable "db_instance_class"  { default = "db.m6g.large" }

variable "backup_bucket"  { default = "backup-temp" }   # 백업/백업정책.yml 과 같은 값
variable "log_bucket"     { default = "logs-archive" }
variable "asset_bucket"   { default = "assets-public" }

variable "admin_cidr" {
  default     = "0.0.0.0/0"
  description = "관리 접속을 허용할 대역. 좁히자는 이야기가 2020년부터 있습니다."
}

variable "표준_태그" {
  default = {
    환경     = "production"
    담당     = "인프라팀"
    비용센터  = "CC-3100"
  }
}
