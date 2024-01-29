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
  tags = merge(var.tags, { provisioner = "Terraform" })

  // This block enabled access logging on the target bucket.
  logging = {
    "target_bucket" = module.s3_bucket_target.id
    "target_prefix" = ""
  }

  use_default_server_side_encryption_src_bkt    = false
  use_default_server_side_encryption_target_bkt = true

}
