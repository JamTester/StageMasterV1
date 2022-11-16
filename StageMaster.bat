
@echo off
powershell -command "&{$p='HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3';$v=(Get-ItemProperty -Path $p).Settings;$v[8]=2;&Set-ItemProperty -Path $p -Name Settings -Value $v;&Stop-Process -f -ProcessName explorer}
chdir > DIR.txt
set /p DIR=<DIR.txt
move DIR.TXT %temp%
echo %~nx0% > file.txt
set /p file=<file.txt
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    cd %temp%
    IF EXIST DIR.txt (
    del DIR.txt
    del file.txt
) ELSE (
    goto NotPresent
)
:NotPresent
    cd %DIR%
    start %file%
    exit /B
    exit
:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

powershell -command "&{$p='HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3';$v=(Get-ItemProperty -Path $p).Settings;$v[8]=3;&Set-ItemProperty -Path $p -Name Settings -Value $v;&Start-Process -f -ProcessName explorer}
setlocal enabledelayedexpansion
set list=windowsterminal cmd concent
for %%a in (!list!) do (
set process=%%a
taskkill /f /im !process!.exe
)
endlocal
exit /B
exit
