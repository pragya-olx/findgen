Aws.config.update({
  region: 'us-east-1',
  credentials: Aws::Credentials.new("AKIAJK4ULXARMVZ4A6SA", "n1g0C0ev8ANpWH2yOJ3oj6ZLrp9doiwLABVtPyqv"),
})

ENV['S3_BUCKET_NAME'] = 'findgen-dev' unless Rails.env.production?