	@Game: Fire Emblem: the Sacred Stones (US version)
	@by laqieer
	@2019-08-30

	.equ ROM_BASE, 0x8000000
	.equ SRAM_BASE, 0xe000000
	
	.arm
	.global _start
_start:
	b load_save_backup
	.incbin	"../FireEmblem8U.gba", 4, 0x1000000 - 4
	/* load save backup from rom to sram when starting the game */
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

	.ltorg

	.align
save_backup_area:

