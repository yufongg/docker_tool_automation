import json
import os
from json2html import *
#reference: https://pypi.org/project/json2html/

path = os.path.split(os.getcwd())[0]
#home/user/automation
dockle_format_path = path + "/security_tools/test_results/dockle_results.json"
with open(dockle_format_path, "r") as read_file:
    data = json.load(read_file)
input = data

test = json2html.convert(json = input)
print(test)
