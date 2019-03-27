import subprocess
import json
provider = "aws"

subprocess.call(['terraform', 'init', '-input=false',
                 '-backend-config=./deployment-variables/backend.tfvars'],
                cwd=f'./terraform/{provider}')

tf_output = subprocess.Popen(['terraform', 'output', '-json'],
                             cwd=f'./terraform/{provider}',
                             stdout=subprocess.PIPE)


jq = subprocess.Popen(['jq', 'with_entries(.value |= .value)'],
                      stdin=tf_output.stdout,
                      stdout=subprocess.PIPE,
                      )

result = json.load(jq.stdout)

with open('../infra.json', 'w') as file:
    json.dump(result, file)
