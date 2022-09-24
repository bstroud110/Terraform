#!/usr/bin/env python3

import os
import os.path
import sys
import fileinput

ENV = input('What environment is this for? (master or preproduction):  ')
OLDPRJ = input('Please enter the old project name:  ')
NEWPRJ = input('Please enter the new project name:  ')

if ENV.lower() == 'master':
    print('You selected the Master environment.')
if ENV.lower() == 'preproduction':
    print('You selected the Preproduction environment.')


#Below method found here to update text in a file:  
# https://stackoverflow.com/questions/17140886/how-to-search-and-replace-text-in-a-file
# https://stackoverflow.com/questions/2753254/how-to-open-a-file-in-the-parent-directory-in-python-in-appengine
# https://stackoverflow.com/questions/32470543/open-file-in-another-directory-python
current_directory = os.path.dirname(__file__)
parent_directory = os.path.split(current_directory)[0]
fileToSearch = os.path.join(parent_directory, 'projects/{}/terraform.tfvars'.format(ENV))
print('Searching file {}'.format(fileToSearch))

with fileinput.FileInput(fileToSearch, inplace=True, backup='.bak') as file:
    for line in file:
        print(line.replace(OLDPRJ, NEWPRJ), end='')

