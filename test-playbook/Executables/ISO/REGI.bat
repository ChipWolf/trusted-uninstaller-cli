:: Remove Windows Media Player from default apps list
NSudoLC -U:T -P:E -M:S -Priority:RealTime -UseCurrentConsole -Wait CMD /c "for /f "usebackq delims=" %%A in (`reg query "HKU\HKLM-SOFTWARE-%AME_ISOGUID%\Classes" /f "WMP11*" ^| findstr /c:"WMP11"`) do reg delete "%%A" /f"
reg delete "HKU\HKLM-SOFTWARE-%AME_ISOGUID%\Classes\Applications\wmplayer.exe" /f

@echo off
for /f "usebackq delims=" %%A in (`reg query "HKU\HKLM-SOFTWARE-%AME_ISOGUID%\Classes" /k /f "AppX" ^| findstr /c:"AppX"`) do (
	reg query "%%A" /v "" | findstr /c:"DesktopStickerEditorCentennial" /c:"LogonWebHost" > NUL
		if not errorlevel 1 (
			echo reg delete "%%A" /f
			reg delete "%%A" /f
		)
)
@echo on
