# Odoo 모듈·기능 목록 (대조용 발췌)

**판본 기준: Odoo 17 Community.** 아래는 요구사항 대조에 쓰려고 추린
것이며 전체 기능 목록이 아닙니다. 기능의 유무와 이름은 **판본과
에디션(Community / Enterprise)에 따라 달라집니다.** 대조 결과에
"판본 의존"이라고 적어야 할 항목은 그렇게 적어 주십시오.

## 설치 대상 모듈

| 모듈 | 성격 | 에디션 | 하는 일 |
|---|---|---|---|
| Contacts (`contacts`) | 핵심 | Community | 거래처·연락처 |
| Sales (`sale_management`) | 업무 | Community | 견적 · 주문 |
| Inventory (`stock`) | 업무 | Community | 재고 · 출하 · 입고 |
| Invoicing (`account`) | 업무 | Community | 청구서 · 대금 등록 |
| Purchase (`purchase`) | 업무 | Community | 발주 |
| Accounting | 업무 | **Enterprise** | 전표 · 결산 · 은행 연동 |
| Studio | 보조 | **Enterprise** | 코드 없이 화면·필드 추가 |
| Korea - Accounting (`l10n_kr`) | 지역화 | Community | 한국 계정과목표 |

## 기능별 확인 사항

### 거래처 (Contacts / `res.partner`)

    · 등록 항목: 이름 · 사업자번호(VAT) · 주소 · 담당자 · 영업담당(user_id)
    · 활성/비활성(`active`) — 비활성은 목록에서 숨고 과거 전표 참조는 유지
    · 중복 검사: 이름·이메일 기준 경고. **사업자번호 유일성은 기본이 아님**
      (설정에서 "Verify VAT Numbers" 를 켜면 형식 검증까지. 유일성 강제는 별도)
    · 여신 한도(Credit Limit): Invoicing 설정에서 켜면 **주문 시 경고**.
      경고이지 차단이 아님. 자동 보류로 만들려면 별도 처리 필요

### 품목 (`product.template`)

    · 등록 항목: 품번(Internal Reference) · 이름 · 단위(UoM) · 판매가
    · 단위는 UoM 표에서 고르는 방식 — 자유 문자열이 아님
    · 활성/비활성으로 단종 처리. 비활성 품목은 신규 주문에서 선택 불가
    · 품목 분류(Product Category)는 **필수 항목**
    · 예전 품번을 담을 전용 열은 없음 (Internal Reference 는 하나)

### 견적·주문 (Sales / `sale.order`)

    · 견적 → 주문 → 청구서가 한 흐름. 견적 확정이 곧 주문
    · 견적서 PDF 출력 · 메일 발송 기본 제공
    · 주문 확정 후 수량 변경 시 변경 이력이 대화창(chatter)에 남음
    · 취소는 상태 변경(Cancelled) — 줄이 지워지지 않음
    · 승인 단계: `sale` 설정의 "Online Signature/Payment" 외에
      **금액 기준 결재선은 기본 제공 아님.** Studio 또는 개발 필요

### 재고·출하 (Inventory / `stock.picking`)

    · 재고 수량은 거래 즉시 반영 (On Hand / Forecasted)
    · 출하 지시(Delivery Order)를 주문에서 자동 생성
    · **부분 출하 시 이월분(Backorder)을 자동으로 만들어 줌** — 기본 동작
    · 재고 실사(Physical Inventory) 화면에서 조정, 조정 이력이 남음
    · 거래명세서(Delivery Slip) 출력 기본 제공

### 청구·수금 (Invoicing / `account.move`)

    · 출하 건에서 청구서 생성 (Invoicing Policy: 주문 수량 / 인도 수량)
    · **여러 출하를 하나의 청구서로 묶는 것 기본 제공**
      (Sales 목록에서 여러 건 선택 → Create Invoice, 또는 정기 청구)
    · 대금 등록(Register Payment)에서 부분 입금 가능 — 잔액이 남음
    · 미수 현황: Partner Ledger · Aged Receivable 보고서
    · 수정 청구서(Credit Note) 기본 제공
    · **한국 전자세금계산서 국세청 연동은 기본 제공 아님.**
      `l10n_kr` 은 계정과목표 중심. 연동은 별도 모듈·서비스 영역이며
      판본과 시점에 따라 달라지므로 확인이 필요합니다

### 반품

    · Return 버튼으로 출하의 역방향 이동 생성 — 재고 자동 복원
    · 교환은 "반품 + 신규 출하" 두 건으로 처리하는 것이 표준 흐름

### 권한

    · 그룹 기반 접근 권한(Sales / Inventory / Accounting 별 User·Manager)
    · 화면·필드 단위 제한은 Record Rule 로 가능. 세밀한 조정은 설정 작업

### 단가 산정 (Pricelist)

    · 가격표(Pricelist)로 거래처별·수량 구간별 단가 지정 가능
    · 기간 지정도 가능 (시작일·종료일)
    · **세 축(거래처 등급 × 수량 구간 × 계절 계수)을 곱셈으로 조합하는
      규칙은 표준 가격표로 표현되지 않음.** 계산식 기반 가격표는 있으나
      등급·계절을 동시에 다루려면 별도 개발 영역

## 대조할 때 주의

    · "될 것 같다" 는 ① 이 아닙니다. 확인하지 못한 것은 "확인 필요" 로.
    · Enterprise 전용 기능을 ① 로 넣지 마십시오. 에디션을 함께 적어야
      합니다.
    · 이 문서는 발췌입니다. 여기에 없는 기능이 Odoo 에 없다는 뜻이
      아닙니다. 없으면 "확인 필요" 입니다.
