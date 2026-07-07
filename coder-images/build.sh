#!/bin/bash
set -e

cd "$(dirname "$0")"

prebuild() {
  local dir="$1"
}

for dir in */; do
    if [ -d "$dir" ]; then
        echo ">>> Building in directory: $dir"
        cd "$dir"
        prebuild "$dir"
        docker buildx bake --push
        cd ..
    fi
done

echo "Build successfully"