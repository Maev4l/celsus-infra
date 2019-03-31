import subprocess
from utils import get_region, init_tf, PROVIDER


init_tf()

region = get_region()


subprocess.run(['terraform', 'destroy', '-auto-approve', '-lock=true',
                f'-var-file=./deployment-variables/{region}/infra.tfvars'],
               cwd=f'../terraform/{PROVIDER}',
               check=True)
