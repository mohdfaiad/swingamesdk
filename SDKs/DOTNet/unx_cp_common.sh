#!/bin/sh

cp ../../Base/All/* ./Mono/C#

if [ -d ./Mono/C#/Resources ]
then
	mkdir ./Mono/C#/Resources
	mkdir ./Mono/C#/Resources/fonts
	mkdir ./Mono/C#/Resources/images
	mkdir ./Mono/C#/Resources/sounds
fi

cp ../../Base/All/Resources/* ./Mono/C#/Resources 
cp ../../Base/All/Resources/fonts/* ./Mono/C#/Resources/fonts
cp ../../Base/All/Resources/images/* ./Mono/C#/Resources/images
cp ../../Base/All/Resources/sounds/* ./Mono/C#/Resources/sounds
cp ../../Base/DOTNet/*.cs ./Mono/C#

if [ -d ./Mono/C#/Properties ]
then
	mkdir ./Mono/C#/Properties
fi
cp ../../Base/DOTNet/Properties/* ./Mono/C#/Properties