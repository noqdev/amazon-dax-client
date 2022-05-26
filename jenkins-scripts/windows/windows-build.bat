REM Python version must be manually installed on the Windows box. This is set in PATH variable during the job configuration.
REM PYTHON_VERSION is the full version number of python to be used, like 3.6.
REM PYTHON_VERSION_SHORT is the short version representation of python to be used, like py36.

REM There's a bug that prevents 9.0.0 from working on Windows
pip install -U "pipenv <9.0.0" tox
pipenv --python %PYTHON_VERSION% install --dev
tox -e %PYTHON_VERSION_SHORT% -r