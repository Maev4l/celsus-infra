import subprocess

provider = "aws"

subprocess.call(['terraform', 'init', '-input=false',
                 '-backend-config=./deployment-variables/backend.tfvars'],
                cwd=f'./terraform/{provider}')

subprocess.call(['terraform', 'destroy', '-auto-approve', '-lock=true',
                 '-var-file=./deployment-variables/infra.tfvars'],
                cwd=f'./terraform/{provider}')
