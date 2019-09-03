/*	Game: Fire Emblem: the Sacred Stones (US version)
 *	by laqieer
 *	2019-08-30
 */

	.equ ROM_BASE, 0x8000000
	.equ SRAM_BASE, 0xe000000
	
	.arm
	.global _start
_start:
	b load_save_backup
	.incbin	"../FireEmblem8U.gba", 4, 0x1c78 - 4
	/* load save backup from rom to sram when starting the game */
	.thumb
_8001c78:
	ldr r0,=#f_8fa0054
	bx r0
	/* todo: add the original SoftResetIfKeyCombo function */
	.ltorg
	.incbin	"../FireEmblem8U.gba", 0x1c78 + 2 * 2 + 4 * 1, 0x1000000 - (0x1c78 + 2 * 2 + 4 * 1)
	.arm
load_save_backup:
	ldr sp,=#0x3007f00
/*	mov r0,#0xfc
	mov r0,r0,lsl#16
	mov r1,#ROM_BASE
	orr r0,r0,r1	*/
	ldr r0,=save_backup_area
	/* devkitpro tool chain adds a string "dkARM" in the end of the rom (8 byte) */
	add r0,r0,#8
	mov r1,#SRAM_BASE
	mov r2,#0x10
	mov r2,r2,lsl#12
loop:
	ldrb r3,[r0]
	ldrb r4,[r0]
	cmp r3,r4
	bne loop
	strb r3,[r1]
	add r1,r1,#1
	add r0,r0,#1
	subs r2,r2,#1
	bne loop
	ldr r0,=0x8000204
	bx r0

	.thumb
	.thumb_func
f_8fa0054:
	push {lr}
	push {r1-r7}
	ldr r0,=#0x3005d90
	ldr r0,[r0]
	add r0,#0x11
	str r0,[sp]
	ldr r4,=#0x3005d90
	ldr r4,[r4]
	add r4,#0x9a
	add r3,r4,#1
	ldr r7,=#0x201f000
	ldrb r5,[r7]
	ldrb r0,[r0]
	add r2,r7,#1
	cmp r5,r0
	beq l_8fa00ac
	strb r0,[r7]
	ldrb r0,[r2]
	add r6,r0,#1
	lsl r0,r6,#0x18
	lsr r0,r0,#0x18
	strb r0,[r2]
	cmp r0,#0x3b
	ble l_8fa00ac
	mov r6,#0
	strb r6,[r2]
	ldrb r6,[r3]
	sub r6,r6,#1
	lsl r1,r6,#0x18
	lsr r1,r1,#0x18
	cmp r1,#0xff
	bne l_8fa00aa
	mov r6,#0x3b
	strb r6,[r3]
	ldrb r6,[r4]
	sub r6,r6,#1
	and r1,r6
	cmp r1,#0xff
	bne l_8fa00a6
	mov r1,#0x17
	bl f_8fa00be
l_8fa00a6:
	strb r1,[r4]
	b l_8fa00ac
l_8fa00aa:
	strb r1,[r3]
l_8fa00ac:
	pop {r1-r7}
	pop {r0}
	bx r0

	.thumb
	.thumb_func
f_8fa00be:
	push {r0-r2}
	ldr r0,=#0x3005de0
	ldr r0,[r0]
	add r0,#0x98
	ldrh r1,[r0]
	sub r1,r1,#1
	mov r2,#0x94
	cmp r1,r2
	blt l_8fa00d2
	ldr r1,=#0xffff
l_8fa00d2:
	strh r1,[r0]
	pop {r0-r2}
	mov pc,lr
	
	.ltorg

	.align
save_backup_area:

