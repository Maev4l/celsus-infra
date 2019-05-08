#! /usr/bin/env python3
import subprocess
from utils import get_environment, init_tf, PROVIDER


init_tf()

environment = get_environment()


subprocess.run(['terraform', 'destroy', '-auto-approve', '-lock=true',
                f'-var-file=./deployment-variables/{environment}/infra.tfvars',
                f'-var-file=./deployment-variables/{environment}/secrets.tfvars'],
               cwd=f'./terraform/{PROVIDER}',
               check=True)
