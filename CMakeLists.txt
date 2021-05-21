cmake_minimum_required(VERSION 3.14)

project(qt5-starter-template LANGUAGES CXX)
set(APPLICATION_NAME "Qt5 Starter Template")
set(APPLICATION_COMPANY_NAME "Garage Research")
set(APPLICATION_COMPANY_DOMAIN "garageresearch.net")
set(APPLICATION_WEBSITE "https://github.com/saidinesh5/qt5-starter-template")
set(APPLICATION_DESCRIPTION "Yet another Qt app")
set(APPLICATION_COPYRIGHT "Copyright 2021 Dinesh Manajipet")
set(APPLICATION_LICENSE "MIT License")
set(APPLICATION_ICON "${CMAKE_SOURCE_DIR}/resources/icon.ico")
set(APPLICATION_BANNER "${CMAKE_SOURCE_DIR}/resources/logo.bmp")

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

option(VERSION_FROM_GIT "Use the version from git" ON)
find_package(Git QUIET)
include(cmake/GetVersionFromGitTag.cmake)
configure_file(version.h.in version.h)

if (UNIX AND NOT APPLE)
    set(GNULINUX TRUE)
endif()

# QtCreator supports the following variables for Android, which are identical to qmake Android variables.
# Check https://doc.qt.io/qt/deployment-android.html for more information.
# They need to be set before the find_package(...) calls below.

#if(ANDROID)
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
#    if (ANDROID_ABI STREQUAL "armeabi-v7a")
#        set(ANDROID_EXTRA_LIBS
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libcrypto.so
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libssl.so)
#    endif()
#endif()

find_package(QT NAMES Qt5 COMPONENTS Core Quick LinguistTools REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Quick LinguistTools REQUIRED)

set(TS_FILES translations/translation_de_DE.ts)

set(PROJECT_SOURCES
        src/main.cpp
        src/qml/qml.qrc
        ${TS_FILES}
)

if(WIN32)
    configure_file(src/application.rc.in "${CMAKE_CURRENT_BINARY_DIR}/application.rc")
    list(APPEND PROJECT_SOURCES "${CMAKE_CURRENT_BINARY_DIR}/application.rc")
endif()

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(${PROJECT_NAME}
        ${PROJECT_SOURCES}
    )

    qt_create_translation(QM_FILES ${CMAKE_SOURCE_DIR}/src ${TS_FILES})
else()
    if(ANDROID)
        add_library(${PROJECT_NAME} SHARED ${PROJECT_SOURCES})
    elseif (WIN32)
        add_executable(${PROJECT_NAME} WIN32 ${PROJECT_SOURCES})
    else ()
        add_executable(${PROJECT_NAME} ${PROJECT_SOURCES})
    endif()

    qt5_create_translation(QM_FILES ${CMAKE_SOURCE_DIR}/src ${TS_FILES})
endif()

target_compile_definitions(${PROJECT_NAME}
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(${PROJECT_NAME}
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick)

if(${GNULINUX})
    install(TARGETS ${PROJECT_NAME} DESTINATION ${CMAKE_INSTALL_PREFIX}/usr/bin)
else()
    install(TARGETS ${PROJECT_NAME} DESTINATION ${CMAKE_INSTALL_PREFIX})
endif()

add_custom_target(OtherFiles DEPENDS ALL
                             SOURCES "README.md"
                                     "android/AndroidManifest.xml"
                                     "android/res/values/libs.xml"
)

# Packaging
if (WIN32)
    install(FILES resources/icon.ico DESTINATION ${CMAKE_INSTALL_PREFIX})
    set(NSIS_APP_NAME "${APPLICATION_NAME}")
    set(NSIS_COMPANY_NAME "${APPLICATION_COMPANY_NAME}")
    set(NSIS_APP_WEBSITE "${APPLICATION_WEBSITE}")
    set(NSIS_APP_DESCRIPTION "${APPLICATION_DESCRIPTION}")
    set(NSIS_APP_VERSION "${${PROJECT_NAME}_VERSION_MAJOR}.${${PROJECT_NAME}_VERSION_MINOR}.${${PROJECT_NAME}_VERSION_PATCH}.0")
    set(NSIS_APP_COPYRIGHT "${APPLICATION_COPYRIGHT}")
    set(NSIS_APP_MAIN_EXE ${PROJECT_NAME}.exe)
    set(NSIS_APP_ICON "${APPLICATION_ICON}")
    set(NSIS_APP_BANNER "${APPLICATION_BANNER}")
    set(NSIS_APP_LICENSE "${APPLICATION_LICENSE}")
    set(NSIS_APP_DIST_DIR "${CMAKE_INSTALL_PREFIX}")
    configure_file(packaging/installer.nsis.in installer.nsis @ONLY)
elseif(ANDROID)
    include(thirdparty/qt-android-cmake/AddQtAndroidApk.cmake)
    add_qt_android_apk(${PROJECT_NAME}_apk ${PROJECT_NAME}
                                       NAME ${APPLICATION_NAME}
                                       PACKAGE_SOURCES ${CMAKE_CURRENT_LIST_DIR}/android
                                       KEYSTORE ${ANDROID_KEYSTORE_FILE} ${ANDROID_KEYSTORE_ALIAS}
                                       KEYSTORE_PASSWORD ${ANDROID_KEYSTORE_PASSWORD})
elseif(${GNULINUX})
    set(APPIMAGE_APP_NAME "${APPLICATION_NAME}")
    set(APPIMAGE_APP_EXEC "${PROJECT_NAME}")
    set(APPIMAGE_APP_ICON "${PROJECT_NAME}")
    configure_file(resources/logo.svg "${CMAKE_BINARY_DIR}/${PROJECT_NAME}.svg" COPYONLY)
    configure_file(packaging/Application.desktop "${CMAKE_BINARY_DIR}/${PROJECT_NAME}.desktop")
    install(FILES "${CMAKE_BINARY_DIR}/${PROJECT_NAME}.svg"
                  "${CMAKE_BINARY_DIR}/${PROJECT_NAME}.desktop"
                  DESTINATION
                  ${CMAKE_INSTALL_PREFIX})
endif()
