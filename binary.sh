#!/usr/bin/bash

systemd-nspawn --machine ansible --directory ./layer --bind=$USER_PWD:/app --bind=/home:/home sh -c "cd /app && $@"
