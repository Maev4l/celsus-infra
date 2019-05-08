#! /usr/bin/env python3
import subprocess
from utils import get_environment, init_tf, output_tf, save_infra_description, PROVIDER


init_tf()

environment = get_environment()

subprocess.run(['terraform', 'apply', '-input=false', '-auto-approve',
                '-lock=true',
                f'-var-file=./deployment-variables/{environment}/infra.tfvars',
                f'-var-file=./deployment-variables/{environment}/secrets.tfvars'],
               cwd=f'./terraform/{PROVIDER}',
               check=True)

filename = output_tf(printJson=False)

save_infra_description(filename)
