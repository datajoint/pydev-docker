#!/bin/bash

#Fix UID/GID
/startup $(id -u) $(id -g)

#Command
"$@"
