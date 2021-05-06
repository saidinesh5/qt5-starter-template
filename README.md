# qt5-starter-template

The boring boilerplate

## Building

#### Prerequisites
* docker installation [set up properly](https://docs.docker.com/get-started/), to access the containers hosted at [My Github Page](https://github.com/saidinesh5?tab=packages&repo_name=qt5-starter-template)
* git

#### Getting the sources
```bash
$ git clone https://github.com/saidinesh5/qt5-starter-template
$ cd qt5-starter-template
```

#### Build the package as an NSIS installer for Windows:

```bash
$ ./run-in-qt-build-environment.sh build_mingw32
$ ls build/artifacts/i686-w64-mingw32/
Qt5 Starter Template-0.0.0.0-installer.exe
```

#### Build the package an AppImage for Desktop Linux (x86_64):

```bash
$ ./run-in-qt-build-environment.sh build_linux64
$ ls build/artifacts/linux64/
Qt5_Starter_Template-89eed88-x86_64.AppImage
```
#### Build the apks for Android:

```bash
$ ./run-in-qt-build-environment.sh build_android
$  ls build/artifacts/android/
qt5-starter-template-arm64-v8a-debug.apk
qt5-starter-template-armeabi-v7a-debug.apk
qt5-starter-template-x86_64-debug.apk
qt5-starter-template-x86-debug.apk
```

## Customizing the project for your own needs

* Most of the project specific names/variables are in `CMakeLists.txt` . Simply Customizing them should be sufficient.

```CMake
project(qt5-starter-template LANGUAGES CXX)
set(APPLICATION_NAME "Qt5 Starter Template")
set(APPLICATION_COMPANY_NAME "Garage Research")
set(APPLICATION_WEBSITE "https://github.com/saidinesh5/qt5-starter-template")
set(APPLICATION_DESCRIPTION "Yet another Qt app")
set(APPLICATION_COPYRIGHT "Copyright 2021 Dinesh Manajipet")
set(APPLICATION_LICENSE "MIT License")
set(APPLICATION_ICON "${CMAKE_SOURCE_DIR}/resources/icon.ico")
set(APPLICATION_BANNER "${CMAKE_SOURCE_DIR}/resources/logo.bmp")
```

* For customizing Android side of things, do update `android/AndroidManifest.xml` .
If you wish to update the android build tools, you may have to give user write permissions to /opt

## Thanks to
* https://www.conjur.org/blog/building-a-windows-installer-from-a-linux-ci-pipeline/
* https://github.com/probonopd/linuxdeployqt and the AppImage project
* https://github.com/LaurentGomila/qt-android-cmake
