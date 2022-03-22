@rem 사본 생성
copy "baserom.gba" "srmahjongd-kr.gba"

@rem 텍스트 처리
@del text.g.asm
tools\textproc charmap.tbl text ko 087c6500 text.g.asm

@rem 컴파일
tools\xkas -o "srmahjongd-kr.gba" main.asm

@pause
