arch gba.thumb


////////////////////////////////////////////////////////////
// 폰트 주소 계산 우회 코드
////////////////////////////////////////////////////////////
org $08005fd4
font_address:
    ldr r1, [pc, #.data_table-font_address-4]
    mov r15, r1
.data_table:
    dd font_address_hack

org $08005fe6
font_address_resume:


////////////////////////////////////////////////////////////
// 반각 폰트 구현 - 1 우회 코드
////////////////////////////////////////////////////////////
org $08005fdc
font_width_add_0:
    ldr r7, [pc, #.data_table-font_width_add_0-4]
    mov r15, r7
.data_table:
    dd font_width_add_0_hack
    nop

org $08006042
    b font_width_add_0

org $08006058
    b font_width_add_0

org $08006068
    b font_width_add_0

org $08006072
    b font_width_add_0
    nop
    nop

org $080061d8
font_width_add_0_resume:


////////////////////////////////////////////////////////////
// 반각 폰트 구현 - 2 우회 코드
////////////////////////////////////////////////////////////
org $0801229c
font_width_add_1:
    ldr r4, [pc, #.data_table-font_width_add_1-4]
    mov r15, r4
.data_table:
    dd font_width_add_1_hack
    nop
    nop


////////////////////////////////////////////////////////////
// 확장 코드
////////////////////////////////////////////////////////////
org $087b8700

////////////////////////////////////////////////////////////
// 폰트 확장
////////////////////////////////////////////////////////////
font_address_hack:
    ldr r1, =#0x11a0
    cmp r0, r1
    bge .korean_font

.default_font:
    ldr r3, =#0x02031ee0
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
    ldr r7, =#korean_font_gfx
    mov r1, #0x18
    mul r1, r0
    add r7, r7, r1
    add r7, r7, #2

.return:
    ldr r1, =#font_address_resume
    mov r15, r1


////////////////////////////////////////////////////////////
// 반각 폰트 구현 - 1
////////////////////////////////////////////////////////////
font_width_add_0_hack:
    ldr r7, =#0xa59f
    cmp r4, r7
    bge .half_size

.full_size:
	mov r0, #0xc
	add r8, r0
    b .return

.half_size:
	mov r0, #0x8
	add r8, r0

.return:
    ldr r1, =#font_width_add_0_resume
    mov r15, r1


////////////////////////////////////////////////////////////
// 반각 폰트 구현 - 2
////////////////////////////////////////////////////////////
font_width_add_1_hack:
    ldr r0, [r6, #0x28]
    ldr r4, =#0xa59f
    cmp r5, r4
    bge .half_size

.full_size:
	add r0, #0xc
    b .return

.half_size:
	add r0, #0x8

.return:
    str r0, [r6, #0x28]
    pop {r4, r5, r6}
    pop {r0}
    bx r0

////////////////////////////////////////////////////////////
// 한글 폰트 그래픽
////////////////////////////////////////////////////////////
korean_font_gfx:
    incbin gfx/korean_font.1bpp
