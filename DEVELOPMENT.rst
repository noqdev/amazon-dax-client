============================
Amazon DAX Client for Python
============================

The Amazon DAX Client for Python is used to access `Amazon DAX`_ clusters from
Python. It is nearly source-compatible with Boto3, with only a small change
needed to the client initialization to use DAX instead of DynamoDB.

.. _`Amazon DAX`: https://aws.amazon.com/dynamodb/dax/

Development
-----------

Working on the Amazon DAX Client requires `pyenv`_ to test against all
supported Python versions (3.6 through 3.9). The
`pyenv-virtualenv`_ plugin is also required.

To work with a particular version:

.. code-block:: sh

   pyenv install 3.6.9 # Or whatever the latest 3.6 is
   pyenv virtualenv 3.6.9 amazon-dax-client-venv36

For each version, the development dependencies need to be installed:

.. code-block:: sh

   pyenv activate amazon-dax-client-venv36
   pip install -r requirements-dev.txt -e .

Now the tests can be run:

.. code-block:: sh

   # Unit tests
   pytest

   # Integration tests
   INTEG_TEST_TABLE_PREFIX=$USER INTEG_TEST_DAX_ENDPOINT=$dax_endpoint:8111 pytest -m "integ and not longrunning"

To run tests for all versions, use `tox`_:

.. code-block:: sh

   pyenv local 3.9.0 3.8.6 3.6.9

   # Run the unit tests
   tox

   # Run the integation tests
   INTEG_TEST_TABLE_PREFIX=$USER INTEG_TEST_DAX_ENDPOINT=$dax_endpoint:8111 tox -c tox-integ.ini

.. _`pyenv`: https://github.com/pyenv/pyenv#installation
.. _`pyenv-virtualenv`: https://github.com/pyenv/pyenv-virtualenv#installation
.. _`tox`: https://tox.readthedocs.io/en/latest/install.html

Antlr
~~~~~

Antlr is used to generate code from the grammar at
``grammar/DynamoDbGrammar.g4`` to the packages ``amazondax.grammar2``
(for Python2) and ``amazondax.grammar`` (for Python3). To regenerate the
code, first install Antlr, then:

.. code-block:: sh
   antlr -Dlanguage=Python2  grammar/DynamoDbGrammar.g4
   mv grammar/*.py amazondax/grammar2
   antlr -Dlanguage=Python3  grammar/DynamoDbGrammar.g4
   mv grammar/*.py amazondax/grammar

Minor changes have been made to the generated Python3 files to suppress
pylint errors.

Publish
-------

To publish:

.. code-block:: sh

    python3 setup.py sdist bdist_wheel
    ./s3-upload $VERSION
    twine upload dist/*
