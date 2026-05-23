#!/bin/bash
df -hl | awk '/^THE-DEVICE/ { sum+=$5 } END { print sum }'
