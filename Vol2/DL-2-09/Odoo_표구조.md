# Odoo 대상 표 구조 (이관 대상 3개 표)

**판본 기준: Odoo 17 Community.** 가져오기(Import) 화면이 받는 열만
추렸습니다. 실제 표에는 훨씬 많은 열이 있습니다.

## 거래처 — `res.partner`

| 대상 열 | 표시 이름 | 필수 | 형식·값 |
|---|---|---|---|
| `name` | Name | **필수** | 문자열 |
| `vat` | Tax ID | | 사업자번호. 하이픈 없이 저장하는 것이 표준 |
| `street` | Street | | 문자열 |
| `city` | City | | 문자열 |
| `country_id` | Country | | 이름 또는 코드 (예: `KR`) |
| `is_company` | Is a Company | | `TRUE` / `FALSE` |
| `customer_rank` | | | 0보다 크면 고객으로 취급 |
| `user_id` | Salesperson | | **사용자 계정**과 연결. 이름 문자열이 아님 |
| `active` | Active | | `TRUE` / `FALSE`. FALSE 면 목록에서 숨김 |
| `property_product_pricelist` | Pricelist | | 가격표 |
| `currency_id` | Currency | **필수** | 통화 코드 (예: `KRW`) |
| `comment` | Notes | | 자유 서술 |
| `ref` | Reference | | 내부 참조 코드 |

주의

    · `phone` · `mobile` · `email` 은 있으나 **개인 연락처를 옮길
      필요가 있는지 먼저 판단**해야 합니다.
    · 담당 영업사원을 `user_id` 에 넣으려면 그 사람의 **사용자 계정이
      미리 있어야** 합니다. 이름만으로는 들어가지 않습니다.

## 품목 — `product.template`

| 대상 열 | 표시 이름 | 필수 | 형식·값 |
|---|---|---|---|
| `name` | Name | **필수** | 문자열 |
| `default_code` | Internal Reference | | 품번 |
| `type` | Product Type | **필수** | `consu` / `service` / `product` |
| `categ_id` | Product Category | **필수** | 분류. 없으면 `All` |
| `uom_id` | Unit of Measure | **필수** | **UoM 표에 있는 값만.** 자유 문자열 불가 |
| `uom_po_id` | Purchase UoM | **필수** | 보통 `uom_id` 와 같게 |
| `list_price` | Sales Price | | 숫자 |
| `active` | Active | | `TRUE` / `FALSE` |
| `description` | Description | | 자유 서술 |

주의

    · `uom_id` 는 미리 정의된 단위만 받습니다. 기존 자료의 `EA` · `SET`
      · `BOX` 같은 표기는 **Units · Set · Box 등으로 옮기거나 UoM 을
      새로 만들어야** 합니다.
    · 규격을 담을 전용 열이 없습니다. `description` 또는 속성(Attribute)
      으로 옮길지 정해야 합니다.
    · 예전 품번을 담을 전용 열이 없습니다.

## 주문 — `sale.order` / `sale.order.line`

`sale.order` (머리)

| 대상 열 | 표시 이름 | 필수 | 형식·값 |
|---|---|---|---|
| `name` | Order Reference | | 주문번호 |
| `partner_id` | Customer | **필수** | 거래처. **실재해야 함** |
| `date_order` | Order Date | **필수** | `YYYY-MM-DD` 또는 `YYYY-MM-DD HH:MM:SS` |
| `state` | Status | | `draft` / `sent` / `sale` / `cancel` |
| `pricelist_id` | Pricelist | **필수** | 가격표 |
| `currency_id` | Currency | | 통화 |

`sale.order.line` (줄)

| 대상 열 | 표시 이름 | 필수 | 형식·값 |
|---|---|---|---|
| `product_id` | Product | **필수** | 품목. **실재해야 함** |
| `product_uom_qty` | Quantity | **필수** | 숫자 |
| `price_unit` | Unit Price | | 숫자. 쉼표·"원" 불가 |
| `name` | Description | **필수** | 보통 품목명 |

주의

    · 금액(합계)은 **저장하는 열이 아니라 계산되는 값**입니다.
      수량 × 단가로 Odoo 가 냅니다. 원본 금액과 계산값이 다르면
      원본 쪽에 문제가 있다는 뜻이므로 대조에 쓰십시오.
    · `date_order` 는 연도가 있어야 합니다. `3/5` 같은 표기는 받지
      않습니다.
    · 상태값이 `완료` · `진행` 두 가지뿐이면 Odoo 의 4단계 중 어디에
      맞출지 정해야 합니다.

## 가져오기 공통

    · CSV/XLSX 첫 줄이 열 이름입니다.
    · 외부 식별자(`id`) 열을 두면 다시 올릴 때 덮어쓰기가 됩니다.
      두지 않으면 **다시 올릴 때마다 중복 생성**됩니다.
    · 참조(거래처·품목)는 이름 또는 외부 식별자로 찾습니다.
      **찾지 못하면 그 줄은 통째로 실패**합니다.
