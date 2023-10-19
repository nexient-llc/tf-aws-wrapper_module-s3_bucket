// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

locals {

  bucket_name = var.bucket_name == null ? module.resource_names["s3"].recommended_per_length_restriction : var.bucket_name
  default_tags = {
    provisioner = "Terraform"
  }

  tags = merge(local.default_tags, var.tags)

  // By using local variable below it is ensured that if default server side encryption needs to be used, it can be enabled as long as var.use_default_server_side_encryption == true. If var.use_default_server_side_encryption == false then SSE-KMS encryption will be used.
  server_side_encryption_configuration = var.use_default_server_side_encryption == true ? {} : {
    "rule" = {
      bucket_key_enabled = var.bucket_key_enabled
      apply_server_side_encryption_by_default = {
        sse_algorithm     = var.kms_s3_key_sse_algorithm
        kms_master_key_id = var.kms_s3_key_arn
      }
    }
  }

}
