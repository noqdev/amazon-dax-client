REM Python version must be manually installed on the Windows box. This is set in PATH variable during the job configuration.
REM PYTHON_VERSION is the full version number of python to be used, like 3.6.
REM PYTHON_VERSION_SHORT is the short version representation of python to be used, like py36.

set AWS_DEFAULT_REGION=us-east-1
set INTEG_TEST_DAX_ENDPOINT=jenkins-integ-test.0h3d6x.clustercfg.dax.use1.cache.amazonaws.com:8111
set INTEG_TEST_TABLE_PREFIX=%JOB_NAME%

pip install -U pipenv tox
pip install -r requirements-dev.txt -e .
tox -c tox-integ.ini -e %PYTHON_VERSION_SHORT%