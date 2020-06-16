#!/bin/bash
set -e

# Create instance with
gcloud compute instances create reddit-app-full \
--boot-disk-size=10GB \
--image-family=reddit-full \
--machine-type=g1-small \
--tags puma-server \
--restart-on-failure
