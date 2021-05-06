#!/bin/bash

docker build -f Dockerfile.mingw32 -t docker.pkg.github.com/saidinesh5/qt5-starter-template/qt5-build-environment-mingw32 .
docker build -f Dockerfile.linux64 -t docker.pkg.github.com/saidinesh5/qt5-starter-template/qt5-build-environment-linux64 .
docker build -f Dockerfile.android -t docker.pkg.github.com/saidinesh5/qt5-starter-template/qt5-build-environment-android .


