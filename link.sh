#!/usr/bin/env bash
# Syncs all configs with stow 

cd $(dirname "${BASH_SOURCE[0]}")

for i in $(ls -d */); do echo "Linking ${i%%/}..."; stow -t $HOME $i; done
