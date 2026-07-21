# Week 7. 최신 import & 자동화 · 마무리 `[대면]`

> 📘 **[이번 주 강의자료(핸즈온 워크북) PDF »](./lecture/강의자료.pdf)** — 실습은 이 문서를 위에서 아래로 따라가며 진행합니다.

> 이번 주가 끝나면: **`import` 블록 + `-generate-config-out`으로 설정을 자동 생성하고, GitHub Actions로 `plan`을 자동 실행할 수 있다.** 그리고 7주를 회고한다.

## 0. 메타 정보
| 항목 | 내용 |
|------|------|
| 일시 | 2026-MM-DD · 60분 |
| 방식 | **대면** |
| 선행 | week6 완료 |
| 산출물 | 실습 PR + 워크북 + **회고 & 데모** |

## 1. 학습 목표 (측정 가능)
- [ ] `import` 블록 + `terraform plan -generate-config-out=...`으로 코드를 자동 생성할 수 있다
- [ ] classic import(week6)와 modern import의 차이를 설명할 수 있다
- [ ] GitHub Actions에서 OIDC로 AWS에 인증하고 `plan`을 실행할 수 있다
- [ ] "PR엔 plan, merge엔 apply" CI 패턴을 설명할 수 있다

## 2. 사전 예습 (필수)
- HashiCorp: [import block](https://developer.hashicorp.com/terraform/language/import), [Generating configuration](https://developer.hashicorp.com/terraform/language/import/generating-configuration) (15분)
- GitHub: [Configuring OIDC in AWS](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) (10분)

## 3. 진행 타임박스 (60분)
| 시간 | 구성 | 내용 |
|------|------|------|
| 0~10분 | 회고 | 랜덤 지목 |
| 10~35분 | 실습 A | modern import + generate-config (25분) |
| 35~50분 | 실습 B | GitHub Actions plan 데모 (15분) |
| 50~60분 | 마무리 | **7주 전체 회고 & 데모**, bootstrap 포함 전체 정리 |

## 4-A. 실습 A — modern import + generate-config
```hcl
# imports.tf — import 블록만 작성 (리소스 본문 없음)
import {
  to = aws_s3_bucket.manual2
  id = "boaz-tf-yourname-manual2"
}
```
```bash
# 콘솔에서 manual2 버킷 생성 후
terraform plan -generate-config-out=generated.tf   # 코드 자동 생성!
# generated.tf 정리 후
terraform apply                                     # state 편입
```
- **week6 대비**: classic은 속성을 사람이 하나씩 채웠지만, modern은 **코드를 자동 생성**. 차이를 워크북에 기록.

## 4-B. 실습 B — GitHub Actions (OIDC, 장기 키 없이)
> **왜 OIDC?** 장기 Access Key를 GitHub Secrets에 넣었다 유출되면 **개인 카드에 과금 폭탄**. OIDC는 단기 토큰으로 IAM Role을 AssumeRole → **영구 키 저장 0개**. 학생 계정에 최적.

세팅 (각자 계정 1회):
1. IAM → Identity providers → OIDC provider 추가: `token.actions.githubusercontent.com` (audience `sts.amazonaws.com`)
2. IAM Role 생성, trust policy에서 **본인 repo/브랜치로 `sub` 제한** (아래 `iam/` 참고)
3. 워크플로 `.github/workflows/terraform.yml`의 `role-to-assume`에 Role ARN 입력

```
PR 생성 → Actions가 terraform plan 실행 → 결과 확인 (apply는 수동/merge 시)
```

## 5. 체크포인트 (DoD)
- [ ] `generate-config-out`으로 `generated.tf` 생성됨
- [ ] modern vs classic 차이를 워크북에 1줄 이상 정리
- [ ] (가능하면) Actions에서 `plan` 성공 (OIDC 인증)
- [ ] **전체 정리**: app + manual + bootstrap(S3/DynamoDB) + IAM Role/OIDC provider까지 destroy/삭제

## 6. 트러블슈팅 FAQ
| 증상 | 원인 | 해결 |
|------|------|------|
| OIDC `Not authorized to perform sts:AssumeRoleWithWebIdentity` | trust policy sub 조건 오타 | repo/branch 조건 확인 |
| Actions `Could not assume role` | `permissions: id-token: write` 누락 | 워크플로 permissions 확인 |
| generated.tf에 read-only 속성 | 자동 생성 한계 | 해당 속성 삭제/수정 |
| working-directory 오류 | 경로 미설정 | job defaults working-directory 확인 |

## 7. 심화 도전과제 (Optional ⭐)
- L2: PR 코멘트로 plan 결과 게시 (`actions/github-script`)
- L3-⭐: environment protection으로 apply 수동 승인 게이트

## 8. 마무리 — 7주 회고
Week1 S3 한 개 → 모듈화 인프라 + 원격 state + CI 자동화까지. 각자 "가장 크게 배운 것 1개"와 "9월 이후 실제 인프라 import에 쓸 것 1개"를 공유.

**⚠️ 스터디 종료 정리(필수):** 모든 리소스 destroy + IAM Role/OIDC provider 삭제 + 실습용 IAM 사용자/액세스 키 비활성화.

---
> ⚠️ **비용 주의**: CI `apply` 데모는 무과금 리소스로, 후 즉시 destroy. **OIDC Role은 종료 후 삭제.** Access Key fallback을 썼다면 반드시 삭제/비활성화.
> **공통 규칙**: 자격증명/secret 커밋 금지 · `destroy` 확인 · 코드는 PR로
