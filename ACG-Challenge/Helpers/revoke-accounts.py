#!/bin/bash/env python3

import subprocess

print("Looks like you're wanting to remove some old accounts.")
accountToRemove = input("Please enter the email address of the account you're looking to remove:  ")
subprocess.run(["gcloud auth revoke {}".format(accountToRemove)])