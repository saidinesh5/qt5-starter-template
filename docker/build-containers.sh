#!/bin/bash

docker build -f Dockerfile.mingw32 -t qt5-build-environment-mingw32 .

docker tag qt5-build-environment-mingw32 docker.pkg.github.com/saidinesh5/qt5-starter-template/qt5-build-environment-mingw32

