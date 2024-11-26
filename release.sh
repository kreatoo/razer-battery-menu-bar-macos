#!/bin/bash

export APPLE_ID=""
export APPLE_ID_PASSWORD=""

xcodebuild

mkdir out
mv build/Release/razer-battery-menu-bar.app out/razer-battery-menu-bar.app


if [[ -z $APPLE_ID ]]
then
  codesign -s - --deep --force ./out/razer-battery-menu-bar.app
fi

unset APPLE_ID
unset APPLE_ID_PASSWORD

rm -rf build