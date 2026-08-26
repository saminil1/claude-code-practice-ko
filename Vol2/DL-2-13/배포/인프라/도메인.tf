# DNS 레코드. 영역 이름은 예시용 도메인입니다.

resource "dns_zone" "main" {
  name    = "example.co.kr"
  comment = "사내업무시스템"
}

resource "dns_record" "www" {
  zone  = "example.co.kr"
  name  = "www"
  type  = "A"
  value = "lb-web"
  ttl   = 300
}

resource "dns_record" "api" {
  zone  = "example.co.kr"
  name  = "api"
  type  = "A"
  value = "lb-web"
  ttl   = 300
}

resource "dns_record" "assets" {
  zone  = "example.co.kr"
  name  = "assets"
  type  = "CNAME"
  value = "assets-public"
  ttl   = 3600
}

resource "dns_record" "mail_spf" {
  zone  = "example.co.kr"
  name  = "@"
  type  = "TXT"
  value = "v=spf1 include:_spf.mailer.example.net ~all"
  ttl   = 3600
}

# 2023년에 내린 서버입니다. 레코드가 남아 있습니다.
# 같은 주소가 인프라/네트워크.tf 의 sg-db 규칙에도 남아 있습니다.
resource "dns_record" "batch" {
  zone  = "example.co.kr"
  name  = "batch"
  type  = "A"
  value = "203.0.113.47"
  ttl   = 3600
}
