#!/bin/bash

vim /etc/sudoers
read name
useradd -m -G wheel name
