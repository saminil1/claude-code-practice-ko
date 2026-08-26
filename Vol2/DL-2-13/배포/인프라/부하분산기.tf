resource "load_balancer" "web" {
  name        = "lb-web"
  scheme      = "internet-facing"
  subnets     = ["public_a", "public_b"]
  groups      = ["sg-web"]
  idle_timeout = 60
  http2       = true

  listener {
    port     = 80
    protocol = "HTTP"
    동작      = "redirect"
    대상      = "https://#{host}#{path}"
    코드      = 301
  }

  listener {
    port     = 443
    protocol = "HTTPS"
    cert     = "cert-wildcard-2026"
    정책      = "TLS-1-2-2021"       # TLS 1.0/1.1 은 받지 않습니다.
    동작      = "forward"
    대상      = "tg-web"
  }

  # 접근 로그를 켜면 logs-archive 로 갑니다. 지금은 꺼져 있습니다.
  # 켜는 일이 지난 점검에서도 지적되었습니다(점검/이전점검결과.md).
  access_log  = false
  access_log_bucket = "logs-archive"
}

resource "target_group" "web" {
  name      = "tg-web"
  port      = 8080
  protocol  = "HTTP"
  대상       = ["web-01", "web-02"]
  상태확인 {
    경로     = "/healthz"
    주기_초   = 15
    시간초과_초 = 5
    정상_기준  = 2
    비정상_기준 = 3
    응답코드   = "200"
  }
  연결고정 {
    사용     = true
    유지_초   = 3600
  }
}
