#!/bin/sh

set -e

# echo "pod version:"
# pod --version

echo "carthage version:"
carthage version

#carthage
#carthage bootstrap --no-build --no-use-binaries

carthage update --no-build --no-use-binaries

# carthage update --platform ios

#cp Cartfile.resolved Carthage/