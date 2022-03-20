@rem 사본 생성
copy "baserom.gba" "srmahjongd-kr.gba"

@rem 컴파일
tools\xkas -o "srmahjongd-kr.gba" main.asm

@pause
