#!/bin/sh
# --batch to prevent interactive command
# --yes to assume "yes" for questions
gpg --quiet --batch --yes --decrypt --passphrase="$PASSPHRASE" \
--output android/key_files.zip android/key_files.zip.gpg && cd android && jar xvf key_files.zip && cd -
ls -d $PWD/android/*
# mv ./android/expensemanager.jks ./android/app
# move your file according to path in key.properties
