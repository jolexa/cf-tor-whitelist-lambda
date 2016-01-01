# cf-tor-whitelist-lambda
AWS Lambda function to whitelist Tor Exit relays via CloudFlare's API. Uses Donncha O' Cearbhaill's [cloudflare-tor-whitelister](https://github.com/DonnchaC/cloudflare-tor-whitelister)

## Files
`main.py` - The actual function that gets ran

`build-package.sh` - Helper information to build the zip file, must supply the "secret" bucket

## Ideology
The idea of this repo is to build a zip package that you can deploy to AWS Lambda. The lambda function fires on a scheduled event, (eg, Daily). Basically, we are using AWS Lambda as a cron daemon.

I was thinking about storing the secret data in AWS DynamoDB, but that was more expensive than I wanted to spend on this.

Ultimately, I choose to store the CloudFlare secret in a encrypted at rest object on S3 because it was easy and it makes this function re-usable for others instead of hardcoding some credentials and not sharing the function. Ideally, the object would be protected by AWS KMS as well, but that costs more than I wanted to spend on this.

Expected secret format:
```
$ cat cloudflare.json
{
  "email": "email@example.com",
  "token": "cf api token"
}
```

## Zip File
The zip file was needed because the whitelister needs the [requests library](http://docs.python-requests.org/en/latest/)

1. Launch a t2.nano, running the published supported AMI (https://docs.aws.amazon.com/lambda/latest/dg/current-supported-versions.html)
2. Run `build-package.sh <secret bucket>`
3. Fetch resulting zip file
4. Upload to AWS Lambda
5. Remember to shutdown the t2.nano if not being used

## Future
* It might be nice to extend this to DynamoDB as well.
* It would be nice to package this up in a CloudFormation stack
