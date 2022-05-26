# Copyright 2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not
# use this file except in compliance with the License. A copy of the License
# is located at
#
#    http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is distributed on
# an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied. See the License for the specific language governing
# permissions and limitations under the License.

__version__ = '2.0.0'

from .AmazonDaxClient import AmazonDaxClient
import logging
from botocore import NullHandler
from os import path

# Configure default logger to do nothing
log = logging.getLogger('amazondax')
log.addHandler(NullHandler())
AMAZON_DAX_ROOT = path.dirname(path.abspath(__file__))
