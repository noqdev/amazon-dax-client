#!/usr/bin/env bash
# PYTHON_VERSION is the full version number of python to be used, like 3.6.3.
# PYTHON_VERSION_SHORT is the short version representation of python to be used, like py36.
# All the variables mentioned above are set in job configuration.

# log the hostname on which script is being executed
hostname

# Install Python build dependencies
sudo yum groupinstall -y "Development Tools"
sudo yum install -y zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel

export AWS_DEFAULT_REGION=us-east-1

if [ ! -f /home/ec2-user/.pyenv/bin/pyenv ]
then
    # The pyenv package is compressed and available in s3 bucket for dax-aws@amazon.com account. Fetch it and put it in ~/.pyenv dir.
    mkdir -p /home/ec2-user/.pyenv
    aws s3 cp s3://pyenv/pyenv-tarball.tar.gz /home/ec2-user/.pyenv
    tar -xzvf /home/ec2-user/.pyenv/pyenv-tarball.tar.gz -C /home/ec2-user/.pyenv
fi

export PATH="/home/ec2-user/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
pyenv install -s $PYTHON_VERSION && pyenv shell $PYTHON_VERSION
pip install -U tox

export INTEG_TEST_DAX_ENDPOINT=jenkins-integ-test.0h3d6x.clustercfg.dax.use1.cache.amazonaws.com:8111
export INTEG_TEST_TABLE_PREFIX=$JOB_NAME

tox -c tox-integ.ini -e $PYTHON_VERSION_SHORT
