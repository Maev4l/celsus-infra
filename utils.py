import argparse
import subprocess

PROVIDER = 'aws'

parser = argparse.ArgumentParser()
parser.add_argument("--region",
                    type=str,
                    choices=['eu-west-1', 'eu-west-3'],
                    help="Specify the deployment region")

args = parser.parse_args()


def get_region():
    return args.region


def init_tf():
    subprocess.run(['terraform', 'init', '-input=false',
                    f'-backend-config=./deployment-variables/backend.tfvars'],
                   cwd=f'./terraform/{PROVIDER}',
                   check=True)
