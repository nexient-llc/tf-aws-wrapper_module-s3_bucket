enable_versioning = false

lifecycle_rule = [
  {
    id      = "delete-after-90-days"
    enabled = true
    expiration = {
      days = 180
    }
    noncurrent_version_expiration = {
      noncurrent_days = 180
    }
    abort_incomplete_multipart_upload_days = 180
    transition = [
      {
        days          = 30
        storage_class = "STANDARD_IA"
      },
      {
        days          = 60
        storage_class = "GLACIER"
      }
    ]
  }
]

metric_configuration = [
  {
    name = "whole-bucket-request-metrics"
  },
  {
    name = "data-request-metrics"
    filter = {
      prefix = "data"
    }

  }
]

# Default server side encryption is disabled and SSE-KMS is used instead.
use_default_server_side_encryption = false
bucket_key_enabled                 = true
object_ownership                   = "BucketOwnerPreferred"
control_object_ownership           = true
