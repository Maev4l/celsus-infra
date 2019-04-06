import subprocess
import json
from utils import get_environment, init_tf, save_infra_description, PROVIDER


init_tf()

environment = get_environment()

tf_output = subprocess.Popen(['terraform', 'output', '-json'],
                             cwd=f'./terraform/{PROVIDER}',
                             stdout=subprocess.PIPE)


jq = subprocess.Popen(['jq', 'with_entries(.value |= .value)'],
                      stdin=tf_output.stdout,
                      stdout=subprocess.PIPE,
                      )

result = json.load(jq.stdout)
print(f"Terraform info:\n{json.dumps(result,sort_keys=True, indent=4)}")
with open('infra.json', 'w') as file:
    json.dump(result, file, sort_keys=True, indent=4)

save_infra_description('infra.json')
