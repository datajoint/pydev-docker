#!/usr/bin/env sh

#Fix UID/GID
/startup $(id -u) $(id -g)

#Command
"$@"
