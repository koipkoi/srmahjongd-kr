@echo off

if exist srmahjongd-kr.gba (
    @echo del srmahjongd-kr.gba
    @del srmahjongd-kr.gba
)

@echo copy "baserom.gba" "srmahjongd-kr.gba"
copy "baserom.gba" "srmahjongd-kr.gba" || goto :exit

@echo tools\textproc charmap.tbl text ko 087c6500 text.g.asm
tools\textproc charmap.tbl text ko 087c6500 text.g.asm || goto :exit

@echo tools\xkas -o "srmahjongd-kr.gba" main.asm
tools\xkas -o "srmahjongd-kr.gba" main.asm || goto :exit

@echo done

:exit
@pause
