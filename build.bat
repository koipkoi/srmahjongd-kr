@echo off

@echo copy "baserom.gba" "srmahjongd-kr.gba"
copy "baserom.gba" "srmahjongd-kr.gba" || (echo baserom.gba 파일이 없습니다. && goto :exit)

@echo del text.g.asm
@del text.g.asm
@echo tools\textproc charmap.tbl text ko 087c6500 text.g.asm
@del text.g.asm
tools\textproc charmap.tbl text ko 087c6500 text.g.asm || goto :exit

@echo tools\xkas -o "srmahjongd-kr.gba" main.asm
tools\xkas -o "srmahjongd-kr.gba" main.asm || goto :exit

@echo done

:exit
@pause
