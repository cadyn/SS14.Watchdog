#!/bin/bash
#SS14 Watchdog Installation Script

cd /tmp
git clone https://github.com/space-wizards/SS14.Watchdog.git
cd SS14.Watchdog
mkdir /tmp/source
mkdir /tmp/app
cd /tmp/source
mkdir SS14.Watchdog
mkdir SS14.Watchdog.Tests
cp /tmp/SS14.Watchdog/*.sln .
cp /tmp/SS14.Watchdog/SS14.Watchdog/*.csproj ./SS14.Watchdog/
cp /tmp/SS14.Watchdog/SS14.Watchdog.Tests/*.csproj ./SS14.Watchdog.Tests/
dotnet restore -r linux-x64

cp -r /tmp/SS14.Watchdog/SS14.Watchdog/* ./SS14.Watchdog/
cp -r /tmp/SS14.Watchdog/SS14.Watchdog.Tests/* ./SS14.Watchdog.Tests/
cd SS14.Watchdog
dotnet publish -c release -r linux-x64 -o /tmp/app --no-self-contained --no-restore

cp -r /tmp/app/* /mnt/server
