
__author__  = 'Chris Joakim'
__email__   = "chjoakim@microsoft.com"
__license__ = "MIT"
__version__ = "February 2022"

import os
import time


class Env(object):

    @classmethod
    def var(cls, name, default=None):
        if name in os.environ:
            return os.environ[name]
        else:
            return default

    @classmethod
    def epoch(cls):
        return arrow.utcnow().timestamp

    @classmethod
    def sleep(cls, sec=1):
        time.sleep(sec)
