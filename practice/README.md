# Week7 실습 A — modern import
```bash
cp example.tfvars terraform.tfvars
# 콘솔에서 <project_name>-manual2 버킷 생성
terraform init
terraform plan -generate-config-out=generated.tf
terraform apply
terraform destroy
```
GitHub Actions(OIDC)는 상위 README §4-B + .github/workflows/terraform.yml 참고.
