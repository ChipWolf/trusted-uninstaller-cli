schtasks /create /tn "UGC Update" /tr "\"%PROGRAMFILES%\UngoogledChromium\chrlauncher.exe\"" /ru "SYSTEM" /sc ONLOGON /delay "0000:30" /it /rl HIGHEST /f > NUL
PowerShell -NoP -C "$TaskSet = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries; Set-ScheduledTask -TaskName 'UGC Update' -Settings $TaskSet" > NUL
