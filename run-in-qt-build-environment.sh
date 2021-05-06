#!/bin/sh

TARGET=${1:-build_mingw32}
WORKDIR=/workdir

if [[ `basename $TARGET` == build_mingw32 ]]; then
    CONTAINER=${CONTAINER:-docker.pkg.github.com/saidinesh5/qt5-starter-template/qt5-build-environment-mingw32}
elif [[ `basename $TARGET` == build_linux64 ]]; then
    CONTAINER=${CONTAINER:-docker.pkg.github.com/saidinesh5/qt5-starter-template/qt5-build-environment-linux64}
elif [[ `basename $TARGET` == build_android ]]; then
    CONTAINER=${CONTAINER:-docker.pkg.github.com/saidinesh5/qt5-starter-template/qt5-build-environment-android}
else
    echo "Unknown target!"
    exit -1
fi

docker run -it -v $PWD:$WORKDIR \
               -v $HOME:$HOME:ro \
               -w $WORKDIR \
               -v /etc/group:/etc/group:ro \
               -v /etc/passwd:/etc/passwd:ro \
               -u $(id -u ${USER}):$(id -g ${USER}) \
               -e HOME=$HOME \
               -e USER=$USER \
               --rm $CONTAINER $WORKDIR/$TARGET
