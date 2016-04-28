Aws.config.update({
  region: 'us-east-1',
  credentials: Aws::Credentials.new("AKIAJK5EH56GDJHQUI4A", "yBFYohL4CQsVbnNO+vREc9hj0UM9xiO01Zq5amnr"),
})

ENV['S3_BUCKET_NAME'] = 'findgen-dev' unless Rails.env.production?