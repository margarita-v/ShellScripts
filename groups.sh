#!/bin/bash
cut -d ':' -f1 /etc/group | grep -i "^[opqr]" | wc -l
