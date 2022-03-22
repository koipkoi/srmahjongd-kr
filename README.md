# 슈퍼 리얼 마작 동창회 한글화

슈퍼 리얼 마작 동창회 GBA 게임의 한글화 프로젝트입니다.

## 사용 도구

- [xkas-plus](https://github.com/devinacker/xkas-plus) : asm 코드 입력 도구
- [textproc](./tools/textproc) : 텍스트 전처리기

## 프로젝트 디렉터리 구조

- asm : 기능 구현에 필요한 asm 파일들이 있습니다.
- gfx : 그래픽과 관련된 파일들이 있습니다.
- text : 텍스트와 관련된 파일들이 있습니다.
- tools : 사용되는 도구가 있습니다.

## 빌드 방법

1. 해당 게임의 원본 바이너리 파일의 이름을 `baserom.gba`로 바꾸어서 프로젝트 상위에 저장시킵니다.

2. `build.bat`을 실행시키면 `srmahjongd-kr.gba` 파일명으로 결과물이 새로 생성됩니다.  
   (터미널 또는 명령 프롬프트에서 build를 실행해도 됩니다.)
