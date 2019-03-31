import subprocess
from utils import get_region, init_tf, PROVIDER


init_tf()

region = get_region()

subprocess.run(['terraform', 'apply', '-input=false', '-auto-approve',
                '-lock=true',
                f'-var-file=./deployment-variables/{region}/infra.tfvars',
                f'-var-file=./deployment-variables/{region}/secrets.tfvars'],
               cwd=f'./terraform/{PROVIDER}',
               check=True)
