# 블록 저장 장치. `encrypted` 를 보십시오.
#
# 만든 시기가 제각각입니다. 2022년에 만든 것은 그때 기본값이
# 꺼짐이었고, 이후에 만든 것은 켜짐입니다. 사후에 켜려면 복제본을
# 만들어 갈아 끼워야 해서 미뤄져 있습니다.

resource "block_volume" "vol_web_01" {
  name       = "vol-web-01"
  size       = 100
  type       = "gp3"
  붙은_서버   = "web-01"
  encrypted  = true
  kms_key    = "key-infra-2025"
  만든_날     = "2025-03-11"
  스냅샷_주기 = "일"
  tags = { 환경 = "production" 담당 = "인프라팀" }
}

resource "block_volume" "vol_web_02" {
  name       = "vol-web-02"
  size       = 100
  type       = "gp3"
  붙은_서버   = "web-02"
  encrypted  = true
  kms_key    = "key-infra-2025"
  만든_날     = "2025-03-11"
  스냅샷_주기 = "일"
  tags = { 환경 = "production" 담당 = "인프라팀" }
}

resource "block_volume" "vol_app_01" {
  name       = "vol-app-01"
  size       = 200
  type       = "gp3"
  붙은_서버   = "app-01"
  encrypted  = true
  kms_key    = "key-infra-2025"
  만든_날     = "2025-03-11"
  스냅샷_주기 = "일"
  tags = { 환경 = "production" 담당 = "인프라팀" }
}

resource "block_volume" "vol_db_01" {
  name       = "vol-db-01"
  size       = 500
  type       = "gp3"
  붙은_서버   = "db-main"
  encrypted  = true
  kms_key    = "key-db-2025"
  만든_날     = "2025-03-11"
  스냅샷_주기 = "일"
  tags = { 환경 = "production" 담당 = "인프라팀" }
}

resource "block_volume" "vol_batch_01" {
  name       = "vol-batch-01"
  size       = 100
  type       = "gp2"
  붙은_서버   = "batch-01"
  encrypted  = true
  kms_key    = "key-infra-2025"
  만든_날     = "2024-01-08"
  스냅샷_주기 = "주"
  tags = { 환경 = "production" 담당 = "" }
}

# 2022년에 만든 것. 그때는 기본값이 꺼짐이었습니다.
resource "block_volume" "vol_legacy_01" {
  name       = "vol-legacy-01"
  size       = 250
  type       = "gp2"
  붙은_서버   = "admin-01"
  encrypted  = false
  kms_key    = null
  만든_날     = "2022-06-20"
  스냅샷_주기 = "없음"
  tags = { 환경 = "production" 담당 = "" }
}
