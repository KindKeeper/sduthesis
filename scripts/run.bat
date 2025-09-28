@ECHO OFF

SET FILENAME=sduthesis
SET XL=xelatex
::SET BT=bibtex
SET PL=pdflatex

REM 所有操作基于项目主目录（脚本目录的父目录）
%XL% "%~dp0..\%FILENAME%"
::%BT% "%~dp0..\%FILENAME%.aux"
%PL% "%~dp0..\%FILENAME%"
%PL% "%~dp0..\%FILENAME%"
pause
CALL "%~dp0clean.bat"