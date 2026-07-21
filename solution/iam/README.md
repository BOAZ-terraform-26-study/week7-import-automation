# OIDC + IAM Role 세팅 (각자 계정 1회)
1. IAM > Identity providers > Add provider: OpenID Connect
   - Provider URL: https://token.actions.githubusercontent.com
   - Audience: sts.amazonaws.com
2. IAM > Roles > Create role > Web identity > 위 provider 선택
   - trust policy는 oidc-trust-policy.json 참고 (<ACCOUNT_ID> 교체, sub는 본인 repo로 제한)
   - 권한: 학습용은 PowerUserAccess (실무는 최소권한). IAM 조작 권한은 제외 권장.
3. 생성된 Role ARN 을 워크플로 role-to-assume 에 입력
4. **스터디 종료 후 Role + OIDC provider 삭제**
