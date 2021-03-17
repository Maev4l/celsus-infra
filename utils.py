import argparse
import subprocess
import boto3
import json

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


def output_tf(printJson=True):
    tf_output = subprocess.Popen(['terraform', 'output', '-json'],
                                 cwd=f'./terraform/{PROVIDER}',
                                 stdout=subprocess.PIPE)

    jq = subprocess.Popen(['jq', 'with_entries(.value |= .value)'],
                          stdin=tf_output.stdout,
                          stdout=subprocess.PIPE,
                          )
    result = json.load(jq.stdout)
    if printJson is True:
        print(
            f"Terraform info:\n{json.dumps(result,sort_keys=True, indent=4)}")

    filename = f'infra.{args.environment}.json'
    with open(filename, 'w') as file:
        json.dump(result, file, sort_keys=True, indent=4)
    return filename


def save_infra_description(filename):
    s3 = boto3.resource('s3')
    bucket = backend_variables['bucket']
    key = f'celsus/{args.environment}/infra.json'
    s3.meta.client.upload_file(
        Filename=filename, Bucket=bucket, Key=key)
    print(
        f'Infrastructure description {filename} saved into S3://{bucket}/{key}')
