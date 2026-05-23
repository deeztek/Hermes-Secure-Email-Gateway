#!/bin/bash

/usr/local/bin/docker inspect hermes_commandbox --format '{{index .Config.Labels "com.docker.compose.project.working_dir"}}' 2>/dev/null
