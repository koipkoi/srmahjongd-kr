arch gba.thumb


////////////////////////////////////////////////////////////
// 확장 테스트
////////////////////////////////////////////////////////////
// org $0821e567
//     db $98, $72
//     db $99, $40
//     db $99, $41
//     db $9d, $41
//     db $a5, $90
//     db $a5, $9e


////////////////////////////////////////////////////////////
// 확장 코드 우회
////////////////////////////////////////////////////////////
org $08005fd4
    ldr r1, =#font_gfx_hack
    mov r15, r1
    nop
    nop
    nop
    nop
korean_font_gfx_return:


////////////////////////////////////////////////////////////
// 폰트 확장 코드
////////////////////////////////////////////////////////////
org $087b8700
font_gfx_hack:
    ldr r1, =#0x11a0
    cmp r0, r1
    bge .korean_font

.default_font:
    ldr  r3, =#0x02031ee0
    ldrb r2, [r5, #5]
    lsl r2, r2, #2
    add r2, r2, r3
    mov r1, #0x1a
    mul r1, r0
    ldr r0, [r2, #0]
    add r0, r0, r1
    add r7, r0, #2
    b .return

.korean_font:
    ldr r1, =#0x11a0
    sub r0, r0, r1
    ldr  r7, =#korean_font_gfx
    mov r1, #0x18
    mul r1, r0
    add r7, r7, r1
    add r7, r7, #2

// 우회하기전 코드의 다음 구문으로 돌아감
.return:
    ldr r1, =#korean_font_gfx_return
    mov r15, r1


////////////////////////////////////////////////////////////
// 기본 폰트 그래픽
////////////////////////////////////////////////////////////
org $082596f4
default_font:
    incbin gfx/default_font.1bpp


////////////////////////////////////////////////////////////
// 한글 폰트 그래픽
////////////////////////////////////////////////////////////
org $087b8800
korean_font_gfx:
    incbin gfx/korean_font.1bpp
