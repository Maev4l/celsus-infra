import argparse
import subprocess
import boto3

PROVIDER = 'aws'

parser = argparse.ArgumentParser()
parser.add_argument("--environment",
                    type=str,
                    choices=['dev'],
                    help="Specify the deployment environment")

args = parser.parse_args()

# Parse the TF backend file
backend_variables = {}
with open(f'./terraform/{PROVIDER}/deployment-variables/{args.environment}/backend.tfvars') \
        as backend_file:
    for line in backend_file:
        name, var = line.partition("=")[::2]
        backend_variables[name.strip().replace('\"', '')] = str(
            var).strip().replace('\"', '')


def get_environment():
    return args.environment


def init_tf():
    subprocess.run(['terraform', 'init', '-input=false',
                    f'-backend-config=./deployment-variables/{args.environment}/backend.tfvars'],
                   cwd=f'./terraform/{PROVIDER}',
                   check=True)


def save_infra_description(filename):
    s3 = boto3.resource('s3')
    bucket = backend_variables['bucket']
    key = f'celsus/{args.environment}/infra.json'
    s3.meta.client.upload_file(
        Filename=filename, Bucket=bucket, Key=key)
