# 관계형 데이터베이스. 운영 한 대와 보고서 전용 한 대.

resource "db_subnet_group" "main" {
  name    = "dbsub-main"
  subnets = ["private_a", "private_b"]
}

resource "db_parameter_group" "postgres15" {
  name   = "pg15-사내표준"
  engine = "postgres15"

  parameter { name = "max_connections"             value = "300"  }
  parameter { name = "shared_buffers"              value = "4GB"  }
  parameter { name = "work_mem"                    value = "16MB" }
  parameter { name = "maintenance_work_mem"        value = "512MB" }
  parameter { name = "effective_cache_size"        value = "12GB" }
  parameter { name = "log_min_duration_statement"  value = "2000" }
  parameter { name = "log_connections"             value = "off"  }
  parameter { name = "log_disconnections"          value = "off"  }
  parameter { name = "timezone"                    value = "Asia/Seoul" }
  parameter { name = "lc_messages"                 value = "ko_KR.UTF-8" }
}

resource "db_instance" "main" {
  name              = "db-main"
  engine            = "postgres"
  version           = "15.4"
  class             = "db.m6g.large"
  storage_gb        = 500
  storage_type      = "gp3"
  storage_encrypted = true
  kms_key           = "key-db-2025"
  multi_az          = true
  backup_retention  = 7
  backup_window     = "17:00-18:00"     # UTC. 한국 시각 새벽 2시.
  maintenance_window = "sun:19:00-sun:20:00"
  public_access     = false
  subnet_group      = "dbsub-main"
  groups            = ["sg-db"]
  parameter_group   = "pg15-사내표준"

  # 감사 로그를 켜면 저장 비용이 늘어 2024년에 껐습니다.
  # 다시 켜자는 이야기는 나왔지만 정해진 것은 없습니다.
  audit_log         = false
  느린질의_로그     = true
  성능_통계         = true
  자동_소버전_올림   = false

  tags = { 환경 = "production" 역할 = "주DB" 담당 = "인프라팀" 비용센터 = "CC-3100" }
}

resource "db_instance" "report" {
  name              = "db-report"
  engine            = "postgres"
  version           = "15.4"
  class             = "db.m6g.large"
  storage_gb        = 500
  storage_type      = "gp3"
  storage_encrypted = true
  kms_key           = "key-db-2025"
  multi_az          = false
  backup_retention  = 1
  backup_window     = "18:00-19:00"
  maintenance_window = "sun:20:00-sun:21:00"
  public_access     = false
  subnet_group      = "dbsub-main"
  groups            = ["sg-db"]
  parameter_group   = "pg15-사내표준"
  복제원본          = "db-main"
  audit_log         = false
  느린질의_로그     = true
  성능_통계         = false
  자동_소버전_올림   = false

  tags = { 환경 = "production" 역할 = "보고서" 담당 = "인프라팀" 비용센터 = "CC-2100" }
}
