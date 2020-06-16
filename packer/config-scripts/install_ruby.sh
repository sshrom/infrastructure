#!/bin/bash
set -e #exit if no err

# Install ruby
apt update
apt install -y ruby-full ruby-bundler build-essential
