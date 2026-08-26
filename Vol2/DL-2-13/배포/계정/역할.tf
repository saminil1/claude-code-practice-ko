# 역할과 그 역할을 맡을 수 있는 계정.

resource "iam_role" "deploy" {
  name     = "role-deploy"
  설명      = "배포 파이프라인이 쓰는 역할"
  policies = ["정책_관리자.json"]
  trusted  = ["svc-deploy"]
  최대세션_시간 = 3600
  # 배포에 필요한 권한만 주자는 이야기가 있었으나, 무엇이 필요한지
  # 추리는 일이 오래 걸려 관리자 정책을 그대로 붙였습니다.
}

resource "iam_role" "readonly" {
  name     = "role-readonly"
  설명      = "보고서·감시 도구용"
  policies = ["정책_읽기.json"]
  trusted  = ["acct-noh", "acct-bae", "svc-monitor"]
  최대세션_시간 = 3600
}

resource "iam_role" "backup" {
  name     = "role-backup"
  설명      = "백업 작업"
  policies = ["정책_관리자.json"]
  trusted  = ["svc-backup"]
  최대세션_시간 = 7200
}

resource "iam_role" "admin" {
  name     = "role-admin"
  설명      = "사람 관리자"
  policies = ["정책_관리자.json"]
  trusted  = ["adm-kim", "adm-park", "adm-jung", "adm-lee",
              "adm-legacy", "adm-vendor", "adm-backup"]
  최대세션_시간 = 43200
  다중인증_요구 = false
  # 이 값을 true 로 두면 다중 인증이 없는 계정은 역할을 맡을 수
  # 없습니다. 지금은 false 라서 누구나 맡을 수 있습니다.
}

resource "iam_group" "개발" {
  name    = "group-dev"
  members = ["dev-choi", "dev-yoon", "dev-han", "dev-seo", "dev-oh",
             "test-01", "test-02", "test-03", "test-04"]
  policies = ["정책_읽기.json"]
  # 시험 계정이 개발 모임에 함께 들어 있습니다.
}

resource "password_policy" "기본" {
  최소길이     = 8
  대문자_요구  = false
  숫자_요구    = true
  특수문자_요구 = false
  바꾸는_주기_일 = 0        # 강제하지 않습니다
  재사용_금지_횟수 = 0
  다중인증_강제 = false
}
