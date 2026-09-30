# terraform plan -generate-config-out=generated.tf 로 자동 생성되는 예시.
# read-only/deprecated 속성은 직접 정리해야 함.
resource "aws_s3_bucket" "manual2" {
  bucket = "boaz-tf-yourname-manual2"
}
