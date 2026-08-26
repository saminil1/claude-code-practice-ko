#!/bin/sh
# 배포. 인자는 staging 또는 production.
# 두 번째 인자로 --직전판 을 주면 롤백입니다.
set -e

ENV="$1"
MODE="$2"
[ -z "$ENV" ] && { echo "환경을 지정하세요 (staging|production)"; exit 1; }

case "$ENV" in
  staging)    CONF="../설정/앱_검증.yml"; 대상="app-stg-01" ;;
  production) CONF="../설정/앱_운영.yml"; 대상="app-01" ;;
  *) echo "모르는 환경: $ENV"; exit 1 ;;
esac

판=$(git rev-parse --short HEAD)
[ "$MODE" = "--직전판" ] && 판=$(cat /var/deploy/직전판)

echo "════ 배포 시작 $(date '+%F %T') ════"
echo "  환경 $ENV · 판 $판 · 설정 $CONF"

echo "[1/6] 설정 확인"
test -f "$CONF" || { echo "설정 파일이 없습니다: $CONF"; exit 2; }
grep -q "환경:" "$CONF" || { echo "설정 파일 모양이 이상합니다"; exit 2; }

echo "[2/6] 이미지 만들기"
docker build -t app:"$판" ..

echo "[3/6] 이미지 올리기"
docker push registry.internal/app:"$판"

echo "[4/6] 부하분산기에서 빼기"
for 서버 in $대상; do
  echo "  - $서버 제외"
  # lb-web 에서 뺍니다. 실제 명령은 사내 도구입니다.
done

echo "[5/6] 서버 교체"
for 서버 in $대상; do
  echo "  - $서버 재시작"
  ssh "$서버" "docker pull registry.internal/app:$판 && systemctl restart app"
  sleep 5
  curl -fsS "http://$서버:8080/healthz" >/dev/null || {
    echo "■ $서버 상태 확인 실패. 멈춥니다."; exit 3; }
done

echo "[6/6] 부하분산기에 넣기"
echo "$판" > /var/deploy/현재판

echo "════ 배포 끝 $(date '+%F %T') ════"
echo "30분 동안 지켜보십시오. 오류율과 응답 시간을 봅니다."
