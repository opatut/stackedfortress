lib\7z.exe a -r -tzip game.love data\
cd src\
..\lib\7z.exe a -r -tzip ..\game.love *
cd ..
if %PROCESSOR_ARCHITECTURE%==x86 (
  lib\windows32\love.exe game.love
) else (
  lib\windows64\love.exe game.love --console
)
