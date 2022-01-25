import os
import subprocess

# find conda folder
subprocess.run(f"""conda init bash""",
    shell=True, executable='/bin/bash', check=True, text=True, capture_output=True)
check = subprocess.run(f"""conda activate base
    which python""",
    shell=True, executable='/bin/bash', check=True, text=True, capture_output=True)

# find env names
stdout = check.stdout
idx = stdout.find("envs")
conda_path = stdout[:idx] + "envs"
envs_content = os.listdir(conda_path)
envs = [fname for fname in envs_content if "." not in fname]

# export envs to YAML
for env_name in envs:
    subprocess.run("conda env export -n {} > ./conda_envs/{}_environment.yml".format(env_name, env_name),
        shell=True, executable='/bin/bash', check=True)
