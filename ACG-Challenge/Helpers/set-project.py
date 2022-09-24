#!/bin/bash/env python3

import subprocess

NEWPRJ = input("Please enter the new project number:  ")

#Set the gcloud project config to NEWPRJ
project = "gcloud info --format='value(config.project)'"
print(subprocess.call(project, shell=True))
subprocess.run(["gcloud config set project {}".format(NEWPRJ)], capture_output=True, text=True, shell=True)

