@echo off
set /p major="Major version: "
set /p minor="Minor version: "
set /p patch="Patch version: "
powershell -File pack.ps1 -MajorVersion %major% -MinorVersion %minor% -PatchVersion %patch%
