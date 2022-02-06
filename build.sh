#!/bin/bash

set -e


mkdir -p /src/src


cd /xeus-utils-build
cp *.{js,wasm} /src/src

echo "============================================="
echo "Compiling wasm bindings done"
echo "============================================="