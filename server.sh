#!/bin/bash

echo "Starting MHO server..."
caddy start
./MHServerEmu/src/MHServerEmu/bin/x64/Debug/net8.0/MHServerEmu

