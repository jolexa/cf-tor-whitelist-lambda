from __future__ import print_function

import boto3
import json
import logging

import subprocess

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    logger.info("Started function")

    s3_client.download_file('BUCKETNAME', 'cloudflare.json', '/tmp/cloudflare.json')
    with open('/tmp/cloudflare.json') as data_file:
        data = json.load(data_file)
    EMAIL = data["email"]
    TOKEN = data["token"]

    subprocess.call("python /var/task/whitelist.py -t " + TOKEN + " -e " + EMAIL , shell=True)

    subprocess.call("shred -vu /tmp/cloudflare.json", shell=True)

    logger.info("Completed function")
