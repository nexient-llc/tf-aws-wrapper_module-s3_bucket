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
attach_access_log_delivery_policy = true
attach_policy                     = true
bucket_key_enabled                = true
