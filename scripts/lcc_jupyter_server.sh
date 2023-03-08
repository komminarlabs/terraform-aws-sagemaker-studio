#!/bin/bash
set -eux

# timeout in minutes
export TIMEOUT_IN_MINS=120

# Should already be running in user home directory, but just to check:
cd /home/sagemaker-user

# By working in a directory starting with ".", we won't clutter up users' Jupyter file tree views
mkdir -p .auto-shutdown

# Create the command-line script for setting the idle timeout
cat > .auto-shutdown/set-time-interval.sh << EOF
#!/opt/conda/bin/python
import json
import requests
TIMEOUT=${TIMEOUT_IN_MINS}
session = requests.Session()
# Getting the xsrf token first from Jupyter Server
response = session.get("http://localhost:8888/jupyter/default/tree")
# calls the idle_checker extension's interface to set the timeout value
response = session.post("http://localhost:8888/jupyter/default/sagemaker-studio-autoshutdown/idle_checker",
            json={"idle_time": TIMEOUT, "keep_terminals": False},
            params={"_xsrf": response.headers['Set-Cookie'].split(";")[0].split("=")[1]})
if response.status_code == 200:
    print("Succeeded, idle timeout set to {} minutes".format(TIMEOUT))
else:
    print("Error!")
    print(response.status_code)
EOF
chmod +x .auto-shutdown/set-time-interval.sh

curl -L https://github.com/aws-samples/sagemaker-studio-auto-shutdown-extension/raw/main/sagemaker_studio_autoshutdown-0.1.5.tar.gz --output .auto-shutdown/sagemaker_studio_autoshutdown-0.1.5.tar.gz

# Installs the auto-shutdown extension
cd .auto-shutdown
tar xzf sagemaker_studio_autoshutdown-0.1.5.tar.gz
cd sagemaker_studio_autoshutdown-0.1.5

eval "$(conda shell.bash hook)"
conda activate studio

pip install --no-dependencies --no-build-isolation -e .
jupyter serverextension enable --py sagemaker_studio_autoshutdown

conda deactivate

# Restarts the jupyter server
nohup supervisorctl -c /etc/supervisor/conf.d/supervisord.conf restart jupyterlabserver

# Waiting for 30 seconds to make sure the Jupyter Server is up and running
sleep 30

# Calling the script to set the idle-timeout and activate the extension
/home/sagemaker-user/.auto-shutdown/set-time-interval.sh
