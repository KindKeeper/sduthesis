@ECHO off

REM 使用脚本所在目录的父目录（即项目主目录）作为工作目录进行清理
DEL /q "%~dp0..\*.log" "%~dp0..\*.aux" "%~dp0..\*.out" "%~dp0..\*.thm" "%~dp0..\*.toc" "%~dp0..\*.lof" "%~dp0..\*.lot" "%~dp0..\*.blg" "%~dp0..\*.bbl" "%~dp0..\*.dvi" "%~dp0..\contents\*.log" "%~dp0..\*.toe"

:: PAUSE