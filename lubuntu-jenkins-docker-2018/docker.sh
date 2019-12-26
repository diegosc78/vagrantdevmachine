#!/bin/bash

echo "[ubuntu.sh] Enabling docker..."
usermod -G docker jenkins
usermod -G docker ubuntu
usermod -G docker vagrant
systemctl enable docker
systemctl start docker



