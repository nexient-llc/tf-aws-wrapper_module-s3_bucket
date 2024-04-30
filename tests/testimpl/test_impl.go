package common

import (
	"context"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestDoesS3BucketExist(t *testing.T, ctx types.TestContext) {
	s3Client := GetAWSS3Client(t)
	bucket_arn := terraform.Output(t, ctx.TerratestTerraformOptions(), "arn")
	target_bucket_arn := terraform.Output(t, ctx.TerratestTerraformOptions(), "target_bucket_arn")
	bucket_name := strings.Split(bucket_arn, ":")[5]
	target_bucket_name := ""
	if target_bucket_arn != "" {
		target_bucket_name = strings.Split(target_bucket_arn, ":")[5]
	}
	bucket_found := false
	target_bucket_found := false

	t.Run("TestDoesBucketExist", func(t *testing.T) {
		s3BucketList, err := s3Client.ListBuckets(context.TODO(), &s3.ListBucketsInput{})
		if err != nil {
			t.Errorf("Failure during ListBuckets: %v", err)
		}
		for _, bucket := range s3BucketList.Buckets {
			if *bucket.Name == bucket_name {
				bucket_found = true
			}
			if target_bucket_name != "" && *bucket.Name == target_bucket_name {
				target_bucket_found = true
			}
			if bucket_found && target_bucket_found {
				break
			}
		}
		assert.True(t, bucket_found, "Bucket not found")
		if target_bucket_name != "" {
			assert.True(t, target_bucket_found, "Target Bucket not found")
		}
	})
}

func GetAWSS3Client(t *testing.T) *s3.Client {
	awsS3Client := s3.NewFromConfig(GetAWSConfig(t))
	return awsS3Client
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}
