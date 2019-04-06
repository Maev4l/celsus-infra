import argparse
import subprocess

PROVIDER = 'aws'

parser = argparse.ArgumentParser()
parser.add_argument("--environment",
                    type=str,
                    choices=['dev'],
                    help="Specify the deployment environment")

args = parser.parse_args()


def get_environment():
    return args.environment


def init_tf():
    subprocess.run(['terraform', 'init', '-input=false',
                    f'-backend-config=./deployment-variables/{args.environment}/backend.tfvars'],
                   cwd=f'./terraform/{PROVIDER}',
                   check=True)
