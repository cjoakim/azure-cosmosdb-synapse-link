import json
import os
import pytest

def write_tmp_file(basename, contents):
    with open('tmp/' + basename, 'w', encoding='utf-8') as out:
        out.write(contents)
        print('tmp/ file written: ' + basename)

def test_env_home():
    assert(os.environ['HOMEPATH'] == "\\Users\\chjoakim")
