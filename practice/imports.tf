# TODO(L1): 콘솔에서 만든 버킷을 import 블록으로 지정
#   to = aws_s3_bucket.manual2
#   id = "${var.project_name}-manual2"
# import {
#   to = ...
#   id = ...
# }
#
# 이후: terraform plan -generate-config-out=generated.tf
# 생성된 generated.tf 를 정리하고 terraform apply
