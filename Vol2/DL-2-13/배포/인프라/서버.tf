resource "compute_instance" "web_01" {
  name        = "web-01"
  type        = "t3.medium"
  image       = "ubuntu-24.04-base-2026-03"
  subnet      = "subnet-public-a"
  groups      = ["sg-web"]
  key_name    = "key-infra-2025"
  monitoring  = true
  root_volume { name = "vol-web-01" size = 100 encrypted = true }
  tags = { 환경 = "production" 역할 = "웹" 담당 = "인프라팀" 비용센터 = "CC-3100" }
}

resource "compute_instance" "web_02" {
  name        = "web-02"
  type        = "t3.medium"
  image       = "ubuntu-24.04-base-2026-03"
  subnet      = "subnet-public-b"
  groups      = ["sg-web"]
  key_name    = "key-infra-2025"
  monitoring  = true
  root_volume { name = "vol-web-02" size = 100 encrypted = true }
  tags = { 환경 = "production" 역할 = "웹" 담당 = "인프라팀" 비용센터 = "CC-3100" }
}

resource "compute_instance" "app_01" {
  name        = "app-01"
  type        = "t3.large"
  image       = "ubuntu-24.04-base-2026-03"
  subnet      = "subnet-private-a"
  groups      = ["sg-web", "sg-cache"]
  key_name    = "key-infra-2025"
  monitoring  = true
  root_volume { name = "vol-app-01" size = 200 encrypted = true }
  tags = { 환경 = "production" 역할 = "응용" 담당 = "인프라팀" 비용센터 = "CC-3100" }
}

resource "compute_instance" "batch_01" {
  name        = "batch-01"
  type        = "t3.small"
  image       = "ubuntu-22.04-base-2023-05"     # 이미지가 옛것입니다
  subnet      = "subnet-private-a"
  groups      = ["sg-admin", "sg-db"]
  key_name    = "key-infra-2022"
  monitoring  = false
  root_volume { name = "vol-batch-01" size = 100 encrypted = true }
  # 예전 배치 서버 203.0.113.47 을 대신합니다.
  # 그 주소가 sg-db 와 도메인.tf 에 아직 남아 있습니다.
  tags = { 환경 = "production" 역할 = "배치" 담당 = "" 비용센터 = "" }
}

resource "compute_instance" "admin_01" {
  name        = "admin-01"
  type        = "t3.micro"
  image       = "ubuntu-22.04-base-2023-05"
  subnet      = "subnet-public-a"
  groups      = ["sg-admin"]
  key_name    = "key-infra-2022"
  monitoring  = false
  root_volume { name = "vol-legacy-01" size = 250 encrypted = false }
  tags = { 환경 = "production" 역할 = "관리" 담당 = "" 비용센터 = "" }
}

resource "auto_scaling_group" "web" {
  name      = "asg-web"
  최소      = 2
  최대      = 6
  희망      = 2
  대상      = ["web-01", "web-02"]
  상태확인   = "ELB"
  유예_초    = 120
}
