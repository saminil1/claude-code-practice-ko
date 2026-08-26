# 객체 저장소. 내보낸 시각 기준 정의 그대로.

resource "object_bucket" "assets_public" {
  name          = "assets-public"
  public_read   = true            # 웹 자산 배포용
  encryption    = "AES256"
  versioning    = false
  access_log    = "logs-archive"

  cors {
    allowed_origins = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_headers = ["*"]
    max_age_seconds = 3600
  }

  lifecycle_rule {
    id      = "오래된-이미지-정리"
    prefix  = "img/tmp/"
    enabled = true
    expiration_days = 30
  }

  tags = {
    환경 = "production"
    용도 = "웹자산"
    담당 = "인프라팀"
    비용센터 = "CC-3100"
  }
}

resource "object_bucket" "backup_temp" {
  name          = "backup-temp"
  public_read   = true            # 2024년 이관 작업 때 열어 둠
  encryption    = "AES256"
  versioning    = false
  access_log    = null

  # 이관 업체가 파일을 받아 가야 해서 열었습니다. 작업은 2024-07 에
  # 끝났습니다. 닫는 일은 아직 남아 있습니다.
  cors {
    allowed_origins = ["*"]
    allowed_methods = ["GET"]
    allowed_headers = ["*"]
    max_age_seconds = 300
  }

  lifecycle_rule {
    id      = "덤프-보관"
    prefix  = "db/"
    enabled = true
    expiration_days = 30
  }

  tags = {
    환경 = "production"
    용도 = "임시"
    담당 = ""
    비용센터 = "CC-3100"
  }
}

resource "object_bucket" "app_data" {
  name          = "app-data"
  public_read   = false
  encryption    = "KMS"
  kms_key       = "key-app-2025"
  versioning    = true
  access_log    = "logs-archive"

  lifecycle_rule {
    id      = "이전판-정리"
    prefix  = ""
    enabled = true
    noncurrent_version_expiration_days = 90
  }

  tags = {
    환경 = "production"
    용도 = "응용자료"
    담당 = "인프라팀"
    비용센터 = "CC-3100"
  }
}

resource "object_bucket" "logs_archive" {
  name          = "logs-archive"
  public_read   = false
  encryption    = "AES256"
  versioning    = true
  access_log    = null            # 로그 저장소 자신의 접근 로그는 두지 않음

  lifecycle_rule {
    id      = "장기보관-이관"
    prefix  = ""
    enabled = true
    transition_days  = 90
    transition_class = "GLACIER"
    expiration_days  = 730
  }

  tags = {
    환경 = "production"
    용도 = "로그"
    담당 = "인프라팀"
    비용센터 = "CC-3100"
  }
}

resource "object_bucket" "reports_internal" {
  name          = "reports-internal"
  public_read   = false
  encryption    = "AES256"
  versioning    = false
  access_log    = "logs-archive"

  lifecycle_rule {
    id      = "보고서-보관"
    prefix  = "monthly/"
    enabled = true
    expiration_days = 1095
  }

  tags = {
    환경 = "production"
    용도 = "보고서"
    담당 = "경영지원팀"
    비용센터 = "CC-2100"
  }
}
