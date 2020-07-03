import os
import json

from collections import OrderedDict
from random import choice

def get_data(file):
    file = open(file, 'r')
    data = json.load(file, object_pairs_hook = OrderedDict)
    file.close()

    return data

def random_class(data):
    return choice(list(data))

def random_code(classname, data):
    return choice(list(data[classname]['status']))
