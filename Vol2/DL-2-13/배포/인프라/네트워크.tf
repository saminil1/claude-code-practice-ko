# 가상 네트워크 · 서브넷 · 경로 · 보안 그룹

resource "vpc" "main" {
  cidr       = "10.0.0.0/16"
  dns_support = true
  tags = { 환경 = "production" 담당 = "인프라팀" }
}

resource "subnet" "public_a" {
  vpc  = "main"
  cidr = "10.0.0.0/24"
  zone = "ap-northeast-2a"
  public_ip_on_launch = true
}

resource "subnet" "public_b" {
  vpc  = "main"
  cidr = "10.0.2.0/24"
  zone = "ap-northeast-2c"
  public_ip_on_launch = true
}

resource "subnet" "private_a" {
  vpc  = "main"
  cidr = "10.0.1.0/24"
  zone = "ap-northeast-2a"
  public_ip_on_launch = false
}

resource "subnet" "private_b" {
  vpc  = "main"
  cidr = "10.0.3.0/24"
  zone = "ap-northeast-2c"
  public_ip_on_launch = false
}

resource "route_table" "public" {
  vpc = "main"
  route { destination = "0.0.0.0/0" target = "igw-main" }
  subnets = ["public_a", "public_b"]
}

resource "route_table" "private" {
  vpc = "main"
  route { destination = "0.0.0.0/0" target = "nat-a" }
  subnets = ["private_a", "private_b"]
}

# ── 보안 그룹 ────────────────────────────────────────────────
# 관리 접속용. 22번이 전체 개방입니다. 재택 근무를 시작하면서
# 2020년에 임시로 열었고 그대로입니다.
resource "security_group" "sg_admin" {
  name        = "sg-admin"
  description = "관리 접속"
  vpc         = "main"
  ingress { port = 22   protocol = "tcp" cidr = "0.0.0.0/0"    설명 = "SSH" }
  ingress { port = 3389 protocol = "tcp" cidr = "10.0.0.0/16"  설명 = "원격 데스크톱(내부)" }
  ingress { port = 9100 protocol = "tcp" cidr = "10.0.1.0/24"  설명 = "지표 수집" }
  egress  { port = 0    protocol = "-1"  cidr = "0.0.0.0/0"    설명 = "전체 허용" }
  tags = { 환경 = "production" 담당 = "인프라팀" }
}

resource "security_group" "sg_web" {
  name        = "sg-web"
  description = "공개 웹"
  vpc         = "main"
  ingress { port = 80  protocol = "tcp" cidr = "0.0.0.0/0"   설명 = "HTTP" }
  ingress { port = 443 protocol = "tcp" cidr = "0.0.0.0/0"   설명 = "HTTPS" }
  ingress { port = 8080 protocol = "tcp" cidr = "10.0.0.0/16" 설명 = "내부 헬스체크" }
  egress  { port = 0   protocol = "-1"  cidr = "0.0.0.0/0"   설명 = "전체 허용" }
  tags = { 환경 = "production" 담당 = "인프라팀" }
}

resource "security_group" "sg_db" {
  name        = "sg-db"
  description = "데이터베이스"
  vpc         = "main"
  ingress { port = 5432 protocol = "tcp" cidr = "10.0.1.0/24"     설명 = "응용 서버" }
  ingress { port = 5432 protocol = "tcp" cidr = "10.0.3.0/24"     설명 = "응용 서버(B)" }
  # 2023년까지 쓰던 배치 서버. 옮겼는데 규칙이 남아 있습니다.
  ingress { port = 5432 protocol = "tcp" cidr = "203.0.113.47/32" 설명 = "옛 배치 서버" }
  egress  { port = 0    protocol = "-1"  cidr = "10.0.0.0/16"     설명 = "내부만" }
  tags = { 환경 = "production" 담당 = "인프라팀" }
}

resource "security_group" "sg_cache" {
  name        = "sg-cache"
  description = "캐시"
  vpc         = "main"
  ingress { port = 6379 protocol = "tcp" cidr = "10.0.1.0/24" 설명 = "응용 서버" }
  ingress { port = 6379 protocol = "tcp" cidr = "10.0.3.0/24" 설명 = "응용 서버(B)" }
  egress  { port = 0    protocol = "-1"  cidr = "10.0.0.0/16" 설명 = "내부만" }
  tags = { 환경 = "production" 담당 = "인프라팀" }
}

resource "network_acl" "public" {
  vpc     = "main"
  subnets = ["public_a", "public_b"]
  rule { 번호 = 100 방향 = "in"  동작 = "allow" cidr = "0.0.0.0/0" 포트 = "80,443" }
  rule { 번호 = 200 방향 = "in"  동작 = "allow" cidr = "0.0.0.0/0" 포트 = "1024-65535" }
  rule { 번호 = 100 방향 = "out" 동작 = "allow" cidr = "0.0.0.0/0" 포트 = "전체" }
}
