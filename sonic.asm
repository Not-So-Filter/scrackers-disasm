; ===========================================================================
; Originally disassembled by: MarkeyJester (DrXInsanity)
; Redisassembly by: Filter
; Special thanks to:
; -> Hivebrain (for SCHG sonic crackers location guide on SonicRetro)
; -> Malevolence (for the SST Object defining/labling)

	cpu 68000

fixBugs = 0
;	| If 1, fixes some bugs (mainly sound driver related)
zeroOffsetOptimization = 0
;	| If 1, makes a handful of zero-offset instructions smaller
; Include SMPS2ASM, for expressing SMPS bytecode in a portable and human-readable form.
SonicDriverVer = 3 ; Tell SMPS2ASM that we are targetting Sonic 3's sound driver
	include "sound/_smps2asm_inc.asm"
        include "MacroSetup.asm"
	include "Macros.asm"
	include "Constants.asm"
	include "Variables.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Sonic Crackers Disassembly
; ---------------------------------------------------------------------------

RomStart:	dc.l v_systemstack&$FFFFFF,	EntryPoint,	ErrorTrap,	ErrorTrap
		dc.l ErrorTrap,	ErrorTrap,	ErrorTrap,	ErrorTrap
		dc.l ErrorTrap,	unk_C81E,	unk_C812,	unk_C818
		dc.l ErrorTrap,	ErrorTrap,	ErrorTrap,	ErrorTrap
		dc.l ErrorTrap,	ErrorTrap,	ErrorTrap,	ErrorTrap
		dc.l ErrorTrap,	ErrorTrap,	ErrorTrap,	ErrorTrap
		dc.l unk_C824,	ErrorTrap,	unk_C82A,	ErrorTrap
		dc.l unk_C836,	ErrorTrap,	unk_C830,	ErrorTrap
		dc.l ErrorTrap,	ErrorTrap,	ErrorTrap,	ErrorTrap
		dc.l ErrorTrap,	ErrorTrap,	ErrorTrap,	ErrorTrap
		dc.l ErrorTrap,	ErrorTrap,	ErrorTrap,	ErrorTrap
		dc.l ErrorTrap,	ErrorTrap,	ErrorTrap,	ErrorTrap
		dc.l ErrorTrap,	ErrorTrap,	ErrorTrap,	ErrorTrap
		dc.l ErrorTrap,	ErrorTrap,	ErrorTrap,	ErrorTrap
		dc.l ErrorTrap,	ErrorTrap,	ErrorTrap,	ErrorTrap
		dc.l ErrorTrap,	ErrorTrap,	ErrorTrap,	ErrorTrap
ConsoleName:	dc.b "SEGA MEGA DRIVE "
ProductDate:	dc.b "(C)SEGA 1994.JUL"
LocalTitle:	dc.b "SONIC STUDIUM                                   "
InterTitle:	dc.b "SONIC STUDIUM                                   "
SerialNo:	dc.b "GM XXXXXXXX-XX"
Checksum:	dc.w 0
IOS:		dc.b "J               "
ROM_Start:	dc.l RomStart
ROM_Finish:	dc.l $1FFFFF
RAM_Start:	dc.l v_startofram&$FFFFFF
RAM_Finish:	dc.l $FFFFFF
SRAMSupport:	dc.l $20202020
SRAM_Start:	dc.l $20202020
SRAM_Finish:	dc.l $20202020
ProductNotes:	dc.b "                                                    "
RegionsFor:	dc.b "JUE             "
; ===========================================================================
; ---------------------------------------------------------------------------
; Beginning Entry Point of Game
; ---------------------------------------------------------------------------

EntryPoint:
		tst.l	(z80_port_1_control).l
		bne.s	loc_20E
		tst.w	(z80_expansion_control).l

loc_20E:
		bne.s	loc_28C
		lea	SetupValues(pc),a5
		movem.w	(a5)+,d5-d7
		movem.l	(a5)+,a0-a4
		move.b	-$10FF(a1),d0
		andi.b	#$F,d0
		beq.s	loc_22E
		move.l	#"SEGA",$2F00(a1)

loc_22E:
		move.w	(a4),d0
		moveq	#0,d0
		movea.l	d0,a6
		move.l	a6,usp
		moveq	#$17,d1

loc_238:
		move.b	(a5)+,d5
		move.w	d5,(a4)
		add.w	d7,d5
		dbf	d1,loc_238
		move.l	(a5)+,(a4)
		move.w	d0,(a3)
		move.w	d7,(a1)
		move.w	d7,(a2)

loc_24A:
		btst	d0,(a1)
		bne.s	loc_24A
		moveq	#$25,d2

loc_250:
		move.b	(a5)+,(a0)+
		dbf	d2,loc_250
		move.w	d0,(a2)
		move.w	d0,(a1)
		move.w	d7,(a2)

loc_25C:
		move.l	d0,-(a6)
		dbf	d6,loc_25C
		move.l	(a5)+,(a4)
		move.l	(a5)+,(a4)
		moveq	#$1F,d3

loc_268:
		move.l	d0,(a3)
		dbf	d3,loc_268
		move.l	(a5)+,(a4)
		moveq	#$13,d4

loc_272:
		move.l	d0,(a3)
		dbf	d4,loc_272
		moveq	#3,d5

loc_27A:
		move.b	(a5)+,$11(a3)
		dbf	d5,loc_27A
		move.w	d0,(a2)
		movem.l	(a6),d0-a6
		disable_ints

loc_28C:
		bra.s	GameProgram

; ===========================================================================
; ---------------------------------------------------------------------------
SetupValues:	dc.w $8000				; VDP register Start
		dc.w $3FFF				; Repeat times for clearing 68k ram
		dc.w $100				; VDP register Number increase (Used for Z80 functioning too)

		dc.l z80_ram				; Z80 Ram start
		dc.l z80_bus_request			; Z80 Bus port
		dc.l z80_reset				; Z80 reset port
		dc.l vdp_data_port			; VDP Data port
		dc.l vdp_control_port			; VDP Address port

		dc.b 4					; 8004
		dc.b $14				; 8114 Display Value
		dc.b $30				; 8230 FG Scroll
		dc.b $3C				; 833C Window
		dc.b 7					; 8407 BG Scroll
		dc.b $6C				; 856C Sprite Table
		dc.b 0					; 8600
		dc.b 0					; 8700 Background Colour (Backdrop)
		dc.b 0					; 8800
		dc.b 0					; 8900
		dc.b $FF				; 8AFF Horizontal Interupt
		dc.b 0					; 8B00 Scroll type
		dc.b $81				; 8C81 40 Cell Display
		dc.b $37				; 8D37 Horizontal Scroll
		dc.b 0					; 8E00
		dc.b 1					; 8F01 VDP Increment on/off
		dc.b 1					; 9001 64 Cell Display (Out of screen extended)
		dc.b 0					; 9100 Window horizontal position
		dc.b 0					; 9200 Window vertical position
		dc.b $FF				; 93FF DMA Registers
		dc.b $FF				; 94FF ""
		dc.b 0					; 9500 ""
		dc.b 0					; 9600 ""
		dc.b $80				; 9780 ""

		dc.l $40000080

		dc.b $AF,$01,$D9,$1F,$11,$27,$00,$21,$26,$00 ; Z80 Instruction Values
		dc.b $F9,$77,$ED,$B0,$DD,$E1,$FD,$E1,$ED,$47
		dc.b $ED,$4F,$D1,$E1,$F1,$08,$D9,$C1,$D1,$E1
		dc.b $F1,$F9,$F3,$ED,$56,$36,$E9,$E9

		dc.w $8104,$8F02			; Display and increment register values
		dc.l $C0000000				; VDP CRam address
		dc.l $40000010
		dc.b $9F,$BF,$DF,$FF			; PSG Values
		even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Game Start
; ---------------------------------------------------------------------------

GameProgram:
		tst.w	(vdp_control_port).l
		lea	($FFFFFFC0).w,a0
		move.l	(a0),d0
		cmpi.l	#"SEGA",d0
		bne.s	loc_326
		move.b	($A10009).l,d0
		and.b	($A1000B).l,d0
		and.b	($A1000D).l,d0
		btst	#6,d0
		bne.s	loc_336

loc_326:
		moveq	#$F,d0
		lea	(a0),a1

loc_32A:
		clr.l	(a1)+
		dbf	d0,loc_32A
		move.l	#"SEGA",(a0)

loc_336:
		moveq	#0,d0				; clear registers (d0 to d6 and a2)
		moveq	#0,d1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5
		moveq	#0,d6
		movea.w	d0,a2
		move.w	#$7FD,d7

loc_34A:
		movem.l	d0-d6/a2,-(a0)
		dbf	d7,loc_34A
		lea	(unk_C800).w,a0
		move.w	#$4EF9,d0			; machine code for 'jmp'
		lea	UnknownRout001(pc),a1		; routine used here just has an 'rts'...
		moveq	#2,d7

loc_360:
		move.w	d0,(a0)+
		move.l	a1,(a0)+
		dbf	d7,loc_360			; the result from this is 'jmp	UnknownRout001'
		lea	UnknownRout000(pc),a1		; routine used here just has 'rte'...
		moveq	#6,d7

loc_36E:
		move.w	d0,(a0)+
		move.l	a1,(a0)+
		dbf	d7,loc_36E
		moveq	#$40,d0
		move.b	d0,($A10009).l
		move.b	d0,($A1000B).l
		move.b	d0,($A1000D).l

loc_38A:
		move.w	(vdp_control_port).l,d0
		btst	#1,d0				; is DMA running?
		bne.s	loc_38A				; if not, wait until it's finished
		lea	(vdp_data_port).l,a0
		move.w	#$8F02,(vdp_control_port).l
		move.w	#$8F02,($FFFFC9D6).w
		moveq	#0,d0				; clear d0
		move.l	#$40000000,(vdp_control_port).l	; set VDP in VRAM write mode
		move.w	#$FFF,d1			; set repeat times

Clear_VRam01:
		move.l	d0,(a0)				; clear VRam
		move.l	d0,(a0)
		move.l	d0,(a0)
		move.l	d0,(a0)
		dbf	d1,Clear_VRam01			; repeat til VRam is cleared
		move.l	#$C0000000,(vdp_control_port).l	; set VDP in CRAM write mode
		move.w	#7,d1				; set repeat times

Clear_CRam:
		move.l	d0,(a0)				; clear CRAM
		move.l	d0,(a0)
		move.l	d0,(a0)
		move.l	d0,(a0)
		dbf	d1,Clear_CRam			; repeat til CRAM is cleared
		move.l	#$40000010,(vdp_control_port).l	; set VDP mode
		move.w	#4,d1				; set repeat times

Clear_VRam02:
		move.l	d0,(a0)				; clear VDP stuff
		move.l	d0,(a0)
		move.l	d0,(a0)
		move.l	d0,(a0)
		dbf	d1,Clear_VRam02			; repeat til VDP stuff is cleared
		lea	VDPSetupArray(pc),a0		; load VDP setup values address to a0
		jsr	(sub_8D0).l
		resetZ80				; reset the Z80
		move	#$2000,sr			; set the stack register

MAINPROGLOOP:
		jsr	(MAINPROG).w			; jump to the actual loop (really should be a jmp since there's no way for it to return)
		bra.s	MAINPROGLOOP			; loop indefinitely

; ===========================================================================
; ---------------------------------------------------------------------------
UnknownRout000:
		rte
; ---------------------------------------------------------------------------
UnknownRout001:
		rts
; ---------------------------------------------------------------------------
ErrorTrap:
		nop					; Delay
		nop					; Delay
		bra.s	ErrorTrap			; Trap
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
VDPSetupArray:	dc.w $8004
		dc.w $8104				; Display mode
		dc.w $8230				; FG Scroll
		dc.w $832C				; Window
		dc.w $8407				; BG Scroll
		dc.w $8578				; Sprite Table
		dc.w $8600
		dc.w $8730				; Background Colour (Backdrop)
		dc.w $8800
		dc.w $8900
		dc.w $8A00				; Horizontal Interupt
		dc.w $8B00				; Scroll type
		dc.w $8C81				; 40 Cell Display
		dc.w $8D34				; Horizontal Scroll
		dc.w $8E00
		dc.w $8F02				; VDP Increment on
		dc.w $9001				; 64 Cell Display (Out of screen extended)
		dc.w $9100				; Window horizontal position
		dc.w $9200				; Window vertical position
		dc.w 0
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; subroutine to setup the VDP (Palettes, etc) via DMA
; ---------------------------------------------------------------------------

VDPSetup_01:
		stopZ80
		waitZ80
		move.w	#$8F02,(vdp_control_port).l	; set VDP Increment
		move.w	#$8F02,($FFFFC9D6).w
		lea	(vdp_control_port).l,a0		; load VDP address port to a0
		ori.w	#$8114,($FFFFC9BA).w
		move.w	($FFFFC9BA).w,(a0)
		lea	VDPClearArr_01(pc),a1		; load VDP values address to a1
		move.w	(a1)+,(a0)			; dump DMA values to VDP
		move.w	(a1),(a0)
		move.w	#$9500,d0			; prepare VDP DMA register value in d0
		lea	VDPClearArr_02(pc),a1		; load location just after VDP values to a1
		moveq	#2,d1				; set repeat times

VDPClr_SetDMA:
		move.b	-(a1),d0			; get end value, dump to d0 and move back
		move.w	d0,(a0)				; dump Complete Register value to VDP
		addi.w	#$100,d0			; increase to next register value
		dbf	d1,VDPClr_SetDMA		; repeat 2 more times
		move.w	#$C000,(a0)
		move.w	#$0080,-(sp)
		move.w	(sp)+,(a0)
		andi.w	#$FFEF,($FFFFC9BA).w
		move.w	($FFFFC9BA).w,(a0)
		startZ80
		move.l	#$C0000000,(vdp_control_port).l	; set VDP in CRam write mode
		move.w	($FFFFD3E4).w,-4(a0)		; move colour value in ram to VDP
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
VDPClearArr_01:	dc.w $9340,$9400			; DMA Transfer Size (0040 x 2 = 0080)
		dc.l $7FE9F2				; DMA Transfer "From" location  (7FE9F2 x 2 = FFD3E4)
VDPClearArr_02: even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; another subroutine to set some VDP values
; ---------------------------------------------------------------------------

VDPSetup_02:
		lea	(vdp_control_port).l,a4		; load VDP address port to a4
		moveq	#0,d3				; clear d3
		stopZ80
		waitZ80
		move.w	($FFFFC9BA).w,d0
		bset	#4,d0
		move.w	d0,(a4)
		move.w	#$8F02,(vdp_control_port).l	; set VDP Increment
		move.w	#$8F02,($FFFFC9D6).w
		lea	($FFFFD4F8).w,a1
		move.w	(a1)+,d7			; load repeat times to d7
		bra.s	loc_542

loc_506:
		lea	VDPVAL003(pc),a0
		movem.w	(a0),d0-d4
		addq.l	#6,a0
		move.b	(a1)+,d1
		move.b	(a1)+,d0
		move.b	(a1)+,d4
		move.b	(a1)+,d4
		move.b	(a1)+,d3
		move.b	(a1)+,d2
		move.w	d0,(a4)
		move.w	d1,(a4)
		move.w	d2,(a4)
		move.w	d3,(a4)
		move.w	d4,(a4)
		move.w	(a1)+,(a4)
		move.w	(a1)+,d1
		ori.w	#$80,d1
		move.w	d1,-(sp)
		move.w	(sp)+,(a4)
		move.l	-(a1),d1
		move.w	d1,(a4)
		move.l	-(a1),d1
		lsl.l	#1,d1
		movea.l	d1,a2
		move.w	(a2),-4(a4)
		addq.w	#8,a1

loc_542:
		dbf	d7,loc_506
		move.w	($FFFFC9BA).w,d1
		bclr	#4,d1
		move.w	d1,(a4)
		startZ80
		clr.w	($FFFFD4F8).w
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
VDPVAL003:	dc.w $9300				; DMA register values (Blank)
		dc.w $9400
		dc.w $9500
		dc.w $9600
		dc.w $9700
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

sub_568:
		moveq	#0,d3
		move.w	d2,d3
		add.w	d2,d3
		add.l	d0,d3
		eor.l	d0,d3
		btst	#$11,d3
		beq.s	sub_5A6
		eor.l	d0,d3
		move.l	d3,d4
		andi.l	#$FFFE0000,d4
		move.l	d4,d5
		sub.l	d0,d4
		move.w	d4,d6
		add.w	d1,d6
		move.w	d4,d2
		lsr.w	#1,d2
		move.l	d3,d7
		sub.l	d5,d7
		lsr.w	#1,d7
		movem.l	d5-d7,-(sp)
		bsr.w	sub_5A6
		movem.l	(sp)+,d5-d7
		move.l	d5,d0
		move.l	d6,d1
		move.l	d7,d2

sub_5A6:
		moveq	#0,d3
		lea	($FFFFD4F8).w,a0
		move.w	(a0)+,d3
		cmpi.w	#$10,d3
		bcs.s	loc_5B6
		rts

loc_5B6:
		moveq	#0,d4
		move.w	d3,d4
		bra.s	loc_5C0

loc_5BC:
		adda.w	#$A,a0

loc_5C0:
		dbf	d4,loc_5BC
		move.w	d2,(a0)+
		andi.l	#$FFFFFF,d0
		lsr.l	#1,d0
		move.l	d0,(a0)+
		andi.l	#$FFFF,d1
		lsl.l	#2,d1
		lsr.w	#2,d1
		ori.w	#$4000,d1
		swap	d1
		move.l	d1,(a0)
		addq.w	#1,($FFFFD4F8).w
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

sub_5E8:
		moveq	#0,d3
		move.w	d2,d3
		add.w	d2,d3
		add.l	d0,d3
		eor.l	d0,d3
		btst	#$11,d3
		beq.s	sub_626
		eor.l	d0,d3
		move.l	d3,d4
		andi.l	#$FFFE0000,d4
		move.l	d4,d5
		sub.l	d0,d4
		move.w	d4,d6
		add.w	d1,d6
		move.w	d4,d2
		lsr.w	#1,d2
		move.l	d3,d7
		sub.l	d5,d7
		lsr.w	#1,d7
		movem.l	d5-d7,-(sp)
		bsr.w	sub_626
		movem.l	(sp)+,d5-d7
		move.l	d5,d0
		move.l	d6,d1
		move.l	d7,d2

sub_626:
		move.l	d0,d6
		andi.l	#$FFFFFF,d0
		lsr.l	#1,d0
		move.w	d1,d3
		andi.w	#$3FFF,d3
		ori.w	#$4000,d3
		rol.w	#2,d1
		andi.w	#3,d1
		lea	(vdp_control_port).l,a0
		stopZ80
		waitZ80
		move.w	($FFFFC9BA).w,d4
		bset	#4,d4
		move.w	d4,(a0)
		move.w	#$8F02,(vdp_control_port).l
		move.w	#$8F02,($FFFFC9D6).w
		move.w	d2,d4
		move.w	#$9300,d5
		move.b	d4,d5
		move.w	d5,(a0)
		rol.w	#8,d2
		move.w	#$9400,d5
		move.b	d2,d5
		move.w	d5,(a0)
		move.l	d0,d2
		move.w	#$9500,d5
		move.b	d2,d5
		move.w	d5,(a0)
		rol.w	#8,d2
		move.w	#$9600,d5
		move.b	d2,d5
		move.w	d5,(a0)
		swap	d2
		move.w	#$9700,d5
		move.b	d2,d5
		move.w	d5,(a0)
		move.w	d3,(a0)
		move.w	d1,d2
		ori.w	#$80,d2
		move.w	d2,-(sp)
		move.w	(sp)+,(a0)
		move.w	d3,(a0)
		move.w	d1,(a0)
		movea.l	d6,a1
		move.w	(a1),-4(a0)			; points to vdp_data_port
		move.w	($FFFFC9BA).w,d4
		bclr	#4,d4
		move.w	d4,(a0)
		startZ80
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

sub_6CC:
		move.b	($FFFFD4E4).w,d1
		bne.s	loc_6E0
		move.b	d0,($FFFFD4E4).w
		move.b	d0,($FFFFD4E6).w
		move.b	#8,($FFFFD4E5).w

loc_6E0:
		subq.b	#1,($FFFFD4E6).w
		beq.s	loc_6E8
		rts

loc_6E8:
		move.b	($FFFFD4E4).w,($FFFFD4E6).w
		bsr.s	sub_6FE
		subq.b	#1,($FFFFD4E5).w
		bne.s	locret_6FC
		move.b	#0,($FFFFD4E4).w

locret_6FC:
		rts

sub_6FE:
		lea	($FFFFD3E4).w,a0
		move.w	#$40,d3
		subq.w	#1,d3

loc_708:
		move.w	(a0),d2
		move.w	d2,d0
		bsr.s	sub_72C
		move.w	d0,d1
		move.w	d2,d0
		lsr.w	#4,d0
		bsr.s	sub_72C
		lsl.w	#4,d0
		or.w	d0,d1
		move.w	d2,d0
		lsr.w	#8,d0
		bsr.s	sub_72C
		lsl.w	#8,d0
		or.w	d0,d1
		move.w	d1,(a0)+
		dbf	d3,loc_708
		rts

sub_72C:
		andi.w	#$F,d0
		beq.s	locret_734
		subq.w	#2,d0

locret_734:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Unused subroutine
; ---------------------------------------------------------------------------

		move.b	($FFFFD4E7).w,d1
		bne.s	loc_750
		move.b	d0,($FFFFD4E7).w
		move.b	d0,($FFFFD4E8).w
		move.b	#8,($FFFFD4E9).w
		move.w	#$E,($FFFFD4EA).w

loc_750:
		subq.b	#1,($FFFFD4E8).w
		beq.s	loc_758
		rts

loc_758:
		move.b	($FFFFD4E7).w,($FFFFD4E8).w
		bsr.s	sub_76E
		subq.b	#1,($FFFFD4E9).w
		bne.s	locret_76C
		move.b	#0,($FFFFD4E7).w

locret_76C:
		rts

sub_76E:
		lea	($FFFFD3E4).w,a0
		lea	($FFFFD464).w,a1
		move.w	($FFFFD4EA).w,d2
		move.w	#$3F,d7

loc_77E:
		move.w	(a1)+,d0
		move.w	d0,d1
		andi.w	#$F,d1
		cmp.w	d2,d1
		bls.s	loc_78C
		addq.w	#2,(a0)

loc_78C:
		move.w	d2,d3
		lsl.w	#4,d3
		move.w	d0,d1
		andi.w	#$F0,d1
		cmp.w	d3,d1
		bls.s	loc_79E
		addi.w	#$20,(a0)

loc_79E:
		move.w	d0,d1
		move.w	d2,d3
		lsl.w	#8,d3
		andi.w	#$F00,d1
		cmp.w	d3,d1
		bls.s	loc_7B0
		addi.w	#$200,(a0)

loc_7B0:
		adda.l	#2,a0
		dbf	d7,loc_77E
		subq.w	#2,($FFFFD4EA).w
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Unused subroutine
; ---------------------------------------------------------------------------

		move.b	($FFFFD4EC).w,d2
		bne.s	loc_7DC
		move.b	d0,($FFFFD4EC).w
		move.b	d0,($FFFFD4ED).w
		subq.b	#1,d1
		move.b	d1,($FFFFD4EE).w
		move.l	a1,($FFFFD4F0).w
		move.l	a2,($FFFFD4F4).w

loc_7DC:
		subq.b	#1,($FFFFD4ED).w
		bne.s	locret_7EC
		move.b	($FFFFD4EC).w,($FFFFD4ED).w
		bsr.w	sub_7EE

locret_7EC:
		rts

sub_7EE:
		movea.l	($FFFFD4F0).w,a1
		movea.l	($FFFFD4F4).w,a2
		moveq	#0,d6
		move.b	($FFFFD4EE).w,d6
		moveq	#0,d7

loc_7FE:
		moveq	#0,d5
		move.w	(a1)+,d0
		move.w	(a2),d1
		move.w	#$200,d4
		move.w	d0,d2
		move.w	d1,d3
		andi.w	#$F00,d2
		andi.w	#$F00,d3
		cmp.w	d2,d3
		beq.s	loc_820
		bcs.s	loc_81C
		neg.w	d4

loc_81C:
		add.w	d4,d3
		addq.w	#1,d7

loc_820:
		or.w	d3,d5
		move.w	#$20,d4
		move.w	d0,d2
		move.w	d1,d3
		andi.w	#$F0,d2
		andi.w	#$F0,d3
		cmp.w	d2,d3
		beq.s	loc_83E
		bcs.s	loc_83A
		neg.w	d4

loc_83A:
		add.w	d4,d3
		addq.w	#1,d7

loc_83E:
		or.w	d3,d5
		move.w	#2,d4
		move.w	d0,d2
		move.w	d1,d3
		andi.w	#$F,d2
		andi.w	#$F,d3
		cmp.w	d2,d3
		beq.s	loc_85C
		bcs.s	loc_858
		neg.w	d4

loc_858:
		add.w	d4,d3
		addq.w	#1,d7

loc_85C:
		or.w	d3,d5
		move.w	d5,(a2)+
		dbf	d6,loc_7FE
		tst.w	d7
		bne.s	locret_86C
		clr.b	($FFFFD4EC).w

locret_86C:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

sub_86E:
		lea	(vdp_data_port).l,a1
		moveq	#0,d6
		move.w	($FFFFD820).w,d6
		swap	d6
		subq.w	#1,d0
		subq.w	#1,d1
		lsl.l	#2,d3
		lsr.w	#2,d3
		ori.w	#$4000,d3
		swap	d3
		andi.w	#3,d3

loc_88E:
		move.l	d3,4(a1)
		move.w	d0,d5

loc_894:
		move.w	d2,(a1)
		dbf	d5,loc_894
		add.l	d6,d3
		dbf	d1,loc_88E
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to Map tiles to Screen in VDP
; ---------------------------------------------------------------------------

MapScreen:
		lea	(vdp_data_port).l,a0		; load VDP data port to a0
		moveq	#0,d6				; clear d6
		move.w	($FFFFD820).w,d6		; load number of tiles to increase to for each set of columns to d6
		swap	d6				; swap words (Sets it to left for long-word amount)

loc_8B0:
		move.l	d0,4(a0)			; set to VDP register
		move.w	d1,d5				; load number of columns to d5

loc_8B6:
		move.w	(a1)+,d4			; load map
		add.w	d3,d4				; add colour/plane/flip (Render Flag)
		move.w	d4,(a0)				; dump to VRam
		dbf	d5,loc_8B6			; repeat til columns are dumped
		add.l	d6,d0				; increase VRam location for next set of columns
		dbf	d2,loc_8B0			; repeat til all rows are dumped
		cmp.w	d0,d0				; ?? Probably left in by accident
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
		ori	#1,ccr
		rts
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

sub_8D0:
		lea	($FFFFC9B8).w,a1

loc_8D4:
		move.w	(a0),d0
		beq.s	loc_8FA
		moveq	#$7F,d1
		and.b	(a0),d1
		cmpi.b	#$13,d1
		bge.s	loc_8F0
		add.w	d1,d1
		move.w	(a0),(a1,d1.w)
		move.w	(a0)+,(vdp_control_port).l
		bra.s	loc_8D4

loc_8F0:
		addq.w	#2,a0
		bra.s	loc_8D4

; ===========================================================================
; ---------------------------------------------------------------------------
		ori	#1,ccr
		rts
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

loc_8FA:
		lea	4(a1),a1
		move.w	(a1)+,d0
		lsl.w	#2,d0
		lsl.w	#8,d0
		move.w	d0,($FFFFD816).w
		move.w	(a1)+,d0
		lsl.w	#2,d0
		lsl.w	#8,d0
		move.w	d0,($FFFFD81E).w
		move.w	(a1)+,d0
		lsl.w	#5,d0
		lsl.w	#8,d0
		move.w	d0,($FFFFD818).w
		move.w	(a1),d0
		lsl.w	#1,d0
		lsl.w	#8,d0
		move.w	d0,($FFFFD81A).w
		move.w	($FFFFC9D2).w,d0
		lsl.w	#2,d0
		lsl.w	#8,d0
		move.w	d0,($FFFFD81C).w
		cmp.w	d0,d0
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Unused Subroutine to initiate the control ports
; appears leftover from somewhere
; ---------------------------------------------------------------------------

ControlInit_Unused:
		move.b	#1,(z80_reset).l
		stopZ80
		waitZ80
		moveq	#$40,d0				; prepare Initiation value
		move.b	d0,($A10009).l			; ...dump to Control Port A
		move.b	d0,($A1000B).l			; ...Control Port B
		move.b	d0,($A1000D).l			; ...and Extra port
		startZ80
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

sub_96E:
		lea	(unk_C938).w,a1
		lea	($A10003).l,a0
		lea	(unk_C936).w,a2
		bsr.w	sub_9D4
		lea	($A10005).l,a0
		lea	(unk_C937).w,a2
		bsr.w	sub_9D4
		bsr.s	sub_992
		rts

sub_992:
		moveq	#7,d0
		cmpi.b	#7,(unk_C936).w
		bne.s	loc_9A0
		subq.w	#4,d0
		bra.s	loc_9A2

loc_9A0:
		subq.w	#1,d0

loc_9A2:
		cmpi.b	#7,(unk_C937).w
		bne.s	loc_9B0
		subq.w	#4,d0
		bcs.s	locret_9D2
		bra.s	loc_9B2

loc_9B0:
		subq.w	#1,d0

loc_9B2:
		move.b	#$F,(a1)
		clr.b	1(a1)
		clr.w	2(a1)
		clr.l	4(a1)
		clr.l	8(a1)
		clr.l	$C(a1)
		lea	$10(a1),a1
		dbf	d0,loc_9B2

locret_9D2:
		rts

sub_9D4:
		bsr.w	sub_A06
		move.b	d0,(a2)
		andi.w	#$E,d0
		add.w	d0,d0
		jsr	loc_9E6(pc,d0.w)
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
loc_9E6:	nop
		rts
; ---------------------------------------------------------------------------
		bra.w	loc_A5A

; ---------------------------------------------------------------------------
		nop
		rts
; ---------------------------------------------------------------------------
		bra.w	loc_C70

; ---------------------------------------------------------------------------
		nop
		rts
; ---------------------------------------------------------------------------
		nop
		rts
; ---------------------------------------------------------------------------
		bra.w	loc_B30

; ---------------------------------------------------------------------------
		bra.w	loc_BBA

; ---------------------------------------------------------------------------
; ===========================================================================

sub_A06:
		stopZ80
		move.b	#$40,6(a0)
		move.b	#$40,(a0)
		moveq	#0,d0
		moveq	#0,d1
		moveq	#$F,d2
		nop
		move.b	(a0),d1
		and.b	d1,d2
		swap	d1
		or.b	byte_A4A(pc,d2.w),d0
		move.b	#0,(a0)
		lsl.w	#2,d0
		moveq	#$F,d2
		nop
		move.b	(a0),d1
		and.b	d1,d2
		or.b	byte_A4A(pc,d2.w),d0
		move.b	#$40,(a0)
		startZ80
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
byte_A4A:	dc.b $00,$01,$01,$01
		dc.b $02,$03,$03,$03
		dc.b $02,$03,$03,$03
		dc.b $02,$03,$03,$03
; ---------------------------------------------------------------------------
; ===========================================================================

loc_A5A:
		_move.b	#2,0(a1)
		move.w	#$FF,d7
		stopZ80
		move.b	#$60,6(a0)
		move.b	#$20,(a0)
		btst	#4,(a0)
		beq.s	loc_AAC
		bsr.w	sub_C48
		bcs.w	loc_AAC
		moveq	#0,d6
		bsr.w	sub_C2E
		bcs.w	loc_AAC
		bsr.w	sub_ACA
		move.b	#$60,(a0)

loc_A96:
		btst	#4,(a0)
		dbne	d7,loc_A96
		beq.w	loc_C62
		startZ80
		rts

loc_AAC:
		lea	$10(a1),a1
		move.b	#$60,(a0)

loc_AB4:
		btst	#4,(a0)
		dbne	d7,loc_AB4
		beq.w	loc_C62
		startZ80
		rts

sub_ACA:
		bsr.w	sub_C2E
		bcs.w	loc_C5C
		andi.w	#$F,d0
		move.b	d0,1(a1)
		bsr.w	sub_C2E
		bcs.w	loc_C5C
		andi.w	#$F,d0
		move.b	d0,2(a1)
		bsr.w	sub_C2E
		bcs.w	loc_C5C
		andi.w	#$F,d0
		move.b	d0,3(a1)
		bsr.w	sub_C2E
		bcs.w	loc_C5C
		andi.w	#$F,d0
		move.b	d0,4(a1)
		bsr.w	sub_C2E
		bcs.w	loc_C5C
		andi.w	#$F,d0
		move.b	d0,5(a1)
		bsr.w	sub_C2E
		bcs.w	loc_C5C
		andi.w	#$F,d0
		move.b	d0,6(a1)
		lea	$10(a1),a1
		rts

; ===========================================================================

loc_B30:
		stopZ80
		move.b	#$40,6(a0)
		moveq	#2,d3

loc_B40:
		move.l	d1,d0
		andi.b	#$F,d0
		beq.s	loc_B6E
		move.b	#$40,(a0)
		moveq	#0,d1
		nop
		nop
		nop
		move.b	(a0),d1
		move.b	#0,(a0)
		swap	d1
		nop
		nop
		nop
		_move.b	0(a0),d1
		dbf	d3,loc_B40
		bra.w	loc_BDA

loc_B6E:
		move.b	#$40,(a0)
		moveq	#0,d2
		_move.b	0(a0),d2
		move.b	#0,(a0)
		swap	d2
		_move.b	0(a0),d2
		startZ80
		_move.b	#1,0(a1)
		move.w	d1,d0
		swap	d1
		asl.b	#2,d0
		andi.w	#$C0,d0
		andi.w	#$3F,d1
		or.b	d1,d0
		not.b	d0
		bsr.w	sub_C0A
		swap	d2
		move.w	d2,d0
		not.b	d0
		andi.w	#$F,d0
		bsr.w	sub_C1C
		lea	$10(a1),a1
		rts

loc_BBA:
		_move.b	#$F,0(a1)
		clr.b	1(a1)
		clr.w	2(a1)
		clr.l	4(a1)
		clr.l	8(a1)
		clr.l	$C(a1)
		lea	$10(a1),a1
		rts

loc_BDA:
		_clr.b	0(a1)
		move.b	#$40,6(a0)
		move.w	d1,d0
		swap	d1
		move.b	#$40,(a0)
		startZ80
		asl.b	#2,d0
		andi.w	#$C0,d0
		andi.w	#$3F,d1
		or.b	d1,d0
		not.b	d0
		bsr.s	sub_C0A
		lea	$10(a1),a1
		rts


sub_C0A:
		move.b	4(a1),d1
		eor.b	d0,d1
		move.b	d0,4(a1)
		and.b	d0,d1
		move.b	d1,5(a1)
		rts

sub_C1C:
		move.b	3(a1),d1
		eor.b	d0,d1
		move.b	d0,3(a1)
		and.b	d0,d1
		move.b	d1,6(a1)
		rts

sub_C2E:
		bchg	#0,d6
		bne.s	sub_C48

loc_C34:
		move.b	#$20,(a0)

loc_C38:
		move.b	(a0),d0
		btst	#4,d0
		dbne	d7,loc_C38
		beq.s	loc_C5C
		move.b	(a0),d0
		rts

sub_C48:
		move.b	#0,(a0)

loc_C4C:
		move.b	(a0),d0
		btst	#4,d0
		dbeq	d7,loc_C4C
		bne.s	loc_C5C
		move.b	(a0),d0
		rts

loc_C5C:
		ori	#1,ccr
		rts

loc_C62:
		startZ80
		ori	#1,ccr
		rts

; ===========================================================================

loc_C70:
		stopZ80
		move.b	#$20,(a0)
		move.b	#$60,6(a0)
		move.w	#$FF,d7
		btst	#4,(a0)
		beq.w	loc_D10
		bsr.s	sub_C48
		bcs.w	loc_D10
		andi.b	#$F,d0
		bsr.s	loc_C34
		bcs.w	loc_D10
		andi.b	#$F,d0
		bsr.s	sub_C48
		bcs.w	loc_D10
		andi.b	#$F,d0
		_move.b	d0,0(a1)
		bsr.s	loc_C34
		bcs.w	loc_D10
		andi.b	#$F,d0
		move.b	d0,$10(a1)
		bsr.s	sub_C48
		bcs.w	loc_D10
		andi.b	#$F,d0
		move.b	d0,$20(a1)
		moveq	#0,d6
		bsr.w	sub_C2E
		bcs.w	loc_D10
		andi.b	#$F,d0
		move.b	d0,$30(a1)
		bsr.s	sub_D3A
		bcs.w	loc_D10
		bsr.s	sub_D3A
		bcs.w	loc_D14
		bsr.s	sub_D3A
		bcs.w	loc_D18
		bsr.s	sub_D3A
		bcs.w	loc_D1C
		move.b	#$60,(a0)

loc_CFA:
		btst	#4,(a0)
		dbne	d7,loc_CFA
		beq.w	loc_C62
		startZ80
		rts

loc_D10:
		lea	$10(a1),a1

loc_D14:
		lea	$10(a1),a1

loc_D18:
		lea	$10(a1),a1

loc_D1C:
		lea	$10(a1),a1
		move.b	#$60,(a0)

loc_D24:
		btst	#4,(a0)
		dbne	d7,loc_D24
		beq.w	loc_C62
		startZ80
		rts

sub_D3A:
		moveq	#0,d0
		move.b	(a1),d0
		cmpi.b	#2,d0
		bhi.s	loc_D58
		add.w	d0,d0
		add.w	d0,d0
		jmp	loc_D4C(pc,d0.w)
; ===========================================================================
; ---------------------------------------------------------------------------
loc_D4C:	bra.w	loc_D98
		bra.w	loc_D72
		bra.w	sub_ACA
; ---------------------------------------------------------------------------
; ===========================================================================

loc_D58:
		clr.b	1(a1)
		clr.w	2(a1)
		clr.l	4(a1)
		clr.l	8(a1)
		clr.l	$C(a1)
		lea	$10(a1),a1
		rts

; ===========================================================================

loc_D72:
		bsr.w	sub_DAA
		bsr.w	sub_C2E
		bcs.w	loc_C5C
		not.b	d0
		andi.w	#$F,d0
		move.b	d0,d2
		move.b	d1,d0
		bsr.w	sub_C0A
		move.b	d2,d0
		bsr.w	sub_C1C
		lea	$10(a1),a1
		rts

loc_D98:
		bsr.s	sub_DAA
		bcs.w	loc_C5C
		move.b	d1,d0
		bsr.w	sub_C0A
		lea	$10(a1),a1
		rts

sub_DAA:
		bsr.w	sub_C2E
		bcs.w	loc_C5C
		andi.w	#$F,d0
		move.w	d0,d1
		bsr.w	sub_C2E
		bcs.w	loc_C5C
		asl.w	#4,d0
		or.b	d0,d1
		not.b	d1
		rts

; ===========================================================================

		include "_inc/Nemesis Decompression.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Unused subroutine
; ---------------------------------------------------------------------------

		lea	($FFFFD79A).w,a1

loc_EF8:
		tst.l	(a1)
		beq.s	loc_F00
		addq.w	#6,a1
		bra.s	loc_EF8

loc_F00:
		move.w	(a0)+,d0
		bmi.s	locret_F0C

loc_F04:
		move.l	(a0)+,(a1)+
		move.w	(a0)+,(a1)+
		dbf	d0,loc_F04

locret_F0C:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Unused subroutine
; ---------------------------------------------------------------------------

		bsr.s	sub_F22
		lea	($FFFFD79A).w,a1
		move.w	(a0)+,d0
		bmi.s	locret_F20

loc_F18:
		move.l	(a0)+,(a1)+
		move.w	(a0)+,(a1)+
		dbf	d0,loc_F18

locret_F20:
		rts

sub_F22:
		lea	($FFFFD79A).w,a1
		moveq	#$F,d0

loc_F28:
		clr.l	(a1)+
		clr.w	(a1)+
		dbf	d0,loc_F28
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Unused subroutine
; ---------------------------------------------------------------------------

		tst.l	($FFFFD79A).w
		beq.s	locret_F84
		tst.w	($FFFFD812).w
		bne.s	locret_F84
		movea.l	($FFFFD79A).w,a0
		lea	NemPCD_WriteRowToVDP(pc),a3
		lea	(v_ngfx_buffer).w,a1
		move.w	(a0)+,d2
		bpl.s	loc_F52
		adda.w	#NemPCD_WriteRowToVDP_XOR-NemPCD_WriteRowToVDP,a3

loc_F52:
		andi.w	#$7FFF,d2
		move.w	d2,($FFFFD812).w
		bsr.w	NemDec_BuildCodeTable
		move.b	(a0)+,d5
		asl.w	#8,d5
		move.b	(a0)+,d5
		moveq	#$10,d6
		moveq	#0,d0
		move.l	a0,($FFFFD79A).w
		move.l	a3,($FFFFD80E).w
		move.l	d0,($FFFFD7FA).w
		move.l	d0,($FFFFD7FE).w
		move.l	d0,($FFFFD802).w
		move.l	d5,($FFFFD806).w
		move.l	d6,($FFFFD80A).w

locret_F84:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Unused subroutine
; ---------------------------------------------------------------------------

		tst.w	($FFFFD812).w
		beq.w	locret_101E
		move.w	#6,($FFFFD814).w
		moveq	#0,d0
		move.w	($FFFFD79E).w,d0
		addi.w	#$C0,($FFFFD79E).w
		bra.s	loc_FBA

; ===========================================================================
; ---------------------------------------------------------------------------
; Unused subroutine to decompress and use art from Pattern Load Cues
; ---------------------------------------------------------------------------

		tst.w	($FFFFD812).w
		beq.s	locret_101E
		move.w	#3,($FFFFD814).w
		moveq	#0,d0
		move.w	($FFFFD79E).w,d0
		addi.w	#$60,($FFFFD79E).w

loc_FBA:
		lea	(vdp_control_port).l,a4
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(a4)
		subq.w	#4,a4
		movea.l	($FFFFD79A).w,a0
		move.l	($FFFFD7FA).w,d0
		move.l	($FFFFD7FE).w,d1
		move.l	($FFFFD802).w,d2
		move.l	($FFFFD806).w,d5
		move.l	($FFFFD80A).w,d6
		movea.l	($FFFFD80E).w,a3
		lea	(v_ngfx_buffer).w,a1

loc_FEE:
		movea.w	#8,a5
		bsr.w	NemPCD_NewRow
		subq.w	#1,($FFFFD812).w
		beq.s	loc_1020
		subq.w	#1,($FFFFD814).w
		bne.s	loc_FEE
		move.l	a0,($FFFFD79A).w
		move.l	d0,($FFFFD7FA).w
		move.l	d1,($FFFFD7FE).w
		move.l	d2,($FFFFD802).w
		move.l	d5,($FFFFD806).w
		move.l	d6,($FFFFD80A).w
		move.l	a3,($FFFFD80E).w

locret_101E:
		rts

loc_1020:
		lea	($FFFFD79A).w,a0
		moveq	#$15,d0

loc_1026:
		move.l	6(a0),(a0)+
		dbf	d0,loc_1026
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Unused subroutine to run Pattern Load Cues
; ---------------------------------------------------------------------------

		lea	(a0),a1
		move.w	(a1)+,d1

loc_1034:
		movea.l	(a1)+,a0
		moveq	#0,d0
		move.w	(a1)+,d0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(vdp_control_port).l
		movem.l	d1/a1,-(sp)
		bsr.w	NemDec
		movem.l	(sp)+,d1/a1
		dbf	d1,loc_1034
		rts

		include "_inc/Enigma Decompression.asm"
		include "_inc/Kosinski Decompression.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

sub_1272:
		bsr.w	sub_12FA
		move.w	d2,(a3)+
		bsr.w	sub_1312
		lsr.w	#4,d0
		lsr.w	#4,d1
		moveq	#0,d3
		move.b	6(a1),d3
		moveq	#$1F,d7

loc_1288:
		bsr.s	sub_12C2
		movea.l	$28(a1),a6
		bsr.w	sub_1416
		addq.w	#1,d0
		dbf	d7,loc_1288
		rts


sub_129A:
		bsr.w	sub_12FA
		move.w	d2,(a3)+
		bsr.w	sub_1312
		lsr.w	#4,d0
		lsr.w	#4,d1
		moveq	#0,d3
		move.b	6(a1),d3
		moveq	#$F,d7

loc_12B0:
		bsr.s	sub_12C2
		movea.l	$28(a1),a6
		bsr.w	sub_1348
		addq.w	#1,d1
		dbf	d7,loc_12B0
		rts

sub_12C2:
		move.w	d0,d4
		move.w	d1,d5
		movea.l	$20(a1),a6
		lsr.w	#3,d4
		lsr.w	#3,d5
		lsl.w	d3,d5
		add.w	d5,d4
		move.b	(a6,d4.w),d4
		andi.w	#$FF,d4
		movea.l	$24(a1),a6
		lsl.w	#7,d4
		move.w	d0,d5
		add.w	d5,d5
		andi.w	#$E,d5
		add.w	d5,d4
		move.w	d1,d5
		lsl.w	#4,d5
		andi.w	#$70,d5
		add.w	d5,d4
		move.w	(a6,d4.w),d4
		rts


sub_12FA:
		move.w	d0,d2
		move.w	d1,d3
		lsl.w	#4,d3
		andi.w	#$F00,d3
		lsr.w	#2,d2
		andi.w	#$7C,d2
		add.w	d3,d2
		or.w	$18(a1),d2
		rts

sub_1312:
		_move.w	0(a1),d2
		move.w	$10(a1),d3
		lsl.w	#4,d3
		andi.w	#$F00,d3
		move.w	#$1000,d4
		sub.w	d3,d4
		andi.w	#$F00,d4
		lsr.w	#8,d4
		move.b	d4,$17(a1)
		lsr.w	#2,d2
		andi.w	#$7C,d2
		move.w	#$80,d4
		sub.w	d2,d4
		andi.w	#$7C,d4
		lsr.w	#2,d4
		move.b	d4,7(a1)
		rts

sub_1348:
		btst	#$A,d4
		beq.s	loc_1358
		btst	#$B,d4
		bne.w	loc_13E4
		bra.s	loc_1380

loc_1358:
		btst	#$B,d4
		bne.s	loc_13B2
		andi.w	#$3FF,d4
		lsl.w	#3,d4
		move.w	(a6,d4.w),d5
		swap	d5
		move.w	4(a6,d4.w),d5
		move.l	d5,(a3)+
		move.w	2(a6,d4.w),d5
		swap	d5
		move.w	6(a6,d4.w),d5
		move.l	d5,$3C(a3)
		rts

loc_1380:
		andi.w	#$3FF,d4
		lsl.w	#3,d4
		move.w	2(a6,d4.w),d5
		eori.w	#$800,d5
		swap	d5
		move.w	6(a6,d4.w),d5
		eori.w	#$800,d5
		move.l	d5,(a3)+
		move.w	(a6,d4.w),d5
		eori.w	#$800,d5
		swap	d5
		move.w	4(a6,d4.w),d5
		eori.w	#$800,d5
		move.l	d5,$3C(a3)
		rts

loc_13B2:
		andi.w	#$3FF,d4
		lsl.w	#3,d4
		move.w	4(a6,d4.w),d5
		eori.w	#$1000,d5
		swap	d5
		move.w	(a6,d4.w),d5
		eori.w	#$1000,d5
		move.l	d5,(a3)+
		move.w	6(a6,d4.w),d5
		eori.w	#$1000,d5
		swap	d5
		move.w	2(a6,d4.w),d5
		eori.w	#$1000,d5
		move.l	d5,$3C(a3)
		rts

loc_13E4:
		andi.w	#$3FF,d4
		lsl.w	#3,d4
		move.w	6(a6,d4.w),d5
		eori.w	#$1800,d5
		swap	d5
		move.w	2(a6,d4.w),d5
		eori.w	#$1800,d5
		move.l	d5,(a3)+
		move.w	4(a6,d4.w),d5
		eori.w	#$1800,d5
		swap	d5
		move.w	(a6,d4.w),d5
		eori.w	#$1800,d5
		move.l	d5,$3C(a3)
		rts

sub_1416:
		btst	#$A,d4
		beq.s	loc_1426
		btst	#$B,d4
		bne.w	loc_14B2
		bra.s	loc_144E

loc_1426:
		btst	#$B,d4
		bne.s	loc_1480
		andi.w	#$3FF,d4

loc_1430:
		lsl.w	#3,d4
		move.w	(a6,d4.w),d5
		swap	d5
		move.w	2(a6,d4.w),d5
		move.l	d5,(a3)+
		move.w	4(a6,d4.w),d5
		swap	d5
		move.w	6(a6,d4.w),d5
		move.l	d5,$7C(a3)
		rts

loc_144E:
		andi.w	#$3FF,d4
		lsl.w	#3,d4
		move.w	2(a6,d4.w),d5
		eori.w	#$800,d5
		swap	d5
		move.w	(a6,d4.w),d5
		eori.w	#$800,d5
		move.l	d5,(a3)+
		move.w	6(a6,d4.w),d5
		eori.w	#$800,d5
		swap	d5
		move.w	4(a6,d4.w),d5
		eori.w	#$800,d5
		move.l	d5,$7C(a3)
		rts

loc_1480:
		andi.w	#$3FF,d4
		lsl.w	#3,d4
		move.w	4(a6,d4.w),d5
		eori.w	#$1000,d5
		swap	d5
		move.w	6(a6,d4.w),d5
		eori.w	#$1000,d5
		move.l	d5,(a3)+
		move.w	(a6,d4.w),d5
		eori.w	#$1000,d5
		swap	d5
		move.w	2(a6,d4.w),d5
		eori.w	#$1000,d5
		move.l	d5,$7C(a3)
		rts

loc_14B2:
		andi.w	#$3FF,d4
		lsl.w	#3,d4
		move.w	6(a6,d4.w),d5
		eori.w	#$1800,d5
		swap	d5
		move.w	4(a6,d4.w),d5
		eori.w	#$1800,d5
		move.l	d5,(a3)+
		move.w	2(a6,d4.w),d5
		eori.w	#$1800,d5
		swap	d5
		move.w	(a6,d4.w),d5
		eori.w	#$1800,d5
		move.l	d5,$7C(a3)
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

sub_14E4:
		lea	(vdp_control_port).l,a1
		lea	-4(a1),a2
		move.w	$18(a5),d3
		move.w	$1A(a5),d4
		move.w	(a4),d0
		beq.w	loc_1570
		move.w	#0,(a4)+
		move.w	#$8F80,(vdp_control_port).l
		move.w	#$8F80,($FFFFC9D6).w
		move.w	d0,d1
		moveq	#$F,d7
		moveq	#0,d6
		move.b	$17(a5),d6
		sub.w	d6,d7
		move.w	d0,(a1)
		move.w	d4,(a1)
		bra.s	loc_1522

loc_1520:
		move.l	(a4)+,(a2)

loc_1522:
		dbf	d6,loc_1520
		move.w	d3,d2
		addi.w	#$7C,d2
		and.w	d2,d0
		move.w	d0,(a1)
		move.w	d4,(a1)

loc_1532:
		move.l	(a4)+,(a2)
		dbf	d7,loc_1532
		addq.w	#2,d1
		moveq	#$F,d7
		moveq	#0,d6
		move.b	$17(a5),d6
		sub.w	d6,d7
		move.w	d1,(a1)
		move.w	d4,(a1)
		bra.s	loc_154C

loc_154A:
		move.l	(a4)+,(a2)

loc_154C:
		dbf	d6,loc_154A
		move.w	d3,d2
		addi.w	#$7E,d2
		and.w	d2,d1
		move.w	d1,(a1)
		move.w	d4,(a1)

loc_155C:
		move.l	(a4)+,(a2)
		dbf	d7,loc_155C
		move.w	#$8F02,(vdp_control_port).l
		move.w	#$8F02,($FFFFC9D6).w

loc_1570:
		move.w	(a3),d0
		beq.s	locret_15CE
		move.w	#0,(a3)+
		move.w	d0,d1
		moveq	#$1F,d7
		moveq	#0,d6
		move.b	7(a5),d6
		sub.w	d6,d7
		move.w	d0,(a1)
		move.w	d4,(a1)
		bra.s	loc_158C

loc_158A:
		move.l	(a3)+,(a2)

loc_158C:
		dbf	d6,loc_158A
		move.w	d3,d2
		addi.w	#$F00,d2
		and.w	d2,d0
		move.w	d0,(a1)
		move.w	d4,(a1)

loc_159C:
		move.l	(a3)+,(a2)
		dbf	d7,loc_159C
		addi.w	#$80,d1
		moveq	#$1F,d7
		moveq	#0,d6
		move.b	7(a5),d6
		sub.w	d6,d7
		move.w	d1,(a1)
		move.w	d4,(a1)
		bra.s	loc_15B8

loc_15B6:
		move.l	(a3)+,(a2)

loc_15B8:
		dbf	d6,loc_15B6
		move.w	d3,d2
		addi.w	#$F80,d2
		and.w	d2,d1
		move.w	d1,(a1)
		move.w	d4,(a1)

loc_15C8:
		move.l	(a3)+,(a2)
		dbf	d7,loc_15C8

locret_15CE:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

sub_15D0:
		moveq	#0,d0
		lea	($FFFFD84C).w,a0
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.w	#$7FFF,(a0)+
		lea	($FFAD08).l,a0
		move.w	#$400,d1

loc_15EE:
		move.l	d0,(a0)+
		dbf	d1,loc_15EE
		lea	($FFAD08).l,a0
		moveq	#$3F,d7
		move.w	a0,($FFFFD84C).w

loc_1600:
		lea	$40(a0),a1
		move.w	a1,(a0)
		movea.l	a1,a0
		dbf	d7,loc_1600
		clr.w	-$40(a0)
		lea	($FFFFD164).w,a0
		moveq	#$4F,d1

loc_1616:
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		dbf	d1,loc_1616
		move.l	d0,($FFFFD9F2).w
		move.l	d0,($FFFFD9F6).w
		move.w	#3,($FFFFD83C).w
		move.w	#$F,($FFFFD840).w
		move.w	#$1F,($FFFFD844).w
		move.w	#$3F,($FFFFD848).w
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

; We think this subroutine is responsible for building object sprites

BuildSprites:
		lea	($FFFFD164).w,a6
		moveq	#0,d6
		lea	($FFFFD3E4).w,a5
		moveq	#$4F,d5
		lea	($FFFFD9F2).w,a4

loc_1650:
		move.l	(a4)+,d0
		move.l	d0,(a6)+
		move.l	(a4)+,(a6)+
		addq.w	#1,d6
		tst.b	d0
		bne.s	loc_1650
		move.b	d6,-5(a6)
		lea	($FFFFD850).w,a4

loc_1664:
		move.w	(a4)+,d0
		bmi.s	loc_1684
		beq.s	loc_1664
		move.b	#$4F,-5(a6)
		cmpi.w	#$4F,d5
		bne.s	loc_167E
		moveq	#0,d0
		move.l	d0,-(a5)
		move.l	d0,-(a5)
		rts
loc_167E:
		clr.b	3(a5)
		rts

loc_1684:
		movea.w	d0,a0
		jsr	(sub_19DA).l
		tst.b	5(a0)
		bpl.s	loc_16BA
		move.w	d2,$14(a0)
		move.w	d3,$16(a0)
		movea.l	$10(a0),a3
		move.b	$20(a0),d0
		andi.w	#$18,d0
		move.w	$20(a0),d4
		move.w	d4,d7
		andi.w	#$7FF,d4
		sub.w	d4,d7
		tst.w	4(a0)
		jsr	loc_16C0(pc,d0.w)

loc_16BA:
		move.w	(a0),d0
		bmi.s	loc_1684
		bra.s	loc_1664

; ===========================================================================
; ---------------------------------------------------------------------------
loc_16C0:	bmi.w	loc_16E0
		bra.w	loc_17FC
; ---------------------------------------------------------------------------
		bmi.w	loc_1716
		bra.w	loc_1832
; ---------------------------------------------------------------------------
		bmi.w	loc_1756
		bra.w	loc_1872
; ---------------------------------------------------------------------------
		bmi.w	loc_17B4
		bra.w	loc_18D0
; ---------------------------------------------------------------------------
; ===========================================================================

loc_16E0:
		cmp.w	d5,d6
		bcc.s	locret_1714
		addq.w	#1,d6
		move.w	(a3)+,d0
		move.w	d0,d1
		ext.w	d0
		add.w	d3,d0
		swap	d0
		move.w	d1,d0
		move.b	d6,d0
		move.l	d0,(a6)+
		move.w	(a3)+,d0
		add.w	d4,d0
		eor.w	d7,d0
		swap	d0
		move.b	(a3)+,d0
		ext.w	d0
		add.w	d2,d0
		andi.w	#$1FF,d0
		bne.s	loc_170E
		move.w	#1,d0

loc_170E:
		move.l	d0,(a6)+
		tst.b	(a3)+
		beq.s	loc_16E0

locret_1714:
		rts
; ===========================================================================

loc_1716:
		cmp.w	d5,d6
		bcc.s	locret_1754
		addq.w	#1,d6
		move.w	(a3)+,d0
		move.w	d0,d1
		ext.w	d0
		add.w	d3,d0
		swap	d0
		move.w	d1,d0
		move.b	d6,d0
		move.l	d0,(a6)+
		move.w	(a3)+,d0
		add.w	d4,d0
		eor.w	d7,d0
		swap	d0
		sub.w	d0,d0
		move.b	-4(a3),d0
		move.b	byte_1794(pc,d0.w),d0
		sub.b	(a3)+,d0
		ext.w	d0
		add.w	d2,d0
		andi.w	#$1FF,d0
		bne.s	loc_174E
		move.w	#1,d0

loc_174E:
		move.l	d0,(a6)+
		tst.b	(a3)+
		beq.s	loc_1716

locret_1754:
		rts
; ===========================================================================

loc_1756:
		cmp.w	d5,d6
		bcc.s	locret_1792
		addq.w	#1,d6
		moveq	#0,d0
		move.b	(a3),d0
		move.w	(a3)+,d1
		move.b	byte_17A4(pc,d0.w),d0
		sub.b	d1,d0
		ext.w	d0
		add.w	d3,d0
		swap	d0
		move.w	d1,d0
		move.b	d6,d0
		move.l	d0,(a6)+
		move.w	(a3)+,d0
		add.w	d4,d0
		eor.w	d7,d0
		swap	d0
		move.b	(a3)+,d0
		ext.w	d0
		add.w	d2,d0
		andi.w	#$1FF,d0
		bne.s	loc_178C
		move.w	#1,d0

loc_178C:
		move.l	d0,(a6)+
		tst.b	(a3)+
		beq.s	loc_1756

locret_1792:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
byte_1794:	dc.b $F8,$F8,$F8,$F8
		dc.b $F0,$F0,$F0,$F0
		dc.b $E8,$E8,$E8,$E8
		dc.b $E0,$E0,$E0,$E0
byte_17A4:	dc.b $F8,$F0,$E8,$E0
		dc.b $F8,$F0,$E8,$E0
		dc.b $F8,$F0,$E8,$E0
		dc.b $F8,$F0,$E8,$E0
		even
; ---------------------------------------------------------------------------
; ===========================================================================

loc_17B4:
		cmp.w	d5,d6
		bcc.s	locret_17FA
		addq.w	#1,d6
		moveq	#0,d0
		move.b	(a3),d0
		move.w	(a3)+,d1
		move.b	byte_17A4(pc,d0.w),d0
		sub.b	d1,d0
		ext.w	d0
		add.w	d3,d0
		swap	d0
		move.w	d1,d0
		move.b	d6,d0
		move.l	d0,(a6)+
		move.w	(a3)+,d0
		add.w	d4,d0
		eor.w	d7,d0
		swap	d0
		sub.w	d0,d0
		move.b	-4(a3),d0
		move.b	byte_1794(pc,d0.w),d0
		sub.b	(a3)+,d0
		ext.w	d0
		add.w	d2,d0
		andi.w	#$1FF,d0
		bne.s	loc_17F4
		move.w	#1,d0

loc_17F4:
		move.l	d0,(a6)+
		tst.b	(a3)+
		beq.s	loc_17B4

locret_17FA:
		rts

; ===========================================================================

loc_17FC:
		cmp.w	d6,d5
		bls.s	locret_1830
		subq.w	#1,d5
		move.w	(a3)+,d0
		move.w	d0,d1
		ext.w	d1
		add.w	d3,d1
		swap	d1
		move.w	d0,d1
		move.b	d5,d1
		move.w	(a3)+,d0
		add.w	d4,d0
		eor.w	d7,d0
		swap	d0
		move.b	(a3)+,d0
		ext.w	d0
		add.w	d2,d0
		andi.w	#$1FF,d0
		bne.s	loc_1828
		move.w	#1,d0

loc_1828:
		move.l	d0,-(a5)
		move.l	d1,-(a5)
		tst.b	(a3)+
		beq.s	loc_17FC

locret_1830:
		rts

; ===========================================================================

loc_1832:
		cmp.w	d6,d5
		bls.s	locret_1870
		subq.w	#1,d5
		move.w	(a3)+,d0
		move.w	d0,d1
		ext.w	d1
		add.w	d3,d1
		swap	d1
		move.w	d0,d1
		move.b	d5,d1
		move.w	(a3)+,d0
		add.w	d4,d0
		eor.w	d7,d0
		swap	d0
		sub.w	d0,d0
		move.b	-4(a3),d0
		move.b	byte_18B0(pc,d0.w),d0
		sub.b	(a3)+,d0
		ext.w	d0
		add.w	d2,d0
		andi.w	#$1FF,d0
		bne.s	loc_1868
		move.w	#1,d0

loc_1868:
		move.l	d0,-(a5)
		move.l	d1,-(a5)
		tst.b	(a3)+
		beq.s	loc_1832

locret_1870:
		rts

; ===========================================================================

loc_1872:
		cmp.w	d6,d5
		bls.s	locret_18AE
		subq.w	#1,d5
		moveq	#0,d1
		move.b	(a3),d1
		move.w	(a3)+,d0
		move.b	byte_18C0(pc,d1.w),d1
		sub.b	d0,d1
		ext.w	d1
		add.w	d3,d1
		swap	d1
		move.w	d0,d1
		move.b	d5,d1
		move.w	(a3)+,d0
		add.w	d4,d0
		eor.w	d7,d0
		swap	d0
		move.b	(a3)+,d0
		ext.w	d0
		add.w	d2,d0
		andi.w	#$1FF,d0
		bne.s	loc_18A6
		move.w	#1,d0

loc_18A6:
		move.l	d0,-(a5)
		move.l	d1,-(a5)
		tst.b	(a3)+
		beq.s	loc_1872

locret_18AE:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
byte_18B0:	dc.b $F8,$F8,$F8,$F8
		dc.b $F0,$F0,$F0,$F0
		dc.b $E8,$E8,$E8,$E8
		dc.b $E0,$E0,$E0,$E0
byte_18C0:	dc.b $F8,$F0,$E8,$E0
		dc.b $F8,$F0,$E8,$E0
		dc.b $F8,$F0,$E8,$E0
		dc.b $F8,$F0,$E8,$E0
		even
; ---------------------------------------------------------------------------
; ===========================================================================

loc_18D0:
		cmp.w	d6,d5
		bls.s	locret_1916
		subq.w	#1,d5
		moveq	#0,d1
		move.b	(a3),d1
		move.w	(a3)+,d0
		move.b	byte_18C0(pc,d1.w),d1
		sub.b	d0,d1
		ext.w	d1
		add.w	d3,d1
		swap	d1
		move.w	d0,d1
		move.b	d5,d1
		move.w	(a3)+,d0
		add.w	d4,d0
		eor.w	d7,d0
		swap	d0
		sub.w	d0,d0
		move.b	-4(a3),d0
		move.b	byte_18B0(pc,d0.w),d0
		sub.b	(a3)+,d0
		ext.w	d0
		add.w	d2,d0
		andi.w	#$1FF,d0
		bne.s	loc_190E
		move.w	#1,d0

loc_190E:
		move.l	d0,-(a5)
		move.l	d1,-(a5)
		tst.b	(a3)+
		beq.s	loc_18D0

locret_1916:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

sub_1918:
		move.l	d7,-(sp)
		lea	($FFFFD83C).w,a0
		move.w	-4(a0,d0.w),d7
		lea	($FFFFD84C).w,a0
		adda.w	d0,a0
		tst.w	($FFFFD84C).w
		beq.s	loc_193E
		tst.l	d0
		bpl.s	loc_1934
		moveq	#-1,d7

loc_1934:
		tst.w	(a0)
		beq.s	loc_1946
		movea.w	(a0),a0
		dbf	d7,loc_1934

loc_193E:
		move.l	(sp)+,d7
		ori	#8,sr
		rts

loc_1946:
		move.w	($FFFFD84C).w,(a0)
		move.w	a0,d7
		movea.w	(a0),a0
		move.w	(a0),($FFFFD84C).w
		clr.w	(a0)
		move.w	d7,2(a0)
		move.w	#$8000,4(a0)
		move.l	#data_197A,$10(a0)
		moveq	#0,d7
		move.l	d7,$20(a0)
		move.l	d7,8(a0)
		move.l	d7,$C(a0)
		movem.l	(sp)+,d7
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
data_197A:
		dc.b $00,$00
		dc.b $00,$00
		dc.b $00,$FF
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

sub_1980:
		move.l	a1,-(sp)
		tst.w	(a6)
		bpl.s	loc_198E
		movea.w	(a6),a1
		move.w	2(a6),2(a1)

loc_198E:
		movea.w	2(a6),a1
		move.w	(a6),(a1)
		move.w	($FFFFD84C).w,(a6)
		move.w	a6,($FFFFD84C).w
		movea.l	a1,a6
		movea.l	(sp)+,a1
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Unused subroutine
; ---------------------------------------------------------------------------
		move.l	a1,-(sp)
		tst.w	(a6)
		bpl.s	loc_19B0
		movea.w	(a6),a1
		move.w	2(a6),2(a1)

loc_19B0:
		movea.w	2(a6),a1
		move.w	(a6),(a1)
		movea.w	(a0),a1
		move.w	a1,(a6)
		move.w	a0,2(a6)
		move.w	a6,(a0)
		move.w	a6,2(a1)
		movea.l	(sp)+,a1
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Unused subroutine
; ---------------------------------------------------------------------------
		move.l	$18(a6),d0
		add.l	d0,8(a6)
		move.l	$1C(a6),d0
		add.l	d0,$C(a6)
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

sub_19DA:
		moveq	#0,d1
		move.w	8(a0),d2
		sub.w	($FFFFC9DE).w,d2
		cmpi.w	#$FFC0,d2
		bge.s	loc_19EC
		moveq	#$40,d1

loc_19EC:
		cmpi.w	#$180,d2
		blt.s	loc_19F4
		moveq	#$40,d1

loc_19F4:
		addi.w	#$80,d2
		move.w	$C(a0),d3
		sub.w	($FFFFC9EE).w,d3
		cmpi.w	#$FFC0,d3
		bge.s	loc_1A08
		moveq	#$40,d1

loc_1A08:
		cmpi.w	#$120,d3
		blt.s	loc_1A10
		moveq	#$40,d1

loc_1A10:
		addi.w	#$80,d3
		andi.w	#$FFBF,4(a0)
		or.w	d1,4(a0)
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Unused subroutine
; ---------------------------------------------------------------------------

		bsr.w	sub_1A3C
		move.w	d7,d1
		add.w	d0,d1
		move.w	d6,d0
		move.w	d4,d2
		move.w	d5,d3
		move.w	a3,d4
		move.w	(a0),d5
		andi.w	#$F000,d5
		rol.w	#4,d5
		cmp.w	d7,d1
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

; Something to do with collision rotation

sub_1A3C:
		movea.w	d4,a3
		move.w	d0,d6
		move.w	d1,d7
		move.w	d2,d4
		move.w	d3,d5
		bsr.w	sub_1BF6
		move.w	(a0),d0
		andi.w	#$F000,d0
		rol.w	#4,d0
		lsl.w	#2,d0
		lea	(unk_0200&$FFFFFF).l,a1
		move.w	a3,d1
		beq.s	loc_1A64
		lea	(unk_0600&$FFFFFF).l,a1

loc_1A64:
		lea	(CollisionArrayRota).l,a2
		jmp	loc_1A6E(pc,d0.w)
; ===========================================================================
; ---------------------------------------------------------------------------
loc_1A6E:	bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C28
; ---------------------------------------------------------------------------
		bsr.w	sub_1AC8
		add.w	d7,d0
		move.w	d6,d1
		move.w	d5,d2
		move.w	d4,d3
		move.w	a3,d4
		move.w	(a0),d5
		andi.w	#$F000,d5
		rol.w	#4,d5
		cmp.w	d7,d0
		rts
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

; Something to do with the Collision array

sub_1AC8:
		movea.w	d4,a3
		move.w	d0,d6
		move.w	d1,d7
		move.w	d2,d4
		move.w	d3,d5
		bsr.w	sub_1BF6
		move.w	(a0),d0
		andi.w	#$F000,d0
		rol.w	#4,d0
		lsl.w	#2,d0
		lea	(unk_0200&$FFFFFF).l,a1
		move.w	a3,d1
		beq.s	loc_1AF0
		lea	(unk_0600&$FFFFFF).l,a1

loc_1AF0:
		exg	d6,d7
		exg	d4,d5
		lea	(CollisionArrayNorm).l,a2
		jmp	loc_1AFE(pc,d0.w)
; ===========================================================================
; ---------------------------------------------------------------------------
loc_1AFE:	bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C24
; ---------------------------------------------------------------------------
		bra.w	loc_1C28
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

; Something to do with Collision Array

sub_1B3E:
		move.w	d0,d6
		move.w	d1,d7
		bsr.w	sub_1BF6
		move.w	(a0),d0
		move.w	d0,d3
		swap	d3
		move.w	d0,d3
		tst.w	d4
		bne.s	loc_1B5C
		lea	(unk_0200&$FFFFFF).l,a1
		rol.w	#2,d3
		bra.s	loc_1B64

loc_1B5C:
		lea	(unk_0600&$FFFFFF).l,a1
		rol.w	#4,d3

loc_1B64:
		andi.w	#3,d3
		swap	d3
		andi.w	#$3FF,d0
		move.b	(a1,d0.w),d0
		andi.w	#$FF,d0
		lea	CurveResistMappings(pc),a3
		move.b	(a3,d0.w),d2
		cmpi.w	#$F0,d0
		bcs.s	loc_1B90
		moveq	#$A,d1
		btst	#0,d0
		beq.s	loc_1B8E
		addq.w	#1,d1

loc_1B8E:
		bchg	d1,d3

loc_1B90:
		lsl.w	#4,d0
		lea	(CollisionArrayRota).l,a1
		lea	(CollisionArrayNorm).l,a2
		lea	(a1,d0.w),a1
		lea	(a2,d0.w),a2
		moveq	#$F,d0
		moveq	#$F,d1
		and.w	d6,d0
		and.w	d7,d1
		andi.w	#$C00,d3
		rol.w	#7,d3
		jsr	locret_1BC6(pc,d3.w)
		ror.w	#7,d3
		swap	d3
		adda.w	d0,a1
		adda.w	d1,a2
		move.w	d6,d0
		move.w	d7,d1
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
locret_1BC6:	rts
; ---------------------------------------------------------------------------
		bra.s	loc_1BDE
; ---------------------------------------------------------------------------
		bra.s	loc_1BE8
; ---------------------------------------------------------------------------
		addi.b	#-$80,d2
		neg.w	d1
		addi.w	#$F,d1
		neg.w	d0
		addi.w	#$F,d0
		rts
; ---------------------------------------------------------------------------
; ===========================================================================

loc_1BDE:
		neg.b	d2
		neg.w	d0
		addi.w	#$F,d0
		rts

; ===========================================================================

loc_1BE8:
		neg.b	d2
		addi.b	#-$80,d2
		neg.w	d1
		addi.w	#$F,d1
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

sub_1BF6:
		moveq	#$70,d2
		moveq	#$70,d3
		and.w	d0,d2
		and.w	d1,d3
		lsr.w	#3,d2
		add.w	d2,d3
		lsr.w	#7,d0
		lsr.w	#7,d1
		move.b	($FFFFC9E4).w,d2
		lsl.w	d2,d1
		add.w	d0,d1
		movea.l	($FFFFC9FE).w,a0
		move.b	(a0,d1.w),d2
		lsl.w	#7,d2
		add.w	d3,d2
		movea.l	($FFFFCA02).w,a0
		lea	(a0,d2.w),a0
		rts

; ===========================================================================

loc_1C24:
		moveq	#0,d0
		rts

; ===========================================================================

loc_1C28:
		move.w	(a0),d0
		move.w	d0,d2
		moveq	#0,d1
		andi.w	#$3FF,d0
		move.b	(a1,d0.w),d1
		move.w	d1,d0
		lsl.w	#4,d0
		lea	(a2,d0.w),a1
		cmpi.w	#$F0,d1
		bcs.s	loc_1C50
		moveq	#$A,d0
		btst	#0,d1
		beq.s	loc_1C4E
		addq.w	#1,d0

loc_1C4E:
		bchg	d0,d2

loc_1C50:
		andi.w	#$C00,d2
		rol.w	#6,d2
		moveq	#$F,d0
		and.w	d6,d0
		tst.w	d5
		bmi.s	loc_1C60
		addq.w	#4,d2

loc_1C60:
		add.w	d2,d2
		move.w	off_1C6A(pc,d2.w),d2
		jmp	off_1C6A(pc,d2.w)
; ===========================================================================
; ---------------------------------------------------------------------------
off_1C6A:	dc.w W1C6A_loc01-off_1C6A
		dc.w W1C6A_loc03-off_1C6A
		dc.w W1C6A_loc05-off_1C6A
		dc.w W1C6A_loc07-off_1C6A
		dc.w W1C6A_loc00-off_1C6A
		dc.w W1C6A_loc02-off_1C6A
		dc.w W1C6A_loc04-off_1C6A
		dc.w W1C6A_loc06-off_1C6A
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------

W1C6A_loc00:
		adda.w	d0,a1
		move.b	(a1),d0
		move.w	d7,d1
		andi.w	#$F,d1
		sub.w	d1,d0
		subq.w	#1,d0
		bpl.s	loc_1C24
		rts
; ---------------------------------------------------------------------------
W1C6A_loc01:
		adda.w	d0,a1
		move.b	(a1),d0
		cmpi.w	#$10,d0
		beq.s	loc_1C24
		move.w	d7,d0
		andi.w	#$F,d0
		neg.w	d0
		addi.w	#$10,d0
		rts
; ---------------------------------------------------------------------------
W1C6A_loc02:
		neg.w	d0
		lea	$F(a1,d0.w),a1
		move.b	(a1),d0
		ext.w	d0
		move.l	d7,d1
		andi.w	#$F,d1
		sub.w	d1,d0
		subq.w	#1,d0
		bpl.w	loc_1C24
		rts
; ---------------------------------------------------------------------------
W1C6A_loc03:
		neg.w	d0
		lea	$F(a1,d0.w),a1
		move.b	(a1),d0
		cmpi.b	#$10,d0
		beq.w	loc_1C24
		move.w	d7,d0
		andi.w	#$F,d0
		neg.w	d0
		addi.w	#$10,d0
		rts
; ---------------------------------------------------------------------------
W1C6A_loc04:
		adda.w	d0,a1
		move.b	(a1),d0
		cmpi.b	#$10,d0
		beq.w	loc_1C24
		move.w	d7,d0
		andi.w	#$F,d0
		addq.w	#1,d0
		neg.w	d0
		rts
; ---------------------------------------------------------------------------
W1C6A_loc05:
		adda.w	d0,a1
		move.b	(a1),d0
		neg.w	d0
		addi.w	#$F,d0
		move.w	d7,d1
		andi.w	#$F,d1
		sub.w	d0,d1
		bgt.w	loc_1C24
		neg.w	d1
		addq.w	#1,d1
		move.w	d1,d0
		rts
; ---------------------------------------------------------------------------
W1C6A_loc06:
		neg.w	d0
		lea	$F(a1,d0.w),a1
		move.b	(a1),d0
		cmpi.b	#$10,d0

loc_1D1E:
		beq.w	loc_1C24
		move.w	d7,d0
		andi.w	#$F,d0
		addq.w	#1,d0
		neg.w	d0
		rts
; ---------------------------------------------------------------------------
W1C6A_loc07:
		neg.w	d0
		lea	$F(a1,d0.w),a1
		move.b	(a1),d0
		ext.w	d0
		neg.w	d0
		addi.w	#$F,d0
		move.w	d7,d1
		andi.w	#$F,d1
		sub.w	d0,d1
		bgt.w	loc_1C24
		neg.w	d1
		addq.w	#1,d1
		move.w	d1,d0
		rts
; ---------------------------------------------------------------------------
W1C6A_loc08:
		swap	d0
		swap	d1
		movea.w	d2,a3
		move.w	d0,d6
		move.w	d1,d7
		bsr.w	sub_1BF6
		move.w	(a0),d0
		move.w	a3,d1
		lea	(unk_0200&$FFFFFF).l,a1
		beq.s	loc_1D72
		lea	(unk_0600&$FFFFFF).l,a1

loc_1D72:
		move.w	d0,d1
		andi.w	#$3FF,d0
		andi.w	#$C00,d1
		rol.w	#6,d1
		adda.w	d0,a1
		moveq	#0,d0
		move.b	(a1),d0
		lea	CurveResistMappings(pc),a1
		move.b	(a1,d0.w),d0
		add.w	d1,d1
		jmp	locret_1D92(pc,d1.w)
; ===========================================================================
; ---------------------------------------------------------------------------
locret_1D92:	rts
; ---------------------------------------------------------------------------
		bra.s	loc_1D9C
; ---------------------------------------------------------------------------
		bra.s	loc_1D9C
; ---------------------------------------------------------------------------
		bra.s	loc_1DA4
; ---------------------------------------------------------------------------
		bra.s	loc_1D9E
; ---------------------------------------------------------------------------
; ===========================================================================

loc_1D9C:
		neg.b	d0

loc_1D9E:
		addi.b	#-$80,d0
		rts

loc_1DA4:
		neg.b	d0
		rts

sub_1DA8:
		tst.b	$1C(a6)
		bpl.s	loc_1DB2
		cmp.w	d0,d0
		rts

loc_1DB2:
		move.w	d0,d6
		move.w	d1,d7
		bsr.w	sub_1BF6
		move.w	(a0),d0
		move.w	d0,d1
		andi.w	#$C000,d0
		beq.w	loc_1E0C
		move.w	d1,d0
		andi.w	#$3FF,d0
		lea	(unk_0200&$FFFFFF).l,a1
		move.b	(a1,d0.w),d0
		andi.w	#$FF,d0
		lsl.w	#4,d0
		lea	(CollisionArrayRota).l,a1
		adda.w	d0,a1
		moveq	#$F,d0
		and.w	d6,d0
		btst	#$A,d1
		beq.s	loc_1DF4
		neg.w	d0
		addi.w	#$F,d0

loc_1DF4:
		adda.w	d0,a1
		move.b	(a1),d0
		cmpi.b	#$10,d0
		beq.s	loc_1E0C
		move.w	d6,d0
		move.w	#$FFF0,d1
		and.w	d7,d1
		subq.w	#1,d1
		cmp.w	d1,d7
		rts

loc_1E0C:
		move.w	d6,d0
		move.w	d7,d1
		cmp.w	d1,d7
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
CollisionArrayNorm:
		binclude	"collide/Collision Array (Normal).bin"
		even
CollisionArrayRota:
		binclude	"collide/Collision Array (Rotated).bin"
		even
CurveResistMappings:
		binclude	"collide/Angle Map.bin"
		even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------

; ---------------------------------------------------------------------------

sub_3F14:
		move.w	d2,d0
		add.w	d0,d0
		andi.w	#$1FE,d0
		move.w	word_3F2A(pc,d0.w),d1
		addi.w	#$80,d0
		move.w	word_3F2A(pc,d0.w),d0
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
word_3F2A:	dc.w $0000,$0192,$0323,$04B5,$0645,$07D5,$0964,$0AF1,$0C7C,$0E05,$0F8C
		dc.w $1111,$1294,$1413,$158F,$1708,$187D,$19EF,$1B5D,$1CC6,$1E2B,$1F8B
		dc.w $20E7,$223D,$238E,$24DA,$261F,$275F,$2899,$29CD,$2AFA,$2C21,$2D41
		dc.w $2E5A,$2F6B,$3076,$3179,$3274,$3367,$3453,$3536,$3612,$36E5,$37AF
		dc.w $3871,$392A,$39DA,$3A82,$3B20,$3BB6,$3C42,$3CC5,$3D3E,$3DAE,$3E14
		dc.w $3E71,$3EC5,$3F0E,$3F4E,$3F84,$3FB1,$3FD3,$3FEC,$3FFB,$4000,$3FFB
		dc.w $3FEC,$3FD3,$3FB1,$3F84,$3F4E,$3F0E,$3EC5,$3E71,$3E14,$3DAE,$3D3E
		dc.w $3CC5,$3C42,$3BB6,$3B20,$3A82,$39DA,$392A,$3871,$37AF,$36E5,$3612
		dc.w $3536,$3453,$3367,$3274,$3179,$3076,$2F6B,$2E5A,$2D41,$2C21,$2AFA
		dc.w $29CD,$2899,$275F,$261F,$24DA,$238E,$223D,$20E7,$1F8B,$1E2B,$1CC6
		dc.w $1B5D,$19EF,$187D,$1708,$158F,$1413,$1294,$1111,$0F8C,$0E05,$0C7C
		dc.w $0AF1,$0964,$07D5,$0645,$04B5,$0323,$0192,$0000
; ---------------------------------------------------------------------------
		dc.w $FE6D
		dc.w $FCDC
		dc.w $FB4A
		dc.w $F9BA
		dc.w $F82A
		dc.w $F69B
		dc.w $F50E
		dc.w $F383
		dc.w $F1FA
		dc.w $F073
		dc.w $EEEE
		dc.w $ED6B
		dc.w $EBEC
		dc.w $EA70
		dc.w $E8F7
		dc.w $E782
		dc.w $E610
		dc.w $E4A2
		dc.w $E339
		dc.w $E1D4
		dc.w $E074
		dc.w $DF18
		dc.w $DDC2
		dc.w $DC71
		dc.w $DB25
		dc.w $D9E0
		dc.w $D8A0
		dc.w $D766
		dc.w $D632
		dc.w $D505
		dc.w $D3DE
		dc.w $D2BE
		dc.w $D1A5
		dc.w $D094
		dc.w $CF89
		dc.w $CE86
		dc.w $CD8B
		dc.w $CC98
		dc.w $CBAC
		dc.w $CAC9
		dc.w $C9ED
		dc.w $C91A
		dc.w $C850
		dc.w $C78E
		dc.w $C6D5
		dc.w $C625
		dc.w $C57D
		dc.w $C4DF
		dc.w $C449
		dc.w $C3BD
		dc.w $C33A
		dc.w $C2C1
		dc.w $C251
		dc.w $C1EB
		dc.w $C18E
		dc.w $C13A
		dc.w $C0F1
		dc.w $C0B1
		dc.w $C07B
		dc.w $C04E
		dc.w $C02C
		dc.w $C013
		dc.w $C004
		dc.w $C000
		dc.w $C004
		dc.w $C013
		dc.w $C02C
		dc.w $C04E
		dc.w $C07B
		dc.w $C0B1
		dc.w $C0F1
		dc.w $C13A
		dc.w $C18E
		dc.w $C1EB
		dc.w $C251
		dc.w $C2C1
		dc.w $C33A
		dc.w $C3BD
		dc.w $C449
		dc.w $C4DF
		dc.w $C57D
		dc.w $C625
		dc.w $C6D5
		dc.w $C78E
		dc.w $C850
		dc.w $C91A
		dc.w $C9ED
		dc.w $CAC9
		dc.w $CBAC
		dc.w $CC98
		dc.w $CD8B
		dc.w $CE86
		dc.w $CF89
		dc.w $D094
		dc.w $D1A5
		dc.w $D2BE
		dc.w $D3DE
		dc.w $D505
		dc.w $D632
		dc.w $D766
		dc.w $D8A0
		dc.w $D9E0
		dc.w $DB25
		dc.w $DC71
		dc.w $DDC2
		dc.w $DF18
		dc.w $E074
		dc.w $E1D4
		dc.w $E339
		dc.w $E4A2
		dc.w $E610
		dc.w $E782
		dc.w $E8F7
		dc.w $EA70
		dc.w $EBEC
		dc.w $ED6B
		dc.w $EEEE
		dc.w $F073
		dc.w $F1FA
		dc.w $F383
		dc.w $F50E
		dc.w $F69B
		dc.w $F82A
		dc.w $F9BA
		dc.w $FB4A
		dc.w $FCDC
		dc.w $FE6D
		dc.w 0
		dc.w $192
		dc.w $323
		dc.w $4B5
		dc.w $645
		dc.w $7D5
		dc.w $964
		dc.w $AF1
		dc.w $C7C
		dc.w $E05
		dc.w $F8C
		dc.w $1111
		dc.w $1294
		dc.w $1413
		dc.w $158F
		dc.w $1708
		dc.w $187D
		dc.w $19EF
		dc.w $1B5D
		dc.w $1CC6
		dc.w $1E2B
		dc.w $1F8B
		dc.w $20E7
		dc.w $223D
		dc.w $238E
		dc.w $24DA
		dc.w $261F
		dc.w $275F
		dc.w $2899
		dc.w $29CD
		dc.w $2AFA
		dc.w $2C21
		dc.w $2D41
		dc.w $2E5A
		dc.w $2F6B
		dc.w $3076
		dc.w $3179
		dc.w $3274
		dc.w $3367
		dc.w $3453
		dc.w $3536
		dc.w $3612
		dc.w $36E5
		dc.w $37AF
		dc.w $3871
		dc.w $392A
		dc.w $39DA
		dc.w $3A82
		dc.w $3B20
		dc.w $3BB6
		dc.w $3C42
		dc.w $3CC5
		dc.w $3D3E
		dc.w $3DAE
		dc.w $3E14
		dc.w $3E71
		dc.w $3EC5
		dc.w $3F0E
		dc.w $3F4E
		dc.w $3F84
		dc.w $3FB1
		dc.w $3FD3
		dc.w $3FEC
		dc.w $3FFB
; ===========================================================================

sub_41AA:
		movem.l	d1-d5,-(sp)
		sub.w	d1,d3
		beq.s	loc_4204
		smi	d0
		bpl.s	loc_41B8
		neg.w	d3

loc_41B8:
		sub.w	d2,d4
		beq.s	loc_4216
		smi	d5
		bpl.s	loc_41C2
		neg.w	d4

loc_41C2:
		ext.l	d4
		asl.l	#8,d4
		divu.w	d3,d4
		moveq	#0,d1
		moveq	#$3F,d2
		swap	d5

loc_41CE:
		move.w	d2,d3
		add.w	d1,d3
		lsr.w	#1,d3
		move.w	d3,d5
		add.w	d5,d5
		cmp.w	word_4220(pc,d5.w),d4
		bcs.s	loc_41E2
		move.w	d3,d1
		move.w	d2,d3

loc_41E2:
		move.w	d3,d2
		sub.w	d1,d3
		subq.w	#1,d3
		bne.s	loc_41CE
		swap	d5
		andi.w	#$80,d0
		eor.b	d0,d5
		bpl.s	loc_41FC
		sub.b	d2,d0
		movem.l	(sp)+,d1-d5
		rts
; ---------------------------------------------------------------------------

loc_41FC:
		add.b	d2,d0
		movem.l	(sp)+,d1-d5
		rts
; ---------------------------------------------------------------------------

loc_4204:
		sub.w	d2,d4
		smi	d0
		andi.w	#$80,d0
		addi.w	#$40,d0
		movem.l	(sp)+,d1-d5
		rts
; ---------------------------------------------------------------------------

loc_4216:
		andi.w	#$80,d0
		movem.l	(sp)+,d1-d5
		rts
; End of function sub_41AA

; ---------------------------------------------------------------------------
word_4220:	dc.w 0
		dc.w 6
		dc.w $D
		dc.w $13
		dc.w $19
		dc.w $20
		dc.w $26
		dc.w $2C
		dc.w $33
		dc.w $39
		dc.w $40
		dc.w $47
		dc.w $4E
		dc.w $55
		dc.w $5C
		dc.w $63
		dc.w $6A
		dc.w $71
		dc.w $79
		dc.w $81
		dc.w $89
		dc.w $91
		dc.w $99
		dc.w $A2
		dc.w $AB
		dc.w $B4
		dc.w $BE
		dc.w $C8
		dc.w $D2
		dc.w $DD
		dc.w $E8
		dc.w $F4
		dc.w $100
		dc.w $10D
		dc.w $11A
		dc.w $129
		dc.w $138
		dc.w $148
		dc.w $159
		dc.w $16B
		dc.w $17F
		dc.w $194
		dc.w $1AB
		dc.w $1C4
		dc.w $1DF
		dc.w $1FD
		dc.w $21D
		dc.w $242
		dc.w $26A
		dc.w $298
		dc.w $2CB
		dc.w $307
		dc.w $34C
		dc.w $39D
		dc.w $3FE
		dc.w $474
		dc.w $507
		dc.w $5C3
		dc.w $6BE
		dc.w $81C
		dc.w $A27
		dc.w $D8F
		dc.w $145B
		dc.w $28BC
word_42A0:	dc.w $2200
		dc.w $7400
		dc.w $7600
		dc.w $780F
; ---------------------------------------------------------------------------

loc_42A8:
		add.w	d0,d0
		add.l	d1,d1
		addx.l	d3,d3
		add.l	d1,d1
		addx.l	d3,d3
		add.l	d2,d2
		addq.l	#1,d2
		cmp.l	d2,d3
		bcs.s	loc_42C6
		addq.w	#1,d0
		sub.l	d2,d3
		addq.l	#1,d2
		dbf	d4,loc_42A8
		rts
; ---------------------------------------------------------------------------

loc_42C6:
		subq.l	#1,d2
		dbf	d4,loc_42A8
		rts

; =============== S U B	R O U T	I N E =======================================


sub_42CE:
		movem.l	d0-d1/d3-d5,-(sp)
		move.w	d0,d3
		move.w	d1,d4
		moveq	#0,d1
		moveq	#0,d2
		sub.w	d1,d3
		beq.s	loc_433E
		smi	d0
		bpl.s	loc_42E4
		neg.w	d3

loc_42E4:
		sub.w	d2,d4
		beq.s	loc_4356
		smi	d5
		bpl.s	loc_42EE
		neg.w	d4

loc_42EE:
		ext.l	d4
		asl.l	#8,d4
		divu.w	d3,d4
		moveq	#0,d1
		moveq	#$3F,d2
		swap	d5

loc_42FA:
		move.w	d2,d3
		add.w	d1,d3
		lsr.w	#1,d3
		move.w	d3,d5
		add.w	d5,d5
		cmp.w	word_4368(pc,d5.w),d4
		bcs.s	loc_430E
		move.w	d3,d1
		move.w	d2,d3

loc_430E:
		move.w	d3,d2
		sub.w	d1,d3
		subq.w	#1,d3
		bne.s	loc_42FA
		swap	d5
		andi.w	#$80,d0
		eor.b	d0,d5
		bpl.s	loc_4330
		sub.b	d2,d0
		move.b	d0,d2
		movem.l	(sp)+,d0-d1/d3-d5
		addq.b	#8,d2
		andi.b	#$F0,d2
		rts
; ---------------------------------------------------------------------------

loc_4330:
		add.b	d0,d2
		movem.l	(sp)+,d0-d1/d3-d5
		addq.b	#8,d2
		andi.b	#$F0,d2
		rts
; ---------------------------------------------------------------------------

loc_433E:
		sub.w	d2,d4
		smi	d2
		andi.w	#$80,d2
		addi.w	#$40,d2
		movem.l	(sp)+,d0-d1/d3-d5
		addq.b	#8,d2
		andi.b	#$F0,d2
		rts
; ---------------------------------------------------------------------------

loc_4356:
		andi.w	#$80,d0
		move.b	d0,d2
		movem.l	(sp)+,d0-d1/d3-d5
		addq.b	#8,d2
		andi.b	#$F0,d2
		rts
; End of function sub_42CE

; ---------------------------------------------------------------------------
word_4368:	dc.w 0
		dc.w 6
		dc.w $D
		dc.w $13
		dc.w $19
		dc.w $20
		dc.w $26
		dc.w $2C
		dc.w $33
		dc.w $39
		dc.w $40
		dc.w $47
		dc.w $4E
		dc.w $55
		dc.w $5C
		dc.w $63
		dc.w $6A
		dc.w $71
		dc.w $79
		dc.w $81
		dc.w $89
		dc.w $91
		dc.w $99
		dc.w $A2
		dc.w $AB
		dc.w $B4
		dc.w $BE
		dc.w $C8
		dc.w $D2
		dc.w $DD
		dc.w $E8
		dc.w $F4
		dc.w $100
		dc.w $10D
		dc.w $11A
		dc.w $129
		dc.w $138
		dc.w $148
		dc.w $159
		dc.w $16B
		dc.w $17F
		dc.w $194
		dc.w $1AB
		dc.w $1C4
		dc.w $1DF
		dc.w $1FD
		dc.w $21D
		dc.w $242
		dc.w $26A
		dc.w $298
		dc.w $2CB
		dc.w $307
		dc.w $34C
		dc.w $39D
		dc.w $3FE
		dc.w $474
		dc.w $507
		dc.w $5C3
		dc.w $6BE
		dc.w $81C
		dc.w $A27
		dc.w $D8F
		dc.w $145B
		dc.w $28BC
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w $8A
		dc.w $8D
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w $8A
		dc.w $8D
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w $8B
		dc.w $8E
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w $487F
		dc.w $3E34
		dc.w $23F
		dc.w $BFE5
		dc.w $7292
		dc.w $74E3
		dc.w $531A
		dc.w $7CDA
		dc.w $6500
		dc.w $1251
		dc.w $FF51
		dc.w $FF4C
		dc.w $44E
		dc.w $7616
		dc.w $38E2
		dc.w $C844
		dc.w $4530
		dc.w $5212
		dc.w $51FF
		dc.w $51FF
		dc.w $51FF
		dc.w $4C04
		dc.w $4E48
		dc.w $4102
		dc.w $21C8
		dc.w $4C01
		dc.w $4101
		dc.w $4E08
		dc.w $1000
		dc.w $4AD8
		dc.w $6730
		dc.w $D802
		dc.w 6
		dc.w $4E
		dc.w $64
		dc.w $4300
		dc.w $41D3
		dc.w $7220
		dc.w $51FF
		dc.w $3000
		dc.w $616B
		dc.w $6171
		dc.w $281
		dc.w $C933
		dc.w $C900
		dc.w $42
		dc.w $D84E
		dc.w $95
		dc.w $6103
		dc.w $4E00
		dc.w $F14E
		dc.w $1531
		dc.w $D8
		dc.w $3100
		dc.w $D831
		dc.w $D8
		dc.w $3100
		dc.w $D84E
		dc.w $BE
		dc.w $4E00
		dc.w $D14E
		dc.w $EF
		dc.w $4E00
		dc.w $8C46
		dc.w $234E
		dc.w $8C
		dc.w $4E00
		dc.w $ED4A
		dc.w $D866
		dc.w $42D8
		dc.w $42D8
		dc.w $42C9
		dc.w $42C9
		dc.w $42CA
		dc.w $42CA
		dc.w $616C
		dc.w $81
		dc.w $C933
		dc.w $C900
		dc.w $61
		dc.w $6B4E
		dc.w $F9
		dc.w $6000
PAL_Unknown_1:	binclude	"Palettes/PalUnknown01.bin"
		even
		dc.b $82, $83, $84, $85, $8D, $90, $87,	$8B, $8C, $91, $92, 0, $48, 0, $89, 8
		dc.b 0,	$FF, $4A, $FF, $6A, $61, $69, $4E, 0, $8A, $4E,	0, $8B,	$4E, 0,	$CC
		dc.b $4E, 0, $A1, $4E, 0, $95, $4E, 0, $F1, $4E, 0, $D2, $4E, 0, $EB, $4E
		dc.b 0,	$F9, $46, $27, $4E, $16, $46, $23, $4E,	$4E, 9,	$47, $C9, $72, $12, $D8
		dc.b $70, $C0, $10, $56, $10, $10, $12,	2, 0, $56, $82,	2, 0, $80, $49,	$FB
		dc.b $12, $FF, 2, 0, $14, $10, $19, $10, $52, $FF, $19,	$FF, $49, $D8, $61, 0
		dc.b $10, $FA, $47, $C9, $72, $12, $D8,	$6B, $70, $C0, $10, $56, $10, $10, $12,	2
		dc.b 0,	$56, $82, 2, 0,	$80, $49, $D8, $60, 0, $19, 0, 0, $19, 0, $12
		dc.b 0,	$B1, $67, $42, 0, $52, 0, $C2, $19, 0, 2, 0, $19, 0, 0,	$72
		dc.b $C2, $E2, $48, $34, $48, $84, $39,	0, 2, 0, $E6, $48, $32,	$48, $82, $39
		dc.b 0,	$4E, 0,	$40, $80, $60, 0, $20, $80, $60, $48, $FF, $4E,	0, $9F,	$4E
		dc.b 4,	$4E, 4,	$4E, 0,	$C9, $20, $FF, $D1, $32, $D8, $34, 1, $4E, 5, $47
		dc.b 0,	$A, $49, 0, $B,	$4B, $C9, $4E, $14, $47, 0, $B,	$49, 0,	$C, $4B
		dc.b $CA, $4E, $14, 0, 0, $FF, $52, $F0, $4C, $7F, $4E,	$4A, $D8, $6A, 0, $10
		dc.b $C9, 2, 0,	$C, 0, $66, $46, $27, $91, $2E,	$20, $4E, $48, $FF, 8, 0
		dc.b $FF, $4A, $FF, $6A, $4E, 0, $8A, $30, $D8,	$32, $D8, $D0, $D0, $D2, $D2, $30
		dc.b $D8, $D1, 0, $D3, 0, $30, $D8, $D1, 0, $D3, 0, $4E, 0, $CC, $4E, 0
		dc.b $95, $4E, $16, $61, $67, $4A, $C9,	$6A, $4C, $7F, $4E, $70, $30, $D8, 2, 0
		dc.b $E5, $20, 0, $43, 0, $34, $36, $4E, $3F, 7, 7, $F,	0, $23,	0, $23
		dc.b 0,	$23, 0,	$23, $4A, $D8, $67, $46, $27, $41, 0, $1B, $23,	$40, 0,	0
		dc.b 0,	$4E, $D, $46, $27, $41,	0, $22,	$23, $7E, 0, 0,	0, $4E,	$D, $46
		dc.b $27, $41, 0, $1F, $23, $77, 0, 0, 0, $4E, $D, $4E,	$43, 0,	$8C, $70
		dc.b $30, $C, $FF, $67,	$48, $FF, $20, $E5, $E4, 0, $40, $48, 2, 0, $46, $27
		dc.b $23, 0, 0,	$4E, $D, $4C, $7F, $60,	$4E, $80, 0, $1B, $7E, 0, $22, $77
		dc.b 0,	$1F, $FF, $72, $32, $D8, 2, 0, $E3, $4E, $10, $60, $60,	$4E, $70, $30
		dc.b $D8, 2, 0,	$ED, $43, 0, $8D, $D3, $41, $D4, $1E, 0, $30, $51, $FF,	$4E
PAL_Unknown_2:	binclude	"Palettes/PalUnknown02.bin"
		even
		dc.b $4E, $4E, $30, $D8, $4E, 0, $60, 0, $60, 0, $48, $41, 2, $21, $C8,	$4C
		dc.b 1,	$46, $27, $70, $72, $74, $36, $C0, $4E,	8, $41,	2, $23,	$4C, 0,	0
		dc.b 0,	$4E, $D, $20, $42, 0, $43, 2, $72, $74,	$36, 0,	$4E, 8,	$23, $78
		dc.b 0,	0, 0, $23, 1, 0, 0, 0, $23, 0, 0, 0, 0,	$23, 0,	$F
		dc.b 0,	0, $23,	0, 1, 0, 0, $31, 0, $D8, $31, 0, $D8, $21, 0, $E
		dc.b $D3, $21, 0, $E, $D4, $4E,	4, $46,	$23, $58, $D8, $4E, 8, 0, $FF, $4A
		dc.b $FF, $6A, $30, $C9, $D0, $D8, $6A,	$70, $C, 0, $63, $70, $31, $D8,	$32, $EB
		dc.b 4,	0, $31,	$D8, $43, 3, $E9, $D2, $20, $65, 0, $72, $74, $36, 0, $4E
		dc.b 8,	$32, $D8, $C, 0, $64, $31, 1, $D8, $20,	$66, 0,	$43, 3,	$72, $74
		dc.b $36, 0, $4E, 8, $31, 0, $D8, $60, 0, $C, 0, $64, $70, $23,	$66, 0
		dc.b 0,	0, $32,	1, $23,	0, 0, $51, $FF,	$20, $6B, 0, $43, 4, $72, $74
		dc.b $36, 0, $4E, 8, $20, $6A, 0, $72, $74, $36, 0, $4E, 8, $60, $70, $23
		dc.b $66, 0, 0,	0, $32,	1, $23,	0, 0, $51, $FF,	$20, $6B, 0, $43, 4
		dc.b $72, $74, $36, 0, $4E, 8, $60, 0, 0, 0, 0,	0, 0, 0, 0, 0
		dc.b 0,	$32, $D8, $D2, $32, $10, $30, $C9, $44,	$D0, $D8, $6A, $70, $B0, $63, $30
		dc.b $31, $D8, $E9, $44, 6, 1, $31, $D8, $4A, $C9, $6B,	$4E, $42, $D8, $C, 0
		dc.b $D8, $66, $31, 0, $D8, $4E, $4A, $D8, $66,	$31, 0,	$D8, $4E, $30, $D8, 2
		dc.b 0,	$31, $D8, $31, 0, $D8, $31, 0, $D8, $4E, $48, $FF, $23,	$7C, 0,	0
		dc.b 0,	$30, $D8, $44, $33, 0, 0, $23, $78, 0, 0, 0, $33, $D8, 0, 0
		dc.b $4E, 9, $10, $C9, $61, $31, $C9, $31, $C9,	$10, $C9, $61, $31, $C9, $31, $C9
		dc.b $4E, 4, 0,	0, $FF,	$4C, $7F, $4E, $72, $C2, $E2, $48, $34,	$48, $84, 2
		dc.b 0,	$E6, $48, $32, $48, $82, $4E, $80, $80,	$C, $D,	0, 5, $44, $72,	$FF
		dc.b $56, $FF, 0, 1, $5D, $FE, $40, 0, $95, 0, $2A, $87, $EC, 0, $1B, $1D
		dc.b $BF, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0
		dc.b 0,	$4E, $30, $D8, $4E, 0, $60, 0, $60, 0, $48, $41, 0, $21, $C8, $4C
		dc.b 1,	$46, $27, $70, $72, $74, $36, $C0, $4E,	8, $20,	$44, 0,	$43, 0,	$72
		dc.b $74, $36, 0, $4E, 8, $23, $78, 0, 0, 0, $23, 0, 0,	0, 0, $23
		dc.b 0,	0, 0, 0, $31, 0, $D8, $46, $23,	$58, $D8, $4E, 0, 0, 0,	0
		dc.b 0,	0, 8, 0, $FF, $4A, $FF,	$6A, $30, $C9, $D1, $D8, $30, $C9, $E9,	$D1
		dc.b $D8, $46, $27, $30, $D8, $32, $D8,	6, 8, $4E, 0, $50, $46,	$23, $10, $C9
		dc.b $6A, $10, 0, $4E, 0, $64, $31, 0, $D8, $42, $D8, $4E, 2, 0, $66, $4E
		dc.b $30, $D8, $4E, 0, $64, $4E, $48, $FF, $23,	$78, 0,	0, 0, $33, $D8,	0
		dc.b 0,	$4E, 9,	$10, $C9, $61, $31, $C9, $31, $C9, $10,	$C9, $61, $31, $C9, $31
		dc.b $C9, 0, 0,	$FF, $4C, $7F, $4E, $72, $C2, $E2, $48,	$34, $48, $84, 2, 0
		dc.b $E6, $48, $32, $48, $82, $4E, $30,	$D8, $E7, $D0, $D8, $D0, $D0, $4E, 0, $4E
		dc.b $60, $FF, $60, 1, $60, 3, $60, 3, $60, 3, $60, 3, $60, $FF, $60, $FF
		dc.b $60, $FF, $60, 3, $60, 6, $60, 6, $60, 6, $60, 6, $60, $FF, $60, $FF
		dc.b $60, $FF, $60, 6, $60, 6, $60, 6, $60, 6, $60, 6, $60, $FF, $60, $FF
		dc.b $60, $FF, $60, 6, $60, 6, $60, 6, $60, 6, $60, 6, $60, $FF, $60, $FF
		dc.b $60, $FF, $60, 6, $60, 6, $60, 6, $60, 6, $60, 6, $60, $FF, $60, $FF
		dc.b $60, $FF, $60, 6, $60, 6, $60, 6, $60, 6, $60, 6, $60, $FF, $60, $FF
		dc.b $60, $FF, $60, 6, $60, 6, $60, 6, $60, 6, $60, 6, $60, $FF, $60, $FF
		dc.b $60, $FF, $60, 6, $60, $FF, $60, $FF, $60,	$FF, $60, $FF, $60, $FF, $60, $FF
		dc.b $60, $FE, $60, 5, $60, $FE, $60, $FE, $60,	$FE, $60, $FE, $60, $FE, $60, $FE
		dc.b $60, $FE, $60, 5, $60, $FE, $60, $FE, $60,	$FE, $60, $FE, $60, $FE, $60, $FE
		dc.b $30, $D8, $4E, 0, $60, 0, $60, 0, $60, 0, $46, $27, $43, $C9, $33,	1
		dc.b 0,	$41, 5,	$45, $D4, $61, 7, $41, 5, $45, $D8, $61, 7, $20, $45, 5
		dc.b $61, 6, $41, $C9, $21, 0, $D, 0, $45, 5, $61, 6, $21, $CA,	$61, 6
		dc.b $41, 5, $43, $CA, $33, 1, 0, $45, $D8, $61, 7, $20, $45, 5, $61, 6
		dc.b $21, $FB, $22, $47, 0, $B,	$49, 0,	$C, $42, 0, $A,	$42, 0,	$B, $42
		dc.b 0,	$B, $42, 0, $C,	$61, 6,	$46, $23, $58, $D8, $4E, $4E, 0, $F5, $58
		dc.b $D8, $30, $D8, $43, $C9, $47, 0, $A, $49, 0, $B, $61, 7, $61, 7, $61
		dc.b 6,	$30, $D8, $43, $CA, $47, 0, $B,	$49, 0,	$C, $61, $61, 6, $4E, $30
		dc.b 0,	$33, 0,	$32, $D8, $92, $6D, $C,	0, $6F,	$32, 0,	$60, $C, $FF, $6E
		dc.b $32, $FF, $D0, $32, $34, 0, 6, 1, $C2, $33, 0, $32, 0, $B0, $6E, $32
		dc.b 0,	$B0, $6E, $33, 0, $4E, $30, 0, $33, 0, $32, 0, 4, 0, $C2, 0
		dc.b $48, $82, 0, $33, 0, $30, 0, $B2, $6E, $30, 0, $B2, $6E, $33, 0, $4E
		dc.b $45, $CA, $42, $FB, $36, $C9, $44,	$56, $FB, $34, $FB, $3E, 0, $30, 0, $32
		dc.b 2,	0, $66,	$4E, $3F, $34, $E0, $48, $44, $34, $34,	$44, $34, 6, 0,	$10
		dc.b $FB, $94, $FB, $51, $FF, $20, $FF,	$CA, $32, $D8, $34, 1, $4E, 5, $4E, $4E
		dc.b $3F, $34, $E0, $48, $34, $34, $44,	$34, 6,	0, $10,	$FB, $94, $FB, $51, $FF
		dc.b $20, $FF, $CA, $32, $D8, $34, 1, $4E, 5, $4E, $4E,	$4E, $4E, $4E, $30, $D8
		dc.b $4E, 0, $60, 0, $60, 0, $60, 0, $46, $27, $43, $C9, $41, 4, $45, $D4
		dc.b $61, 5, $41, 4, $45, $D8, $61, 5, $20, $45, 3, $61, 4, $41, $C9, $21
		dc.b 0,	$D, 0, $45, 3, $61, 4, $21, $CA, $61, 4, $41, 3, $43, $CA, $33
		dc.b 1,	0, $45,	$D8, $61, 5, $20, $45, 3, $61, 4, $21, $FB, $22, $47, 0
		dc.b $B, $49, 0, $C, $61, 4, $46, $23, $58, $D8, $4E, $4E, 0, $F5, $58,	$D8
		dc.b $30, $D8, $43, $C9, $47, 0, $A, $49, 0, $B, $61, 5, $61, 5, $61, 4
		dc.b $30, $D8, $43, $CA, $47, 0, $B, $49, 0, $C, $61, $61, 5, $4E, 0, $9D
		dc.b $4E, $72, $30, 0, $33, 0, $32, $D8, $C2, 0, $82, 0, $33, 0, $30, 0
		dc.b $B2, $6E, $30, 0, $B2, $6E, $33, 0, $4E, $70, $30,	$C9, $32, $C9, $34, $90
		dc.b $67, $48, $22, $E2, $D1, $FB, $20,	$E4, $D1, $FB, $20, $E6, $D1, $FB, $20,	$E8
		dc.b $D1, $FB, $45, $CD, $32, 0, 6, 0, $E4, 2, $FF, $47, $10, $7E, $34,	$28
		dc.b $34, $51, $FF, $4E, $FF, $FB, $FF,	$FB, $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB
		dc.b $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB, $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB
		dc.b $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB, $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB
		dc.b $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB, $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB
		dc.b $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB, $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB
		dc.b $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB, $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB
		dc.b $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB, $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB
		dc.b $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB, $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB
		dc.b $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB, $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB
		dc.b $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB, $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB
		dc.b $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB, $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB
		dc.b $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB, $FF, $FB, $FF, $FB, $FF, $FB, $FF,	$FB
		dc.b $FF, $FB, $FF, $FB, $C, $D, $C9, $64, $31,	1, $C9,	$60, $31, 1, $C9, $47
		dc.b $CA, $36, $C9, $44, $38, $CA, $44,	$7E, $34, $CA, $52, $31, $CA, $7C, $52,	$4E
		dc.b $3F, 2, 0,	$D0, $36, $36, $51, $FF, $58, $4E, $3F,	2, 0, $D0, $36,	$36
		dc.b $51, $FF, $20, $FF, $CA, $32, $D8,	$34, 1,	$4E, 5,	$4E, $4E, $4E, $4E, $4E
		dc.b $4E, $4E, $4E, $4E, $4E, $4E, $4E,	$4E, $4E, $4E, $4E, $4E, $4E, $4E, $4E,	$4E
		dc.b $4E, $4E, $4E, $4E, $4E, $4E, $4E,	$4E, $4E, $4E, $4E, $4E, 0, $E,	0, $9B
		dc.b 0,	0, $80,	$80, 0,	$7E, 0,	5, 0, 0, $45, 0, $57, 0, $90, 0
		dc.b $93, 0, 0,	4, 4, 3, 0, 0, 2, 0, 0,	$A5, 0,	$A6, 0,	$A7
		dc.b 8,	2, $C, 8, $E, 2, 0, $E,	0, $C, $E, 0, $E, 8, 0,	0
		dc.b 8,	$E, 0, 0, 2, $E, $E, $C, $A, 4,	0, 0, 0, 0, 2, $A
		dc.b 0,	$A7, 0,	$F6, 0,	$D, $10, $10, 0, 6, 0, $F, 0, 0, $BB, 0
		dc.b $C6, 0, $ED, 0, $EE, 0, $A, $10, $C, 1, 4,	0, $B, 0, 0, 9
		dc.b 0,	$10, 0,	$18, 8,	$E, $A,	6, $E, 8, 2, 6,	2, 2, 0, 0
		dc.b 0,	0, 2, $E, 8, $E, $A, 6,	4, 2, 0, 0, $E,	$E, $E,	8
		dc.b 8,	0, $E, 0, $2F, $20, $49, 0, 2, $4E, $D,	$20, $4E, $D, $20, $20
		dc.b 0,	2, $72,	$32, 0,	$EB, $24, $94, $44, $E2, $4E, 5, $4E, $22, 0, $30
		dc.b 0,	$2F, $20, $2F, $4E, $10, $24, $20, $21,	0, $2F,	$20, $70, $2F, $4E, $10
		dc.b $24, $20, $21, 0, $2F, $20, $70, $2F, $4E,	$10, $24, $20, $4E, $22, $45, 0
		dc.b 2,	$70, $24, $24, $51, $FF, $45, 0, 6, $70, $24, $24, $51,	$FF, $4E, $30
		dc.b 0,	$2A, $7E, $48, $FF, $20, $30, 0, $32, 0, $38, 0, $4E, $12, $26,	$4E
		dc.b $14, $4C, $7F, 6, 0, 0, $51, $FF, $33, 0, $4E, $2F, $30, 0, $32, 0
		dc.b $B3, 2, $FF, $67, $B2, 0, $6D, $30, 0, $32, 0, $26, $4E, $12, $60,	$30
		dc.b 0,	6, 2, $32, 0, $26, $4E,	$12, $26, $30, 0, $32, 0, $B3, 2, $FF
		dc.b $67, $B2, 0, $6D, $30, 0, $32, 0, $4E, $12, $30, 0, $32, 0, 6, 1
		dc.b $4E, $12, $4E, $4C, 0, $48, 0, $D4, 0, $4C, 0, $48, 0, $4E, $70, $30
		dc.b $E5, $E4, 0, $40, $48, 2, 0, $23, 0, $32, $33, 0, $33, 0, $32, $33
		dc.b 0,	$33, 0,	$13, 0,	$13, 0,	$13, 0,	$13, 0,	$33, 0,	$33, 0,	$33
		dc.b 0,	$33, 0,	$33, 0,	$70, $10, 0, $74, $D0, $55, $FF, $13, 0, $70, $10
		dc.b 0,	$74, $D0, $55, $FF, $13, 0, $4E, $30, 0, $33, 0, $32, $D8, $92,	$6D
		dc.b $C, 0, $6F, $32, 0, $60, $C, $FF, $6E, $32, $FF, $D0, $33,	0, $32,	0
		dc.b $B0, $6E, $32, 0, $B0, $6E, $33, 0, $4E, $30, 0, $33, 0, $32, $D8,	$92
		dc.b $6D, $C, 0, $6F, $32, 0, $60, $C, $FF, $6E, $32, $FF, $D0,	$33, 0,	$32
		dc.b 0,	$B0, $6E, $32, 0, $B0, $6E, $33, 0, $4E, $61, 0, $4E, $43, $C9,	$70
		dc.b $10, 0, $4E, 0, $60, 0, $60, 0, $60, 0, $60, 0, $60, 1, $60, 1
		dc.b $60, 1, $10, 0, $67, $33, $8B, 0, 0, $31, $8B, $C9, $70, $23, $40,	0
		dc.b 0,	0, $23,	0, 0, $72, $32,	$D8, $E5, $E4, 0, $40, $48, 2, 0, $23
		dc.b 0,	0, $23,	0, 0, $13, 0, 0, $4E, $10, 0, $67

; ===========================================================================
; ---------------------------------------------------------------------------
; Main Game Program
; ---------------------------------------------------------------------------

MAINPROG:
		move.w	(v_gamemode).w,d0
		andi.w	#$78,d0
		jsr	GameModeArray(pc,d0.w)		; run through correct mode routine
		bra.s	MAINPROG			; loop

; ===========================================================================
; ---------------------------------------------------------------------------
; Main Game mode array
; ---------------------------------------------------------------------------

GameModeArray:
ptr_GM_Sega:	jmp	(SegaScreen).l			; SEGA screen (00)
		nop
; ---------------------------------------------------------------------------
ptr_GM_Title:	jmp	(TitleScreen).l			; Title Screen (08)
		nop
; ---------------------------------------------------------------------------
ptr_GM_Field:	jmp	(Fields).l			; Fields Screen (10)
		nop
; ---------------------------------------------------------------------------
ptr_GM_Level:	jmp	(Levels).l			; Level Zones (18)
		nop
; ---------------------------------------------------------------------------
ptr_GM_Null:	jmp	(UnkRet001).l			; Null (20)
		nop
; ---------------------------------------------------------------------------
		jmp	(UnkRet002).l			; Null (28)
		nop
; ---------------------------------------------------------------------------
ptr_GM_LevelSelect:
		jmp	(LevelSelect).l			; Level Select (on Main Menu) (30)
		nop
; ---------------------------------------------------------------------------
		jmp	(UnkRet003).l			; Null (38)
		nop
; ---------------------------------------------------------------------------
ptr_GM_Options:	jmp	(OptionSoundTest).l		; Options (Sound Test) (40)
		nop
; ---------------------------------------------------------------------------
		jmp	(GMAReturn).l			; Null (48)
		nop
; ---------------------------------------------------------------------------
		jmp	(GMAReturn).l			; Null (50)
		nop
; ---------------------------------------------------------------------------
		jmp	(GMAReturn).l			; Null (58)
		nop
; ---------------------------------------------------------------------------
		jmp	(GMAReturn).l			; Null (60)
		nop
; ---------------------------------------------------------------------------
		jmp	(GMAReturn).l			; Null (68)
		nop
; ---------------------------------------------------------------------------
		jmp	(GMAReturn).l			; Null (70)
		nop
; ---------------------------------------------------------------------------
		jmp	(GMAReturn).l			; Null (78)
		nop
; ---------------------------------------------------------------------------

GMAReturn:
		rts
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

sub_5090:
		moveq	#0,d3
		move.w	d1,d3
		lsl.l	#2,d3
		lsr.w	#2,d3
		ori.w	#$4000,d3
		swap	d3
		move.l	d3,(vdp_control_port).l
		move.w	d0,d1
		rol.w	#4,d1
		bsr.s	sub_50B4
		rol.w	#4,d1
		bsr.s	sub_50B4
		rol.w	#4,d1
		bsr.s	sub_50B4
		rol.w	#4,d1

sub_50B4:
		move.w	d1,d2
		andi.w	#$F,d2
		move.w	#0,d3
		add.b	loc_50CA(pc,d2.w),d3
		move.w	d3,(vdp_data_port).l
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

loc_50CA:
		move.b	(a1),d0
		move.b	(a3),d1
		move.b	(a5),d2
		move.b	(sp),d3
		move.b	(a1)+,d4
		move.l	-(a2),-(a0)
		move.l	-(a4),-(a1)
		move.l	-(a6),-(a2)
		movem.l	d2-d6/a0-a1,-(sp)
		moveq	#0,d3
		move.w	d1,d3
		lsl.l	#2,d3
		lsr.w	#2,d3
		ori.w	#$4000,d3
		swap	d3
		move.l	d3,(vdp_control_port).l
		cmpi.w	#$FFFF,d0
		bcs.s	loc_50FC
		move.w	#$FFFF,d0

loc_50FC:
		lea	loc_5152(pc),a0
		moveq	#4,d1
		move.w	#0,d4
		move.w	#$10,d5
		moveq	#0,d6
		lea	(vdp_data_port).l,a1
		tst.w	d0
		beq.s	loc_5142

loc_5116:
		moveq	#0,d2
		move.w	(a0)+,d3

loc_511A:
		sub.w	d3,d0
		bcs.s	loc_5122
		addq.w	#1,d2
		bra.s	loc_511A
; ---------------------------------------------------------------------------

loc_5122:
		add.w	d3,d0
		tst.b	d6
		bne.s	loc_5130
		tst.w	d2
		beq.s	loc_5136
		move.b	#1,d6

loc_5130:
		add.w	d5,d2
		move.w	d2,(a1)
		bra.s	loc_5138
; ---------------------------------------------------------------------------

loc_5136:
		move.w	d4,(a1)

loc_5138:
		dbf	d1,loc_5116
		movem.l	(sp)+,d2-d6/a0-a1
		rts
; ---------------------------------------------------------------------------

loc_5142:
		subq.w	#1,d1

loc_5144:
		move.w	d4,(a1)
		dbf	d1,loc_5144
		move.w	d5,(a1)
		movem.l	(sp)+,d2-d6/a0-a1
		rts
; ---------------------------------------------------------------------------
loc_5152:	dc.b $27
		dc.b $10
		dc.b   3
		dc.b $E8				; �
		dc.b   0
		dc.b $64				; d
		dc.b   0
		dc.b  $A
		dc.b   0
		dc.b   1
		dc.b $74				; t
		dc.b   0
		dc.b $34				; 4
		dc.b   0
		dc.b $E5				; �
		dc.b $8A				; �
		dc.b $E4				; �
		dc.b $4A				; J
		dc.b   0
		dc.b $42				; B
		dc.b $40				; @
		dc.b   0
		dc.b $48				; H
		dc.b $42				; B
		dc.b $23				; #
		dc.b $C2				; �
		dc.b   0
		dc.b $C0				; �
		dc.b   0
		dc.b   4
		dc.b $70				; p
		dc.b   0
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown subroutine
; ---------------------------------------------------------------------------

UnknownRout002:
		move.b	(a0)+,d0
		bmi.s	UR002Return
		subi.w	#$20,d0
		addi.w	#0,d0
		or.w	d1,d0
		move.w	d0,(vdp_data_port).l
		bra.s	UnknownRout002

UR002Return:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; subroutine to load the Z80
; ---------------------------------------------------------------------------

SoundDriverLoad:
		disable_ints				; set the stack register (Stopping VBlank)
		stopZ80
		waitZ80
		resetZ80
		lea	Z80_Driver(pc),a0		; load Z80 location on ROM to a0
		lea	(z80_ram).l,a1			; load current Z80 RAM
		move.w	#(Z80_Driver_end-Z80_Driver)-1,d0 ; set repeat times

.dumpRAM:
		move.b	(a0)+,(a1)+			; dump Z80 to Z80 RAM
		dbf	d0,.dumpRAM			; repeat til Z80 is dumped

.wait:
		move.b	#0,(a1)+			; clear the remaining Z80 space
		cmpa.l	#z80_ram_end,a1			; has the end of Z80 been reached?
		bne.s	.wait				; if not, loop til it has
		resetZ80a
		moveq	#$7F,d0				; set repeat times
		dbf	d0,*				; delay to make sure the YM2612 works correctly
		startZ80
		resetZ80
		enable_ints				; set the stack register (Starting VBlank)
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
Z80_Driver:
		include	"sound/Z80.asm"
Z80_Driver_end:	even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; subroutine to save BGM number to Z80 to play music
; ---------------------------------------------------------------------------

PlayMusic:
		stopZ80
		waitZ80
		move.b	d0,(z80_ram+zSoundQueue1).l	; save BGM number to Z80
		startZ80
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Sega Screen (Mode: 00)
; ---------------------------------------------------------------------------

SegaScreen:
		pea	(a0)
		lea	loc_6EB4(pc),a0
		move.l	a0,(v_vdpindex).w
		movem.l	(sp)+,a0
		jsr	(SoundDriverLoad).l		; load the Z80 Sound Driver
		lea	loc_6442(pc),a0
		jsr	(sub_8D0).w
		bra.s	SegaContin
; ===========================================================================
; ---------------------------------------------------------------------------
loc_6442:	dc.w $8230
		dc.w $8407
		dc.w $833C
		dc.w $855C
		dc.w $8D2F
		dc.w $8B00
		dc.w $8C81
		dc.w $9011
		dc.w $8700
		dc.w $9100
		dc.w $9200
		dc.w 0
; ---------------------------------------------------------------------------
; ===========================================================================

SegaContin:
		move.w	#$80,($FFFFD820).w
		moveq	#$3F,d0
		moveq	#$3F,d1
		moveq	#0,d2
		move.w	($FFFFD816).w,d3
		jsr	(sub_86E).w
		moveq	#$3F,d0
		moveq	#$3F,d1
		moveq	#0,d2
		move.w	($FFFFD818).w,d3
		jsr	(sub_86E).w
		lea	PAL_Segalogo(pc),a0		; load Sega Palette address to a0
		lea	($FFFFD3E4).w,a1
		movem.l	(a0)+,d0-d7
		movem.l	d0-d7,(a1)
		lea	$20(a1),a1
		movem.l	(a0)+,d0-d7
		movem.l	d0-d7,(a1)
		bsr.w	sub_682C
		move.l	#$F01,d0
		moveq	#1,d1
		lea	($FFFFD164).w,a0
		moveq	#6,d7

loc_64AA:
		move.l	d0,(a0)+
		move.l	d1,(a0)+
		addq.w	#1,d0
		dbf	d7,loc_64AA
		move.l	#$F00,(a0)+
		move.l	d1,(a0)
		clr.w	($FFFFFAC4).w
		move.w	#1,($FFFFFAC6).w
		move.w	($FFFFFFC4).w,d0
		andi.w	#4,d0
		move.w	d0,($FFFFFAC8).w
		ori.w	#$8124,($FFFFC9BA).w
		move.w	($FFFFC9BA).w,(vdp_control_port).l
		ori.w	#$8144,($FFFFC9BA).w
		move.w	($FFFFC9BA).w,(vdp_control_port).l
		addq.w	#4,(v_subgamemode).w		; increase sega screen mode

loc_64F2:
		pea	(loc_64F2).l
		bclr	#7,($FFFFFFC9).w

loc_64FE:
		tst.b	($FFFFFFC9).w
		bpl.s	loc_64FE
		move.w	(v_subgamemode).w,d0		; load sub mode to d0
		jmp	SegaSubArray(pc,d0.w)		; jump to correct sub mode routine
; ===========================================================================
; ---------------------------------------------------------------------------
; Sega Screen Sub Modes
; ---------------------------------------------------------------------------
SegaSubArray:	bra.w	SegaScreen
; ---------------------------------------------------------------------------
		bra.w	loc_6526
; ---------------------------------------------------------------------------
		bra.w	SegaPaletteStart
; ---------------------------------------------------------------------------
		bra.w	SegaPaletteCycle
; ---------------------------------------------------------------------------
		bra.w	loc_65C6
; ---------------------------------------------------------------------------
		bra.w	loc_65F6
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; subroutine to return without doing anything (Used in multiple routines)
; ---------------------------------------------------------------------------

MultiReturn:
		rts					; return

; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

loc_6526:
		tst.b	($FFFFC93C).w
		bpl.s	loc_6532
		move.w	#$14,(v_subgamemode).w

loc_6532:
		move.w	($FFFFFAC8).w,d0
		jmp	loc_653A(pc,d0.w)

loc_653A:
		bra.w	loc_696A
		bra.w	loc_6C20

; ===========================================================================
; ---------------------------------------------------------------------------
; Sega Screen palette cycling startup routine
; ---------------------------------------------------------------------------

SegaPaletteStart:
		tst.b	($FFFFC93C).w
		bpl.s	loc_654E
		move.w	#$14,(v_subgamemode).w

loc_654E:
		subq.w	#1,($FFFFFAC4).w
		bne.s	MultiReturn
		moveq	#$3F,d0
		moveq	#$3F,d1
		moveq	#0,d2
		move.w	($FFFFD816).w,d3
		jsr	(sub_86E).w
		moveq	#$3F,d0
		moveq	#$3F,d1
		moveq	#0,d2
		move.w	($FFFFD818).w,d3
		jsr	(sub_86E).w
		move.w	#0,($FFFFFAC4).w		; clear colour number
		move.w	($FFFFD3E8).w,($FFFFFAC6).w	; save first colour to storage
		move.w	#$EEE,($FFFFD3E8).w		; save white to colour palette
		addq.w	#4,(v_subgamemode).w		; increase sub mode
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Sega Screen palette cycling routine
; ---------------------------------------------------------------------------

SegaPaletteCycle:
		tst.b	($FFFFC93C).w
		bpl.s	loc_6594
		move.w	#$14,(v_subgamemode).w

loc_6594:
		lea	($FFFFD3E8).w,a0		; load palette address to a0
		move.w	($FFFFFAC4).w,d0		; load current colour number to d0
		add.w	d0,d0				; double it
		adda.w	d0,a0				; add to colour palette location
		move.w	($FFFFFAC6).w,(a0)+		; reload original colour from storage
		move.w	(a0),($FFFFFAC6).w		; save next current colour to storage
		move.w	#$EEE,(a0)			; save white to colour palette
		addq.w	#1,($FFFFFAC4).w		; increase colour number to next colour
		cmpi.w	#$C,($FFFFFAC4).w		; has colour number finished at C?
		bne.w	MultiReturn			; if not, branch to return
		move.w	#$40,($FFFFFAC4).w		; set colour number to 40
		addq.w	#4,(v_subgamemode).w		; increase sub mode
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

loc_65C6:
		tst.b	($FFFFC93C).w
		bpl.s	loc_65D2
		move.w	#$14,(v_subgamemode).w

loc_65D2:
		subq.w	#1,($FFFFFAC4).w		; minus 1 from colour number
		bpl.w	MultiReturn			; if still positive, branch
		moveq	#1,d0
		jsr	(sub_6CC).w
		bne.w	MultiReturn
		move.w	#id_Title,(v_gamemode).w	; set screen mode to title screen
		clr.l	(v_subgamemode).w		; clear sub mode
		movea.l	(RomStart).w,sp			; set stack pointer
		jmp	(MAINPROG).w			; jump to the main game loop
; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

loc_65F6:
		moveq	#1,d0
		jsr	(sub_6CC).w
		bne.w	MultiReturn
		move.w	#id_Title,(v_gamemode).w
		clr.l	(v_subgamemode).w
		movea.l	(RomStart).w,sp
		jmp	(MAINPROG).w
; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

SegaScrn_CheckRegion:
		move.b	(z80_version).l,d0		; load Z80 version number
		rol.b	#2,d0				; roll left 2 bits
		andi.w	#2,d0				; get only the original 1st bit that was in version number
		move.w	off_6626(pc,d0.w),($FFFFD402).w	; color a specific part of the palette depending on region
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

off_6626:
		;	black, white
		dc.w	$0000,$0EEE

loc_662A:
		lea	(vdp_data_port).l,a3
		movea.l	a4,a5

loc_6632:
		movea.l	a5,a6
		adda.w	($FFFFD816).w,a6
		subq.w	#6,a6
		jsr	(sub_6F26).l
		disable_ints
		move.l	d0,4(a3)
		move.w	d6,d5
		move.w	#$8100,d0

loc_664E:
		move.b	(a0)+,d0
		move.w	d0,(a3)
		move.b	(a0)+,d0
		move.w	d0,(a3)
		move.b	(a0)+,d0
		move.w	d0,(a3)
		move.b	(a0)+,d0
		move.w	d0,(a3)
		dbf	d5,loc_664E
		movea.l	a5,a6
		adda.w	($FFFFD818).w,a6
		subq.w	#6,a6
		jsr	(sub_6F26).l
		move.l	d0,4(a3)
		move.w	d6,d5
		move.w	#$8100,d0

loc_667A:
		move.b	(a0)+,d0
		move.w	d0,(a3)
		move.b	(a0)+,d0
		move.w	d0,(a3)
		move.b	(a0)+,d0
		move.w	d0,(a3)
		move.b	(a0)+,d0
		move.w	d0,(a3)
		dbf	d5,loc_667A
		enable_ints
		adda.w	d4,a5
		dbf	d7,loc_6632
		rts
; ---------------------------------------------------------------------------

loc_669A:
		movea.l	a4,a6
		adda.w	($FFFFD816).w,a6
		subq.w	#8,a6

loc_66A2:
		move.w	#$80F,d2
		lea	(vdp_data_port).l,a3

loc_66AC:
		jsr	(sub_6F26).l
		disable_ints
		move.l	d0,4(a3)
		move.w	d6,d5
		moveq	#0,d0
		move.l	d0,(a3)
		move.l	d0,(a3)

loc_66C2:
		move.l	(a0)+,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		dbf	d5,loc_66C2
		moveq	#0,d0
		move.l	d0,(a3)
		move.l	d0,(a3)
		enable_ints
		adda.w	d4,a6
		dbf	d7,loc_66AC
		rts
; ---------------------------------------------------------------------------

loc_6728:
		move.w	#$80F,d2
		lea	(vdp_data_port).l,a3
		movea.l	a4,a6
		adda.w	($FFFFD816).w,a6

loc_6738:
		jsr	(sub_6F26).l
		disable_ints
		move.l	d0,4(a3)
		movea.l	a0,a1
		move.w	d6,d5

loc_674A:
		move.l	(a1)+,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		move.w	d0,(a3)
		dbf	d5,loc_674A
		adda.w	d4,a6
		jsr	(sub_6F26).l
		move.l	d0,4(a3)
		move.w	d6,d5

loc_67BC:
		move.l	(a0)+,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		move.w	d0,(a3)
		rol.l	#4,d1
		move.l	d1,d0
		move.w	d2,d0
		rol.l	#4,d0
		move.w	d0,(a3)
		move.w	d0,(a3)
		dbf	d5,loc_67BC
		enable_ints
		adda.w	d4,a6
		dbf	d7,loc_6738
		rts

; =============== S U B	R O U T	I N E =======================================

; ===========================================================================
; ---------------------------------------------------------------------------
; this section maps the "SEGA" large letters on screen correctly
; ---------------------------------------------------------------------------

sub_682C:
		lea	(vdp_data_port).l,a3		; load VDP address to a3
		moveq	#$F,d7				; set repeat times
		disable_ints				; set the stack register (Stopping VBlank)
		move.l	#$5E000000,4(a3)		; set VDP to VRam write mode
		moveq	#0,d0				; clear d0

; this is to set the art in such a way that each tile represents 1 pixel on screen
; (Repeats for pixel values 0 to F)

DumpTileSizedPixel:
		move.l	d0,(a3)				; set value to VRam
		move.l	d0,(a3)
		move.l	d0,(a3)
		move.l	d0,(a3)
		move.l	d0,(a3)
		move.l	d0,(a3)
		move.l	d0,(a3)
		move.l	d0,(a3)
		addi.l	#$11111111,d0			; increase all nybbles by 1
		dbf	d7,DumpTileSizedPixel		; repeat 10 times
		moveq	#0,d2				; clear d2
		moveq	#$F,d7				; set d7 repeat times

; this is to set the art in such a way that each tile represents 1/4 of a pixel on screen
; (Repeats for pixel values 0 to F [x 4 as there are 4 pixels in 1 tile])

loc_6860:
		moveq	#0,d1				; clear d1
		moveq	#$F,d6				; set d6 repeat times

loc_6864:
		move.l	d2,d0				; copy value 2 to d0
		move.w	d1,d0				; copy value 1 to d0
		move.l	d0,(a3)				; set values to VRam
		move.l	d0,(a3)
		move.l	d0,(a3)
		move.l	d0,(a3)
		moveq	#0,d0				; clear end word of d0
		move.l	d0,(a3)				; set values to VRam
		move.l	d0,(a3)
		move.l	d0,(a3)
		move.l	d0,(a3)
		addi.w	#$1111,d1			; increase all nybbles in value 1 by 1
		dbf	d6,loc_6864			; repeat 10 times
		addi.l	#$11110000,d2			; increase all nybbles in value 2 by 1
		dbf	d7,loc_6860			; repeat 10 times
		enable_ints				; set the stack register
		lea	ARTCRA_SegaLogo(pc),a0		; load Crackers compressed Sega logo art address to a0
		lea	(unk_0200&$FFFFFF).l,a1		; load Ram address to dump, to a1
		jsr	(CracDec).l			; decompress the art and dump
; ---------------------------------------------------------------------------
; this part virtually copies the Sega art to a second location
; first location for Large SEGA letters, second location for small letters
; ---------------------------------------------------------------------------
		lea	(unk_0200&$FFFFFF).l,a0		; load dumped art location to a0
		lea	(unk_0A00&$FFFFFF).l,a1		; load second art location to a1
		move.l	#$48000000,(a1)+		; set VDP settings first to second art location
		move.w	#$40,(a1)+			; then set repeat times to it
		moveq	#3,d6				; set repeat times

loc_68B8:
		moveq	#$1F,d7

loc_68BA:
		move.l	(a0)+,(a1)+
		move.l	(a0)+,$7C(a1)
		move.l	(a0)+,$FC(a1)
		move.l	(a0)+,$17C(a1)
		dbf	d7,loc_68BA
		lea	$180(a1),a1
		dbf	d6,loc_68B8
		lea	(unk_0A00&$FFFFFF).l,a1
		jsr	(SegaToVDP).l
		lea	(unk_0200&$FFFFFF).l,a0
		lea	(unk_0A00&$FFFFFF).l,a1
		moveq	#$7F,d6

loc_68EE:
		moveq	#7,d7

loc_68F0:
		move.w	(a0)+,d0
		move.w	d0,d1
		move.w	d0,-(sp)
		move.b	(sp)+,d0
		ror.b	#4,d0
		ror.w	#4,d0
		swap	d0
		move.w	d1,d0
		lsl.w	#8,d0
		move.b	d1,d0
		ror.b	#4,d0
		ror.w	#4,d0
		move.l	d0,(a1)+
		move.l	d0,$1C(a1)
		dbf	d7,loc_68F0
		lea	$20(a1),a1
		dbf	d6,loc_68EE
		lea	(unk_0A00&$FFFFFF).l,a0
		lea	($FF2A00).l,a1
		move.l	#$40000001,(a1)+
		move.w	#$100,(a1)+
		moveq	#7,d6

loc_6932:
		moveq	#$1F,d7

loc_6934:
		move.l	(a0)+,(a1)+
		move.l	(a0)+,$7C(a1)
		move.l	(a0)+,$FC(a1)
		move.l	(a0)+,$17C(a1)
		move.l	(a0)+,$1FC(a1)
		move.l	(a0)+,$27C(a1)
		move.l	(a0)+,$2FC(a1)
		move.l	(a0)+,$37C(a1)
		dbf	d7,loc_6934
		lea	$380(a1),a1
		dbf	d6,loc_6932
		lea	($FF2A00).l,a1
		jmp	(SegaToVDP).l
; End of function sub_682C

; ---------------------------------------------------------------------------

loc_696A:
		subq.w	#1,($FFFFFAC6).w
		bne.w	MultiReturn
		addq.w	#4,($FFFFFAC4).w
		move.w	($FFFFFAC4).w,d0

loc_697A:
		jmp	loc_697A(pc,d0.w)
; ---------------------------------------------------------------------------
		bra.w	loc_69D2
; ---------------------------------------------------------------------------
		bra.w	loc_6A36
; ---------------------------------------------------------------------------
		bra.w	loc_6A88
; ---------------------------------------------------------------------------
		bra.w	loc_6AE6
; ---------------------------------------------------------------------------
		bra.w	loc_6B70
; ---------------------------------------------------------------------------
		bra.w	loc_69EC
; ---------------------------------------------------------------------------
		bra.w	loc_6A3E
; ---------------------------------------------------------------------------
		bra.w	loc_6A94
; ---------------------------------------------------------------------------
		bra.w	loc_6AF0
; ---------------------------------------------------------------------------
		bra.w	loc_6B7C
; ---------------------------------------------------------------------------
		bra.w	loc_69F4
; ---------------------------------------------------------------------------
		bra.w	loc_6A46
; ---------------------------------------------------------------------------
		bra.w	loc_6AA0
; ---------------------------------------------------------------------------
		bra.w	loc_6AFA
; ---------------------------------------------------------------------------
		bra.w	loc_6B88
; ---------------------------------------------------------------------------
		bra.w	loc_69FC
; ---------------------------------------------------------------------------
		bra.w	loc_6A4E
; ---------------------------------------------------------------------------
		bra.w	loc_6AAC
; ---------------------------------------------------------------------------
		bra.w	loc_6B04
; ---------------------------------------------------------------------------
		bra.w	loc_6B94
; ---------------------------------------------------------------------------
		bra.w	loc_6BD8
; ---------------------------------------------------------------------------

loc_69D2:
		move.w	#$8164,(vdp_control_port).l
		move.w	#$8164,($FFFFC9BA).w
		bsr.w	SegaScrn_CheckRegion
		lea	(unk_0200&$FFFFFF+$80).l,a0
		bra.s	loc_6A02
; ---------------------------------------------------------------------------

loc_69EC:
		lea	(unk_0400&$FFFFFF+$80).l,a0
		bra.s	loc_6A02
; ---------------------------------------------------------------------------

loc_69F4:
		lea	(unk_0600&$FFFFFF+$80).l,a0
		bra.s	loc_6A02
; ---------------------------------------------------------------------------

loc_69FC:
		lea	(unk_0800&$FFFFFF+$80).l,a0

loc_6A02:
		move.w	#8,($FFFFFAC6).w
		lea	($FFFFD164).w,a1
		clr.l	(a1)+
		move.w	#$FFA0,($FFFFCA5E).w
		move.w	#$FFA0,($FFFFCA60).w
		move.w	#$18,($FFFFCDDE).w
		move.w	#$14,($FFFFCDE0).w
		lea	(RomStart).w,a4
		move.w	#$80,d4
		moveq	#3,d6
		moveq	#$F,d7
		bra.w	loc_6728
; ---------------------------------------------------------------------------

loc_6A36:
		lea	(unk_0200&$FFFFFF).l,a0
		bra.s	loc_6A54
; ---------------------------------------------------------------------------

loc_6A3E:
		lea	(unk_0400&$FFFFFF).l,a0
		bra.s	loc_6A54
; ---------------------------------------------------------------------------

loc_6A46:
		lea	(unk_0600&$FFFFFF).l,a0
		bra.s	loc_6A54
; ---------------------------------------------------------------------------

loc_6A4E:
		lea	(unk_0800&$FFFFFF).l,a0

loc_6A54:
		move.w	#4,($FFFFFAC6).w
		lea	($FFFFD164).w,a1
		clr.l	(a1)+
		move.w	#$FFA0,($FFFFCA5E).w
		move.w	#$FFA0,($FFFFCA60).w
		move.w	#$18,($FFFFCDDE).w
		move.w	#$14,($FFFFCDE0).w
		lea	($20).w,a4
		move.w	#$80,d4
		moveq	#3,d6
		moveq	#$1F,d7
		bra.w	loc_669A
; ---------------------------------------------------------------------------

loc_6A88:
		lea	(unk_0200&$FFFFFF).l,a0
		move.w	#$FFA0,d0
		bra.s	loc_6AB6
; ---------------------------------------------------------------------------

loc_6A94:
		lea	(unk_0400&$FFFFFF).l,a0
		move.w	#$FFB0,d0
		bra.s	loc_6AB6
; ---------------------------------------------------------------------------

loc_6AA0:
		lea	(unk_0600&$FFFFFF).l,a0
		move.w	#$FFC0,d0
		bra.s	loc_6AB6
; ---------------------------------------------------------------------------

loc_6AAC:
		lea	(unk_0800&$FFFFFF).l,a0
		move.w	#$FFD0,d0

loc_6AB6:
		move.w	#4,($FFFFFAC6).w
		lea	($FFFFD164).w,a1
		clr.l	(a1)+
		move.w	d0,($FFFFCA5E).w
		move.w	d0,($FFFFCA60).w
		move.w	#$118,($FFFFCDDE).w
		move.w	#$114,($FFFFCDE0).w
		lea	(loc_1430).w,a4
		move.w	#$80,d4
		moveq	#3,d6
		moveq	#$F,d7
		bra.w	loc_662A
; ---------------------------------------------------------------------------

loc_6AE6:
		move.w	#$200,d7
		move.w	#$E0,d0				; "�"
		bra.s	loc_6B0C
; ---------------------------------------------------------------------------

loc_6AF0:
		move.w	#$240,d7
		move.w	#$F0,d0				; "�"
		bra.s	loc_6B0C
; ---------------------------------------------------------------------------

loc_6AFA:
		move.w	#$280,d7
		move.w	#$110,d0
		bra.s	loc_6B0C
; ---------------------------------------------------------------------------

loc_6B04:
		move.w	#$2C0,d7
		move.w	#$120,d0

loc_6B0C:
		move.w	#4,($FFFFFAC6).w
		move.w	#$A0,($FFFFCA5E).w		; "�"
		move.w	#$A0,($FFFFCA60).w		; "�"
		move.w	#$118,($FFFFCDDE).w
		move.w	#$114,($FFFFCDE0).w
		lea	($FFFFD164).w,a0
		move.l	#$C80F01,(a0)+
		move.w	d7,(a0)+
		move.w	d0,(a0)+
		addi.w	#$10,d7
		move.l	#$C80F02,(a0)+
		move.w	d7,(a0)+
		addi.w	#$20,d0
		move.w	d0,(a0)+
		addi.w	#$10,d7
		move.l	#$E80F03,(a0)+
		move.w	d7,(a0)+
		subi.w	#$20,d0
		move.w	d0,(a0)+
		addi.w	#$10,d7
		move.l	#$E80F04,(a0)+
		move.w	d7,(a0)+
		addi.w	#$20,d0
		move.w	d0,(a0)
		rts
; ---------------------------------------------------------------------------

loc_6B70:
		move.l	#$4000EF,d7
		lea	($FFFFD184).w,a0
		bra.s	loc_6B9E
; ---------------------------------------------------------------------------

loc_6B7C:
		move.l	#$500105,d7
		lea	($FFFFD18C).w,a0
		bra.s	loc_6B9E
; ---------------------------------------------------------------------------

loc_6B88:
		move.l	#$60011B,d7
		lea	($FFFFD194).w,a0
		bra.s	loc_6B9E
; ---------------------------------------------------------------------------

loc_6B94:
		move.l	#$700135,d7
		lea	($FFFFD19C).w,a0

loc_6B9E:
		move.w	#4,($FFFFFAC6).w
		move.w	#$A0,($FFFFCA5E).w		; "�"
		move.w	#$A0,($FFFFCA60).w		; "�"
		move.w	#$118,($FFFFCDDE).w
		move.w	#$114,($FFFFCDE0).w
		move.w	#$D8,(a0)+
		addq.l	#2,a0
		move.l	d7,(a0)
		lea	($FFFFD164).w,a0
		clr.w	(a0)
		addq.l	#8,a0
		clr.w	(a0)
		addq.l	#8,a0
		clr.w	(a0)
		addq.l	#8,a0
		clr.w	(a0)
		rts
; ---------------------------------------------------------------------------

loc_6BD8:
		lea	($FFFFD164).w,a0
		move.l	$20(a0),d0
		move.b	3(a0),d0
		move.l	d0,(a0)+
		move.l	$20(a0),(a0)+
		move.l	$20(a0),d0
		move.b	3(a0),d0
		move.l	d0,(a0)+
		move.l	$20(a0),(a0)+
		move.l	$20(a0),d0
		move.b	3(a0),d0
		move.l	d0,(a0)+
		move.l	$20(a0),(a0)+
		move.l	$20(a0),d0
		move.b	3(a0),d0
		move.l	d0,(a0)+
		move.l	$20(a0),(a0)
		move.w	#$10,($FFFFFAC4).w
		addq.w	#4,(v_subgamemode).w
		rts
; ---------------------------------------------------------------------------

loc_6C20:
		move.w	($FFFFFAC4).w,d0
		jmp	loc_6C28(pc,d0.w)
; ---------------------------------------------------------------------------

loc_6C28:
		bra.w	loc_6C48
; ---------------------------------------------------------------------------
		bra.w	loc_6CFC
; ---------------------------------------------------------------------------
		bra.w	loc_6D22
; ---------------------------------------------------------------------------
		bra.w	loc_6CFC
; ---------------------------------------------------------------------------
		bra.w	loc_6D6E
; ---------------------------------------------------------------------------
		bra.w	loc_6DDC
; ---------------------------------------------------------------------------
		bra.w	loc_6DFE
; ---------------------------------------------------------------------------
		bra.w	loc_6E66
; ---------------------------------------------------------------------------

loc_6C48:
		move.w	#$9003,(vdp_control_port).l
		move.w	#$9003,($FFFFC9D8).w
		lea	(vdp_data_port).l,a3
		movea.w	($FFFFD816).w,a6
		lea	$BE(a6),a6
		move.l	#$A0F1A0F1,d2
		disable_ints
		moveq	#$1F,d7

loc_6C70:
		jsr	(sub_6F26).l
		move.l	d0,4(a3)
		move.l	d2,(a3)
		move.l	d2,(a3)
		move.l	d2,(a3)
		move.l	d2,(a3)
		adda.w	#$100,a6
		dbf	d7,loc_6C70
		enable_ints
		addq.w	#4,($FFFFFAC4).w
		move.w	#$20,($FFFFFAC6).w		; " "
		move.w	#$F8,($FFFFCA5E).w
		move.w	#$18,($FFFFCDDE).w
		move.w	#$F8,($FFFFCA60).w
		move.w	#$18,($FFFFCDE0).w
		lea	(unk_0200&$FFFFFF).l,a0
		movea.w	($FFFFD816).w,a6
		bsr.w	sub_6CF0
		lea	(unk_0400&$FFFFFF).l,a0
		movea.w	($FFFFD818).w,a6
		lea	$2C(a6),a6
		bsr.w	sub_6CF0
		lea	(unk_0600&$FFFFFF).l,a0
		movea.w	($FFFFD816).w,a6
		lea	$58(a6),a6
		bsr.w	sub_6CF0
		lea	(unk_0800&$FFFFFF).l,a0
		movea.w	($FFFFD818).w,a6
		lea	$8C(a6),a6

; =============== S U B	R O U T	I N E =======================================


sub_6CF0:

; FUNCTION CHUNK AT 000066A2 SIZE 00000086 BYTES

		move.w	#$100,d4
		moveq	#3,d6
		moveq	#$1F,d7
		bra.w	loc_66A2
; End of function sub_6CF0

; ---------------------------------------------------------------------------

loc_6CFC:
		move.w	#$8164,(vdp_control_port).l
		move.w	#$8164,($FFFFC9BA).w
		subi.w	#$10,($FFFFCA5E).w
		subi.w	#$10,($FFFFCA60).w
		subq.w	#1,($FFFFFAC6).w
		bne.s	locret_6D20
		addq.w	#4,($FFFFFAC4).w

locret_6D20:
		rts
; ---------------------------------------------------------------------------

loc_6D22:
		lea	(vdp_data_port).l,a3
		moveq	#0,d2
		movea.w	($FFFFD816).w,a6
		lea	$BE(a6),a6
		disable_ints
		moveq	#$1F,d7

loc_6D38:
		jsr	(sub_6F26).l
		move.l	d0,4(a3)
		move.l	d2,(a3)
		move.l	d2,(a3)
		move.l	d2,(a3)
		move.l	d2,(a3)
		adda.w	#$100,a6
		dbf	d7,loc_6D38
		enable_ints
		subi.w	#$10,($FFFFCA5E).w
		subi.w	#$10,($FFFFCA60).w
		addq.w	#4,($FFFFFAC4).w
		move.w	#$20,($FFFFFAC6).w		; " "
		rts
; ---------------------------------------------------------------------------

loc_6D6E:
		bsr.w	SegaScrn_CheckRegion
		disable_ints
		moveq	#$3F,d0
		moveq	#$3F,d1
		moveq	#0,d2
		move.w	($FFFFD816).w,d3
		jsr	(sub_86E).w
		moveq	#$3F,d0
		moveq	#$3F,d1
		moveq	#0,d2
		move.w	($FFFFD818).w,d3
		jsr	(sub_86E).w
		enable_ints
		lea	(dword_6DBC).l,a0
		lea	($FFFFD164).w,a1
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		addq.w	#4,($FFFFFAC4).w
		move.w	#$20,($FFFFFAC6).w		; " "
		rts
; ---------------------------------------------------------------------------
dword_6DBC:	dc.l $D80F01
		dc.l $40FFEF
		dc.l $D80F02
		dc.l $500005
		dc.l $D80F03
		dc.l $60001B
		dc.l $D80F00
		dc.l $700035
; ---------------------------------------------------------------------------

loc_6DDC:
		addq.w	#8,($FFFFD16A).w
		addq.w	#8,($FFFFD172).w
		addq.w	#8,($FFFFD17A).w
		addq.w	#8,($FFFFD182).w
		subq.w	#1,($FFFFFAC6).w
		bne.s	locret_6DFC
		addq.w	#4,($FFFFFAC4).w
		move.w	#$21,($FFFFFAC6).w		; "!"

locret_6DFC:
		rts
; ---------------------------------------------------------------------------

loc_6DFE:
		subq.w	#1,($FFFFFAC6).w
		beq.s	loc_6E40
		move.w	($FFFFFAC6).w,d0
		move.w	d0,d1
		andi.w	#3,d1
		bne.s	locret_6E3E
		andi.w	#$1C,d0
		lea	(dword_6E46).l,a0
		adda.w	d0,a0
		lea	($FFFFD16A).w,a1
		move.b	(a0)+,d0
		ext.w	d0
		add.w	d0,(a1)
		move.b	(a0)+,d0
		ext.w	d0
		add.w	d0,8(a1)
		move.b	(a0)+,d0
		ext.w	d0
		add.w	d0,$10(a1)
		move.b	(a0)+,d0
		ext.w	d0
		add.w	d0,$18(a1)

locret_6E3E:
		rts
; ---------------------------------------------------------------------------

loc_6E40:
		addq.w	#4,($FFFFFAC4).w
		rts
; ---------------------------------------------------------------------------
dword_6E46:	dc.l 0
		dc.l $FEFFFF00
		dc.l $FEFEFFFF
		dc.l $FEFFFF00
		dc.l $FEFEFFFF
		dc.l 0
		dc.l $2020202
		dc.l $6040200
; ---------------------------------------------------------------------------

loc_6E66:
		lea	($FFFFD184).w,a0
		move.l	-$20(a0),d0
		move.b	3(a0),d0
		move.l	d0,(a0)+
		move.l	-$20(a0),(a0)+
		move.l	-$20(a0),d0
		move.b	3(a0),d0
		move.l	d0,(a0)+
		move.l	-$20(a0),(a0)+
		move.l	-$20(a0),d0
		move.b	3(a0),d0
		move.l	d0,(a0)+
		move.l	-$20(a0),(a0)+
		move.l	-$20(a0),d0
		move.b	3(a0),d0
		move.l	d0,(a0)+
		move.l	-$20(a0),(a0)
		move.b	#4,-$21(a0)
		move.w	#$10,($FFFFFAC4).w
		addq.w	#4,(v_subgamemode).w
		rts
; ---------------------------------------------------------------------------

loc_6EB4:
		movem.l	d0-a6,-(sp)
		jsr	(sub_96E).w
		move.l	#$FFFFD164,d0
		move.w	($FFFFD81A).w,d1
		move.w	#$140,d2
		jsr	(sub_5E8).w
		jsr	(VDPSetup_01).w
		move.w	($FFFFD81C).w,d0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		andi.w	#3,d0
		move.l	d0,(vdp_control_port).l
		move.l	($FFFFCA5E).w,(vdp_data_port).l
		move.l	#$40000010,(vdp_control_port).l
		move.l	($FFFFCDDE).w,(vdp_data_port).l
		move.w	($FFFFFFC4).w,d0
		add.w	d0,d0
		add.w	d0,d0
		add.w	($FFFFFFC4).w,d0
		addq.w	#1,d0
		move.w	d0,($FFFFFFC4).w
		ori.b	#$80,($FFFFFFC9).w
		addq.w	#1,($FFFFF000).w
		movem.l	(sp)+,d0-a6
		rte

; =============== S U B	R O U T	I N E =======================================


sub_6F26:
		move.w	a6,d0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		andi.w	#3,d0
		rts
; End of function sub_6F26


; ===========================================================================
; ---------------------------------------------------------------------------
; subroutine to dump Sega Tile Data to VDP"s VRam
; ---------------------------------------------------------------------------

SegaToVDP:
		move.l	(a0)+,d0			; load VDP settings to d0
		move.w	(a0)+,d7			; load no of repeats to d7
		lea	(vdp_data_port).l,a5		; load VDP address to a5
		move	sr,-(sp)			; move sr to stack pointer
		disable_ints				; set the stack register (Stopping VBlank)
		move.l	d0,4(a5)			; set VDP settings to VDP

SegatoVDPRep:
		move.l	(a0)+,(a5)			; dump data to VRam
		move.l	(a0)+,(a5)
		move.l	(a0)+,(a5)
		move.l	(a0)+,(a5)
		move.l	(a0)+,(a5)
		move.l	(a0)+,(a5)
		move.l	(a0)+,(a5)
		move.l	(a0)+,(a5)
		dbf	d7,SegatoVDPRep			; repeat
		rte
; ===========================================================================
; ---------------------------------------------------------------------------
PAL_Segalogo:	binclude	"Palettes/PalSegaLogo.bin" ; palettes used in the Sega logo
		even
ARTCRA_SegaLogo:binclude	"artcra/Sega Logo.bin"	; compressed Sega patterns
		even
; ---------------------------------------------------------------------------
; Unknown Data
		dc.w $31F9
		dc.w $0111
		dc.w $FF0A
		dc.w $F00F
		dc.w $FFFF
		dc.w $FFFF
		dc.w $FF00
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Title Screen (Mode: 08)
; ---------------------------------------------------------------------------

TitleScreen:
		move.w	(v_subgamemode).w,d0		; load sub mode to d0
		jmp	loc_735E(pc,d0.w)		; go to correct routine dependant on d0

; ===========================================================================
; ---------------------------------------------------------------------------
; Sega Screen Sub Modes
; ---------------------------------------------------------------------------
loc_735E:	bra.w	TitleLoad
; ---------------------------------------------------------------------------
		bra.w	TitleStart
; ---------------------------------------------------------------------------
; ===========================================================================

TitleLoad:
		pea	(a0)
		lea	loc_7576(pc),a0
		move.l	a0,(v_vdpindex).w
		movem.l	(sp)+,a0
		disable_ints
		lea	loc_7382(pc),a0
		jsr	(sub_8D0).w
		bra.s	loc_739A
; ---------------------------------------------------------------------------
loc_7382:	dc.w $8230
		dc.w $8407
		dc.w $833C
		dc.w $857C
		dc.w $8D3F
		dc.w $8B00
		dc.w $8C81
		dc.w $9011
		dc.w $8700
		dc.w $9100
		dc.w $9200
		dc.w 0
; ---------------------------------------------------------------------------

loc_739A:
		move.w	($FFFFD81C).w,d0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		andi.w	#3,d0
		move.l	d0,(vdp_control_port).l
		move.l	#0,(vdp_data_port).l
		move.l	#$40000010,(vdp_control_port).l
		move.l	#0,(vdp_data_port).l
		moveq	#$3F,d0
		moveq	#$3F,d1
		moveq	#0,d2
		move.w	#$C000,d3
		jsr	(sub_86E).w
		moveq	#$3F,d0
		moveq	#$3F,d1
		moveq	#0,d2
		move.w	#$E000,d3
		jsr	(sub_86E).w
		lea	ARTNEM_MainMenusText(pc),a0	; load Main Menu text art address to a0
		move.l	#$40000000,(vdp_control_port).l	; set VDP location to dump
		jsr	(NemDec).w			; decompress
		move.l	#$41040003,d0			; prepare VDP settings
		lea	MAPUNC_TitleMenu_1(pc),a1	; load uncompressed title mappings to a1 (Title Screen "Banner")
		moveq	#$25,d1				; set X loop
		moveq	#$F,d2				; set Y loop
		move.w	#0,d3				; set to use palette line 0 (and to map behind object plane)
		jsr	(MapScreen).w			; map it on screen correctly
		move.l	#$4A180003,d0			; prepare VDP settings
		lea	MAPUNC_TitleMenu_2(pc),a1	; load uncompressed title mappings to a1 (Title Screen "Main Menu Selection")
		moveq	#7,d1				; set X loop
		moveq	#3,d2				; set Y loop
		move.w	#0,d3				; set to use palette line 0 (and to map behind object plane)
		move.w	#$100,($FFFFD820).w
		jsr	(MapScreen).w			; map it on screen correctly
		move.w	#$80,($FFFFD820).w
		move.l	#$4BBC0003,d0
		lea	MAPUNC_TitleMenu_3(pc),a1	; load uncompressed title mappings to a1 (Title Screen "1ST	ROM 19940401")
		moveq	#7,d1				; set X loop
		moveq	#1,d2				; set Y loop
		move.w	#0,d3				; set to use palette line 0 (and to map behind object plane)
		move.w	#$100,($FFFFD820).w
		jsr	(MapScreen).w			; map it on screen correctly
		move.w	#$80,($FFFFD820).w
		lea	PAL_MainMenus(pc),a0
		lea	($FFFFD3E4).w,a1
		moveq	#$F,d0

loc_7462:
		move.l	(a0)+,(a1)+
		dbf	d0,loc_7462
		jsr	(VDPSetup_01).w
		move.l	#$78000003,(vdp_control_port).l
		move.l	#0,(vdp_data_port).l
		move.l	#$1E00D0,(vdp_data_port).l
		clr.w	($FFFFD826).w
		clr.w	($FFFFD832).w
		enable_ints				; set the stack register
		addq.w	#4,(v_subgamemode).w		; increase sub mode
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
PAL_MainMenus:	binclude	"Palettes/PalMainMenus.bin"
		even
; ---------------------------------------------------------------------------
; ===========================================================================

TitleStart:
		bclr	#7,($FFFFFFC9).w

loc_74E2:
		tst.b	($FFFFFFC9).w
		bpl.s	loc_74E2
		move.w	($FFFFC946).w,d0
		add.w	($FFFFD826).w,d0
		bpl.s	loc_74F4
		moveq	#0,d0

loc_74F4:
		cmpi.w	#3,d0
		bls.s	loc_74FC
		moveq	#3,d0

loc_74FC:
		move.w	d0,($FFFFD826).w
		lsl.w	#4,d0
		addi.w	#$120,d0
		move.w	d0,($FFFFD832).w
		tst.b	($FFFFC93D).w
		bmi.s	loc_7512
		rts
; ---------------------------------------------------------------------------

loc_7512:
		clr.w	($FFFFD83A).w
		clr.w	(v_subgamemode).w
		move.w	($FFFFD826).w,d0
		beq.s	loc_7526
		cmpi.w	#1,d0
		bne.s	loc_7552

loc_7526:
		move.w	#1,($FFFFD834).w
		move.w	#1,($FFFFD836).w
		move.w	#id_Level,(v_gamemode).w
		move.b	#0,($FFFFD89C).w
		tst.w	d0
		bne.s	loc_754A
		move.b	#$FF,($FFFFD8AC).w
		rts
; ---------------------------------------------------------------------------

loc_754A:
		move.b	#$10,($FFFFD8AC).w
		rts
; ---------------------------------------------------------------------------

loc_7552:
		cmpi.w	#2,($FFFFD826).w
		bne.s	loc_7562
		move.w	#id_Options,(v_gamemode).w		; "@"
		rts
; ---------------------------------------------------------------------------

loc_7562:
		move.b	#0,($FFFFD89C).w
		move.b	#$FF,($FFFFD8AC).w
		move.w	#id_LevelSelect,(v_gamemode).w		; "0"
		rts
; ---------------------------------------------------------------------------

loc_7576:
		movem.l	d0-a6,-(sp)
		move.l	#$78000003,(vdp_control_port).l
		move.w	($FFFFD832).w,(vdp_data_port).l
		jsr	(sub_96E).w
		move.b	($FFFFC93C).w,d0
		bsr.s	sub_75BC
		move.w	d1,($FFFFC940).w
		move.w	d2,($FFFFC942).w
		move.b	($FFFFC93D).w,d0
		bsr.s	sub_75BC
		move.w	d1,($FFFFC944).w
		move.w	d2,($FFFFC946).w
		jsr	(VDPSetup_01).w
		ori.b	#$80,($FFFFFFC9).w
		movem.l	(sp)+,d0-a6
		rte

; =============== S U B	R O U T	I N E =======================================


sub_75BC:
		moveq	#3,d1
		and.w	d0,d1
		ror.w	#1,d1
		ext.l	d1
		move.w	d1,d2
		swap	d1
		or.w	d1,d2
		andi.w	#$C,d0
		ror.w	#3,d0
		ext.l	d0
		move.w	d0,d1
		swap	d0
		or.w	d0,d1
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
ARTNEM_MainMenusText:
		binclude	"artnem/Main Menu Text.bin"
		even
MAPUNC_TitleMenu_1:
		binclude	"Uncompressed/MapuncTitleMenu01.bin" ; Uncompressed mappings	for the	title screen banner
		even
MAPUNC_TitleMenu_2:
		binclude	"Uncompressed/MapuncTitleMenu02.bin" ; Uncompressed mappings	for the	title menu selection
		even
MAPUNC_TitleMenu_3:
		binclude	"Uncompressed/MapuncTitleMenu03.bin" ; Uncompressed mappings	for the	title menu (1ST	ROM 19940401)
		even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Field Screens (Mode: 10)
; ---------------------------------------------------------------------------

Fields:
		pea	(a0)
		lea	loc_8010(pc),a0
		move.l	a0,(v_vdpindex).w
		movem.l	(sp)+,a0
		lea	loc_7ED8(pc),a0
		jsr	(sub_8D0).w
		move.b	#bgm_Electoria,d0		; load BGM 81
		jsr	(PlayMusic).l			; Play BGM
		lea	PAL_PrimaryColours_Field(pc),a0	; load primary Field palettes address to a0
		lea	($FFFFD3E4).w,a1
		movem.l	(a0)+,d0-d7
		movem.l	d0-d7,(a1)
		lea	$20(a1),a1
		movem.l	(a0)+,d0-d7
		movem.l	d0-d7,(a1)
		andi.w	#$81BC,($FFFFC9BA).w
		move.w	($FFFFC9BA).w,(vdp_control_port).l
		jsr	(sub_8634).l
		jsr	(sub_15D0).w
		move.w	#5,($FFFFD83C).w
		move.w	#7,($FFFFD840).w
		move.w	#$3F,($FFFFD844).w		; "?"
		move.w	#$3F,($FFFFD848).w		; "?"
		jsr	(sub_8196).l
		jsr	(sub_D1E0).l
		jsr	(sub_FA44).l
		ori.w	#$8144,($FFFFC9BA).w
		move.w	($FFFFC9BA).w,(vdp_control_port).l
		bra.w	loc_7EEC
; ===========================================================================
; ---------------------------------------------------------------------------
PAL_PrimaryColours_Field:
		binclude	 "Palettes/PalPrimaryColoursField.bin"
		even
; ---------------------------------------------------------------------------
loc_7ED8:	dc.w $8230
		dc.w $832C
		dc.w $8407
		dc.w $8554
		dc.w $8D2B
		dc.w $9011
		dc.w $8720
		dc.w $8B03
		dc.w $8C89
		dc.w 0
; ---------------------------------------------------------------------------
; ===========================================================================

loc_7EEC:

		pea	(loc_7EEC).l
		bclr	#7,($FFFFFFC9).w

loc_7EF8:
		tst.b	($FFFFFFC9).w			; I think these act like a lagger, removing them...
		bpl.s	loc_7EF8			; ...causes the fields to run extremely fast
		bsr.w	sub_F390
		jsr	(Field_ReadController).l
		jsr	(Field_PauseGame).l
		jsr	(sub_CCCA).l			; commented out causes screen not to follow durin normal play, and stars on the tether didn"t animate
		jsr	(sub_81F8).l			; Sonic/Tails object related
		jsr	(sub_82B2).l			; deformation/screen control??
		disable_ints
		jsr	(BuildSprites).w			; object loading routine/sprite building (We think)
		enable_ints
		rts

; =============== S U B	R O U T	I N E =======================================

Field_ReadController:
		jsr	(sub_96E).w
		lea	(unk_C938).w,a3
		moveq	#0,d1
		move.b	($FFFFD89C).w,d1
		moveq	#7,d0
		and.b	3(a3,d1.w),d0
		sne	d2
		move.b	4(a3,d1.w),d0
		move.b	d0,d1
		andi.b	#$70,d1				; "p"
		sne	d1
		or.b	d2,d1
		andi.b	#$70,d1				; "p"
		or.b	d1,d0
		lea	($FFFFFB00).w,a4
		move.b	-1(a4),d1
		andi.w	#$F,d1
		move.b	(a4,d1.w),d2
		move.b	d0,(a4,d1.w)
		addq.b	#1,-1(a4)
		move.b	d2,-2(a4)
		lea	($FFFFD89C).w,a4
		bsr.w	sub_7FB0
		move.b	($FFFFFAFE).w,d0
		lea	(unk_C938).w,a3
		moveq	#0,d1
		move.b	($FFFFD8AC).w,d1
		bmi.s	loc_7FA8
		moveq	#7,d0
		and.b	3(a3,d1.w),d0
		sne	d2
		move.b	4(a3,d1.w),d0
		move.b	d0,d1
		andi.b	#$70,d1				; "p"
		sne	d1
		or.b	d2,d1
		andi.b	#$70,d1				; "p"
		or.b	d1,d0

loc_7FA8:
		lea	($FFFFD8AC).w,a4
		bra.w	sub_7FB0
; End of function Field_ReadController


; =============== S U B	R O U T	I N E =======================================


sub_7FB0:
		move.b	2(a4),4(a4)
		move.b	d0,2(a4)
		move.b	4(a4),d1
		eor.b	d0,d1
		beq.s	loc_7FC6
		clr.b	6(a4)

loc_7FC6:
		addq.b	#1,6(a4)
		and.b	d0,d1
		move.b	d1,3(a4)
		andi.w	#$F,d0
		move.b	byte_8000(pc,d0.w),5(a4)
		moveq	#3,d1
		and.w	d0,d1
		ror.w	#1,d1
		ext.l	d1
		move.w	d1,d2
		swap	d1
		or.w	d1,d2
		move.w	d2,$A(a4)
		andi.w	#$C,d0
		ror.w	#3,d0
		ext.l	d0
		move.w	d0,d1
		swap	d0
		or.w	d0,d1
		move.w	d1,8(a4)
		rts
; End of function sub_7FB0

; ---------------------------------------------------------------------------
byte_8000:	dc.b 0,	$C0, $40, $C0
		dc.b $80, $A0, $60, $A0
		dc.b 0,	$E0, $20, $E0
		dc.b $80, $A0, $60, $A0
; ---------------------------------------------------------------------------

loc_8010:
		movem.l	d0-a6,-(sp)
		move.l	#$FFFFCA5E,d0
		move.w	($FFFFD81C).w,d1
		move.w	#$1C0,d2
		jsr	(sub_5E8).w
		move.l	#$40000010,(vdp_control_port).l
		move.l	($FFFFCDDE).w,(vdp_data_port).l
		jsr	(VDPSetup_01).w
		jsr	(sub_C9DE).l
		move.l	#$FFFFD164,d0
		move.w	($FFFFD81A).w,d1
		move.w	#$140,d2
		jsr	(sub_5E8).w
		ori.b	#$80,($FFFFFFC9).w
		addq.w	#1,($FFFFF000).w
		movem.l	(sp)+,d0-a6
		rte

; =============== S U B	R O U T	I N E =======================================


Field_PauseGame:
		tst.b	($FFFFD89F).w
		bpl.w	locret_8194
		move.b	($FFFFC93C).w,d0
		andi.b	#$70,d0				; "p"
		cmpi.b	#$70,d0				; "p"
		bne.s	loc_8086
		disable_ints
		suba.l	a0,a0
		movea.l	(a0)+,sp
		movea.l	(a0)+,a0
		jmp	(a0)
; ---------------------------------------------------------------------------

loc_8086:
		movem.l	d0-a6,-(sp)

loc_808A:
		bclr	#7,($FFFFFFC9).w

loc_8090:
		tst.b	($FFFFFFC9).w
		bpl.s	loc_8090
		jsr	(Field_ReadController).l
		move.b	($FFFFD89E).w,d0
		andi.b	#$70,d0				; "p"
		beq.w	loc_814C
		moveq	#0,d0
		lea	($FFFFF9C0).w,a0
		move.w	#$17F,d1

loc_80B2:
		move.l	d0,(a0)+
		dbf	d1,loc_80B2
		move.w	d0,($FFFFD830).w
		move.w	d0,($FFFFD832).w
		lea	($FFFFC9DE).w,a0
		moveq	#$F,d1

loc_80C6:
		move.l	d0,(a0)+
		dbf	d1,loc_80C6
		lea	($FFFFCA1E).w,a0
		moveq	#$F,d1

loc_80D2:
		move.l	d0,(a0)+
		dbf	d1,loc_80D2
		lea	($FFFFCA5E).w,a0
		move.w	#$DF,d1				; "�"

loc_80E0:
		move.l	d0,(a0)+
		dbf	d1,loc_80E0
		move.l	d0,($FFFFCDDE).w
		lea	(vdp_data_port).l,a0
		move.w	#$8F02,(vdp_control_port).l
		move.w	#$8F02,($FFFFC9D6).w
		moveq	#0,d0
		move.l	#$40000000,(vdp_control_port).l
		move.w	#$FFF,d1

loc_810E:
		move.l	d0,(a0)
		move.l	d0,(a0)
		move.l	d0,(a0)
		move.l	d0,(a0)
		dbf	d1,loc_810E
		move.l	#$40000010,(vdp_control_port).l
		move.l	($FFFFCDDE).w,(vdp_data_port).l
		clr.w	(v_subgamemode).w
		addq.w	#1,($FFFFD836).w
		tst.w	($FFFFD834).w
		beq.s	loc_813E
		addq.w	#1,($FFFFD83A).w

loc_813E:
		move.w	#id_Level,(v_gamemode).w
		movea.l	(RomStart).w,sp
		jmp	(MAINPROG).w
; ---------------------------------------------------------------------------

loc_814C:
		move.w	($FFFFD8A4).w,d0
		move.w	($FFFFD8A6).w,d1
		add.w	d0,d0
		add.w	d0,d0
		add.w	d1,d1
		add.w	d1,d1
		movea.w	($FFFFD862).w,a0
		add.w	d0,8(a0)
		add.w	d1,$C(a0)
		movea.w	($FFFFD864).w,a0
		add.w	d0,8(a0)
		add.w	d1,$C(a0)
		jsr	(sub_CCCA).l
		jsr	(sub_82B2).l
		jsr	(BuildSprites).w
		bsr.w	sub_F374
		tst.b	($FFFFC93D).w
		bpl.w	loc_808A
		movem.l	(sp)+,d0-a6

locret_8194:
		rts
; End of function Field_PauseGame


; =============== S U B	R O U T	I N E =======================================


sub_8196:
		move.w	#0,($FFFFD866).w
		move.w	#4,($FFFFD868).w
		moveq	#4,d0
		jsr	(sub_1918).w
		bmi.s	loc_81CC
		move.w	#$80,4(a0)			; "�"
		move.w	#2,6(a0)
		move.w	#$70,8(a0)			; "p"
		move.w	#$70,$C(a0)			; "p"
		move.w	#$8000,$20(a0)
		move.w	a0,($FFFFD862).w

loc_81CC:
		moveq	#4,d0
		jsr	(sub_1918).w
		bmi.s	locret_81F6
		move.w	#$80,4(a0)			; "�"
		move.w	#$802,6(a0)
		move.w	#$B0,8(a0)			; "�"
		move.w	#$70,$C(a0)			; "p"
		move.w	#$8000,$20(a0)
		move.w	a0,($FFFFD864).w

locret_81F6:
		rts
; End of function sub_8196


; =============== S U B	R O U T	I N E =======================================


sub_81F8:
		lea	($FFFFD850).w,a6

loc_81FC:
		_move.w	0(a6),d0
		bne.s	loc_8204
		rts
; ---------------------------------------------------------------------------

loc_8204:
		movea.w	d0,a6
		tst.b	6(a6)
		bne.s	loc_8214
		lea	($FFFFD89C).w,a5
		bsr.s	sub_821C
		bra.s	loc_81FC
; ---------------------------------------------------------------------------

loc_8214:
		lea	($FFFFD8AC).w,a5
		bsr.s	sub_821C
		bra.s	loc_81FC
; End of function sub_81F8


; =============== S U B	R O U T	I N E =======================================


sub_821C:
		pea	(sub_8736).l
		pea	loc_82A6(pc)
		tst.b	(a5)
		bpl.s	loc_8236
		move.b	($FFFFD89E).w,d0
		andi.b	#$70,d0				; "p"
		bne.w	loc_828C

loc_8236:
		move.w	8(a5),d0
		beq.s	loc_8260
		add.w	d0,d0
		add.w	d0,8(a6)
		tst.w	d0
		bpl.s	loc_8254
		move.w	#4,$26(a6)
		move.w	#$8000,$20(a6)
		bra.s	loc_8260
; ---------------------------------------------------------------------------

loc_8254:
		move.w	#4,$26(a6)
		move.w	#$8800,$20(a6)

loc_8260:
		move.w	$A(a5),d1
		beq.s	loc_828C
		add.w	d1,d1
		add.w	d1,$C(a6)
		tst.w	d1
		bpl.s	loc_827E
		move.w	#6,$26(a6)
		move.w	#$8000,$20(a6)
		rts
; ---------------------------------------------------------------------------

loc_827E:
		move.w	#2,$26(a6)
		move.w	#$8000,$20(a6)
		rts
; ---------------------------------------------------------------------------

loc_828C:
		or.w	d1,d0
		bne.s	locret_82A4
		move.w	$26(a6),d0
		beq.s	locret_82A4
		lsr.w	#1,d0
		subq.w	#1,d0
		move.b	d0,$28(a6)
		move.w	#0,$26(a6)

locret_82A4:
		rts
; End of function sub_821C


; =============== S U B	R O U T	I N E =======================================


loc_82A6:
		tst.b	(a5)
		bmi.s	locret_82AE
		bsr.w	nullsub_1

locret_82AE:
		rts
; End of function loc_82A6


; =============== S U B	R O U T	I N E =======================================


nullsub_1:
		rts
; End of function nullsub_1


; =============== S U B	R O U T	I N E =======================================


sub_82B2:
							; Field_PauseGame+116p
		move.w	($FFFFD830).w,d0
		bpl.s	loc_82BA
		moveq	#0,d0

loc_82BA:
		cmpi.w	#$BF,d0				; "�"
		bcs.s	loc_82C4
		move.w	#$BF,d0				; "�"

loc_82C4:
		move.w	d0,($FFFFD830).w
		move.w	d0,($FFFFC9DE).w
		move.w	($FFFFD832).w,d0
		bpl.s	loc_82D4
		moveq	#0,d0

loc_82D4:
		cmpi.w	#$11F,d0
		bcs.s	loc_82DE
		move.w	#$11F,d0

loc_82DE:
		move.w	d0,($FFFFD832).w
		move.w	d0,($FFFFC9EE).w
		move.w	d0,d1
		lsr.w	#1,d1
		swap	d0
		move.w	d1,d0
		move.l	d0,($FFFFCDDE).w
		tst.w	($FFFFD834).w
		bne.w	loc_837C
		subq.w	#3,($FFFFFAEE).w
		subq.w	#5,($FFFFFAF0).w
		move.w	($FFFFD830).w,d0
		neg.w	d0
		move.w	d0,d1
		swap	d0
		swap	d1
		move.w	($FFFFFAEE).w,d0
		move.w	($FFFFFAF0).w,d1
		btst	#0,($FFFFCDE1).w
		beq.s	loc_8320
		exg	d0,d1

loc_8320:
		lea	($FFFFCA5E).w,a0
		move.w	#$6F,d2				; "o"

loc_8328:
		move.l	d0,(a0)+
		move.l	d1,(a0)+
		dbf	d2,loc_8328
		cmpi.w	#5,($FFFFFAEA).w
		bcs.s	loc_8356
		clr.w	($FFFFFAEA).w
		addq.w	#1,($FFFFFAEC).w
		move.w	($FFFFFAEC).w,d0
		andi.w	#3,d0
		lsl.w	#3,d0
		move.l	PALCY_RainbowField(pc,d0.w),($FFFFD43C).w
		move.l	PALCY_RainbowField+4(pc,d0.w),($FFFFD440).w

loc_8356:
		addq.w	#1,($FFFFFAEA).w
		rts
; ---------------------------------------------------------------------------
PALCY_RainbowField:dc.w	$EEA
		dc.w $EC4
		dc.w $E82
		dc.w $E40
		dc.w $EC4
		dc.w $E82
		dc.w $E40
		dc.w $EEA
		dc.w $E82
		dc.w $E40
		dc.w $EEA
		dc.w $EC4
		dc.w $E40
		dc.w $EEA
		dc.w $EC4
		dc.w $E82
; ---------------------------------------------------------------------------

loc_837C:
		move.w	($FFFFD830).w,d0
		neg.w	d0
		move.w	d0,d1
		lsr.w	#1,d1
		swap	d0
		move.w	d1,d0
		lea	($FFFFCA5E).w,a0
		move.w	#$DF,d1				; "�"

loc_8392:
		move.l	d0,(a0)+
		dbf	d1,loc_8392
		lea	loc_856A(pc),a0
		bsr.w	sub_860A
		lea	loc_85D6(pc),a0
		bsr.w	sub_860A
		cmpi.w	#$A,($FFFFFAF0).w
		bcs.s	loc_83E4
		clr.w	($FFFFFAF0).w
		move.w	($FFFFFAF2).w,d0
		andi.w	#$7FF0,d0
		addi.w	#$10,d0
		cmpi.w	#$180,d0
		bcs.s	loc_83C8
		moveq	#0,d0

loc_83C8:
		move.w	d0,($FFFFFAF2).w
		move.l	PALCY_ElectricField_1(pc,d0.w),($FFFFD44A).w
		move.l	PALCY_ElectricField_1+4(pc,d0.w),($FFFFD44E).w
		move.l	PALCY_ElectricField_1+8(pc,d0.w),($FFFFD452).w
		move.l	PALCY_ElectricField_1+$C(pc,d0.w),($FFFFD456).w

loc_83E4:
		addq.w	#1,($FFFFFAF0).w
		rts
; End of function sub_82B2

; ---------------------------------------------------------------------------
PALCY_ElectricField_1:dc.w $CE0
		dc.w $AC2
		dc.w $880
		dc.w $642
		dc.w $EAE
		dc.w $A8E
		dc.w $86A
		dc.w $626
		dc.w $CE0
		dc.w $AC2
		dc.w $880
		dc.w $642
		dc.w $EAE
		dc.w $A8E
		dc.w $86A
		dc.w $626
		dc.w $AC2
		dc.w $880
		dc.w $642
		dc.w $420
		dc.w $A8E
		dc.w $86A
		dc.w $626
		dc.w $404
		dc.w $880
		dc.w $642
		dc.w $420
		dc.w $200
		dc.w $86A
		dc.w $626
		dc.w $404
		dc.w $200
		dc.w $642
		dc.w $420
		dc.w $200
		dc.w $200
		dc.w $626
		dc.w $404
		dc.w $200
		dc.w $200
		dc.w $420
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $404
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $420
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $404
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $626
		dc.w $404
		dc.w $200
		dc.w $200
		dc.w $642
		dc.w $420
		dc.w $200
		dc.w $200
		dc.w $86A
		dc.w $626
		dc.w $404
		dc.w $200
		dc.w $880
		dc.w $642
		dc.w $420
		dc.w $200
		dc.w $A8E
		dc.w $86A
		dc.w $626
		dc.w $404
		dc.w $AC2
		dc.w $880
		dc.w $642
		dc.w $420
		dc.w $EAE
		dc.w $A8E
		dc.w $86A
		dc.w $626
		dc.w $CE0
		dc.w $AC2
		dc.w $880
		dc.w $642
		dc.w $EAE
		dc.w $A8E
		dc.w $86A
		dc.w $626
		dc.w $CE0
		dc.w $AC2
		dc.w $880
		dc.w $642
		dc.w $A8E
		dc.w $86A
		dc.w $626
		dc.w $404
		dc.w $AC2
		dc.w $880
		dc.w $642
		dc.w $420
		dc.w $86A
		dc.w $626
		dc.w $404
		dc.w $200
		dc.w $880
		dc.w $642
		dc.w $420
		dc.w $200
		dc.w $626
		dc.w $404
		dc.w $200
		dc.w $200
		dc.w $642
		dc.w $420
		dc.w $200
		dc.w $200
		dc.w $404
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $420
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $404
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $420
		dc.w $200
		dc.w $200
		dc.w $200
		dc.w $642
		dc.w $420
		dc.w $200
		dc.w $200
		dc.w $626
		dc.w $404
		dc.w $200
		dc.w $200
		dc.w $880
		dc.w $642
		dc.w $420
		dc.w $200
		dc.w $86A
		dc.w $626
		dc.w $404
		dc.w $200
		dc.w $AC2
		dc.w $880
		dc.w $642
		dc.w $420
		dc.w $A8E
		dc.w $86A
		dc.w $626
		dc.w $404
loc_856A:	dc.l $FFFFFAEC
		dc.l $FFFFD41C
PALCY_ElectricField_2:dc.w $EE0
		dc.w $64
		dc.w $420
		dc.w $32
		dc.w $EE0
		dc.w 2
		dc.w $420
		dc.w 2
		dc.w $EE0
		dc.w 2
		dc.w $420
		dc.w 2
		dc.w $EE0
		dc.w 2
		dc.w $420
		dc.w 2
		dc.w $EE0
		dc.w 2
		dc.w $420
		dc.w 2
		dc.w $EE0
		dc.w 2
		dc.w $420
		dc.w 2
		dc.w $EE0
		dc.w $A
		dc.w $420
		dc.w $A
		dc.w $EE0
		dc.w $14
		dc.w $420
		dc.w 2
		dc.w $EE0
		dc.w 2
		dc.w $420
		dc.w 2
		dc.w $EE0
		dc.w 2
		dc.w $420
		dc.w 2
		dc.w $EE0
		dc.w 2
		dc.w $420
		dc.w 2
		dc.w $EE0
		dc.w 2
		dc.w $420
		dc.w 2
		dc.w $EE0
		dc.b $FF
		dc.b $FF
loc_85D6:	dc.l $FFFFFAEE
		dc.l $FFFFD41E
		dc.l $8E00032
		dc.l $6C00005
		dc.l $4A00005
		dc.l $2800005
		dc.l $600005
		dc.l $400005
		dc.l $600005
		dc.l $2800005
		dc.l $4A00005
		dc.l $6C00005
		dc.l $8E0FFFF

; =============== S U B	R O U T	I N E =======================================

sub_860A:
		movea.l	(a0)+,a1
		movea.l	(a0)+,a2
		subq.b	#1,1(a1)
		bne.s	locret_8630
		addq.b	#4,(a1)
		move.b	(a1),d0
		andi.w	#$FC,d0				; "�"
		move.w	(a0,d0.w),(a2)
		move.w	2(a0,d0.w),d0
		bpl.s	loc_862C
		move.w	2(a0),(a1)
		rts
; ---------------------------------------------------------------------------

loc_862C:
		move.b	d0,1(a1)

locret_8630:
		rts
; End of function sub_860A

; ---------------------------------------------------------------------------
		rts

; =============== S U B	R O U T	I N E =======================================


sub_8634:
		tst.w	($FFFFD834).w
		bne.w	loc_866E
		lea	(PAL_RainbowField).l,a0
		bsr.w	sub_86A0
		lea	(ARTCRA_RainbowField8x8).l,a0
		bsr.w	sub_86BA
		lea	(MAPUNC_RainbowFieldFG).l,a0
		movea.w	($FFFFD816).w,a1
		bsr.w	sub_86EA
		lea	(MAPUNC_RainbowFieldBG).l,a0
		movea.w	($FFFFD818).w,a1
		bsr.w	sub_86EA
		rts
; ---------------------------------------------------------------------------

loc_866E:
		lea	(PAL_ElectricField).l,a0
		bsr.w	sub_86A0
		lea	(ARTCRA_ElectricField8x8).l,a0
		bsr.w	sub_86BA
		lea	(MAPUNC_ElectricFieldFG).l,a0
		movea.w	($FFFFD816).w,a1
		bsr.w	sub_86EA
		lea	(MAPUNC_ElectricFieldBG).l,a0
		movea.w	($FFFFD818).w,a1
		bsr.w	sub_86EA
		rts
; End of function sub_8634


; =============== S U B	R O U T	I N E =======================================


sub_86A0:
		lea	($FFFFD424).w,a1
		movem.l	(a0)+,d0-d7
		movem.l	d0-d7,(a1)
		lea	$20(a1),a1
		movem.l	(a0)+,d0-d7
		movem.l	d0-d7,(a1)
		rts
; End of function sub_86A0


; =============== S U B	R O U T	I N E =======================================


sub_86BA:
		move.w	(a0)+,d7

loc_86BC:
		move.w	d7,-(sp)
		disable_ints
		lea	(unk_0200&$FFFFFF).l,a1
		move.l	a1,d0
		move.w	(a0)+,d1
		move.w	(a0)+,d2
		lsl.w	#4,d2
		jsr	(CracDec).l			; run through Crackers Decompression
		move.l	a0,-(sp)
		jsr	(sub_5E8).w
		movea.l	(sp)+,a0
		enable_ints
		move.w	(sp)+,d7
		dbf	d7,loc_86BC
		rts
; End of function sub_86BA


; =============== S U B	R O U T	I N E =======================================


sub_86EA:
		move.w	(a0)+,d7

loc_86EC:
		move.w	d7,-(sp)
		disable_ints
		move.w	(a0)+,d6
		add.w	a1,d6
		move.w	(a0)+,d5
		move.w	(a0)+,d4
		move.w	(a0)+,d3

loc_86FC:
		move.w	d6,d0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		andi.w	#3,d0
		move.l	d0,(vdp_control_port).l
		move.w	d4,d2

loc_8714:
		move.w	(a0)+,d0
		add.w	d5,d0
		move.w	d0,(vdp_data_port).l
		dbf	d2,loc_8714
		addi.w	#$80,d6
		dbf	d3,loc_86FC
		enable_ints
		move.w	(sp)+,d7
		dbf	d7,loc_86EC
		rts
; End of function sub_86EA


; =============== S U B	R O U T	I N E =======================================


sub_8736:
		tst.b	6(a6)
		bne.s	loc_8748
		lea	($FFFFD87C).w,a4
		moveq	#1,d2
		move.w	($FFFFD866).w,d0
		bra.s	loc_8752
; ---------------------------------------------------------------------------

loc_8748:
		lea	($FFFFD888).w,a4
		moveq	#8,d2
		move.w	($FFFFD868).w,d0

loc_8752:
		lea	word_87BC(pc,d0.w),a3
		movea.l	(a3),a0
		movea.l	$20(a3),a1
		movea.l	$40(a3),a2
		movea.l	$60(a3),a3
		move.w	$26(a6),d0
		adda.w	(a0,d0.w),a0
		moveq	#0,d1
		move.b	$28(a6),d1
		move.b	3(a0,d1.w),d0
		cmp.b	1(a0),d1
		bls.s	loc_878A
		move.b	2(a0),d0
		move.b	d0,$28(a6)
		move.b	3(a0,d0.w),d0
		bra.s	loc_87A0
; ---------------------------------------------------------------------------

loc_878A:
		move.b	(a0),d1
		add.w	d1,$28(a6)
		move.b	$28(a6),d1
		cmp.b	1(a0),d1
		bls.s	loc_87A4
		move.b	2(a0),$28(a6)

loc_87A0:
		clr.b	$29(a6)

loc_87A4:
		add.w	d0,d0
		add.w	d0,d0
		adda.w	(a1,d0.w),a3
		adda.w	2(a1,d0.w),a2
		move.l	a2,(a4)
		or.b	d2,($FFFFD87A).w
		move.l	a3,obMap(a6)
		rts
; End of function sub_8736

; ---------------------------------------------------------------------------
word_87BC:	dc.l ANI_SonicFields
		dc.l ANI_TailsFields
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l PLCMAP_SonicFields_MainIndex
		dc.l PLCMAP_TailsFields_MainIndex
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l PLC_SonicFields
		dc.l PLC_TailsFields
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l Map_SonicFields
		dc.l Map_TailsFields
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0


; ===========================================================================

		include "_inc/Crackers Decompression.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Level Zones
; ---------------------------------------------------------------------------

Levels:
		pea	(a0)
		lea	loc_8B1C(pc),a0
		move.l	a0,(v_vdpindex).w
		movem.l	(sp)+,a0
		lea	loc_89C8(pc),a0
		jsr	(sub_8D0).w
		move.b	#bgm_Electoria,d0
		tst.w	($FFFFD834).w
		beq.s	loc_88C2
		move.w	($FFFFD83A).w,d0
		andi.w	#3,d0
		addi.w	#$82,d0				; "�"

loc_88C2:
		jsr	(PlayMusic).l
		lea	PAL_PrimaryColours(pc),a1
		lea	($FFFFD3E4).w,a0
		moveq	#$F,d1

loc_88D2:
		move.l	(a1)+,(a0)+
		dbf	d1,loc_88D2
		move.w	#0,(a0)
		bsr.w	sub_F45C
		bsr.w	sub_FA44
		andi.w	#$81BC,($FFFFC9BA).w
		move.w	($FFFFC9BA).w,(vdp_control_port).l
		clr.l	($FFFFD82C).w
		jsr	(sub_9514).l
		bsr.w	sub_8BFE
		jsr	(sub_F116).l
		jsr	(sub_15D0).w
		move.w	#5,($FFFFD83C).w
		move.w	#7,($FFFFD840).w
		move.w	#$3F,($FFFFD844).w		; "?"
		move.w	#$3F,($FFFFD848).w		; "?"
		jsr	(sub_BE72).l
		jsr	(sub_D1E0).l
		jsr	(sub_EFD4).l
		jsr	(sub_8C30).l
		enable_ints
		jsr	(sub_8CCE).l
		jsr	(sub_ED26).l
		tst.w	($FFFFD834).w
		bne.s	loc_8968
		clr.w	($FFFFD830).w
		clr.w	($FFFFD832).w
		clr.w	($FFFFC9DE).w
		clr.w	($FFFFC9EE).w
		clr.w	($FFFFCA1E).w
		clr.w	($FFFFCA2E).w

loc_8968:
		bsr.w	sub_F58C

loc_896C:
		ori.w	#$8144,($FFFFC9BA).w
		move.w	($FFFFC9BA).w,(vdp_control_port).l
		bsr.w	sub_F4FE
		jsr	(sub_F94A).l
		bra.w	loc_89E0
; ---------------------------------------------------------------------------
PAL_PrimaryColours:
		binclude	"Palettes/PalPrimaryColours.bin"
		even
loc_89C8:	dc.w $8230
		dc.w $832C
		dc.w $8407
		dc.w $8578
		dc.w $8D34
		dc.w $9001
		dc.w $8730
		dc.w $8B00
		dc.w $8C81
		dc.w $9100
		dc.w $9200
		dc.w 0
; ---------------------------------------------------------------------------

loc_89E0:

		pea	(loc_89E0).l
		bclr	#7,($FFFFFFC9).w

loc_89EC:
		tst.b	($FFFFFFC9).w
		bpl.s	loc_89EC
		bsr.w	sub_F390
		jsr	(Level_ReadController).l
		jsr	(Level_PauseGame).l
		jsr	(sub_CCCA).l
		jsr	(sub_A178).l
		jsr	(sub_9514).l
		jsr	(sub_F12C).l
		jsr	(sub_D20A).l
		jsr	(Level_UpdateHUD).l
		jsr	(Level_AnimateBG).l
		disable_ints
		jsr	(BuildSprites).w
		enable_ints
		rts

; =============== S U B	R O U T	I N E =======================================


Level_ReadController:
							; Level_PauseGame+32p
		jsr	(sub_96E).w
		lea	(unk_C938).w,a3
		moveq	#0,d1
		move.b	($FFFFD89C).w,d1
		moveq	#7,d0
		and.b	3(a3,d1.w),d0
		sne	d2
		move.b	4(a3,d1.w),d0
		move.b	d0,d1
		andi.b	#$70,d1				; "p"
		sne	d1
		or.b	d2,d1
		andi.b	#$70,d1				; "p"
		or.b	d1,d0
		lea	($FFFFFB00).w,a4
		move.b	-1(a4),d1
		andi.w	#$F,d1
		move.b	(a4,d1.w),d2
		move.b	d0,(a4,d1.w)
		addq.b	#1,-1(a4)
		move.b	d2,-2(a4)
		lea	($FFFFD89C).w,a4
		bsr.w	sub_8ABC
		move.b	($FFFFFAFE).w,d0
		lea	(unk_C938).w,a3
		moveq	#0,d1
		move.b	($FFFFD8AC).w,d1
		bmi.s	loc_8AB4
		moveq	#7,d0
		and.b	3(a3,d1.w),d0
		sne	d2
		move.b	4(a3,d1.w),d0
		move.b	d0,d1
		andi.b	#$70,d1				; "p"
		sne	d1
		or.b	d2,d1
		andi.b	#$70,d1				; "p"
		or.b	d1,d0

loc_8AB4:
		lea	($FFFFD8AC).w,a4
		bra.w	sub_8ABC
; End of function Level_ReadController


; =============== S U B	R O U T	I N E =======================================


sub_8ABC:
		move.b	2(a4),4(a4)
		move.b	d0,2(a4)
		move.b	4(a4),d1
		eor.b	d0,d1
		beq.s	loc_8AD2
		clr.b	6(a4)

loc_8AD2:
		addq.b	#1,6(a4)
		and.b	d0,d1
		move.b	d1,3(a4)
		andi.w	#$F,d0
		move.b	byte_8B0C(pc,d0.w),5(a4)
		moveq	#3,d1
		and.w	d0,d1
		ror.w	#1,d1
		ext.l	d1
		move.w	d1,d2
		swap	d1
		or.w	d1,d2
		move.w	d2,$A(a4)
		andi.w	#$C,d0
		ror.w	#3,d0
		ext.l	d0
		move.w	d0,d1
		swap	d0
		or.w	d0,d1
		move.w	d1,8(a4)
		rts
; End of function sub_8ABC

; ---------------------------------------------------------------------------
byte_8B0C:	dc.b 0,	$C0, $40, $C0
		dc.b $80, $A0, $60, $A0
		dc.b 0,	$E0, $20, $E0
		dc.b $80, $A0, $60, $A0
; ---------------------------------------------------------------------------

loc_8B1C:
		movem.l	d0-a6,-(sp)
		jsr	(sub_9F7C).l
		jsr	(VDPSetup_02).w
		jsr	(VDPSetup_01).w
		jsr	(sub_C9DE).l
		move.l	#$FFFFD164,d0
		move.w	($FFFFD81A).w,d1
		move.w	#$140,d2
		jsr	(sub_5E8).w
		lea	(unk_0A00&$FFFFFF).l,a3
		lea	(unk_0B02&$FFFFFF).l,a4
		lea	($FFFFC9DE).w,a5
		jsr	(sub_14E4).w
		lea	(unk_0B84&$FFFFFF).l,a3
		lea	(unk_0C86&$FFFFFF).l,a4
		lea	($FFFFCA1E).w,a5
		jsr	(sub_14E4).w
		ori.b	#$80,($FFFFFFC9).w
		addq.w	#1,($FFFFF000).w
		movem.l	(sp)+,d0-a6
		rte

; =============== S U B	R O U T	I N E =======================================


Level_PauseGame:
		tst.b	($FFFFD89F).w
		bpl.w	locret_8BFC
		move.b	($FFFFC93C).w,d0
		andi.b	#$70,d0				; "p"
		cmpi.b	#$70,d0				; "p"
		bne.s	loc_8BA0
		disable_ints
		suba.l	a0,a0
		movea.l	(a0)+,sp
		movea.l	(a0)+,a0
		jmp	(a0)
; ---------------------------------------------------------------------------

loc_8BA0:
		movem.l	d0-a6,-(sp)

loc_8BA4:
		bclr	#7,($FFFFFFC9).w

loc_8BAA:
		tst.b	($FFFFFFC9).w
		bpl.s	loc_8BAA
		jsr	(Level_ReadController).l
		move.w	($FFFFD8A4).w,d0
		move.w	($FFFFD8A6).w,d1
		add.w	d0,d0
		add.w	d0,d0
		add.w	d1,d1
		add.w	d1,d1
		movea.w	($FFFFD862).w,a0
		add.w	d0,8(a0)
		add.w	d1,$C(a0)
		movea.w	($FFFFD864).w,a0
		add.w	d0,8(a0)
		add.w	d1,$C(a0)
		jsr	(sub_CCCA).l
		jsr	(sub_9514).l
		jsr	(BuildSprites).w
		bsr.w	sub_F374
		tst.b	($FFFFC93D).w
		bpl.s	loc_8BA4
		movem.l	(sp)+,d0-a6

locret_8BFC:
		rts
; End of function Level_PauseGame


; =============== S U B	R O U T	I N E =======================================


sub_8BFE:
		moveq	#0,d0
		move.w	($FFFFD834).w,d0
		andi.w	#1,d0
		lsl.l	#2,d0
		movea.l	off_8C20(pc,d0.w),a0
		lea	word_8C18(pc,d0.w),a1
		move.w	(a1)+,d2
		move.w	(a1),d3
		rts
; End of function sub_8BFE

; ---------------------------------------------------------------------------
word_8C18:	dc.w $3FFF
		dc.w $7FF
		dc.w $7FF
		dc.w $FFF
off_8C20:	dc.l Objpos_SSZ
		dc.l Objpos_TTZ
		dc.l Objpos_SSZ
		dc.l Objpos_TTZ

; =============== S U B	R O U T	I N E =======================================


sub_8C30:
		tst.w	($FFFFD834).w
		beq.s	locret_8C7E
		disable_ints
		lea	(ARTNEM_Springs).l,a0
		move.l	#$40E00002,(vdp_control_port).l
		jsr	(NemDec).w
		disable_ints
		lea	(ARTNEM_SpikesVer).l,a0
		move.l	#$7EE00001,(vdp_control_port).l
		jsr	(NemDec).w
		disable_ints
		lea	(ARTNEM_SpikesHoz).l,a0
		move.l	#$77E00001,(vdp_control_port).l
		jsr	(NemDec).w

locret_8C7E:
		rts
; End of function sub_8C30

; ---------------------------------------------------------------------------
		lea	(word_8CBA).l,a1

loc_8C86:
		moveq	#0,d0
		move.w	(a1)+,d0
		cmpi.w	#$FFFF,d0
		beq.s	locret_8CB8
		movem.l	d0-a6,-(sp)
		movea.l	(a1)+,a0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		andi.w	#3,d0
		disable_ints
		move.l	d0,(vdp_control_port).l
		jsr	(NemDec).w
		movem.l	(sp)+,d0-a6
		bra.s	loc_8C86
; ---------------------------------------------------------------------------

locret_8CB8:
		rts
; ---------------------------------------------------------------------------
word_8CBA:	dc.w $80E0
		dc.l ARTNEM_Springs
		dc.w $7EE0
		dc.l ARTNEM_SpikesVer
		dc.w $77E0
		dc.l ARTNEM_SpikesHoz
		dc.w $FFFF

; =============== S U B	R O U T	I N E =======================================


sub_8CCE:
		moveq	#0,d1
		move.w	($FFFFD834).w,d1
		andi.w	#1,d1
		lsl.l	#1,d1
		jmp	loc_8CDE(pc,d1.w)
; End of function sub_8CCE

; ---------------------------------------------------------------------------

loc_8CDE:
		bra.s	locret_8CE2
; ---------------------------------------------------------------------------
		bra.s	loc_8CE4
; ---------------------------------------------------------------------------

locret_8CE2:
		rts
; ---------------------------------------------------------------------------

loc_8CE4:
		moveq	#0,d0
		move.w	($FFFFD83A).w,d0
		andi.w	#3,d0
		lsl.l	#6,d0
		lea	(PAL_TechnoTowerZone).l,a1
		adda.l	d0,a1
		lea	($FFFFD424).w,a0
		move.b	#$1F,d7

loc_8D00:
		move.w	(a1)+,(a0)+
		dbf	d7,loc_8D00
		rts
; ---------------------------------------------------------------------------
PAL_TechnoTowerZone:binclude "Palettes/PalTechnoTowerZone.bin"
		even
; ---------------------------------------------------------------------------

UnkRet001:
		rts
; ---------------------------------------------------------------------------

UnkRet002:
		rts
; ---------------------------------------------------------------------------

LevelSelect:
		move.w	(v_subgamemode).w,d0
		jmp	loc_8E14(pc,d0.w)
; ---------------------------------------------------------------------------

loc_8E14:
		bra.w	loc_8E1C
; ---------------------------------------------------------------------------
		bra.w	loc_8EC0
; ---------------------------------------------------------------------------

loc_8E1C:
		pea	(a0)
		lea	loc_903C(pc),a0
		move.l	a0,(v_vdpindex).w
		movem.l	(sp)+,a0
		disable_ints
		moveq	#$3F,d0
		moveq	#$3F,d1
		moveq	#0,d2
		move.w	#$C000,d3
		jsr	(sub_86E).w
		lea	ARTNEM_MenuSelectorBorder(pc),a0
		move.l	#$4C000000,(vdp_control_port).l
		jsr	(NemDec).w
		move.l	#$42000003,d0
		lea	MAPUNC_SelectMenu_1(pc),a1
		moveq	#$27,d1
		moveq	#3,d2
		move.w	#0,d3
		jsr	(MapScreen).w
		move.l	#$78000003,(vdp_control_port).l
		move.l	#$1000001,(vdp_data_port).l
		move.l	#$1E00A8,(vdp_data_port).l
		move.l	#$A00F00,(vdp_data_port).l
		move.l	#$600110,(vdp_data_port).l
		move.w	#0,($FFFFD834).w
		move.w	#0,($FFFFD836).w
		move.l	#$EEE,($FFFFD3E4).w
		move.l	#$EEE,($FFFFD404).w
		jsr	(VDPSetup_01).w
		enable_ints
		addq.w	#4,(v_subgamemode).w
		rts
; ---------------------------------------------------------------------------

loc_8EC0:
		bclr	#7,($FFFFFFC9).w

loc_8EC6:
		tst.b	($FFFFFFC9).w
		bpl.s	loc_8EC6
		move.w	($FFFFC944).w,d0
		add.w	($FFFFD834).w,d0
		bpl.s	loc_8ED8
		moveq	#0,d0

loc_8ED8:
		cmpi.w	#9,d0
		bls.s	loc_8EE0
		moveq	#9,d0

loc_8EE0:
		move.w	d0,($FFFFD834).w
		move.w	d0,d1
		lsl.w	#5,d1
		subi.w	#$90,d1				; "�"
		move.w	d1,($FFFFD830).w
		lea	MAPUNC_SelectMenu_2(pc),a1
		lsl.w	#4,d0
		adda.w	d0,a1
		move.l	#$65080003,d0
		moveq	#7,d1
		moveq	#0,d2
		move.w	#0,d3
		jsr	(MapScreen).w
		move.w	($FFFFD834).w,d1
		cmpi.w	#7,d1
		bcc.s	loc_8F3A
		move.w	#$100,($FFFFD820).w
		move.l	#$66100003,d0
		lea	MAPUNC_SelectMenu_3(pc),a1
		moveq	#$F,d1
		moveq	#5,d2
		move.w	#0,d3
		jsr	(MapScreen).w
		move.w	#$80,($FFFFD820).w
		bra.w	loc_8FCA
; ---------------------------------------------------------------------------

loc_8F3A:
		cmpi.w	#9,d1
		bcc.s	loc_8F84
		moveq	#0,d0
		move.l	#$66100003,(vdp_control_port).l
		move.w	#$17F,d1

loc_8F50:
		move.l	d0,(vdp_data_port).l
		dbf	d1,loc_8F50
		move.l	#$6B100003,d0
		lea	MAPUNC_SelectMenu_4(pc),a1
		moveq	#$F,d1
		moveq	#0,d2
		move.w	#0,d3
		jsr	(MapScreen).w
		move.l	#$6A100003,d0
		moveq	#$F,d1
		moveq	#0,d2
		move.w	#0,d3
		jsr	(MapScreen).w
		bra.s	loc_8FCA
; ---------------------------------------------------------------------------

loc_8F84:
		moveq	#0,d0
		move.l	#$66100003,(vdp_control_port).l
		move.w	#$17F,d1

loc_8F94:
		move.l	d0,(vdp_data_port).l
		dbf	d1,loc_8F94
		move.l	#$6B100003,d0
		lea	MAPUNC_SelectMenu_5(pc),a1
		moveq	#$F,d1
		moveq	#0,d2
		move.w	#0,d3
		jsr	(MapScreen).w
		bra.s	loc_8FCA
; ---------------------------------------------------------------------------
word_8FB6:	dc.w 5
		dc.w 5
		dc.w 5
		dc.w 5
		dc.w 5
		dc.w 5
		dc.w 5
		dc.w 1
		dc.w 1
		dc.w 0
; ---------------------------------------------------------------------------

loc_8FCA:
		move.w	($FFFFD834).w,d1
		add.w	d1,d1
		move.w	word_8FB6(pc,d1.w),d1
		move.w	($FFFFC946).w,d0
		neg.w	d0
		add.w	($FFFFD836).w,d0
		bpl.s	loc_8FE2
		moveq	#0,d0

loc_8FE2:
		cmp.w	d1,d0
		bls.s	loc_8FE8
		move.w	d1,d0

loc_8FE8:
		move.w	d0,($FFFFD836).w
		lsl.w	#4,d0
		neg.w	d0
		addi.w	#$130,d0
		move.w	d0,($FFFFD832).w
		tst.b	($FFFFC93D).w
		bmi.s	loc_9000
		rts
; ---------------------------------------------------------------------------

loc_9000:
		clr.l	(v_subgamemode).w
		cmpi.w	#9,($FFFFD834).w
		bne.s	loc_9014
		move.w	#id_Null,(v_gamemode).w		; " "
		rts
; ---------------------------------------------------------------------------

loc_9014:
		tst.w	($FFFFD836).w
		bne.s	loc_9022
		move.w	#id_Field,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

loc_9022:
		move.w	($FFFFD836).w,d0
		andi.w	#3,d0
		move.w	d0,($FFFFD83A).w
		move.w	#1,($FFFFD836).w
		move.w	#id_Level,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

loc_903C:
		movem.l	d0-a6,-(sp)
		move.l	#$7C000003,(vdp_control_port).l
		move.w	($FFFFD830).w,d0
		neg.w	d0
		move.w	d0,(vdp_data_port).l
		move.l	#$78000003,(vdp_control_port).l
		move.w	($FFFFD832).w,(vdp_data_port).l
		jsr	(sub_96E).w
		move.b	($FFFFC93C).w,d0
		bsr.s	sub_9098
		move.w	d1,($FFFFC940).w
		move.w	d2,($FFFFC942).w
		move.b	($FFFFC93D).w,d0
		bsr.s	sub_9098
		move.w	d1,($FFFFC944).w
		move.w	d2,($FFFFC946).w
		jsr	(VDPSetup_01).w
		ori.b	#$80,($FFFFFFC9).w
		movem.l	(sp)+,d0-a6
		rte

; =============== S U B	R O U T	I N E =======================================


sub_9098:
		moveq	#3,d1
		and.w	d0,d1
		ror.w	#1,d1
		ext.l	d1
		move.w	d1,d2
		swap	d1
		or.w	d1,d2
		andi.w	#$C,d0
		ror.w	#3,d0
		ext.l	d0
		move.w	d0,d1
		swap	d0
		or.w	d0,d1
		rts
; End of function sub_9098

; ---------------------------------------------------------------------------
ARTNEM_MenuSelectorBorder:
		binclude	"artnem/Menu Select Border.bin" ; Selector Art for Select Menu screen
		even
MAPUNC_SelectMenu_1:
		binclude	"Uncompressed/MapuncSelectMenu01.bin" ; Uncompressed mappings	for the	select menu (Top W? numbers that scroll)
		even
MAPUNC_SelectMenu_2:
		binclude	"Uncompressed/MapuncSelectMenu02.bin" ; Uncompressed mappings for the select menu (World ? words)
		even
MAPUNC_SelectMenu_3:
		binclude	"Uncompressed/MapuncSelectMenu03.bin" ; Uncompressed mappings	for the	select menu (Attraction	LV.? words)
		even
MAPUNC_SelectMenu_4:
		binclude	"Uncompressed/MapuncSelectMenu04.bin" ; Uncompressed mappings	for the	select menu (Field/Attraction words)
		even
MAPUNC_SelectMenu_5:
		binclude	"Uncompressed/MapuncSelectMenu05.bin" ; Uncompressed mappings	for the	select menu (Special Stage word)
		even
; ---------------------------------------------------------------------------

UnkRet003:
		rts
; ---------------------------------------------------------------------------

OptionSoundTest:
		move.w	(v_subgamemode).w,d0
		jmp	OptionSoundTest_SubModes(pc,d0.w)
; ---------------------------------------------------------------------------

OptionSoundTest_SubModes:
		bra.w	loc_93DC
; ---------------------------------------------------------------------------
		bra.w	loc_944C
; ---------------------------------------------------------------------------

loc_93DC:
		pea	(a0)
		lea	loc_94B4(pc),a0
		move.l	a0,(v_vdpindex).w
		movem.l	(sp)+,a0
		disable_ints
		moveq	#$3F,d0
		moveq	#$3F,d1
		moveq	#0,d2
		move.w	#$C000,d3
		jsr	(sub_86E).w
		move.l	#$44200003,d0
		lea	loc_9440(pc),a1
		moveq	#5,d1
		moveq	#0,d2
		move.w	#0,d3
		jsr	(MapScreen).w
		move.l	#$78000003,(vdp_control_port).l
		move.l	#0,(vdp_data_port).l
		move.l	#0,(vdp_data_port).l
		move.w	#$80,($FFFFD82A).w		; "�"
		enable_ints
		addq.w	#4,(v_subgamemode).w
		rts
; ---------------------------------------------------------------------------
loc_9440:	dc.w $2F
		dc.w $30
		dc.w $34
		dc.w $29
		dc.w $2F
		dc.w $2E
; ---------------------------------------------------------------------------

loc_944C:
		bclr	#7,($FFFFFFC9).w

loc_9452:
		tst.b	($FFFFFFC9).w
		bpl.s	loc_9452
		move.w	($FFFFC944).w,d0
		add.b	d0,($FFFFD82B).w
		move.w	($FFFFC946).w,d0
		lsl.w	#4,d0
		add.b	d0,($FFFFD82B).w
		disable_ints
		move.w	($FFFFD82A).w,d0
		move.w	($FFFFD816).w,d1
		addi.w	#$820,d1
		jsr	(sub_5090).l
		enable_ints
		move.b	($FFFFC93D).w,d0
		bpl.s	loc_94A0
		move.b	#flg_FadeOut,d0
		jsr	(PlayMusic).l
		move.w	#id_Title,(v_gamemode).w
		clr.l	(v_subgamemode).w
		rts
; ---------------------------------------------------------------------------

loc_94A0:
		andi.b	#$70,d0				; "p"
		bne.s	loc_94A8
		rts
; ---------------------------------------------------------------------------

loc_94A8:
		move.w	($FFFFD82A).w,d0
		jsr	(PlayMusic).l
		rts
; ---------------------------------------------------------------------------

loc_94B4:
		movem.l	d0-a6,-(sp)
		move.l	#$78000003,(vdp_control_port).l
		move.w	($FFFFD832).w,(vdp_data_port).l
		jsr	(sub_96E).w
		move.b	($FFFFC93C).w,d0
		bsr.s	sub_94F6
		move.w	d1,($FFFFC940).w
		move.w	d2,($FFFFC942).w
		move.b	($FFFFC93D).w,d0
		bsr.s	sub_94F6
		move.w	d1,($FFFFC944).w
		move.w	d2,($FFFFC946).w
		ori.b	#$80,($FFFFFFC9).w
		movem.l	(sp)+,d0-a6
		rte

; =============== S U B	R O U T	I N E =======================================


sub_94F6:
		moveq	#3,d1
		and.w	d0,d1
		ror.w	#1,d1
		ext.l	d1
		move.w	d1,d2
		swap	d1
		or.w	d1,d2
		andi.w	#$C,d0
		ror.w	#3,d0
		ext.l	d0
		move.w	d0,d1
		swap	d0
		or.w	d0,d1
		rts
; End of function sub_94F6


; =============== S U B	R O U T	I N E =======================================


sub_9514:
		move.w	($FFFFD834).w,d0
		lsl.w	#3,d0
		add.w	($FFFFD836).w,d0
		add.w	d0,d0
		add.w	d0,d0
		jmp	loc_9528(pc,d0.w)
; End of function sub_9514

; ---------------------------------------------------------------------------

locret_9526:
		rts
; ---------------------------------------------------------------------------

loc_9528:
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	loc_9668
; ---------------------------------------------------------------------------
		bra.w	locret_987C
; ---------------------------------------------------------------------------
		bra.w	locret_987E
; ---------------------------------------------------------------------------
		bra.w	locret_9880
; ---------------------------------------------------------------------------
		bra.w	locret_9882
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	loc_9884
; ---------------------------------------------------------------------------
		bra.w	locret_9BE0
; ---------------------------------------------------------------------------
		bra.w	locret_9BE2
; ---------------------------------------------------------------------------
		bra.w	locret_9BE4
; ---------------------------------------------------------------------------
		bra.w	locret_9BE6
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9BE8
; ---------------------------------------------------------------------------
		bra.w	locret_9BEA
; ---------------------------------------------------------------------------
		bra.w	locret_9BEC
; ---------------------------------------------------------------------------
		bra.w	locret_9BEE
; ---------------------------------------------------------------------------
		bra.w	locret_9BF0
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9BF2
; ---------------------------------------------------------------------------
		bra.w	locret_9BF4
; ---------------------------------------------------------------------------
		bra.w	locret_9BF6
; ---------------------------------------------------------------------------
		bra.w	locret_9BF8
; ---------------------------------------------------------------------------
		bra.w	locret_9BFA
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9BFC
; ---------------------------------------------------------------------------
		bra.w	locret_9BFE
; ---------------------------------------------------------------------------
		bra.w	locret_9C00
; ---------------------------------------------------------------------------
		bra.w	locret_9C02
; ---------------------------------------------------------------------------
		bra.w	locret_9C04
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9C06
; ---------------------------------------------------------------------------
		bra.w	locret_9C08
; ---------------------------------------------------------------------------
		bra.w	locret_9C0A
; ---------------------------------------------------------------------------
		bra.w	locret_9C0C
; ---------------------------------------------------------------------------
		bra.w	locret_9C0E
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9C10
; ---------------------------------------------------------------------------
		bra.w	locret_9C12
; ---------------------------------------------------------------------------
		bra.w	locret_9C14
; ---------------------------------------------------------------------------
		bra.w	locret_9C16
; ---------------------------------------------------------------------------
		bra.w	locret_9C18
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9C1A
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9C1C
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9C1E
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------
		bra.w	locret_9526
; ---------------------------------------------------------------------------

loc_9668:
		move.w	($FFFFD82C).w,d0
		jmp	loc_9670(pc,d0.w)
; ---------------------------------------------------------------------------

loc_9670:
		bra.w	loc_967C
; ---------------------------------------------------------------------------
		bra.w	loc_9720
; ---------------------------------------------------------------------------
		bra.w	loc_972A
; ---------------------------------------------------------------------------

loc_967C:
		disable_ints
		lea	($FFFFC9DE).w,a1
		move.w	#$104,$1E(a1)
		lea	PAL_SpeedSliderZone(pc),a0
		lea	($FFFFD424).w,a2
		bsr.w	sub_9E6E
		lea	loc_9C28(pc),a0
		lea	($FFFFD816).w,a2
		bsr.w	sub_9E84
		movea.l	a1,a0
		lea	SSZ_ArtLocs(pc),a2
		bsr.w	sub_9D30
		lea	($FFFFC9DE).w,a0
		move.l	#v_128x128&$FFFFFF,$28(a0)
		lea	SSZ_MapFGLocs(pc),a2
		bsr.w	DecEniMapLocs
		move.l	a1,($FFFFCA46).w
		bsr.w	sub_9DA2
		lea	loc_9C4A(pc),a0
		lea	($FFFFCA1E).w,a1
		move.w	#$104,$1E(a1)
		lea	($FFFFD818).w,a2
		bsr.w	sub_9E84
		movea.l	a1,a0
		lea	SSZ_MapBGLocs(pc),a2
		bsr.w	DecEniMapLocs
		move.l	a1,($FFFFFBC0).w
		movea.l	a0,a1
		lea	(unk_0B84&$FFFFFF).l,a3
		lea	(unk_0C86&$FFFFFF).l,a4
		clr.w	(unk_0A00&$FFFFFF).l
		clr.w	(unk_0B02&$FFFFFF).l
		clr.w	(unk_0B84&$FFFFFF).l
		clr.w	(unk_0C86&$FFFFFF).l
		bsr.w	sub_9DC6
		enable_ints
		addq.w	#4,($FFFFD82C).w
		rts
; ---------------------------------------------------------------------------

loc_9720:
		jsr	(sub_F538).l
		addq.w	#4,($FFFFD82C).w

loc_972A:
		movea.w	($FFFFD862).w,a0
		lea	($FFFFC9DE).w,a1
		lea	(unk_0A00&$FFFFFF).l,a3
		lea	(unk_0B02&$FFFFFF).l,a4
		bsr.w	sub_9EF8
		bsr.w	sub_9F3A
		bsr.w	sub_9DFE
		movea.w	($FFFFD862).w,a0
		lea	($FFFFCA1E).w,a1
		lea	(unk_0B84&$FFFFFF).l,a3
		lea	(unk_0C86&$FFFFFF).l,a4
		bsr.s	sub_97B4
		bsr.w	sub_9DFE
		rts
; ---------------------------------------------------------------------------
		_move.w	0(a1),d0
		move.w	d0,2(a1)
		move.w	($FFFFD830).w,d1
		sub.w	d0,d1
		blt.s	loc_9782
		cmpi.w	#$10,d1
		ble.s	loc_978C
		move.w	#$10,d1
		bra.s	loc_978C
; ---------------------------------------------------------------------------

loc_9782:
		cmpi.w	#$FFF0,d1
		bgt.s	loc_978C
		move.w	#$FFF0,d1

loc_978C:
		add.w	d1,d0
		move.w	d0,d1
		move.w	8(a1),d2
		addi.w	#$13F,d2
		and.w	d2,d1
		_move.w	d1,0(a1)
		move.w	8(a1),d1
		cmp.w	d1,d0
		bgt.s	loc_97AE
		move.w	$A(a1),d1
		cmp.w	d1,d0
		bgt.s	locret_97B2

loc_97AE:
		_move.w	d1,0(a1)

locret_97B2:
		rts

; =============== S U B	R O U T	I N E =======================================


sub_97B4:
		move.w	$10(a1),d0
		move.w	d0,$12(a1)
		move.w	$C(a0),d1
		subi.w	#$80,d1
		mulu.w	#2,d1
		ext.l	d1
		divu.w	#5,d1
		move.w	d1,$10(a1)
		move.w	$C(a1),d0
		cmp.w	d0,d1
		bgt.s	loc_97E2
		move.w	$E(a1),d0
		cmp.w	d0,d1
		bgt.s	locret_97E6

loc_97E2:
		move.w	d0,$10(a1)

locret_97E6:
		rts
; End of function sub_97B4

; ---------------------------------------------------------------------------
		lea	($FFFFCA5E).w,a2
		clr.w	($FFFFFBC8).w
		move.w	($FFFFC9DE).w,d3
		neg.w	d3
		addq.w	#3,($FFFFFBC4).w
		move.w	($FFFFFBC4).w,d2
		move.w	#$6F,d7				; "o"
		move.w	$10(a1),d0
		move.w	d0,d1
		andi.w	#1,d1
		bne.s	loc_9846

loc_980E:
		jsr	(sub_3F14).w
		move.w	d3,(a2)+
		lsr.w	#8,d1
		ext.w	d1
		neg.w	d1
		move.w	d1,(a2)+
		move.w	d3,(a2)+
		neg.w	d1
		move.w	d1,(a2)+
		addi.l	#$1000,($FFFFFBC8).w
		sub.w	($FFFFFBC8).w,d2
		dbf	d7,loc_980E
		move.l	#$FFFFCA5E,d0
		move.w	($FFFFD81C).w,d1
		move.w	#$1C0,d2
		jsr	(sub_568).w
		rts
; ---------------------------------------------------------------------------

loc_9846:
		jsr	(sub_3F14).w
		move.w	d3,(a2)+
		lsr.w	#8,d1
		ext.w	d1
		move.w	d1,(a2)+
		move.w	d3,(a2)+
		neg.w	d1
		move.w	d1,(a2)+
		addi.l	#$1000,($FFFFFBC8).w
		sub.w	($FFFFFBC8).w,d2
		dbf	d7,loc_9846
		move.l	#$FFFFCA5E,d0
		move.w	($FFFFD81C).w,d1
		move.w	#$1C0,d2
		jsr	(sub_568).w
		rts
; ---------------------------------------------------------------------------

locret_987C:
		rts
; ---------------------------------------------------------------------------

locret_987E:
		rts
; ---------------------------------------------------------------------------

locret_9880:
		rts
; ---------------------------------------------------------------------------

locret_9882:
		rts
; ---------------------------------------------------------------------------

loc_9884:
		move.w	($FFFFD82C).w,d0
		jmp	loc_988C(pc,d0.w)
; ---------------------------------------------------------------------------

loc_988C:
		bra.w	loc_9898
; ---------------------------------------------------------------------------
		bra.w	loc_991E
; ---------------------------------------------------------------------------
		bra.w	loc_9928
; ---------------------------------------------------------------------------

loc_9898:
		disable_ints
		lea	($FFFFC9DE).w,a1
		lea	PAL_TechnoTowerZoneUnused(pc),a0
		lea	($FFFFD424).w,a2
		bsr.w	sub_9E6E
		lea	loc_9CB0(pc),a0
		lea	($FFFFD816).w,a2
		bsr.w	sub_9E84
		movea.l	a1,a0
		lea	TTZ_ArtLocs(pc),a2
		bsr.w	sub_9D30
		lea	($FFFFC9DE).w,a0
		move.l	#v_128x128&$FFFFFF,$28(a0)
		lea	TTZ_MapFGLocs(pc),a2
		bsr.w	DecEniMapLocs
		move.l	a1,($FFFFCA46).w
		bsr.w	sub_9DA2
		lea	loc_9CD2(pc),a0
		lea	($FFFFCA1E).w,a1
		move.w	#$104,$1E(a1)
		lea	($FFFFD818).w,a2
		bsr.w	sub_9E84
		movea.l	a1,a0
		lea	TTZ_MapBGLocs(pc),a2
		bsr.w	DecEniMapLocs
		move.l	a1,($FFFFFBC0).w
		movea.l	a0,a1
		lea	(unk_0B84&$FFFFFF).l,a3
		lea	(unk_0C86&$FFFFFF).l,a4
		bsr.w	sub_9DC6
		enable_ints
		addq.w	#4,($FFFFD82C).w
		rts
; ---------------------------------------------------------------------------

loc_991E:
		jsr	(sub_F538).l
		addq.w	#4,($FFFFD82C).w

loc_9928:
		movea.w	($FFFFD862).w,a0
		lea	($FFFFC9DE).w,a1
		lea	(unk_0A00&$FFFFFF).l,a3
		lea	(unk_0B02&$FFFFFF).l,a4
		bsr.w	sub_9EF8
		bsr.w	sub_9F3A
		bsr.w	sub_9DFE
		movea.w	($FFFFD862).w,a0
		lea	($FFFFCA1E).w,a1
		lea	(unk_0B84&$FFFFFF).l,a3
		lea	(unk_0C86&$FFFFFF).l,a4
		bsr.s	sub_996A
		bsr.w	sub_9F3A
		jsr	(sub_9DFE).l
		rts

; =============== S U B	R O U T	I N E =======================================


sub_996A:
		moveq	#0,d1
		_move.w	0(a1),d0
		move.w	d0,2(a1)
		move.w	($FFFFD830).w,d1
		mulu.w	#$13,d1
		divu.w	#$1B,d1
		_move.w	d1,0(a1)
		move.w	8(a1),d0
		cmp.w	d0,d1
		bgt.s	loc_9994
		move.w	$A(a1),d0
		cmp.w	d0,d1
		bgt.s	locret_9998

loc_9994:
		_move.w	d0,0(a1)

locret_9998:
		rts
; End of function sub_996A

; ---------------------------------------------------------------------------
		moveq	#0,d0
		move.w	($FFFFC9EE).w,d0
		move.w	($FFFFC9F0).w,d1
		move.w	d0,d2
		sub.w	d1,d0
		beq.s	loc_99CC
		swap	d0
		move.l	d0,d1
		lsr.l	#1,d0
		add.l	d0,($FFFFFBC4).w
		move.l	d1,d0
		lsr.l	#2,d0
		add.l	d0,($FFFFFBC8).w
		move.l	d1,d0
		lsr.l	#3,d0
		add.l	d0,($FFFFFBCC).w
		move.l	d1,d0
		lsr.l	#4,d0
		add.l	d0,($FFFFFBD0).w

loc_99CC:
		lea	($FFFFCDDE).w,a2
		_move.w	0(a1),d1
		addi.w	#$F,d1
		lsr.w	#2,d1
		andi.w	#$FFFC,d1
		lea	dword_99F0(pc,d1.w),a3
		moveq	#$13,d7

loc_99E4:
		move.w	d2,(a2)+
		movea.l	(a3)+,a4
		move.w	(a4),(a2)+
		dbf	d7,loc_99E4
		rts
; ---------------------------------------------------------------------------
dword_99F0:	dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC8
		dc.l $FFFFFBC8
		dc.l $FFFFFBC8
		dc.l $FFFFFBC8
		dc.l $FFFFFBCC
		dc.l $FFFFFBCC
		dc.l $FFFFFBD0
		dc.l $FFFFFBD0
		dc.l $FFFFFBD8
		dc.l $FFFFFBD8
		dc.l $FFFFFBD8
		dc.l $FFFFFBD8
		dc.l $FFFFFBD8
		dc.l $FFFFFBD8
		dc.l $FFFFFBD8
		dc.l $FFFFFBD8
		dc.l $FFFFFBD0
		dc.l $FFFFFBD0
		dc.l $FFFFFBCC
		dc.l $FFFFFBCC
		dc.l $FFFFFBC8
		dc.l $FFFFFBC8
		dc.l $FFFFFBC8
		dc.l $FFFFFBC8
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC8
		dc.l $FFFFFBC8
		dc.l $FFFFFBC8
		dc.l $FFFFFBC8
		dc.l $FFFFFBCC
		dc.l $FFFFFBCC
		dc.l $FFFFFBD0
		dc.l $FFFFFBD0
		dc.l $FFFFFBD8
		dc.l $FFFFFBD8
		dc.l $FFFFFBD8
		dc.l $FFFFFBD8
		dc.l $FFFFFBD8
		dc.l $FFFFFBD8
		dc.l $FFFFFBD8
		dc.l $FFFFFBD8
		dc.l $FFFFFBD0
		dc.l $FFFFFBD0
		dc.l $FFFFFBCC
		dc.l $FFFFFBCC
		dc.l $FFFFFBC8
		dc.l $FFFFFBC8
		dc.l $FFFFFBC8
		dc.l $FFFFFBC8
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
		dc.l $FFFFFBC4
; ---------------------------------------------------------------------------
		cmpi.w	#$D60,($FFFFC9EE).w
		bcc.s	loc_9B80
		move.w	#$10C,($FFFFC9FC).w
		bra.s	locret_9BDE
; ---------------------------------------------------------------------------

loc_9B80:
		move.w	#$114,($FFFFC9FC).w
		lea	($FFFFCA5E).w,a3
		move.w	($FFFFC9DE).w,d3
		neg.w	d3
		move.w	($FFFFCA1E).w,d4
		neg.w	d4
		moveq	#$1B,d7
		move.w	($FFFFCA1C).w,d2
		addq.w	#1,d2
		move.w	d2,($FFFFCA1C).w

loc_9BA2:
		moveq	#6,d6

loc_9BA4:
		addq.w	#1,d2
		jsr	(sub_3F14).w
		andi.w	#3,d0
		add.w	d3,d0
		move.w	d0,(a3)+
		move.w	d4,(a3)+
		dbf	d6,loc_9BA4
		addq.w	#4,d2
		jsr	(sub_3F14).w
		andi.w	#4,d0
		add.w	d3,d0
		move.w	d0,(a3)+
		move.w	d4,(a3)+
		dbf	d7,loc_9BA2
		move.l	#$FFFFCA5E,d0
		move.w	($FFFFD81C).w,d1
		move.w	#$1C0,d2
		jsr	(sub_568).w

locret_9BDE:
		rts
; ---------------------------------------------------------------------------

locret_9BE0:
		rts
; ---------------------------------------------------------------------------

locret_9BE2:
		rts
; ---------------------------------------------------------------------------

locret_9BE4:
		rts
; ---------------------------------------------------------------------------

locret_9BE6:
		rts
; ---------------------------------------------------------------------------

locret_9BE8:
		rts
; ---------------------------------------------------------------------------

locret_9BEA:
		rts
; ---------------------------------------------------------------------------

locret_9BEC:
		rts
; ---------------------------------------------------------------------------

locret_9BEE:
		rts
; ---------------------------------------------------------------------------

locret_9BF0:
		rts
; ---------------------------------------------------------------------------

locret_9BF2:
		rts
; ---------------------------------------------------------------------------

locret_9BF4:
		rts
; ---------------------------------------------------------------------------

locret_9BF6:
		rts
; ---------------------------------------------------------------------------

locret_9BF8:
		rts
; ---------------------------------------------------------------------------

locret_9BFA:
		rts
; ---------------------------------------------------------------------------

locret_9BFC:
		rts
; ---------------------------------------------------------------------------

locret_9BFE:
		rts
; ---------------------------------------------------------------------------

locret_9C00:
		rts
; ---------------------------------------------------------------------------

locret_9C02:
		rts
; ---------------------------------------------------------------------------

locret_9C04:
		rts
; ---------------------------------------------------------------------------

locret_9C06:
		rts
; ---------------------------------------------------------------------------

locret_9C08:
		rts
; ---------------------------------------------------------------------------

locret_9C0A:
		rts
; ---------------------------------------------------------------------------

locret_9C0C:
		rts
; ---------------------------------------------------------------------------

locret_9C0E:
		rts
; ---------------------------------------------------------------------------

locret_9C10:
		rts
; ---------------------------------------------------------------------------

locret_9C12:
		rts
; ---------------------------------------------------------------------------

locret_9C14:
		rts
; ---------------------------------------------------------------------------

locret_9C16:
		rts
; ---------------------------------------------------------------------------

locret_9C18:
		rts
; ---------------------------------------------------------------------------

locret_9C1A:
		rts
; ---------------------------------------------------------------------------

locret_9C1C:
		rts
; ---------------------------------------------------------------------------

locret_9C1E:
		rts
; ---------------------------------------------------------------------------
SSZ_ArtLocs:	dc.l ARTNEM_SSZ8x8_FG
		dc.l ARTNEM_SSZ8x8_BG
loc_9C28:	dc.b   0
		dc.b   0
		dc.b   0
		dc.b $D0				; �
		dc.b $80				; �
		dc.b $10
		dc.b $80				; �
		dc.b  $C
		dc.b   0
		dc.b $40				; @
		dc.b $7E				; ~
		dc.b $C0				; �
		dc.b   0
		dc.b   0
		dc.b   5
		dc.b $20
		dc.b   0
		dc.b   0
SSZ_MapFGLocs:	dc.l MAPENI_SSZ16x16_FG
		dc.l MAPENI_SSZ128x128_FG
		dc.l MAPENI_SSZLayout_FG
		dc.l COL_SSZPrimary
loc_9C4A:	dc.b   0
		dc.b   0
		dc.b   0
		dc.b $54				; T
		dc.b   4
		dc.b   8
		dc.b   4
		dc.b   6
		dc.b   3
		dc.b $33				; 3
		dc.b   0
		dc.b $C0				; �
		dc.b   0
		dc.b   0
		dc.b   2
		dc.b $20
		dc.b   0
		dc.b   0
SSZ_MapBGLocs:	dc.l MAPENI_SSZ16x16_BG
		dc.l MAPENI_SSZ128x128_BG
		dc.l MAPENI_SSZLayout_BG
PAL_SpeedSliderZone:
		binclude	"Palettes/PalSpeedSliderZone.bin"
		even
TTZ_ArtLocs:	dc.l ARTNEM_TTZ8x8_FG
		dc.l ARTNEM_TTZ8x8_BG
loc_9CB0:	dc.b   0
		dc.b $15
		dc.b  $D
		dc.b $E0				; �
		dc.b $10
		dc.b $20
		dc.b $10
		dc.b $20
		dc.b   0
		dc.b $40				; @
		dc.b   6
		dc.b $C0				; �
		dc.b   0
		dc.b   0
		dc.b  $F
		dc.b $20
		dc.b   0
		dc.b   0
TTZ_MapFGLocs:	dc.l MAPENI_TTZ16x16_FG
		dc.l MAPENI_TTZ128x128_FG
		dc.l MAPENI_TTZLayout_FG
		dc.l COL_TTZPrimary
loc_9CD2:	dc.b   0
		dc.b $30				; 0
		dc.b  $A
		dc.b $60				; `
		dc.b $10
		dc.b $20
		dc.b  $C
		dc.b $18
		dc.b   1
		dc.b $6F				; o
		dc.b   4
		dc.b $C0				; �
		dc.b   0
		dc.b   0
		dc.b  $B
		dc.b $20
		dc.b   0
		dc.b   0
TTZ_MapBGLocs:	dc.l MAPENI_TTZ16x16_BG
		dc.l MAPENI_TTZ128x128_BG
		dc.l MAPENI_TTZLayout_BG
PAL_TechnoTowerZoneUnused:
		binclude	"Palettes/PalTechnoTowerZoneUnused.bin"
		even

; =============== S U B	R O U T	I N E =======================================

sub_9D30:
		move.l	a0,-(sp)
		movea.l	(a2)+,a0
		lea	(unk_0200&$FFFFFF).l,a4
		jsr	(NemDecToRAM).w
		movea.l	(a2)+,a0
		jsr	(NemDecToRAM).w
		movea.l	(sp)+,a0
		move.l	#unk_0200&$FFFFFF,d0
		moveq	#0,d1
		move.w	$1C(a0),d1
		lsl.w	#5,d1
		move.l	d0,d2
		sub.l	a4,d2
		neg.w	d2
		lsr.w	#1,d2
		jsr	(sub_5E8).w
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; (I think) Subroutine to take the data in "MapLocs" tables and decompress
; them correctly

; input:
;	$1C(a0) = starting art tile (added to each 8x8 before writing to destination)
;	a2 = source address
;	$28(a0) = destination address

; usage:
;	lea	(source).l,a2
;	move.l	#destination,$28(a0)
;	move.w	#arttile,$1C(a0)
;	bsr.w	DecEniMapLocs
; ---------------------------------------------------------------------------

DecEniMapLocs:
		movea.l	$28(a0),a1
		move.w	$1C(a0),d0
		move.l	a0,-(sp)
		movea.l	(a2)+,a0
		move.l	a2,-(sp)
		jsr	(EniDec).w
		movea.l	(sp)+,a2
		movea.l	(sp)+,a0
		move.l	a1,$24(a0)
		move.l	a0,-(sp)
		movea.l	(a2)+,a0
		moveq	#0,d0
		move.l	a2,-(sp)
		jsr	(EniDec).w
		movea.l	(sp)+,a2
		movea.l	(sp)+,a0
		move.l	a1,$20(a0)
		move.l	a0,-(sp)
		movea.l	(a2)+,a0
		moveq	#0,d0
		move.l	a2,-(sp)
		jsr	(EniDec).w
		movea.l	(sp)+,a2
		movea.l	(sp)+,a0
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

sub_9DA2:
		movea.l	(a2)+,a1
		lea	(unk_0200&$FFFFFF).l,a2
		moveq	#$7F,d0

loc_9DAC:
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		dbf	d0,loc_9DAC
		lea	(unk_0600&$FFFFFF).l,a2
		moveq	#$7F,d0

loc_9DBC:
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		dbf	d0,loc_9DBC
		rts

sub_9DC6:
		move.w	$10(a1),d0
		movea.l	a1,a5
		moveq	#$F,d7

loc_9DCE:
		movem.l	d0-a6,-(sp)
		movea.l	a3,a0
		_move.w	0(a1),d0
		move.w	$10(a1),d1
		move.w	$18(a1),d4
		jsr	(sub_1272).w
		movea.l	a0,a3
		jsr	(sub_14E4).w
		movem.l	(sp)+,d0-a6
		addi.w	#$10,$10(a1)
		dbf	d7,loc_9DCE
		move.w	d0,$10(a1)
		rts
; End of function sub_9DC6


; =============== S U B	R O U T	I N E =======================================


sub_9DFE:
		move.l	a3,-(sp)
		_move.w	0(a1),d0
		move.w	2(a1),d1
		eor.w	d1,d0
		andi.w	#$FFF0,d0
		beq.s	loc_9E38
		_cmp.w	0(a1),d1
		blt.s	loc_9E26
		_move.w	0(a1),d0
		move.w	$10(a1),d1
		movea.l	a4,a3
		jsr	(sub_129A).w
		bra.s	loc_9E38
; ---------------------------------------------------------------------------

loc_9E26:
		move.w	2(a1),d0
		addi.w	#$200,d0
		move.w	$10(a1),d1
		movea.l	a4,a3
		jsr	(sub_129A).w

loc_9E38:
		movea.l	(sp)+,a3
		move.w	$10(a1),d0
		move.w	$12(a1),d1
		eor.w	d1,d0
		andi.w	#$FFF0,d0
		beq.s	locret_9E6C
		cmp.w	$10(a1),d1
		blt.s	loc_9E5C
		_move.w	0(a1),d0
		move.w	$10(a1),d1
		jmp	(sub_1272).w
; ---------------------------------------------------------------------------

loc_9E5C:
		_move.w	0(a1),d0
		move.w	$12(a1),d1
		addi.w	#$100,d1
		jmp	(sub_1272).w
; ---------------------------------------------------------------------------

locret_9E6C:
		rts
; End of function sub_9DFE


; =============== S U B	R O U T	I N E =======================================


sub_9E6E:
		movem.l	(a0)+,d0-d7
		movem.l	d0-d7,(a2)
		adda.w	#$20,a2
		movem.l	(a0)+,d0-d7
		movem.l	d0-d7,(a2)
		rts
; End of function sub_9E6E


; =============== S U B	R O U T	I N E =======================================


sub_9E84:
		moveq	#0,d0
		move.w	(a2),d0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		andi.w	#3,d0
		move.l	d0,$18(a1)
		move.w	(a0)+,d1
		_move.w	d1,0(a1)
		move.w	d1,2(a1)
		move.w	(a0)+,d1
		move.w	d1,$10(a1)
		move.w	d1,$12(a1)
		move.b	(a0)+,4(a1)
		move.b	(a0)+,$14(a1)
		move.b	(a0)+,5(a1)
		move.b	(a0)+,$15(a1)
		move.w	(a0)+,$1C(a1)
		move.w	(a0)+,8(a1)
		move.w	(a0)+,$A(a1)
		move.w	(a0)+,$C(a1)
		move.w	(a0)+,$E(a1)
		moveq	#0,d0
		move.b	4(a1),d0
		moveq	#$F,d2

loc_9EDA:
		add.w	d0,d0
		dbcs	d2,loc_9EDA
		move.b	d2,6(a1)
		moveq	#0,d0
		move.b	$14(a1),d0
		moveq	#$F,d2

loc_9EEC:
		add.w	d0,d0
		dbcs	d2,loc_9EEC
		move.b	d2,$16(a1)
		rts
; End of function sub_9E84


; =============== S U B	R O U T	I N E =======================================


sub_9EF8:
		_move.w	0(a1),d0
		move.w	d0,2(a1)
		move.w	($FFFFD830).w,d1
		sub.w	d0,d1
		blt.s	loc_9F14
		cmpi.w	#$10,d1
		ble.s	loc_9F1E
		move.w	#$10,d1
		bra.s	loc_9F1E
; ---------------------------------------------------------------------------

loc_9F14:
		cmpi.w	#$FFF0,d1
		bgt.s	loc_9F1E
		move.w	#$FFF0,d1

loc_9F1E:
		add.w	d1,d0
		_move.w	d0,0(a1)
		move.w	8(a1),d1
		cmp.w	d1,d0
		bgt.s	loc_9F34
		move.w	$A(a1),d1
		cmp.w	d1,d0
		bgt.s	locret_9F38

loc_9F34:
		_move.w	d1,0(a1)

locret_9F38:
		rts
; End of function sub_9EF8


; =============== S U B	R O U T	I N E =======================================


sub_9F3A:
		move.w	$10(a1),d0
		move.w	d0,$12(a1)
		move.w	($FFFFD832).w,d1
		sub.w	d0,d1
		blt.s	loc_9F56
		cmpi.w	#$10,d1
		ble.s	loc_9F60
		move.w	#$10,d1
		bra.s	loc_9F60
; ---------------------------------------------------------------------------

loc_9F56:
		cmpi.w	#$FFF0,d1
		bgt.s	loc_9F60
		move.w	#$FFF0,d1

loc_9F60:
		add.w	d1,d0
		move.w	d0,$10(a1)
		move.w	$C(a1),d1
		cmp.w	d1,d0
		bgt.s	loc_9F76
		move.w	$E(a1),d1
		cmp.w	d1,d0
		bgt.s	locret_9F7A

loc_9F76:
		move.w	d1,$10(a1)

locret_9F7A:
		rts
; End of function sub_9F3A


; =============== S U B	R O U T	I N E =======================================


sub_9F7C:
		bsr.w	sub_9F82
		rts
; End of function sub_9F7C


; =============== S U B	R O U T	I N E =======================================


sub_9F82:
		lea	($FFFFC9DE).w,a1
		moveq	#0,d0
		move.b	$1F(a1),d0
		jmp	loc_9F90(pc,d0.w)
; End of function sub_9F82

; ---------------------------------------------------------------------------

loc_9F90:
		bra.w	loc_9FAC
; ---------------------------------------------------------------------------
		bra.w	loc_9FFA
; ---------------------------------------------------------------------------
		bra.w	loc_A062
; ---------------------------------------------------------------------------
		bra.w	loc_A098
; ---------------------------------------------------------------------------
		bra.w	locret_A132
; ---------------------------------------------------------------------------
		bra.w	loc_A0FE
; ---------------------------------------------------------------------------
		bra.w	locret_A134
; ---------------------------------------------------------------------------

loc_9FAC:
		move.b	$1E(a1),d0
		beq.s	locret_9FF8
		move.w	#$8B00,(vdp_control_port).l
		move.w	#$8B00,($FFFFC9CE).w
		moveq	#0,d0
		move.l	#$40000010,(vdp_control_port).l
		move.l	d0,(vdp_data_port).l
		moveq	#0,d1
		move.w	($FFFFD81C).w,d1
		lsl.l	#2,d1
		lsr.w	#2,d1
		ori.w	#$4000,d1
		swap	d1
		andi.w	#3,d1
		move.l	d1,(vdp_control_port).l
		move.l	d0,(vdp_data_port).l
		move.b	#0,$1E(a1)

locret_9FF8:
		rts
; ---------------------------------------------------------------------------

loc_9FFA:
		move.b	$1E(a1),d0
		beq.s	loc_A014
		move.w	#$8B00,(vdp_control_port).l
		move.w	#$8B00,($FFFFC9CE).w
		move.b	#0,$1E(a1)

loc_A014:
		move.l	#$40000010,(vdp_control_port).l
		move.w	$10(a1),(vdp_data_port).l
		move.w	($FFFFCA2E).w,(vdp_data_port).l
		moveq	#0,d0
		move.w	($FFFFD81C).w,d0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		andi.w	#3,d0
		move.l	d0,(vdp_control_port).l
		_move.w	0(a1),d0
		neg.w	d0
		move.w	d0,(vdp_data_port).l
		move.w	($FFFFCA1E).w,d1
		neg.w	d1
		move.w	d1,(vdp_data_port).l
		rts
; ---------------------------------------------------------------------------

loc_A062:
		move.b	$1E(a1),d0
		beq.s	loc_A07C
		move.w	#$8B03,(vdp_control_port).l
		move.w	#$8B03,($FFFFC9CE).w
		move.b	#0,$1E(a1)

loc_A07C:
		move.l	#$40000010,(vdp_control_port).l
		move.w	$10(a1),(vdp_data_port).l
		move.w	($FFFFCA2E).w,(vdp_data_port).l
		rts
; ---------------------------------------------------------------------------

loc_A098:
		move.b	$1E(a1),d0
		beq.s	loc_A0B2
		move.w	#$8B04,(vdp_control_port).l
		move.w	#$8B04,($FFFFC9CE).w
		move.b	#0,$1E(a1)

loc_A0B2:
		lea	($FFFFCDDE).w,a3
		lea	(vdp_data_port).l,a4
		move.l	#$40000010,(vdp_control_port).l
		bsr.w	sub_A14E
		moveq	#0,d0
		move.w	($FFFFD81C).w,d0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		andi.w	#3,d0
		move.l	d0,(vdp_control_port).l
		_move.w	0(a1),d0
		neg.w	d0
		move.w	d0,(vdp_data_port).l
		move.w	($FFFFCA1E).w,d1
		neg.w	d1
		move.w	d1,(vdp_data_port).l
		rts
; ---------------------------------------------------------------------------

loc_A0FE:
		move.b	$1E(a1),d0
		beq.s	loc_A118
		move.w	#$8B07,(vdp_control_port).l
		move.w	#$8B07,($FFFFC9CE).w
		move.b	#0,$1E(a1)

loc_A118:
		lea	($FFFFCDDE).w,a3
		lea	(vdp_data_port).l,a4
		move.l	#$40000010,(vdp_control_port).l
		bsr.w	sub_A14E
		rts
; ---------------------------------------------------------------------------

locret_A132:
		rts
; ---------------------------------------------------------------------------

locret_A134:
		rts
; ---------------------------------------------------------------------------
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)

; =============== S U B	R O U T	I N E =======================================


sub_A14E:
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		move.l	(a3)+,(a4)
		rts
; End of function sub_A14E


; =============== S U B	R O U T	I N E =======================================
; ---------------------------------------------------------------------------
; We think this is object loading subroutine or at least something to do with objects
; ---------------------------------------------------------------------------

sub_A178:
		lea	($FFFFD850).w,a6

loc_A17C:
		_move.w	0(a6),d0
		bne.s	loc_A184
		rts
; ---------------------------------------------------------------------------

loc_A184:
		movea.w	d0,a6
		moveq	#0,d0
		move.b	6(a6),d0
		jsr	loc_A192(pc,d0.w)
		bra.s	loc_A17C
; End of function sub_A178

; ---------------------------------------------------------------------------
; this is related to the controls of Sonic/Tails

loc_A192:
		bra.w	loc_A1AA			; sonic controls
; ---------------------------------------------------------------------------
		bra.w	loc_A1BC			; tails controls
; ---------------------------------------------------------------------------
		bra.w	loc_A1F2			; seems to effect the positioning of Sonics arm
; ---------------------------------------------------------------------------
		bra.w	loc_A1FC			; something to do with when tails is still and sonic is running at full speed
; ---------------------------------------------------------------------------
		bra.w	loc_A22A			; (I think) Sonics loading parts
; ---------------------------------------------------------------------------
		bra.w	loc_A234			; tails' loading parts (his two tails etc)
; ---------------------------------------------------------------------------

loc_A1AA:
		move.w	($FFFFD866).w,d0
		movea.l	off_A1CE(pc,d0.w),a0
		lea	($FFFFD89C).w,a5
		movea.w	($FFFFD864).w,a4
		jmp	(a0)
; ---------------------------------------------------------------------------

loc_A1BC:
		move.w	($FFFFD868).w,d0
		movea.l	off_A1CE(pc,d0.w),a0
		lea	($FFFFD8AC).w,a5
		movea.w	($FFFFD862).w,a4
		jmp	(a0)
; ---------------------------------------------------------------------------
off_A1CE:	dc.l loc_A26A				; something to do with stopping reflexes
		dc.l loc_AB30
		dc.l locret_B414
		dc.l locret_B416
		dc.l locret_B418
		dc.l locret_B41A
		dc.l locret_B41C
		dc.l locret_B41E
		dc.l locret_B420
; ---------------------------------------------------------------------------

loc_A1F2:
		move.w	($FFFFD866).w,d0
		movea.l	off_A206(pc,d0.w),a0
		jmp	(a0)
; ---------------------------------------------------------------------------

loc_A1FC:
		move.w	($FFFFD868).w,d0
		movea.l	off_A206(pc,d0.w),a0
		jmp	(a0)
; ---------------------------------------------------------------------------
off_A206:	dc.l loc_B422
		dc.l loc_B81A
		dc.l loc_A262
		dc.l loc_A262
		dc.l loc_A262
		dc.l loc_A262
		dc.l loc_A262
		dc.l loc_A262
		dc.l loc_A262
; ---------------------------------------------------------------------------

loc_A22A:
		move.w	($FFFFD866).w,d0
		movea.l	off_A23E(pc,d0.w),a0
		jmp	(a0)
; ---------------------------------------------------------------------------

loc_A234:
		move.w	($FFFFD868).w,d0
		movea.l	off_A23E(pc,d0.w),a0
		jmp	(a0)
; ---------------------------------------------------------------------------
off_A23E:	dc.l loc_A262
		dc.l loc_BC30
		dc.l loc_A262
		dc.l loc_A262
		dc.l loc_A262
		dc.l loc_A262
		dc.l loc_A262
		dc.l loc_A262
		dc.l loc_A262
; ---------------------------------------------------------------------------

loc_A262:
		andi.w	#$FF7F,4(a6)
		rts
; ---------------------------------------------------------------------------

loc_A26A:
		move.w	#$C10,$22(a6)
		moveq	#0,d0
		move.b	7(a6),d0
		pea	loc_C746(pc)
		move.w	locret_A282(pc,d0.w),d0
		jmp	locret_A282(pc,d0.w)
; ---------------------------------------------------------------------------

locret_A282:
		rts
; ---------------------------------------------------------------------------
		dc.w loc_A296-locret_A282
		dc.w loc_A588-locret_A282
		dc.w loc_A66E-locret_A282
		dc.w loc_A67C-locret_A282
		dc.w loc_A72E-locret_A282
		dc.w locret_A992-locret_A282
		dc.w loc_A994-locret_A282
		dc.w loc_A9C8-locret_A282
		dc.w loc_AA46-locret_A282
; ---------------------------------------------------------------------------

loc_A296:
		pea	loc_A506(pc)
		bset	#0,$25(a6)
		bclr	#4,$25(a6)
		clr.l	$18(a6)
		clr.l	$1C(a6)
		cmpi.w	#$1A,$26(a6)
		beq.w	loc_A4B4
		tst.b	(a5)
		bpl.s	loc_A2CC
		move.b	($FFFFD89E).w,d0
		andi.b	#$70,d0				; "p"
		beq.s	loc_A2CC
		clr.w	$2C(a6)
		bra.s	loc_A2D4
; ---------------------------------------------------------------------------

loc_A2CC:
		move.w	8(a5),d0
		bne.w	loc_A3D2

loc_A2D4:
		move.w	#$FFF4,d0
		move.w	$2C(a6),d1
		beq.s	loc_A2F0
		bpl.s	loc_A2E4
		neg.w	d0
		neg.w	d1

loc_A2E4:
		cmpi.w	#$C,d1
		bcc.w	loc_A42E
		clr.w	$2C(a6)

loc_A2F0:
		btst	#3,$25(a6)
		sne	d0
		andi.b	#8,d0
		move.b	d0,$20(a6)
		move.b	#$A,($FFFFFAE8).w
		move.b	$2A(a6),d0
		addi.b	#$10,d0
		cmpi.b	#$20,d0
		bcc.s	loc_A38A
		move.w	8(a6),d0
		moveq	#0,d1
		move.b	$23(a6),d1
		add.w	$C(a6),d1
		move.w	$24(a6),d4
		andi.w	#2,d4
		bsr.w	sub_BF84
		cmpi.w	#$FF80,d5
		bne.s	loc_A38A
		btst	#3,$25(a6)
		bne.s	loc_A356
		move.b	#8,$20(a6)
		moveq	#0,d3
		move.b	$22(a6),d3
		add.w	d3,d0
		bsr.w	sub_BF84
		cmpi.w	#$FF80,d5
		bne.s	loc_A37C
		bra.s	loc_A36E
; ---------------------------------------------------------------------------

loc_A356:
		move.b	#0,$20(a6)
		moveq	#0,d3
		move.b	$22(a6),d3
		sub.w	d3,d0
		bsr.w	sub_BF84
		cmpi.w	#$FF80,d5
		bne.s	loc_A37C

loc_A36E:
		move.w	#$18,$26(a6)
		andi.b	#3,$28(a6)
		rts
; ---------------------------------------------------------------------------

loc_A37C:
		move.w	#$16,$26(a6)
		andi.b	#3,$28(a6)
		rts
; ---------------------------------------------------------------------------

loc_A38A:
		move.w	$A(a5),d0
		beq.s	loc_A3A6
		move.l	#$100,$26(a6)
		tst.w	d0
		bmi.s	locret_A3A4
		move.l	#$200,$26(a6)

locret_A3A4:
		rts
; ---------------------------------------------------------------------------

loc_A3A6:
		cmpi.w	#$14,$26(a6)
		beq.s	locret_A3D0
		tst.w	$26(a6)
		beq.s	loc_A3B8
		clr.w	$28(a6)

loc_A3B8:
		move.w	#0,$26(a6)
		tst.b	$29(a6)
		bpl.s	loc_A3CA
		move.w	#$14,$26(a6)

loc_A3CA:
		move.b	#0,$28(a6)

locret_A3D0:
		rts
; ---------------------------------------------------------------------------

loc_A3D2:
		move.b	3(a5),d1
		andi.b	#$C,d1
		beq.s	loc_A3E0
		clr.w	$28(a6)

loc_A3E0:
		move.w	$24(a6),d1
		eor.w	d0,d1
		move.w	$2C(a6),d2
		ext.l	d2
		swap	d2
		eor.w	d1,d2
		andi.w	#8,d2
		bne.s	loc_A40A
		andi.w	#8,d1
		eor.w	d1,$24(a6)
		tst.w	$2C(a6)
		bpl.s	loc_A42A
		neg.w	$2C(a6)
		bra.s	loc_A42A
; ---------------------------------------------------------------------------

loc_A40A:
		move.w	$2C(a6),d0
		bpl.s	loc_A412
		neg.w	d0

loc_A412:
		cmpi.w	#$80,d0
		bcc.s	loc_A420
		eor.w	d1,$24(a6)
		moveq	#0,d0
		bra.s	loc_A432
; ---------------------------------------------------------------------------

loc_A420:
		move.l	#$1A0000,$26(a6)
		rts
; ---------------------------------------------------------------------------

loc_A42A:
		move.w	#$C,d0

loc_A42E:
		add.w	$2C(a6),d0

loc_A432:
		move.w	d0,$2C(a6)
		bpl.s	loc_A43A
		neg.w	d0

loc_A43A:
		cmpi.w	#$400,d0
		bcs.s	loc_A44A
		moveq	#$A,d2
		andi.w	#$3FF,$28(a6)
		bra.s	loc_A45A
; ---------------------------------------------------------------------------

loc_A44A:
		lsr.w	#4,d0
		cmpi.w	#$10,d0
		bcc.s	loc_A454
		moveq	#$10,d0

loc_A454:
		add.w	d0,$28(a6)
		moveq	#2,d2

loc_A45A:
		move.b	$2A(a6),d0
		btst	#3,$25(a6)
		bne.s	loc_A488
		subi.b	#$10,d0
		neg.b	d0
		lsr.w	#4,d0
		btst	#3,d0
		sne	d1
		andi.w	#6,d0
		add.w	d2,d0
		move.w	d0,$26(a6)
		andi.b	#$18,d1
		move.b	d1,$20(a6)
		rts
; ---------------------------------------------------------------------------

loc_A488:
		subi.b	#$80,d0
		neg.b	d0
		subi.b	#$10,d0
		neg.b	d0
		lsr.w	#4,d0
		btst	#3,d0
		sne	d1
		andi.w	#6,d0
		add.w	d2,d0
		move.w	d0,$26(a6)
		andi.b	#$18,d1
		eori.b	#$10,d1
		move.b	d1,$20(a6)
		rts
; ---------------------------------------------------------------------------

loc_A4B4:
		btst	#3,$25(a6)
		sne	d0
		not.b	d0
		andi.b	#8,d0
		move.b	d0,$20(a6)
		move.w	#$FF80,d0
		move.w	$2C(a6),d1
		beq.s	loc_A4E0
		bpl.s	loc_A4D6
		neg.w	d0
		neg.w	d1

loc_A4D6:
		cmpi.w	#$80,d1
		bcc.s	loc_A4F0
		clr.w	$2C(a6)

loc_A4E0:
		move.l	#0,$26(a6)
		eori.b	#8,$25(a6)
		rts
; ---------------------------------------------------------------------------

loc_A4F0:
		add.w	$2C(a6),d0
		move.w	d0,$2C(a6)
		move.w	#$1A,$26(a6)
		andi.b	#3,$28(a6)
		rts
; ---------------------------------------------------------------------------

loc_A506:
		cmpi.l	#$200,$26(a6)
		beq.s	loc_A51E
		tst.b	(a5)
		bmi.s	loc_A530
		bsr.w	sub_AA76
		bsr.w	sub_AAA4
		bra.s	loc_A530
; ---------------------------------------------------------------------------

loc_A51E:
		move.b	3(a5),d0
		andi.b	#$70,d0				; "p"
		beq.s	loc_A530
		move.b	#$E,7(a6)
		rts
; ---------------------------------------------------------------------------

loc_A530:
		bsr.w	nullsub_2
		bsr.w	sub_CBC0
		jsr	(sub_C49A).l
		jsr	(sub_C29E).l
		beq.s	loc_A550
		move.w	d0,($FFFFFAC0).w
		move.w	d1,($FFFFFAC2).w
		rts
; ---------------------------------------------------------------------------

loc_A550:
		bclr	#0,$25(a6)
		move.b	#8,7(a6)
		move.b	$2A(a6),d2
		btst	#3,$25(a6)
		beq.s	loc_A56C
		addi.b	#-$80,d2

loc_A56C:
		jsr	(sub_3F14).w
		move.w	$2C(a6),d2
		muls.w	d2,d0
		muls.w	d2,d1
		asr.l	#6,d0
		asr.l	#6,d1
		move.l	d0,$18(a6)
		move.l	d1,$1C(a6)
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

loc_A588:
		btst	#0,$25(a6)
		bne.w	loc_A63E
		pea	loc_A61A(pc)
		addi.l	#$3800,$1C(a6)
		bclr	#0,$25(a6)
		bset	#4,$25(a6)
		move.w	#$12,$26(a6)
		clr.b	$2A(a6)
		clr.w	$2C(a6)
		move.w	8(a5),d0
		bne.s	loc_A5E4
		move.l	$18(a6),d0
		move.l	d0,d1
		bpl.s	loc_A5C8
		neg.l	d1

loc_A5C8:
		andi.l	#$FFFFF800,d1
		bne.s	loc_A5D6
		clr.l	$18(a6)
		bra.s	loc_A5FC
; ---------------------------------------------------------------------------

loc_A5D6:
		swap	d0
		ext.l	d0
		swap	d0
		ori.w	#1,d0
		neg.w	d0
		bra.s	loc_A5F2
; ---------------------------------------------------------------------------

loc_A5E4:
		move.w	$24(a6),d1
		eor.w	d0,d1
		andi.w	#8,d1
		eor.w	d1,$24(a6)

loc_A5F2:
		swap	d0
		sub.w	d0,d0
		asr.l	#4,d0
		add.l	d0,$18(a6)

loc_A5FC:
		move.b	2(a5),d0
		andi.b	#$70,d0				; "p"
		bne.s	locret_A618
		cmpi.l	#$FFFC8000,$1C(a6)
		bge.s	locret_A618
		move.l	#$FFFC8000,$1C(a6)

locret_A618:
		rts
; ---------------------------------------------------------------------------

loc_A61A:
		bsr.w	sub_CBC0
		bsr.w	sub_AA76
		jsr	(sub_C49A).l
		jsr	(sub_C636).l
		bne.s	loc_A632
		rts
; ---------------------------------------------------------------------------

loc_A632:
		tst.l	$1C(a6)
		bpl.s	loc_A63E
		clr.l	$1C(a6)
		rts
; ---------------------------------------------------------------------------

loc_A63E:
		move.l	$18(a6),d0
		bpl.s	loc_A64E
		btst	#3,$25(a6)
		bne.s	loc_A656
		bra.s	loc_A658
; ---------------------------------------------------------------------------

loc_A64E:
		btst	#3,$25(a6)
		beq.s	loc_A658

loc_A656:
		neg.l	d0

loc_A658:
		asr.l	#8,d0
		move.w	d0,$2C(a6)
		move.b	#2,7(a6)
		move.l	#0,$26(a6)
		rts
; ---------------------------------------------------------------------------

loc_A66E:
		move.b	#2,7(a6)
		bset	#4,$25(a6)
		rts
; ---------------------------------------------------------------------------

loc_A67C:
		pea	loc_A6E8(pc)
		addi.l	#$3800,$1C(a6)
		bclr	#0,$25(a6)
		bset	#4,$25(a6)
		move.w	#$12,$26(a6)
		clr.b	$2A(a6)
		clr.w	$2C(a6)
		move.w	8(a5),d0
		bne.s	loc_A6CE
		move.l	$18(a6),d0
		move.l	d0,d1
		bpl.s	loc_A6B2
		neg.l	d1

loc_A6B2:
		andi.l	#$FFFFF800,d1
		bne.s	loc_A6C0
		clr.l	$18(a6)
		rts
; ---------------------------------------------------------------------------

loc_A6C0:
		swap	d0
		ext.l	d0
		swap	d0
		ori.w	#1,d0
		neg.w	d0
		bra.s	loc_A6DC
; ---------------------------------------------------------------------------

loc_A6CE:
		move.w	$24(a6),d1
		eor.w	d0,d1
		andi.w	#8,d1
		eor.w	d1,$24(a6)

loc_A6DC:
		swap	d0
		sub.w	d0,d0
		asr.l	#4,d0
		add.l	d0,$18(a6)
		rts
; ---------------------------------------------------------------------------

loc_A6E8:
		bsr.w	sub_CBC0
		bsr.w	sub_AA76
		jsr	(sub_C49A).l
		jsr	(sub_C636).l
		beq.s	locret_A72C
		move.l	$18(a6),d0
		bpl.s	loc_A70E
		btst	#3,$25(a6)
		bne.s	loc_A716
		bra.s	loc_A718
; ---------------------------------------------------------------------------

loc_A70E:
		btst	#3,$25(a6)
		beq.s	loc_A718

loc_A716:
		neg.l	d0

loc_A718:
		asr.l	#8,d0
		move.w	d0,$2C(a6)
		move.b	#2,7(a6)
		move.l	#0,$26(a6)

locret_A72C:
		rts
; ---------------------------------------------------------------------------

loc_A72E:
		btst	#4,$25(a6)
		beq.s	loc_A738
		rts
; ---------------------------------------------------------------------------

loc_A738:
		moveq	#$A,d0
		btst	#3,$20(a6)
		beq.s	loc_A744
		neg.w	d0

loc_A744:
		add.w	8(a6),d0
		move.w	d0,8(a4)
		move.w	$C(a6),d0
		subi.w	#$A,d0
		move.w	d0,$C(a4)
		move.b	#$C,7(a4)
		pea	loc_A8D6(pc)
		bclr	#4,$25(a6)
		btst	#0,$25(a6)
		beq.s	loc_A778
		clr.l	$18(a6)
		clr.l	$1C(a6)

loc_A778:
		cmpi.w	#$1A,$26(a6)
		beq.w	loc_A88A
		move.w	8(a5),d0
		bne.w	loc_A7CE
		move.w	#$FFF4,d0
		move.w	$2C(a6),d1
		beq.s	loc_A7A6
		bpl.s	loc_A79A
		neg.w	d0
		neg.w	d1

loc_A79A:
		cmpi.w	#$C,d1
		bcc.w	loc_A804
		clr.w	$2C(a6)

loc_A7A6:
		btst	#3,$25(a6)
		sne	d0
		andi.b	#8,d0
		move.b	d0,$20(a6)
		move.l	#$1C0000,$26(a6)
		move.w	$A(a5),d0
		bpl.s	locret_A7CC
		move.l	#$1C0100,$26(a6)

locret_A7CC:
		rts
; ---------------------------------------------------------------------------

loc_A7CE:
		move.w	$24(a6),d1
		eor.w	d0,d1
		andi.w	#8,d1
		bne.s	loc_A7E0
		tst.w	$2C(a6)
		bpl.s	loc_A800

loc_A7E0:
		move.w	$2C(a6),d0
		bpl.s	loc_A7E8
		neg.w	d0

loc_A7E8:
		cmpi.w	#$80,d0
		bcc.s	loc_A7F6
		eor.w	d1,$24(a6)
		moveq	#0,d0
		bra.s	loc_A808
; ---------------------------------------------------------------------------

loc_A7F6:
		move.l	#$1A0000,$26(a6)
		rts
; ---------------------------------------------------------------------------

loc_A800:
		move.w	#$C,d0

loc_A804:
		add.w	$2C(a6),d0

loc_A808:
		move.w	d0,$2C(a6)
		bpl.s	loc_A810
		neg.w	d0

loc_A810:
		cmpi.w	#$400,d0
		bcs.s	loc_A820
		moveq	#$26,d2				; "&"
		andi.w	#$3FF,$28(a6)
		bra.s	loc_A830
; ---------------------------------------------------------------------------

loc_A820:
		lsr.w	#4,d0
		cmpi.w	#$10,d0
		bcc.s	loc_A82A
		moveq	#$10,d0

loc_A82A:
		add.w	d0,$28(a6)
		moveq	#$1E,d2

loc_A830:
		move.b	$2A(a6),d0
		btst	#3,$25(a6)
		bne.s	loc_A85E
		subi.b	#$10,d0
		neg.b	d0
		lsr.w	#4,d0
		btst	#3,d0
		sne	d1
		andi.w	#6,d0
		add.w	d2,d0
		move.w	d0,$26(a6)
		andi.b	#$18,d1
		move.b	d1,$20(a6)
		rts
; ---------------------------------------------------------------------------

loc_A85E:
		subi.b	#$80,d0
		neg.b	d0
		subi.b	#$10,d0
		neg.b	d0
		lsr.w	#4,d0
		btst	#3,d0
		sne	d1
		andi.w	#6,d0
		add.w	d2,d0
		move.w	d0,$26(a6)
		andi.b	#$18,d1
		eori.b	#$10,d1
		move.b	d1,$20(a6)
		rts
; ---------------------------------------------------------------------------

loc_A88A:
		btst	#3,$25(a6)
		sne	d0
		not.b	d0
		andi.b	#8,d0
		move.b	d0,$20(a6)
		move.w	#$FF80,d0
		move.w	$2C(a6),d1
		beq.s	loc_A8B6
		bpl.s	loc_A8AC
		neg.w	d0
		neg.w	d1

loc_A8AC:
		cmpi.w	#$80,d1
		bcc.s	loc_A8C6
		clr.w	$2C(a6)

loc_A8B6:
		move.l	#$1C0000,$26(a6)
		eori.b	#8,$25(a6)
		rts
; ---------------------------------------------------------------------------

loc_A8C6:
		add.w	$2C(a6),d0
		move.w	d0,$2C(a6)
		andi.b	#3,$28(a6)
		rts
; ---------------------------------------------------------------------------

loc_A8D6:
		move.b	2(a5),d0
		move.b	d0,d1
		andi.b	#$70,d0				; "p"
		bne.s	loc_A928
		move.b	5(a5),d2
		andi.b	#$F,d1
		bne.s	loc_A8F8
		moveq	#-$60,d2
		btst	#3,$25(a6)
		bne.s	loc_A8F8
		moveq	#-$20,d2

loc_A8F8:
		jsr	(sub_3F14).w
		ext.l	d0
		ext.l	d1
		asl.l	#5,d0
		asl.l	#5,d1
		add.l	d0,8(a4)
		add.l	d1,$C(a4)
		add.l	$18(a6),d0
		add.l	$1C(a6),d1
		move.l	d0,$18(a4)
		move.l	d1,$1C(a4)
		move.b	#8,7(a4)
		move.b	#2,7(a6)

loc_A928:
		bsr.w	nullsub_2
		bsr.w	sub_CBC0
		jsr	(sub_C49A).l
		jsr	(sub_C29E).l
		beq.s	loc_A94E
		bset	#0,$25(a6)
		move.w	d0,($FFFFFAC0).w
		move.w	d1,($FFFFFAC2).w
		rts
; ---------------------------------------------------------------------------

loc_A94E:
		bclr	#0,$25(a6)
		beq.s	loc_A988
		move.b	#8,7(a6)
		move.b	$2A(a6),d2
		btst	#3,$25(a6)
		beq.s	loc_A96C
		addi.b	#-$80,d2

loc_A96C:
		jsr	(sub_3F14).w
		move.w	$2C(a6),d2
		muls.w	d2,d0
		muls.w	d2,d1
		asr.l	#6,d0
		asr.l	#6,d1
		move.l	d0,$18(a6)
		move.l	d1,$1C(a6)
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

loc_A988:
		addi.l	#$3800,$1C(a6)
		rts
; ---------------------------------------------------------------------------

locret_A992:
		rts
; ---------------------------------------------------------------------------

loc_A994:
		bclr	#4,$25(a6)
		move.w	#$2E,$26(a6)			; "."
		addq.b	#1,$28(a6)
		tst.l	$2C(a6)
		bne.s	loc_A9B2
		btst	#1,2(a5)
		bne.s	loc_A9C0

loc_A9B2:
		move.w	#$800,$2C(a6)
		move.b	#6,7(a6)
		rts
; ---------------------------------------------------------------------------

loc_A9C0:
		jsr	(sub_CBC0).l
		rts
; ---------------------------------------------------------------------------

loc_A9C8:
		move.w	#$100,$30(a6)
		btst	#0,$25(a6)
		bne.w	loc_AA08
		addi.l	#$3800,$1C(a6)
		bclr	#0,$25(a6)
		move.w	#$30,$26(a6)			; "0"
		clr.b	$2A(a6)
		clr.w	$2C(a6)
		bsr.w	sub_CBC0
		jsr	(sub_C49A).l
		jsr	(sub_C636).l
		bne.s	loc_AA08
		rts
; ---------------------------------------------------------------------------

loc_AA08:
		move.l	$18(a6),d0
		bpl.s	loc_AA18
		btst	#3,$25(a6)
		bne.s	loc_AA20
		bra.s	loc_AA22
; ---------------------------------------------------------------------------

loc_AA18:
		btst	#3,$25(a6)
		beq.s	loc_AA22

loc_AA20:
		neg.l	d0

loc_AA22:
		asr.l	#8,d0
		move.w	d0,$2C(a6)
		tst.w	$32(a6)
		bmi.s	loc_AA3E
		move.b	#2,7(a6)
		move.l	#0,$26(a6)
		rts
; ---------------------------------------------------------------------------

loc_AA3E:
		move.b	#$12,7(a6)
		rts
; ---------------------------------------------------------------------------

loc_AA46:
		andi.b	#8,$20(a6)
		moveq	#0,d0
		move.w	d0,$2C(a6)
		move.l	d0,$18(a6)
		move.l	d0,$1C(a6)
		tst.w	$30(a6)
		bne.s	loc_AA6E
		move.w	#$10,$32(a6)
		move.b	#2,7(a6)
		rts
; ---------------------------------------------------------------------------

loc_AA6E:
		move.w	#$32,$26(a6)			; "2"
		rts

; =============== S U B	R O U T	I N E =======================================


sub_AA76:
		move.b	3(a5),d0
		andi.b	#$70,d0				; "p"
		beq.s	locret_AAA2
		move.w	($FFFFFAE0).w,d0
		cmpi.w	#$18,d0
		bcc.s	locret_AAA2
		move.b	#$A,7(a6)
		bclr	#4,$25(a6)
		andi.b	#$F,2(a5)
		andi.b	#$F,3(a5)

locret_AAA2:
		rts
; End of function sub_AA76


; =============== S U B	R O U T	I N E =======================================


sub_AAA4:
		move.b	3(a5),d0
		andi.b	#$70,d0				; "p"
		beq.s	locret_AAF6
		move.b	#4,7(a6)
		clr.w	$28(a6)
		bclr	#0,$25(a6)
		move.b	$2A(a6),d2
		jsr	(sub_3F14).w
		move.w	d0,d3
		move.w	d1,d4
		btst	#3,$25(a6)
		beq.s	loc_AAD4
		neg.w	d0

loc_AAD4:
		move.w	$2C(a6),d2
		muls.w	d2,d0
		muls.w	d2,d1
		move.w	#$680,d2
		muls.w	d2,d3
		muls.w	d2,d4
		add.l	d4,d0
		sub.l	d3,d1
		asr.l	#6,d0
		asr.l	#6,d1
		move.l	d0,$18(a6)
		move.l	d1,$1C(a6)
		rts
; ---------------------------------------------------------------------------

locret_AAF6:
		rts
; End of function sub_AAA4


; =============== S U B	R O U T	I N E =======================================


nullsub_2:
		rts
; End of function nullsub_2

; ---------------------------------------------------------------------------
		tst.w	$2C(a6)
		bne.s	loc_AB02

locret_AB00:
		rts
; ---------------------------------------------------------------------------

loc_AB02:
		move.b	$2A(a6),d0
		move.b	d0,d2
		subi.b	#$20,d0
		cmpi.b	#$C0,d0
		bcc.s	locret_AB00
		jsr	(sub_3F14).w
		asr.w	#8,d1
		ext.w	d2
		ext.l	d2
		swap	d2
		move.w	$24(a6),d0
		btst	#3,d0
		beq.s	loc_AB2A
		neg.w	d1

loc_AB2A:
		add.w	d1,$2C(a6)
		rts
; ---------------------------------------------------------------------------

loc_AB30:
		move.w	#$C0D,$22(a6)
		moveq	#0,d0
		move.b	7(a6),d0
		pea	loc_C746(pc)
		move.w	locret_AB48(pc,d0.w),d0
		jmp	locret_AB48(pc,d0.w)
; ---------------------------------------------------------------------------

locret_AB48:
		rts
; ---------------------------------------------------------------------------
		dc.w loc_AB5C-locret_AB48
		dc.w loc_AE3A-locret_AB48
		dc.w loc_AF20-locret_AB48
		dc.w loc_AF2E-locret_AB48
		dc.w loc_AFE0-locret_AB48
		dc.w loc_B240-locret_AB48
		dc.w loc_B274-locret_AB48
		dc.w loc_B2A8-locret_AB48
		dc.w loc_B32A-locret_AB48
; ---------------------------------------------------------------------------

loc_AB5C:
		pea	loc_ADB8(pc)
		bset	#0,$25(a6)
		bclr	#4,$25(a6)
		clr.l	$18(a6)
		clr.l	$1C(a6)
		cmpi.w	#$1A,$26(a6)
		beq.w	loc_AD66
		tst.b	(a5)
		bpl.s	loc_AB92
		move.b	($FFFFD89E).w,d0
		andi.b	#$70,d0				; "p"
		beq.s	loc_AB92
		clr.w	$2C(a6)
		bra.s	loc_AB9A
; ---------------------------------------------------------------------------

loc_AB92:
		move.w	8(a5),d0
		bne.w	loc_AC98

loc_AB9A:
		move.w	#$FFF0,d0
		move.w	$2C(a6),d1
		beq.s	loc_ABB6
		bpl.s	loc_ABAA
		neg.w	d0
		neg.w	d1

loc_ABAA:
		cmpi.w	#$10,d1
		bcc.w	loc_ACE0
		clr.w	$2C(a6)

loc_ABB6:
		btst	#3,$25(a6)
		sne	d0
		andi.b	#8,d0
		move.b	d0,$20(a6)
		move.b	#$A,($FFFFFAE8).w
		move.b	$2A(a6),d0
		addi.b	#$10,d0
		cmpi.b	#$20,d0
		bcc.s	loc_AC50
		move.w	8(a6),d0
		moveq	#0,d1
		move.b	$23(a6),d1
		add.w	$C(a6),d1
		move.w	$24(a6),d4
		andi.w	#2,d4
		bsr.w	sub_BF84
		cmpi.w	#$FF80,d5
		bne.s	loc_AC50
		btst	#3,$25(a6)
		bne.s	loc_AC1C
		move.b	#8,$20(a6)
		moveq	#0,d3
		move.b	$22(a6),d3
		add.w	d3,d0
		bsr.w	sub_BF84
		cmpi.w	#$FF80,d5
		bne.s	loc_AC42
		bra.s	loc_AC34
; ---------------------------------------------------------------------------

loc_AC1C:
		move.b	#0,$20(a6)
		moveq	#0,d3
		move.b	$22(a6),d3
		sub.w	d3,d0
		bsr.w	sub_BF84
		cmpi.w	#$FF80,d5
		bne.s	loc_AC42

loc_AC34:
		move.w	#$18,$26(a6)
		andi.b	#3,$28(a6)
		rts
; ---------------------------------------------------------------------------

loc_AC42:
		move.w	#$16,$26(a6)
		andi.b	#3,$28(a6)
		rts
; ---------------------------------------------------------------------------

loc_AC50:
		move.w	$A(a5),d0
		beq.s	loc_AC6C
		move.l	#$100,$26(a6)
		tst.w	d0
		bmi.s	locret_AC6A
		move.l	#$200,$26(a6)

locret_AC6A:
		rts
; ---------------------------------------------------------------------------

loc_AC6C:
		cmpi.w	#$14,$26(a6)
		beq.s	locret_AC96
		tst.w	$26(a6)
		beq.s	loc_AC7E
		clr.w	$28(a6)

loc_AC7E:
		move.w	#0,$26(a6)
		tst.b	$29(a6)
		bpl.s	loc_AC90
		move.w	#$14,$26(a6)

loc_AC90:
		move.b	#0,$28(a6)

locret_AC96:
		rts
; ---------------------------------------------------------------------------

loc_AC98:
		move.b	3(a5),d1
		andi.b	#$C,d1
		beq.s	loc_ACA6
		clr.w	$28(a6)

loc_ACA6:
		move.w	$24(a6),d1
		eor.w	d0,d1
		move.w	$2C(a6),d2
		ext.l	d2
		swap	d2
		eor.w	d2,d1
		andi.w	#8,d1
		beq.s	loc_ACDC
		move.w	$2C(a6),d0
		bpl.s	loc_ACC4
		neg.w	d0

loc_ACC4:
		cmpi.w	#$80,d0
		bcc.s	loc_ACD2
		eor.w	d1,$24(a6)
		moveq	#0,d0
		bra.s	loc_ACE4
; ---------------------------------------------------------------------------

loc_ACD2:
		move.l	#$1A0000,$26(a6)
		rts
; ---------------------------------------------------------------------------

loc_ACDC:
		move.w	#$10,d0

loc_ACE0:
		add.w	$2C(a6),d0

loc_ACE4:
		move.w	d0,$2C(a6)
		bpl.s	loc_ACEC
		neg.w	d0

loc_ACEC:
		cmpi.w	#$400,d0
		bcs.s	loc_ACFC
		moveq	#$A,d2
		andi.w	#$1FF,$28(a6)
		bra.s	loc_AD0C
; ---------------------------------------------------------------------------

loc_ACFC:
		lsr.w	#4,d0
		cmpi.w	#$10,d0
		bcc.s	loc_AD06
		moveq	#$10,d0

loc_AD06:
		add.w	d0,$28(a6)
		moveq	#2,d2

loc_AD0C:
		move.b	$2A(a6),d0
		btst	#3,$25(a6)
		bne.s	loc_AD3A
		subi.b	#$10,d0
		neg.b	d0
		lsr.w	#4,d0
		btst	#3,d0
		sne	d1
		andi.w	#6,d0
		add.w	d2,d0
		move.w	d0,$26(a6)
		andi.b	#$18,d1
		move.b	d1,$20(a6)
		rts
; ---------------------------------------------------------------------------

loc_AD3A:
		subi.b	#$80,d0
		neg.b	d0
		subi.b	#$10,d0
		neg.b	d0
		lsr.w	#4,d0
		btst	#3,d0
		sne	d1
		andi.w	#6,d0
		add.w	d2,d0
		move.w	d0,$26(a6)
		andi.b	#$18,d1
		eori.b	#$10,d1
		move.b	d1,$20(a6)
		rts
; ---------------------------------------------------------------------------

loc_AD66:
		btst	#3,$25(a6)
		sne	d0
		not.b	d0
		andi.b	#8,d0
		move.b	d0,$20(a6)
		move.w	#$FF80,d0
		move.w	$2C(a6),d1
		beq.s	loc_AD92
		bpl.s	loc_AD88
		neg.w	d0
		neg.w	d1

loc_AD88:
		cmpi.w	#$80,d1
		bcc.s	loc_ADA2
		clr.w	$2C(a6)

loc_AD92:
		move.l	#0,$26(a6)
		eori.b	#8,$25(a6)
		rts
; ---------------------------------------------------------------------------

loc_ADA2:
		add.w	$2C(a6),d0
		move.w	d0,$2C(a6)
		move.w	#$1A,$26(a6)
		andi.b	#3,$28(a6)
		rts
; ---------------------------------------------------------------------------

loc_ADB8:
		cmpi.l	#$200,$26(a6)
		beq.s	loc_ADD0
		tst.b	(a5)
		bmi.s	loc_ADE2
		bsr.w	sub_B35A
		bsr.w	sub_B388
		bra.s	loc_ADE2
; ---------------------------------------------------------------------------

loc_ADD0:
		move.b	3(a5),d0
		andi.b	#$70,d0				; "p"
		beq.s	loc_ADE2
		move.b	#$E,7(a6)
		rts
; ---------------------------------------------------------------------------

loc_ADE2:
		bsr.w	nullsub_3
		bsr.w	sub_CBC0
		jsr	(sub_C49A).l
		jsr	(sub_C29E).l
		beq.s	loc_AE02
		move.w	d0,($FFFFFAC0).w
		move.w	d1,($FFFFFAC2).w
		rts
; ---------------------------------------------------------------------------

loc_AE02:
		bclr	#0,$25(a6)
		move.b	#8,7(a6)
		move.b	$2A(a6),d2
		btst	#3,$25(a6)
		beq.s	loc_AE1E
		addi.b	#-$80,d2

loc_AE1E:
		jsr	(sub_3F14).w
		move.w	$2C(a6),d2
		muls.w	d2,d0
		muls.w	d2,d1
		asr.l	#6,d0
		asr.l	#6,d1
		move.l	d0,$18(a6)
		move.l	d1,$1C(a6)
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

loc_AE3A:
		btst	#0,$25(a6)
		bne.w	loc_AEF0
		pea	loc_AECC(pc)
		addi.l	#$3800,$1C(a6)
		bclr	#0,$25(a6)
		bset	#4,$25(a6)
		move.w	#$12,$26(a6)
		clr.b	$2A(a6)
		clr.w	$2C(a6)
		move.w	8(a5),d0
		bne.s	loc_AE96
		move.l	$18(a6),d0
		move.l	d0,d1
		bpl.s	loc_AE7A
		neg.l	d1

loc_AE7A:
		andi.l	#$FFFFF800,d1
		bne.s	loc_AE88
		clr.l	$18(a6)
		bra.s	loc_AEAE
; ---------------------------------------------------------------------------

loc_AE88:
		swap	d0
		ext.l	d0
		swap	d0
		ori.w	#1,d0
		neg.w	d0
		bra.s	loc_AEA4
; ---------------------------------------------------------------------------

loc_AE96:
		move.w	$24(a6),d1
		eor.w	d0,d1
		andi.w	#8,d1
		eor.w	d1,$24(a6)

loc_AEA4:
		swap	d0
		sub.w	d0,d0
		asr.l	#4,d0
		add.l	d0,$18(a6)

loc_AEAE:
		move.b	2(a5),d0
		andi.b	#$70,d0				; "p"
		bne.s	locret_AECA
		cmpi.l	#$FFFC0000,$1C(a6)
		bge.s	locret_AECA
		move.l	#$FFFC0000,$1C(a6)

locret_AECA:
		rts
; ---------------------------------------------------------------------------

loc_AECC:
		bsr.w	sub_CBC0
		bsr.w	sub_B35A
		jsr	(sub_C49A).l
		jsr	(sub_C636).l
		bne.s	loc_AEE4
		rts
; ---------------------------------------------------------------------------

loc_AEE4:
		tst.l	$1C(a6)
		bpl.s	loc_AEF0
		clr.l	$1C(a6)
		rts
; ---------------------------------------------------------------------------

loc_AEF0:
		move.l	$18(a6),d0
		bpl.s	loc_AF00
		btst	#3,$25(a6)
		bne.s	loc_AF08
		bra.s	loc_AF0A
; ---------------------------------------------------------------------------

loc_AF00:
		btst	#3,$25(a6)
		beq.s	loc_AF0A

loc_AF08:
		neg.l	d0

loc_AF0A:
		asr.l	#8,d0
		move.w	d0,$2C(a6)
		move.b	#2,7(a6)
		move.l	#0,$26(a6)
		rts
; ---------------------------------------------------------------------------

loc_AF20:
		move.b	#2,7(a6)
		bset	#4,$25(a6)
		rts
; ---------------------------------------------------------------------------

loc_AF2E:
		pea	loc_AF9A(pc)
		addi.l	#$3800,$1C(a6)
		bclr	#0,$25(a6)
		bset	#4,$25(a6)
		move.w	#$12,$26(a6)
		clr.b	$2A(a6)
		clr.w	$2C(a6)
		move.w	8(a5),d0
		bne.s	loc_AF80
		move.l	$18(a6),d0
		move.l	d0,d1
		bpl.s	loc_AF64
		neg.l	d1

loc_AF64:
		andi.l	#$FFFFF800,d1
		bne.s	loc_AF72
		clr.l	$18(a6)
		rts
; ---------------------------------------------------------------------------

loc_AF72:
		swap	d0
		ext.l	d0
		swap	d0
		ori.w	#1,d0
		neg.w	d0
		bra.s	loc_AF8E
; ---------------------------------------------------------------------------

loc_AF80:
		move.w	$24(a6),d1
		eor.w	d0,d1
		andi.w	#8,d1
		eor.w	d1,$24(a6)

loc_AF8E:
		swap	d0
		sub.w	d0,d0
		asr.l	#4,d0
		add.l	d0,$18(a6)
		rts
; ---------------------------------------------------------------------------

loc_AF9A:
		bsr.w	sub_CBC0
		bsr.w	sub_B35A
		jsr	(sub_C49A).l
		jsr	(sub_C636).l
		beq.s	locret_AFDE
		move.l	$18(a6),d0
		bpl.s	loc_AFC0
		btst	#3,$25(a6)
		bne.s	loc_AFC8
		bra.s	loc_AFCA
; ---------------------------------------------------------------------------

loc_AFC0:
		btst	#3,$25(a6)
		beq.s	loc_AFCA

loc_AFC8:
		neg.l	d0

loc_AFCA:
		asr.l	#8,d0
		move.w	d0,$2C(a6)
		move.b	#2,7(a6)
		move.l	#0,$26(a6)

locret_AFDE:
		rts
; ---------------------------------------------------------------------------

loc_AFE0:
		btst	#4,$25(a6)
		beq.s	loc_AFEA
		rts
; ---------------------------------------------------------------------------

loc_AFEA:
		move.w	8(a6),8(a4)
		move.w	$C(a6),d0
		subi.w	#$20,d0
		move.w	d0,$C(a4)
		clr.l	$1C(a4)
		move.b	#$C,7(a4)
		move.w	#$12,$26(a4)
		pea	loc_B184(pc)
		bclr	#4,$25(a6)
		btst	#0,$25(a6)
		beq.s	loc_B026
		clr.l	$18(a6)
		clr.l	$1C(a6)

loc_B026:
		cmpi.w	#$1A,$26(a6)
		beq.w	loc_B138
		move.w	8(a5),d0
		bne.w	loc_B07C
		move.w	#$FFF0,d0
		move.w	$2C(a6),d1
		beq.s	loc_B054
		bpl.s	loc_B048
		neg.w	d0
		neg.w	d1

loc_B048:
		cmpi.w	#$10,d1
		bcc.w	loc_B0B2
		clr.w	$2C(a6)

loc_B054:
		btst	#3,$25(a6)
		sne	d0
		andi.b	#8,d0
		move.b	d0,$20(a6)
		move.l	#$1C0000,$26(a6)
		move.w	$A(a5),d0
		bpl.s	locret_B07A
		move.l	#$1C0100,$26(a6)

locret_B07A:
		rts
; ---------------------------------------------------------------------------

loc_B07C:
		move.w	$24(a6),d1
		eor.w	d0,d1
		andi.w	#8,d1
		bne.s	loc_B08E
		tst.w	$2C(a6)
		bpl.s	loc_B0AE

loc_B08E:
		move.w	$2C(a6),d0
		bpl.s	loc_B096
		neg.w	d0

loc_B096:
		cmpi.w	#$80,d0
		bcc.s	loc_B0A4
		eor.w	d1,$24(a6)
		moveq	#0,d0
		bra.s	loc_B0B6
; ---------------------------------------------------------------------------

loc_B0A4:
		move.l	#$1A0000,$26(a6)
		rts
; ---------------------------------------------------------------------------

loc_B0AE:
		move.w	#$10,d0

loc_B0B2:
		add.w	$2C(a6),d0

loc_B0B6:
		move.w	d0,$2C(a6)
		bpl.s	loc_B0BE
		neg.w	d0

loc_B0BE:
		cmpi.w	#$400,d0
		bcs.s	loc_B0CE
		moveq	#$26,d2				; "&"
		andi.w	#$1FF,$28(a6)
		bra.s	loc_B0DE
; ---------------------------------------------------------------------------

loc_B0CE:
		lsr.w	#4,d0
		cmpi.w	#$10,d0
		bcc.s	loc_B0D8
		moveq	#$10,d0

loc_B0D8:
		add.w	d0,$28(a6)
		moveq	#$1E,d2

loc_B0DE:
		move.b	$2A(a6),d0
		btst	#3,$25(a6)
		bne.s	loc_B10C
		subi.b	#$10,d0
		neg.b	d0
		lsr.w	#4,d0
		btst	#3,d0
		sne	d1
		andi.w	#6,d0
		add.w	d2,d0
		move.w	d0,$26(a6)
		andi.b	#$18,d1
		move.b	d1,$20(a6)
		rts
; ---------------------------------------------------------------------------

loc_B10C:
		subi.b	#$80,d0
		neg.b	d0
		subi.b	#$10,d0
		neg.b	d0
		lsr.w	#4,d0
		btst	#3,d0
		sne	d1
		andi.w	#6,d0
		add.w	d2,d0
		move.w	d0,$26(a6)
		andi.b	#$18,d1
		eori.b	#$10,d1
		move.b	d1,$20(a6)
		rts
; ---------------------------------------------------------------------------

loc_B138:
		btst	#3,$25(a6)
		sne	d0
		not.b	d0
		andi.b	#8,d0
		move.b	d0,$20(a6)
		move.w	#$FF80,d0
		move.w	$2C(a6),d1
		beq.s	loc_B164
		bpl.s	loc_B15A
		neg.w	d0
		neg.w	d1

loc_B15A:
		cmpi.w	#$80,d1
		bcc.s	loc_B174
		clr.w	$2C(a6)

loc_B164:
		move.l	#$1C0000,$26(a6)
		eori.b	#8,$25(a6)
		rts
; ---------------------------------------------------------------------------

loc_B174:
		add.w	$2C(a6),d0
		move.w	d0,$2C(a6)
		andi.b	#3,$28(a6)
		rts
; ---------------------------------------------------------------------------

loc_B184:
		move.b	2(a5),d0
		move.b	d0,d1
		andi.b	#$70,d0				; "p"
		bne.s	loc_B1D6
		move.b	5(a5),d2
		andi.b	#$F,d1
		bne.s	loc_B1A6
		moveq	#-$60,d2
		btst	#3,$25(a6)
		bne.s	loc_B1A6
		moveq	#-$20,d2

loc_B1A6:
		jsr	(sub_3F14).w
		ext.l	d0
		ext.l	d1
		asl.l	#5,d0
		asl.l	#5,d1
		add.l	d0,8(a4)
		add.l	d1,$C(a4)
		add.l	$18(a6),d0
		add.l	$1C(a6),d1
		move.l	d0,$18(a4)
		move.l	d1,$1C(a4)
		move.b	#8,7(a4)
		move.b	#2,7(a6)

loc_B1D6:
		bsr.w	nullsub_3
		bsr.w	sub_CBC0
		jsr	(sub_C49A).l
		jsr	(sub_C29E).l
		beq.s	loc_B1FC
		bset	#0,$25(a6)
		move.w	d0,($FFFFFAC0).w
		move.w	d1,($FFFFFAC2).w
		rts
; ---------------------------------------------------------------------------

loc_B1FC:
		bclr	#0,$25(a6)
		beq.s	loc_B236
		move.b	#8,7(a6)
		move.b	$2A(a6),d2
		btst	#3,$25(a6)
		beq.s	loc_B21A
		addi.b	#-$80,d2

loc_B21A:
		jsr	(sub_3F14).w
		move.w	$2C(a6),d2
		muls.w	d2,d0
		muls.w	d2,d1
		asr.l	#6,d0
		asr.l	#6,d1
		move.l	d0,$18(a6)
		move.l	d1,$1C(a6)
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

loc_B236:
		addi.l	#$3800,$1C(a6)
		rts
; ---------------------------------------------------------------------------

loc_B240:
		cmpi.b	#$A,7(a4)
		beq.s	loc_B250
		move.b	#8,7(a6)
		rts
; ---------------------------------------------------------------------------

loc_B250:
		bclr	#0,$25(a6)
		bset	#4,$25(a6)
		move.w	#$12,$26(a6)
		moveq	#0,d0
		move.w	d0,$2C(a6)
		move.l	d0,$18(a6)
		moveq	#-1,d0
		move.l	d0,$1C(a6)
		rts
; ---------------------------------------------------------------------------

loc_B274:
		bclr	#4,$25(a6)
		move.w	#$2E,$26(a6)			; "."
		addq.b	#1,$28(a6)
		tst.l	$2C(a6)
		bne.s	loc_B292
		btst	#1,2(a5)
		bne.s	loc_B2A0

loc_B292:
		move.w	#$800,$2C(a6)
		move.b	#6,7(a6)
		rts
; ---------------------------------------------------------------------------

loc_B2A0:
		jsr	(sub_CBC0).l
		rts
; ---------------------------------------------------------------------------

loc_B2A8:
		move.w	#$100,$30(a6)
		btst	#0,$25(a6)
		bne.w	loc_B2EC
		addi.l	#$3800,$1C(a6)
		bclr	#0,$25(a6)
		move.w	#$30,$26(a6)			; "0"
		clr.b	$2A(a6)
		clr.w	$2C(a6)
		bsr.w	sub_CBC0
		bsr.w	sub_B35A
		jsr	(sub_C49A).l
		jsr	(sub_C636).l
		bne.s	loc_B2EC
		rts
; ---------------------------------------------------------------------------

loc_B2EC:
		move.l	$18(a6),d0
		bpl.s	loc_B2FC
		btst	#3,$25(a6)
		bne.s	loc_B304
		bra.s	loc_B306
; ---------------------------------------------------------------------------

loc_B2FC:
		btst	#3,$25(a6)
		beq.s	loc_B306

loc_B304:
		neg.l	d0

loc_B306:
		asr.l	#8,d0
		move.w	d0,$2C(a6)
		tst.w	$32(a6)
		bmi.s	loc_B322
		move.b	#2,7(a6)
		move.l	#0,$26(a6)
		rts
; ---------------------------------------------------------------------------

loc_B322:
		move.b	#$12,7(a6)
		rts
; ---------------------------------------------------------------------------

loc_B32A:
		andi.b	#8,$20(a6)
		moveq	#0,d0
		move.w	d0,$2C(a6)
		move.l	d0,$18(a6)
		move.l	d0,$1C(a6)
		tst.w	$30(a6)
		bne.s	loc_B352
		move.w	#$10,$32(a6)
		move.b	#2,7(a6)
		rts
; ---------------------------------------------------------------------------

loc_B352:
		move.w	#$32,$26(a6)			; "2"
		rts

; =============== S U B	R O U T	I N E =======================================


sub_B35A:
		move.b	3(a5),d0
		andi.b	#$70,d0				; "p"
		beq.s	locret_B386
		move.w	($FFFFFAE0).w,d0
		cmpi.w	#$18,d0
		bcc.s	locret_B386
		move.b	#$A,7(a6)
		bclr	#4,$25(a6)
		andi.b	#$F,2(a5)
		andi.b	#$F,3(a5)

locret_B386:
		rts
; End of function sub_B35A


; =============== S U B	R O U T	I N E =======================================


sub_B388:
		move.b	3(a5),d0
		andi.b	#$70,d0				; "p"
		beq.s	locret_B3DA
		move.b	#4,7(a6)
		clr.w	$28(a6)
		bclr	#0,$25(a6)
		move.b	$2A(a6),d2
		jsr	(sub_3F14).w
		move.w	d0,d3
		move.w	d1,d4
		btst	#3,$25(a6)
		beq.s	loc_B3B8
		neg.w	d0

loc_B3B8:
		move.w	$2C(a6),d2
		muls.w	d2,d0
		muls.w	d2,d1
		move.w	#$700,d2
		muls.w	d2,d3
		muls.w	d2,d4
		add.l	d4,d0
		sub.l	d3,d1
		asr.l	#6,d0
		asr.l	#6,d1
		move.l	d0,$18(a6)
		move.l	d1,$1C(a6)
		rts
; ---------------------------------------------------------------------------

locret_B3DA:
		rts
; End of function sub_B388


; =============== S U B	R O U T	I N E =======================================


nullsub_3:
		rts
; End of function nullsub_3

; ---------------------------------------------------------------------------
		tst.w	$2C(a6)
		bne.s	loc_B3E6

locret_B3E4:
		rts
; ---------------------------------------------------------------------------

loc_B3E6:
		move.b	$2A(a6),d0
		move.b	d0,d2
		subi.b	#$20,d0
		cmpi.b	#$C0,d0
		bcc.s	locret_B3E4
		jsr	(sub_3F14).w
		asr.w	#8,d1
		ext.w	d2
		ext.l	d2
		swap	d2
		move.w	$24(a6),d0
		btst	#3,d0
		beq.s	loc_B40E
		neg.w	d1

loc_B40E:
		add.w	d1,$2C(a6)
		rts
; ---------------------------------------------------------------------------

locret_B414:
		rts
; ---------------------------------------------------------------------------

locret_B416:
		rts
; ---------------------------------------------------------------------------

locret_B418:
		rts
; ---------------------------------------------------------------------------

locret_B41A:
		rts
; ---------------------------------------------------------------------------

locret_B41C:
		rts
; ---------------------------------------------------------------------------

locret_B41E:
		rts
; ---------------------------------------------------------------------------

locret_B420:
		rts
; ---------------------------------------------------------------------------

loc_B422:
		movea.w	$24(a6),a5
		tst.b	5(a5)
		bmi.s	loc_B436
		andi.w	#$FF7F,4(a6)
		bra.w	loc_B7D2
; ---------------------------------------------------------------------------

loc_B436:
		pea	(loc_B7D2).l
		move.w	$26(a5),d7
		move.w	off_B448(pc,d7.w),d7
		jmp	off_B448(pc,d7.w)
; ---------------------------------------------------------------------------
off_B448:	dc.w loc_B47C-off_B448
		dc.w sub_B512-off_B448
		dc.w sub_B548-off_B448
		dc.w sub_B580-off_B448
		dc.w sub_B5B8-off_B448
		dc.w sub_B5F0-off_B448
		dc.w sub_B610-off_B448
		dc.w sub_B632-off_B448
		dc.w sub_B652-off_B448
		dc.w loc_B674-off_B448
		dc.w sub_B67C-off_B448
		dc.w sub_B6A2-off_B448
		dc.w sub_B6CC-off_B448
		dc.w loc_B6F6-off_B448
		dc.w sub_B6FE-off_B448
		dc.w sub_B714-off_B448
		dc.w sub_B734-off_B448
		dc.w sub_B756-off_B448
		dc.w sub_B776-off_B448
		dc.w sub_B714-off_B448
		dc.w sub_B734-off_B448
		dc.w sub_B756-off_B448
		dc.w sub_B776-off_B448
		dc.w loc_B798-off_B448
		dc.w loc_B7A0-off_B448
		dc.w sub_B7A8-off_B448
; ---------------------------------------------------------------------------

loc_B47C:
		ori.w	#$80,4(a6)			; "�"
		cmpi.b	#2,$28(a5)
		bne.s	loc_B492
		andi.w	#$FF7F,4(a6)
		rts
; ---------------------------------------------------------------------------

loc_B492:
		moveq	#$FFFFFFF5,d0
		moveq	#$FFFFFFFA,d1
		bsr.w	sub_CA82
		move.w	#$14,$26(a6)
		rts
; ---------------------------------------------------------------------------

loc_B4A2:
		tst.w	$2E(a5)
		beq.s	sub_B4EC
		ori.w	#$80,4(a6)			; "�"
		move.b	$2B(a5),d0
		addq.b	#8,d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		move.w	word_B4CC(pc,d0.w),$26(a6)
		clr.b	$20(a6)
		moveq	#0,d0
		moveq	#-2,d1
		bra.w	loc_CA8A
; ---------------------------------------------------------------------------
word_B4CC:	dc.w $9C
		dc.w $98
		dc.w $94
		dc.w $90
		dc.w $8C
		dc.w $88
		dc.w $84
		dc.w $80
		dc.w $7C
		dc.w $B8
		dc.w $B4
		dc.w $B0
		dc.w $AC
		dc.w $A8
		dc.w $A4
		dc.w $A0

; =============== S U B	R O U T	I N E =======================================


sub_B4EC:
		ori.w	#$80,4(a6)			; "�"
		moveq	#0,d4
		move.b	$28(a5),d4
		add.w	d4,d4
		add.w	d4,d4
		add.w	d4,d4
		move.w	(a0,d4.w),$26(a6)
		move.w	2(a0,d4.w),d0
		move.w	4(a0,d4.w),d1
		bsr.w	sub_CA82
		rts
; End of function sub_B4EC

; ---------------------------------------------------------------------------

sub_B512:
		lea	loc_B518(pc),a0
		bra.s	loc_B4A2
; ---------------------------------------------------------------------------
loc_B518:	dc.w $14
		dc.w $FFF3
		dc.w $FFFA
		dc.w 0
		dc.w $18
		dc.w $FFE6
		dc.w $FFFE
		dc.w 0
		dc.w $1C
		dc.w $FFF4
		dc.w $FFFA
		dc.w 0
		dc.w $20
		dc.w $FFF6
		dc.w $FFF9
		dc.w 0
		dc.w $C
		dc.w $FFFC
		dc.w $FFF5
		dc.w 0
		dc.w $10
		dc.w $FFFB
		dc.w 0
		dc.w 0
; ---------------------------------------------------------------------------

sub_B548:
		lea	word_B550(pc),a0
		bra.w	loc_B4A2
; ---------------------------------------------------------------------------
word_B550:
		dc.w $2C
		dc.w 1
		dc.w 0
		dc.w 0
		dc.w $30
		dc.w $FFF5
		dc.w $FFFF
		dc.w 0
		dc.w $34
		dc.w $FFFF
		dc.w $FFF6
		dc.w 0
		dc.w $38
		dc.w 2
		dc.w $FFF5
		dc.w 0
		dc.w $24
		dc.w 6
		dc.w $FFEC
		dc.w 0
		dc.w $28
		dc.w 3
		dc.w $FFF5
		dc.w 0
; ---------------------------------------------------------------------------

sub_B580:
		lea	word_B588(pc),a0
		bra.w	loc_B4A2
; ---------------------------------------------------------------------------
word_B588:
		dc.w $44
		dc.w $FFFA
		dc.w $FFFF
		dc.w 0
		dc.w $48
		dc.w $FFFE
		dc.w 3
		dc.w 0
		dc.w $4C
		dc.w $FFFA
		dc.w $FFFE
		dc.w 0
		dc.w $50
		dc.w $FFF9
		dc.w $FFF3
		dc.w 0
		dc.w $3C
		dc.w $FFF5
		dc.w $FFEC
		dc.w 0
		dc.w $40
		dc.w 0
		dc.w $FFEF
		dc.w 0
; ---------------------------------------------------------------------------

sub_B5B8:
		lea	loc_B5C0(pc),a0
		bra.w	loc_B4A2
; ---------------------------------------------------------------------------
loc_B5C0:	dc.w $5C
		dc.w 7
		dc.w $FFF9
		dc.w 0
		dc.w $60
		dc.w 6
		dc.w 5
		dc.w 0
		dc.w $64
		dc.w $FFFD
		dc.w $FFFB
		dc.w 0
		dc.w $68
		dc.w $FFFC
		dc.w $FFF8
		dc.w 0
		dc.w $54
		dc.w $FFF3
		dc.w $FFF4
		dc.w 0
		dc.w $58
		dc.w $FFFC
		dc.w $FFEF
		dc.w 0
; ---------------------------------------------------------------------------

sub_B5F0:
		ori.w	#$80,4(a6)			; "�"
		moveq	#$FFFFFFF2,d0
		moveq	#$FFFFFFF3,d1
		btst	#0,$28(a5)
		beq.s	loc_B604
		moveq	#$FFFFFFF1,d0

loc_B604:
		bsr.w	sub_CA82
		move.w	#$6C,$26(a6)			; "l"
		rts
; ---------------------------------------------------------------------------

sub_B610:
		ori.w	#$80,4(a6)			; "�"
		moveq	#-2,d0
		moveq	#$FFFFFFF6,d1
		btst	#0,$28(a5)
		beq.s	loc_B626
		moveq	#-3,d0
		moveq	#$FFFFFFF7,d1

loc_B626:
		bsr.w	sub_CA82
		move.w	#$70,$26(a6)			; "p"
		rts
; ---------------------------------------------------------------------------

sub_B632:
		ori.w	#$80,4(a6)			; "�"
		moveq	#$FFFFFFF3,d0
		moveq	#$FFFFFFF8,d1
		btst	#0,$28(a5)
		beq.s	loc_B646
		moveq	#$FFFFFFF9,d1

loc_B646:
		bsr.w	sub_CA82
		move.w	#$74,$26(a6)			; "t"
		rts
; ---------------------------------------------------------------------------

sub_B652:
		ori.w	#$80,4(a6)			; "�"
		moveq	#-3,d0
		moveq	#$FFFFFFF4,d1
		btst	#0,$28(a5)
		beq.s	loc_B668
		moveq	#-2,d0
		moveq	#$FFFFFFF5,d1

loc_B668:
		bsr.w	sub_CA82
		move.w	#$78,$26(a6)			; "x"
		rts
; ---------------------------------------------------------------------------

loc_B674:
		andi.w	#$FF7F,4(a6)
		rts
; ---------------------------------------------------------------------------

sub_B67C:
		ori.w	#$80,4(a6)			; "�"
		moveq	#$FFFFFFEA,d0
		moveq	#$FFFFFFF4,d1
		bsr.w	sub_CA82
		moveq	#0,d0
		move.b	$28(a5),d0
		add.w	d0,d0
		move.w	word_B69A(pc,d0.w),$26(a6)
		rts
; ---------------------------------------------------------------------------
word_B69A:	dc.w word_B69A-word_B69A
		dc.w 4
		dc.w sub_B6A2-word_B69A
		dc.w 4
; ---------------------------------------------------------------------------

sub_B6A2:
		lea	word_B6AC(pc),a0
		bsr.w	sub_B4EC
		rts
; ---------------------------------------------------------------------------
word_B6AC:
		dc.w $F4
		dc.w $FFEE
		dc.w $FFEC
		dc.w 0
		dc.w $F8
		dc.w $FFEC
		dc.w $FFEA
		dc.w 0
		dc.w $FC
		dc.w $FFEC
		dc.w $FFEA
		dc.w 0
		dc.w $F8
		dc.w $FFEC
		dc.w $FFEA
		dc.w 0
; ---------------------------------------------------------------------------

sub_B6CC:
		lea	word_B6D6(pc),a0
		bsr.w	sub_B4EC
		rts
; ---------------------------------------------------------------------------
word_B6D6:	dc.w $100
		dc.w $FFEC
		dc.w $FFEC
		dc.w 0
		dc.w $104
		dc.w $FFEC
		dc.w $FFEA
		dc.w 0
		dc.w $108
		dc.w $FFEC
		dc.w $FFEC
		dc.w 0
		dc.w $104
		dc.w $FFEC
		dc.w $FFEC
		dc.w 0
; ---------------------------------------------------------------------------

loc_B6F6:
		andi.w	#$FF7F,4(a6)
		rts
; ---------------------------------------------------------------------------

sub_B6FE:
		ori.w	#$80,4(a6)			; "�"
		moveq	#-3,d0
		moveq	#$FFFFFFF3,d1
		bsr.w	sub_CA82
		move.w	#$BC,$26(a6)			; "�"
		rts
; ---------------------------------------------------------------------------

sub_B714:
		ori.w	#$80,4(a6)			; "�"
		moveq	#0,d0
		moveq	#$FFFFFFF3,d1
		btst	#0,$28(a5)
		beq.s	loc_B728
		moveq	#-2,d0

loc_B728:
		bsr.w	sub_CA82
		move.w	#$BC,$26(a6)			; "�"
		rts
; ---------------------------------------------------------------------------

sub_B734:
		ori.w	#$80,4(a6)			; "�"
		moveq	#4,d0
		moveq	#$FFFFFFE7,d1
		btst	#0,$28(a5)
		beq.s	loc_B74A
		moveq	#3,d0
		moveq	#$FFFFFFE8,d1

loc_B74A:
		bsr.w	sub_CA82
		move.w	#$C0,$26(a6)			; "�"
		rts
; ---------------------------------------------------------------------------

sub_B756:
		ori.w	#$80,4(a6)			; "�"
		moveq	#-5,d0
		moveq	#$FFFFFFE9,d1
		btst	#0,$28(a5)
		beq.s	loc_B76A
		moveq	#$FFFFFFEB,d1

loc_B76A:
		bsr.w	sub_CA82
		move.w	#$C4,$26(a6)			; "�"
		rts
; ---------------------------------------------------------------------------

sub_B776:
		ori.w	#$80,4(a6)			; "�"
		moveq	#$FFFFFFEE,d0
		moveq	#$FFFFFFF6,d1
		btst	#0,$28(a5)
		beq.s	loc_B78C
		moveq	#$FFFFFFEF,d0
		moveq	#$FFFFFFF7,d1

loc_B78C:
		bsr.w	sub_CA82
		move.w	#$C8,$26(a6)			; "�"
		rts
; ---------------------------------------------------------------------------

loc_B798:
		andi.w	#$FF7F,4(a6)
		rts
; ---------------------------------------------------------------------------

loc_B7A0:
		andi.w	#$FF7F,4(a6)
		rts
; ---------------------------------------------------------------------------

sub_B7A8:
		ori.w	#$80,4(a6)			; "�"
		moveq	#$FFFFFFF0,d0
		moveq	#$FFFFFFE9,d1
		bsr.w	sub_CA82
		moveq	#0,d0
		move.b	$28(a5),d0
		add.w	d0,d0
		move.w	word_B7C6(pc,d0.w),$26(a6)
		rts
; ---------------------------------------------------------------------------
word_B7C6:	dc.w $FC
		dc.w $100
		dc.w $104
		dc.w $108
		dc.w $10C
		dc.w $110
; ---------------------------------------------------------------------------

loc_B7D2:

		tst.b	5(a6)
		bmi.s	loc_B7DA
		rts
; ---------------------------------------------------------------------------

loc_B7DA:
		move.w	$26(a6),d0
		lea	(PLCMAP_SonArm_MainIndex).l,a0
		lea	(Map_SonicArm).l,a1
		lea	(PLC_SonicArm).l,a2
		adda.w	(a0,d0.w),a1
		adda.w	2(a0,d0.w),a2
		move.l	a1,obMap(a6)
		tst.b	6(a5)
		bne.s	loc_B80E
		move.l	a2,($FFFFD888).w
		ori.b	#8,($FFFFD87A).w
		rts
; ---------------------------------------------------------------------------

loc_B80E:
		move.l	a2,($FFFFD88C).w
		ori.b	#$10,($FFFFD87A).w
		rts
; ---------------------------------------------------------------------------

loc_B81A:
		movea.w	$24(a6),a5
		tst.b	5(a5)
		bmi.s	loc_B82E
		andi.w	#$FF7F,4(a6)
		bra.w	loc_BBE8
; ---------------------------------------------------------------------------

loc_B82E:
		pea	(loc_BBE8).l
		move.w	$26(a5),d7
		move.w	off_B840(pc,d7.w),d7
		jmp	off_B840(pc,d7.w)
; ---------------------------------------------------------------------------
off_B840:	dc.w sub_B874-off_B840
		dc.w sub_B916-off_B840
		dc.w sub_B95C-off_B840
		dc.w sub_B9A4-off_B840
		dc.w sub_B9EC-off_B840
		dc.w sub_BA34-off_B840
		dc.w sub_BA4A-off_B840
		dc.w sub_BA60-off_B840
		dc.w sub_BA76-off_B840
		dc.w loc_BA8C-off_B840
		dc.w sub_BA94-off_B840
		dc.w sub_BAB4-off_B840
		dc.w sub_BADE-off_B840
		dc.w loc_BB08-off_B840
		dc.w sub_BB10-off_B840
		dc.w sub_BB26-off_B840
		dc.w sub_BB46-off_B840
		dc.w sub_BB68-off_B840
		dc.w sub_BB88-off_B840
		dc.w sub_BB26-off_B840
		dc.w sub_BB46-off_B840
		dc.w sub_BB68-off_B840
		dc.w sub_BB88-off_B840
		dc.w loc_BBAA-off_B840
		dc.w loc_BBB2-off_B840
		dc.w sub_BBBA-off_B840
; ---------------------------------------------------------------------------

sub_B874:
		ori.w	#$80,4(a6)			; "�"
		cmpi.b	#2,$28(a5)
		bne.s	loc_B892
		moveq	#$FFFFFFF9,d0
		moveq	#$FFFFFFF6,d1
		bsr.w	sub_CA82
		move.w	#$64,$26(a6)			; "d"
		rts
; ---------------------------------------------------------------------------

loc_B892:
		moveq	#$FFFFFFF4,d0
		moveq	#$FFFFFFEE,d1
		bsr.w	sub_CA82
		move.w	#$5C,$26(a6)			; "\"
		rts
; ---------------------------------------------------------------------------

loc_B8A2:
		tst.w	$2E(a5)
		beq.s	sub_B8F0
		ori.w	#$80,4(a6)			; "�"
		move.b	$2B(a5),d0
		addq.b	#8,d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		move.w	word_B8D0(pc,d0.w),$26(a6)
		clr.b	$20(a6)
		moveq	#0,d0
		moveq	#-2,d1
		move.b	$20(a5),d2
		bra.w	loc_CA8A
; ---------------------------------------------------------------------------
word_B8D0:	dc.w $20
		dc.w $1C
		dc.w $18
		dc.w $14
		dc.w $10
		dc.w $C
		dc.w 8
		dc.w 4
		dc.w 0
		dc.w $3C
		dc.w $38
		dc.w $34
		dc.w $30
		dc.w $2C
		dc.w $28
		dc.w $24

; =============== S U B	R O U T	I N E =======================================


sub_B8F0:
		ori.w	#$80,4(a6)			; "�"
		moveq	#0,d4
		move.b	$28(a5),d4
		add.w	d4,d4
		add.w	d4,d4
		add.w	d4,d4
		move.w	(a0,d4.w),$26(a6)
		move.w	2(a0,d4.w),d0
		move.w	4(a0,d4.w),d1
		bsr.w	sub_CA82
		rts
; End of function sub_B8F0

; ---------------------------------------------------------------------------

sub_B916:
		lea	word_B91C(pc),a0
		bra.s	loc_B8A2
; ---------------------------------------------------------------------------
word_B91C:	dc.w $60
		dc.w $FFF4
		dc.w $FFEE
		dc.w 0
		dc.w $64
		dc.w $FFF4
		dc.w $FFEE
		dc.w 0
		dc.w $58
		dc.w $FFF4
		dc.w $FFEE
		dc.w 0
		dc.w $5C
		dc.w $FFF4
		dc.w $FFEE
		dc.w 0
		dc.w $60
		dc.w $FFF4
		dc.w $FFEE
		dc.w 0
		dc.w $64
		dc.w $FFF4
		dc.w $FFEE
		dc.w 0
		dc.w $58
		dc.w $FFF4
		dc.w $FFEE
		dc.w 0
		dc.w $5C
		dc.w $FFF4
		dc.w $FFEE
		dc.w 0
; ---------------------------------------------------------------------------

sub_B95C:
		lea	word_B964(pc),a0
		bra.w	loc_B8A2
; ---------------------------------------------------------------------------
word_B964:	dc.w $70
		dc.w $FFF0
		dc.w $FFE9
		dc.w 0
		dc.w $74
		dc.w $FFF0
		dc.w $FFE9
		dc.w 0
		dc.w $68
		dc.w $FFF0
		dc.w $FFE9
		dc.w 0
		dc.w $6C
		dc.w $FFF0
		dc.w $FFE9
		dc.w 0
		dc.w $70
		dc.w $FFF0
		dc.w $FFE9
		dc.w 0
		dc.w $74
		dc.w $FFF0
		dc.w $FFE9
		dc.w 0
		dc.w $68
		dc.w $FFF0
		dc.w $FFE9
		dc.w 0
		dc.w $6C
		dc.w $FFF0
		dc.w $FFE9
		dc.w 0
; ---------------------------------------------------------------------------

sub_B9A4:
		lea	word_B9AC(pc),a0
		bra.w	loc_B8A2
; ---------------------------------------------------------------------------
word_B9AC:	dc.w $80
		dc.w $FFEE
		dc.w $FFEC
		dc.w 0
		dc.w $84
		dc.w $FFEE
		dc.w $FFEC
		dc.w 0
		dc.w $78
		dc.w $FFEE
		dc.w $FFEC
		dc.w 0
		dc.w $7C
		dc.w $FFEE
		dc.w $FFEC
		dc.w 0
		dc.w $80
		dc.w $FFEE
		dc.w $FFEC
		dc.w 0
		dc.w $84
		dc.w $FFEE
		dc.w $FFEC
		dc.w 0
		dc.w $78
		dc.w $FFEE
		dc.w $FFEC
		dc.w 0
		dc.w $7C
		dc.w $FFEE
		dc.w $FFEC
		dc.w 0
; ---------------------------------------------------------------------------

sub_B9EC:
		lea	word_B9F4(pc),a0
		bra.w	loc_B8A2
; ---------------------------------------------------------------------------
word_B9F4:	dc.w $80
		dc.w $FFF0
		dc.w $FFE8
		dc.w 0
		dc.w $84
		dc.w $FFF0
		dc.w $FFE8
		dc.w 0
		dc.w $78
		dc.w $FFF0
		dc.w $FFE8
		dc.w 0
		dc.w $7C
		dc.w $FFF0
		dc.w $FFE8
		dc.w 0
		dc.w $80
		dc.w $FFF0
		dc.w $FFE8
		dc.w 0
		dc.w $84
		dc.w $FFF0
		dc.w $FFE8
		dc.w 0
		dc.w $78
		dc.w $FFF0
		dc.w $FFE8
		dc.w 0
		dc.w $7C
		dc.w $FFF0
		dc.w $FFE8
		dc.w 0
; ---------------------------------------------------------------------------

sub_BA34:
		ori.w	#$80,4(a6)			; "�"
		moveq	#$FFFFFFF0,d0
		moveq	#$FFFFFFEE,d1
		bsr.w	sub_CA82
		move.w	#$A8,$26(a6)			; "�"
		rts
; ---------------------------------------------------------------------------

sub_BA4A:
		ori.w	#$80,4(a6)			; "�"
		moveq	#$FFFFFFF0,d0
		moveq	#$FFFFFFE9,d1
		bsr.w	sub_CA82
		move.w	#$AC,$26(a6)			; "�"
		rts
; ---------------------------------------------------------------------------

sub_BA60:
		ori.w	#$80,4(a6)			; "�"
		moveq	#$FFFFFFEE,d0
		moveq	#$FFFFFFF0,d1
		bsr.w	sub_CA82
		move.w	#$B0,$26(a6)			; "�"
		rts
; ---------------------------------------------------------------------------

sub_BA76:
		ori.w	#$80,4(a6)			; "�"
		moveq	#$FFFFFFF0,d0
		moveq	#$FFFFFFE8,d1
		bsr.w	sub_CA82
		move.w	#$B4,$26(a6)			; "�"
		rts
; ---------------------------------------------------------------------------

loc_BA8C:
		andi.w	#$FF7F,4(a6)
		rts
; ---------------------------------------------------------------------------

sub_BA94:
		ori.w	#$80,4(a6)			; "�"
		moveq	#$FFFFFFF4,d0
		cmpi.b	#$14,$28(a5)
		bcs.s	loc_BAA6
		subq.w	#1,d0

loc_BAA6:
		moveq	#$FFFFFFEE,d1
		bsr.w	sub_CA82
		move.w	#$5C,$26(a6)			; "\"
		rts
; ---------------------------------------------------------------------------

sub_BAB4:
		lea	word_BABE(pc),a0
		bsr.w	sub_B8F0
		rts
; ---------------------------------------------------------------------------
word_BABE:	dc.w $40
		dc.w $FFEE
		dc.w $FFEC
		dc.w 0
		dc.w $44
		dc.w $FFEC
		dc.w $FFEA
		dc.w 0
		dc.w $48
		dc.w $FFEC
		dc.w $FFEA
		dc.w 0
		dc.w $44
		dc.w $FFEC
		dc.w $FFEA
		dc.w 0
; ---------------------------------------------------------------------------

sub_BADE:
		lea	loc_BAE8(pc),a0
		bsr.w	sub_B8F0
		rts
; ---------------------------------------------------------------------------
loc_BAE8:	dc.w $4C
		dc.w $FFEC
		dc.w $FFEC
		dc.w 0
		dc.w $50
		dc.w $FFEC
		dc.w $FFEA
		dc.w 0
		dc.w $54
		dc.w $FFEC
		dc.w $FFEC
		dc.w 0
		dc.w $50
		dc.w $FFEC
		dc.w $FFEC
		dc.w 0
; ---------------------------------------------------------------------------

loc_BB08:
		andi.w	#$FF7F,4(a6)
		rts
; ---------------------------------------------------------------------------

sub_BB10:
		ori.w	#$80,4(a6)			; "�"
		moveq	#-3,d0
		moveq	#-5,d1
		bsr.w	sub_CA82
		move.w	#$BC,$26(a6)			; "�"
		rts
; ---------------------------------------------------------------------------

sub_BB26:
		ori.w	#$80,4(a6)			; "�"
		moveq	#0,d0
		moveq	#-5,d1
		btst	#0,$28(a5)
		beq.s	loc_BB3A
		moveq	#-2,d0

loc_BB3A:
		bsr.w	sub_CA82
		move.w	#$BC,$26(a6)			; "�"
		rts
; ---------------------------------------------------------------------------

sub_BB46:
		ori.w	#$80,4(a6)			; "�"
		moveq	#4,d0
		moveq	#$FFFFFFE7,d1
		btst	#0,$28(a5)
		beq.s	loc_BB5C
		moveq	#3,d0
		moveq	#$FFFFFFE8,d1

loc_BB5C:
		bsr.w	sub_CA82
		move.w	#$C0,$26(a6)			; "�"
		rts
; ---------------------------------------------------------------------------

sub_BB68:
		ori.w	#$80,4(a6)			; "�"
		moveq	#-5,d0
		moveq	#$FFFFFFE9,d1
		btst	#0,$28(a5)
		beq.s	loc_BB7C
		moveq	#$FFFFFFEB,d1

loc_BB7C:
		bsr.w	sub_CA82
		move.w	#$C4,$26(a6)			; "�"
		rts
; ---------------------------------------------------------------------------

sub_BB88:
		ori.w	#$80,4(a6)			; "�"
		moveq	#$FFFFFFEE,d0
		moveq	#$FFFFFFF6,d1
		btst	#0,$28(a5)
		beq.s	loc_BB9E
		moveq	#$FFFFFFEF,d0
		moveq	#$FFFFFFF7,d1

loc_BB9E:
		bsr.w	sub_CA82
		move.w	#$C8,$26(a6)			; "�"
		rts
; ---------------------------------------------------------------------------

loc_BBAA:
		andi.w	#$FF7F,4(a6)
		rts
; ---------------------------------------------------------------------------

loc_BBB2:
		andi.w	#$FF7F,4(a6)
		rts
; ---------------------------------------------------------------------------

sub_BBBA:
		ori.w	#$80,4(a6)			; "�"
		moveq	#$FFFFFFF4,d0
		moveq	#$FFFFFFEE,d1
		bsr.w	sub_CA82
		moveq	#0,d0
		move.b	$28(a5),d0
		add.w	d0,d0
		move.w	word_BBD8(pc,d0.w),$26(a6)
		rts
; ---------------------------------------------------------------------------
word_BBD8:	dc.w $F0
		dc.w $F4
		dc.w $F8
		dc.w $FC
		dc.w $100
		dc.w $104
		dc.w $108
		dc.w $10C
; ---------------------------------------------------------------------------

loc_BBE8:

		tst.b	5(a6)
		bmi.s	loc_BBF0
		rts
; ---------------------------------------------------------------------------

loc_BBF0:
		move.w	$26(a6),d0
		lea	(PLCMAP_TalArm_MainIndex).l,a0
		lea	(MAP_TailsArm).l,a1
		lea	(PLC_TailsArm).l,a2
		adda.w	(a0,d0.w),a1
		adda.w	2(a0,d0.w),a2
		move.l	a1,obMap(a6)
		tst.b	6(a5)
		bne.s	loc_BC24
		move.l	a2,($FFFFD888).w
		ori.b	#8,($FFFFD87A).w
		rts
; ---------------------------------------------------------------------------

loc_BC24:
		move.l	a2,($FFFFD88C).w
		ori.b	#$10,($FFFFD87A).w
		rts
; ---------------------------------------------------------------------------

loc_BC30:
		movea.w	$24(a6),a5
		tst.b	5(a5)
		bmi.s	loc_BC44
		andi.w	#$FF7F,4(a6)
		bra.w	loc_BE26
; ---------------------------------------------------------------------------

loc_BC44:
		pea	(loc_BE26).l
		move.w	$26(a5),d7
		move.w	word_BC56(pc,d7.w),d7
		jmp	word_BC56(pc,d7.w)
; ---------------------------------------------------------------------------
word_BC56:	dc.w loc_BC8A-word_BC56
		dc.w loc_BCBC-word_BC56
		dc.w loc_BCBC-word_BC56
		dc.w loc_BCBC-word_BC56
		dc.w loc_BCBC-word_BC56
		dc.w loc_BCC4-word_BC56
		dc.w loc_BCC4-word_BC56
		dc.w loc_BCC4-word_BC56
		dc.w loc_BCC4-word_BC56
		dc.w loc_BCF0-word_BC56
		dc.w loc_BC8A-word_BC56
		dc.w loc_BC8A-word_BC56
		dc.w loc_BC8A-word_BC56
		dc.w loc_BDD6-word_BC56
		dc.w loc_BC8A-word_BC56
		dc.w loc_BCBC-word_BC56
		dc.w loc_BCBC-word_BC56
		dc.w loc_BCBC-word_BC56
		dc.w loc_BCBC-word_BC56
		dc.w loc_BCC4-word_BC56
		dc.w loc_BCC4-word_BC56
		dc.w loc_BCC4-word_BC56
		dc.w loc_BCC4-word_BC56
		dc.w loc_BDDE-word_BC56
		dc.w loc_BE16-word_BC56
		dc.w loc_BE1E-word_BC56
; ---------------------------------------------------------------------------

loc_BC8A:
		ori.w	#$80,4(a6)

sub_BC90:
		move.w	$2A(a6),d0
		addi.w	#$20,d0
		cmpi.w	#$500,d0
		bcs.s	loc_BCA0
		moveq	#0,d0

loc_BCA0:
		move.w	d0,$2A(a6)
		moveq	#0,d0
		move.b	$2A(a6),d0
		addi.w	#$76,d0				; "v"
		move.w	d0,$26(a6)
		moveq	#$FFFFFFDC,d0
		moveq	#$FFFFFFEE,d1
		bsr.w	sub_CA82
		rts
; ---------------------------------------------------------------------------

loc_BCBC:
		andi.w	#$FF7F,4(a6)
		rts
; ---------------------------------------------------------------------------

loc_BCC4:
		ori.w	#$80,4(a6)			; "�"
		move.w	#$67,$26(a6)			; "g"
		moveq	#$FFFFFFF0,d0
		moveq	#0,d1
		move.b	#0,$20(a6)
		tst.b	$28(a5)
		beq.s	loc_BCE6
		move.b	#$18,$20(a6)

loc_BCE6:
		move.b	$20(a5),d2
		bsr.w	loc_CA8A
		rts
; ---------------------------------------------------------------------------

loc_BCF0:
		ori.w	#$80,4(a6)			; "�"
		move.w	$18(a5),d0
		move.w	$1C(a5),d1
		jsr	(sub_42CE).w
		addi.w	#$10,d2
		andi.w	#$E0,d2				; "�"
		lsr.w	#2,d2
		move.w	word_BD36+4(pc,d2.w),d0
		move.b	$28(a5),d1
		andi.w	#$1E,d1
		add.w	d1,d0
		move.w	word_BD76(pc,d0.w),$26(a6)
		move.w	word_BD36(pc,d2.w),d0
		move.w	word_BD36+2(pc,d2.w),d1
		move.w	word_BD36+6(pc,d2.w),d2
		move.b	d2,$20(a6)
		bsr.w	loc_CA8A
		rts
; ---------------------------------------------------------------------------
word_BD36:	dc.w $FFDC
		dc.w $FFF8
		dc.w 0
		dc.w 0
		dc.w 7
		dc.w 7
		dc.w $48
		dc.w $18
		dc.w $FFF8
		dc.w $C
		dc.w $30
		dc.w $18
		dc.w $FFE1
		dc.w 7
		dc.w $18
		dc.w $18
		dc.w $FFDC
		dc.w $FFF8
		dc.w 0
		dc.w $18
		dc.w 7
		dc.w 7
		dc.w $48
		dc.w 0
		dc.w $FFF8
		dc.w $C
		dc.w $30
		dc.w 0
		dc.w $FFE1
		dc.w 7
		dc.w $18
		dc.w 0
word_BD76:	dc.w $54
		dc.w $55
		dc.w $56
		dc.w $57
		dc.w $54
		dc.w $55
		dc.w $56
		dc.w $57
		dc.w $54
		dc.w $55
		dc.w $56
		dc.w $57
		dc.w $58
		dc.w $59
		dc.w $5A
		dc.w $5B
		dc.w $58
		dc.w $59
		dc.w $5A
		dc.w $5B
		dc.w $58
		dc.w $59
		dc.w $5A
		dc.w $5B
		dc.w $5C
		dc.w $5D
		dc.w $5E
		dc.w $5F
		dc.w $5C
		dc.w $5D
		dc.w $5E
		dc.w $5F
		dc.w $5C
		dc.w $5D
		dc.w $5E
		dc.w $5F
		dc.w $60
		dc.w $61
		dc.w $62
		dc.w $63
		dc.w $60
		dc.w $61
		dc.w $62
		dc.w $63
		dc.w $60
		dc.w $61
		dc.w $62
		dc.w $63
; ---------------------------------------------------------------------------

loc_BDD6:
		andi.w	#$FF7F,4(a6)
		rts
; ---------------------------------------------------------------------------

loc_BDDE:
		ori.w	#$80,4(a6)			; "�"
		moveq	#0,d0
		move.b	$28(a5),d0
		add.w	d0,d0
		move.w	word_BDFC(pc,d0.w),$26(a6)
		moveq	#-$20,d0
		moveq	#-4,d1
		bsr.w	sub_CA82
		rts
; ---------------------------------------------------------------------------
word_BDFC:	dc.w $54
		dc.w $54
		dc.w $54
		dc.w $55
		dc.w $55
		dc.w $55
		dc.w $56
		dc.w $56
		dc.w $56
		dc.w $57
		dc.w $57
		dc.w $57
		dc.w $FFFF
; ---------------------------------------------------------------------------

loc_BE16:
		andi.w	#$FF7F,4(a6)
		rts
; ---------------------------------------------------------------------------

loc_BE1E:
		andi.w	#$FF7F,4(a6)
		rts
; ---------------------------------------------------------------------------

loc_BE26:

		tst.b	5(a6)
		bmi.s	loc_BE2E
		rts
; ---------------------------------------------------------------------------

loc_BE2E:
		move.w	$26(a6),d0
		add.w	d0,d0
		add.w	d0,d0
		lea	(PLCMAP_Tails_MainIndex).l,a0
		lea	(MAP_Tails).l,a1
		lea	(PLC_Tails).l,a2
		adda.w	(a0,d0.w),a1
		adda.w	2(a0,d0.w),a2
		move.l	a1,obMap(a6)
		tst.b	6(a5)
		bne.s	loc_BE66
		move.l	a2,($FFFFD894).w
		ori.b	#$40,($FFFFD87A).w		; "@"
		rts
; ---------------------------------------------------------------------------

loc_BE66:
		move.l	a2,($FFFFD898).w
		ori.b	#$80,($FFFFD87A).w
		rts

; =============== S U B	R O U T	I N E =======================================


sub_BE72:
		move.w	#0,($FFFFD866).w
		move.w	#4,($FFFFD868).w
		moveq	#4,d0
		jsr	(sub_1918).w
		bmi.s	loc_BE9C
		move.w	#$80,4(a0)			; "�"
		move.w	#$800,6(a0)
		move.w	#0,$20(a0)
		move.w	a0,($FFFFD862).w

loc_BE9C:
		moveq	#4,d0
		jsr	(sub_1918).w
		bmi.s	loc_BEE0
		move.w	#$80,4(a0)			; "�"
		move.w	#2,6(a0)
		move.w	($FFFFC9DE).w,d0
		addi.w	#$B8,d0				; "�"
		move.w	d0,8(a0)
		move.w	($FFFFC9EE).w,d0
		addi.w	#$70,d0				; "p"
		move.w	d0,$C(a0)
		move.w	#0,$20(a0)
		movea.w	($FFFFD862).w,a6
		move.w	a0,($FFFFD862).w
		move.w	a0,$24(a6)
		move.w	#$10,$32(a0)

loc_BEE0:
		moveq	#4,d0
		jsr	(sub_1918).w
		bmi.s	loc_BF00
		move.w	#$80,4(a0)			; "�"
		move.w	#$1000,6(a0)
		move.w	#0,$20(a0)
		move.w	($FFFFD862).w,$24(a0)

loc_BF00:
		moveq	#4,d0
		jsr	(sub_1918).w
		bmi.s	loc_BF1E
		move.w	#$80,4(a0)			; "�"
		move.w	#$C00,6(a0)
		move.w	#$21,$20(a0)			; "!"
		move.w	a0,($FFFFD864).w

loc_BF1E:
		moveq	#4,d0
		jsr	(sub_1918).w
		bmi.s	loc_BF62
		move.w	#$80,4(a0)			; "�"
		move.w	#$402,6(a0)
		move.w	($FFFFC9DE).w,d0
		addi.w	#$88,d0				; "�"
		move.w	d0,8(a0)
		move.w	($FFFFC9EE).w,d0
		addi.w	#$70,d0				; "p"
		move.w	d0,$C(a0)
		move.w	#$21,$20(a0)			; "!"
		movea.w	($FFFFD864).w,a6
		move.w	a0,($FFFFD864).w
		move.w	a0,$24(a6)
		move.w	#$10,$32(a0)

loc_BF62:
		moveq	#4,d0
		jsr	(sub_1918).w
		bmi.s	locret_BF82
		move.w	#$80,4(a0)			; "�"
		move.w	#$1400,6(a0)
		move.w	#$21,$20(a0)			; "!"
		move.w	($FFFFD864).w,$24(a0)

locret_BF82:
		rts
; End of function sub_BE72


; =============== S U B	R O U T	I N E =======================================


sub_BF84:
		jsr	(sub_1B3E).w
		moveq	#0,d5
		tst.b	d2
		bne.s	loc_BF90
		moveq	#0,d2

loc_BF90:
		btst	d3,($FFFFFAE8).w
		beq.s	loc_BFB4
		move.b	(a1),d5
		beq.s	loc_BFF8
		cmpi.b	#$10,d5
		beq.s	loc_BFB4
		btst	#$1B,d3
		bne.s	loc_BFF6
		move.w	d1,d6
		andi.w	#$F,d6
		sub.w	d6,d5
		neg.w	d5
		addq.w	#1,d5
		rts
; ---------------------------------------------------------------------------

loc_BFB4:
		addi.w	#$10,d1
		jsr	(sub_1B3E).w
		moveq	#0,d5
		tst.b	d2
		bne.s	loc_BFC4
		moveq	#0,d2

loc_BFC4:
		subi.w	#$10,d1
		btst	d3,($FFFFFAE8).w
		beq.s	loc_BFD6
		move.b	(a1),d5
		cmpi.b	#$10,d5
		bne.s	loc_BFDA

loc_BFD6:
		moveq	#$FFFFFF80,d5
		rts
; ---------------------------------------------------------------------------

loc_BFDA:
		btst	#$1B,d3
		beq.s	loc_BFE4
		moveq	#0,d5
		moveq	#0,d2

loc_BFE4:
		move.w	d1,d6
		andi.w	#$F,d6
		sub.w	d6,d5
		neg.w	d5
		bmi.s	loc_BFD6
		subi.w	#$F,d5
		rts
; ---------------------------------------------------------------------------

loc_BFF6:
		moveq	#0,d2

loc_BFF8:
		subi.w	#$10,d1
		move.w	d2,-(sp)
		move.l	d3,-(sp)
		jsr	(sub_1B3E).w
		moveq	#0,d5
		tst.b	d2
		bne.s	loc_C00C
		moveq	#0,d2

loc_C00C:
		move.l	(sp)+,d7
		move.w	(sp)+,d6
		addi.w	#$10,d1
		btst	d3,($FFFFFAE8).w
		beq.s	loc_C03A
		move.b	(a1),d5
		cmpi.b	#$10,d5
		beq.s	loc_C03A
		move.w	d1,d6
		andi.w	#$F,d6
		neg.w	d5
		addi.w	#$11,d5
		add.w	d6,d5
		cmpi.w	#$10,d5
		bls.s	locret_C038
		moveq	#$10,d5

locret_C038:
		rts
; ---------------------------------------------------------------------------

loc_C03A:
		move.w	d1,d5
		andi.w	#$F,d5
		addq.w	#1,d5
		move.w	d6,d2
		move.l	d7,d3
		rts
; End of function sub_BF84


; =============== S U B	R O U T	I N E =======================================


sub_C048:
		jsr	(sub_1B3E).w
		moveq	#0,d5
		tst.b	d2
		bne.s	loc_C054
		moveq	#$FFFFFFC0,d2

loc_C054:
		btst	d3,($FFFFFAE8).w
		beq.s	loc_C078
		move.b	(a2),d5
		beq.s	loc_C0C6
		cmpi.b	#$10,d5
		beq.s	loc_C078
		btst	#$1A,d3
		bne.s	loc_C0C4
		move.w	d0,d6
		andi.w	#$F,d6
		sub.w	d6,d5
		neg.w	d5
		addq.w	#1,d5
		rts
; ---------------------------------------------------------------------------

loc_C078:
		addi.w	#$10,d0
		jsr	(sub_1B3E).w
		moveq	#0,d5
		tst.b	d2
		bne.s	loc_C088
		moveq	#$FFFFFFC0,d2

loc_C088:
		subi.w	#$10,d0
		btst	d3,($FFFFFAE8).w
		beq.s	loc_C09A
		move.b	(a2),d5
		cmpi.b	#$10,d5
		bne.s	loc_C09E

loc_C09A:
		moveq	#$FFFFFF80,d5
		rts
; ---------------------------------------------------------------------------

loc_C09E:
		btst	#$1A,d3
		beq.s	loc_C0B2
		move.w	d0,d5
		andi.w	#$F,d5
		subi.w	#$F,d5
		moveq	#$FFFFFFC0,d2
		rts
; ---------------------------------------------------------------------------

loc_C0B2:
		move.w	d0,d6
		andi.w	#$F,d6
		sub.w	d6,d5
		neg.w	d5
		bmi.s	loc_C09A
		subi.w	#$F,d5
		rts
; ---------------------------------------------------------------------------

loc_C0C4:
		moveq	#$FFFFFFC0,d2

loc_C0C6:
		subi.w	#$10,d0
		move.w	d2,-(sp)
		move.l	d3,-(sp)
		jsr	(sub_1B3E).w
		moveq	#0,d5
		tst.b	d2
		bne.s	loc_C0DA
		moveq	#$FFFFFFC0,d2

loc_C0DA:
		move.l	(sp)+,d7
		move.w	(sp)+,d6
		addi.w	#$10,d0
		btst	d3,($FFFFFAE8).w
		beq.s	loc_C108
		move.b	(a2),d5
		cmpi.b	#$10,d5
		beq.s	loc_C108
		move.w	d0,d6
		andi.w	#$F,d6
		neg.w	d5
		addi.w	#$11,d5
		add.w	d6,d5
		cmpi.w	#$10,d5
		bls.s	locret_C106
		moveq	#$10,d5

locret_C106:
		rts
; ---------------------------------------------------------------------------

loc_C108:
		move.w	d0,d5
		andi.w	#$F,d5
		addq.w	#1,d5
		move.w	d6,d2
		move.l	d7,d3
		rts
; End of function sub_C048


; =============== S U B	R O U T	I N E =======================================


sub_C116:
		jsr	(sub_1B3E).w
		moveq	#0,d5
		tst.b	d2
		bne.s	loc_C122
		moveq	#$FFFFFF80,d2

loc_C122:
		btst	d3,($FFFFFAE8).w
		beq.s	loc_C146
		move.b	(a1),d5
		beq.s	loc_C188
		cmpi.b	#$10,d5
		beq.s	loc_C146
		btst	#$1B,d3
		beq.s	loc_C186
		move.w	d1,d6
		andi.w	#$F,d6
		subi.w	#$10,d6
		add.w	d6,d5
		rts
; ---------------------------------------------------------------------------

loc_C146:
		subi.w	#$10,d1
		jsr	(sub_1B3E).w
		moveq	#0,d5
		tst.b	d2
		bne.s	loc_C156
		moveq	#$FFFFFF80,d2

loc_C156:
		addi.w	#$10,d1
		btst	d3,($FFFFFAE8).w
		beq.s	loc_C168
		move.b	(a1),d5
		cmpi.b	#$10,d5
		bne.s	loc_C16C

loc_C168:
		moveq	#$7F,d5
		rts
; ---------------------------------------------------------------------------

loc_C16C:
		btst	#$1B,d3
		bne.s	loc_C17C
		move.w	d1,d5
		andi.w	#$F,d5
		moveq	#$FFFFFF80,d2
		rts
; ---------------------------------------------------------------------------

loc_C17C:
		move.w	d1,d6
		andi.w	#$F,d6
		add.w	d6,d5
		rts
; ---------------------------------------------------------------------------

loc_C186:
		moveq	#$FFFFFF80,d2

loc_C188:
		addi.w	#$10,d1
		move.w	d2,-(sp)
		move.l	d3,-(sp)
		jsr	(sub_1B3E).w
		moveq	#0,d5
		tst.b	d2
		bne.s	loc_C19C
		moveq	#$FFFFFF80,d2

loc_C19C:
		move.l	(sp)+,d7
		move.w	(sp)+,d6
		subi.w	#$10,d1
		btst	d3,($FFFFFAE8).w
		beq.s	loc_C1CA
		move.b	(a1),d5
		cmpi.b	#$10,d5
		beq.s	loc_C1CA
		move.w	d1,d6
		andi.w	#$F,d6
		subi.w	#$20,d6
		sub.w	d5,d6
		move.w	d6,d5
		cmpi.w	#$FFF0,d5
		bcc.s	locret_C1C8
		moveq	#$FFFFFFF0,d5

locret_C1C8:
		rts
; ---------------------------------------------------------------------------

loc_C1CA:
		move.w	d1,d5
		andi.w	#$F,d5
		subi.w	#$10,d5
		move.w	d6,d2
		move.l	d7,d3
		rts
; End of function sub_C116


; =============== S U B	R O U T	I N E =======================================


sub_C1DA:
		jsr	(sub_1B3E).w
		moveq	#0,d5
		tst.b	d2
		bne.s	loc_C1E6
		moveq	#$40,d2

loc_C1E6:
		btst	d3,($FFFFFAE8).w
		beq.s	loc_C20A
		move.b	(a2),d5
		beq.s	loc_C24C
		cmpi.b	#$10,d5
		beq.s	loc_C20A
		btst	#$1A,d3
		beq.s	loc_C24A
		move.w	d0,d6
		andi.w	#$F,d6
		subi.w	#$10,d6
		add.w	d6,d5
		rts
; ---------------------------------------------------------------------------

loc_C20A:
		subi.w	#$10,d0
		jsr	(sub_1B3E).w
		moveq	#0,d5
		tst.b	d2
		bne.s	loc_C21A
		moveq	#$40,d2

loc_C21A:
		addi.w	#$10,d0
		btst	d3,($FFFFFAE8).w
		beq.s	loc_C22C
		move.b	(a2),d5
		cmpi.b	#$10,d5
		bne.s	loc_C230

loc_C22C:
		moveq	#$7F,d5
		rts
; ---------------------------------------------------------------------------

loc_C230:
		btst	#$1A,d3
		bne.s	loc_C240
		move.w	d0,d5
		andi.w	#$F,d5
		moveq	#$40,d2
		rts
; ---------------------------------------------------------------------------

loc_C240:
		move.w	d0,d6
		andi.w	#$F,d6
		add.w	d6,d5
		rts
; ---------------------------------------------------------------------------

loc_C24A:
		moveq	#$40,d2

loc_C24C:
		addi.w	#$10,d0
		move.w	d2,-(sp)
		move.l	d3,-(sp)
		jsr	(sub_1B3E).w
		moveq	#0,d5
		tst.b	d2
		bne.s	loc_C260
		moveq	#$40,d2

loc_C260:
		move.l	(sp)+,d7
		move.w	(sp)+,d6
		subi.w	#$10,d0
		btst	d3,($FFFFFAE8).w
		beq.s	loc_C28E
		move.b	(a2),d5
		cmpi.b	#$10,d5
		beq.s	loc_C28E
		move.w	d0,d6
		andi.w	#$F,d6
		subi.w	#$20,d6
		sub.w	d5,d6
		move.w	d6,d5
		cmpi.w	#$FFF0,d5
		bcc.s	locret_C28C
		moveq	#$FFFFFFF0,d5

locret_C28C:
		rts
; ---------------------------------------------------------------------------

loc_C28E:
		move.w	d0,d5
		andi.w	#$F,d5
		subi.w	#$10,d5
		move.w	d6,d2
		move.l	d7,d3
		rts
; End of function sub_C1DA


; =============== S U B	R O U T	I N E =======================================


sub_C29E:
		move.w	$24(a6),d4
		andi.w	#2,d4
		move.b	#$A,($FFFFFAE8).w
		move.b	$2A(a6),d0
		addi.b	#$20,d0
		andi.w	#$C0,d0				; "�"
		lsr.w	#4,d0
		jmp	loc_C2BE(pc,d0.w)
; End of function sub_C29E

; ---------------------------------------------------------------------------

loc_C2BE:
		bra.w	loc_C2CE
; ---------------------------------------------------------------------------
		bra.w	loc_C340
; ---------------------------------------------------------------------------
		bra.w	loc_C3B4
; ---------------------------------------------------------------------------
		bra.w	loc_C428
; ---------------------------------------------------------------------------

loc_C2CE:
		moveq	#0,d0
		move.b	$22(a6),d0
		add.w	8(a6),d0
		moveq	#0,d1
		move.b	$23(a6),d1
		add.w	$C(a6),d1
		bsr.w	sub_BF84
		move.l	d3,-(sp)
		move.w	d2,-(sp)
		move.w	d5,-(sp)
		move.b	d2,($FFFFFAC5).w
		move.l	a0,($FFFFFACA).w
		moveq	#0,d2
		move.b	$22(a6),d2
		neg.w	d2
		add.w	d2,d0
		add.w	d2,d0
		bsr.w	sub_BF84
		move.b	d2,($FFFFFAC4).w
		move.l	a0,($FFFFFAC6).w
		move.w	d5,d0
		move.w	(sp)+,d1
		cmp.w	d1,d0
		bgt.s	loc_C326
		beq.s	loc_C334
		sub.w	d1,$C(a6)
		move.w	(sp)+,d2
		move.b	d2,$2A(a6)
		move.l	(sp)+,d3
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C326:
		sub.w	d0,$C(a6)
		move.b	d2,$2A(a6)
		addq.l	#6,sp
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C334:
		moveq	#0,d2
		cmpi.w	#$FF80,d0
		bne.s	loc_C326
		addq.l	#6,sp
		rts
; ---------------------------------------------------------------------------

loc_C340:
		moveq	#0,d0
		move.b	$22(a6),d0
		neg.w	d0
		add.w	8(a6),d0
		moveq	#0,d1
		move.b	$23(a6),d1
		add.w	$C(a6),d1
		bsr.w	sub_C1DA
		move.l	d3,-(sp)
		move.w	d2,-(sp)
		move.w	d5,-(sp)
		move.b	d2,($FFFFFAC5).w
		move.l	a0,($FFFFFACA).w
		moveq	#0,d2
		move.b	$23(a6),d2
		neg.w	d2
		add.w	d2,d1
		add.w	d2,d1
		bsr.w	sub_C1DA
		move.b	d2,($FFFFFAC4).w
		move.l	a0,($FFFFFAC6).w
		move.w	d5,d0
		move.w	(sp)+,d1
		cmp.w	d1,d0
		blt.s	loc_C39A
		beq.s	loc_C3A8
		sub.w	d1,8(a6)
		move.w	(sp)+,d2
		move.b	d2,$2A(a6)
		move.l	(sp)+,d3
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C39A:
		sub.w	d0,8(a6)
		move.b	d2,$2A(a6)
		addq.l	#6,sp
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C3A8:
		moveq	#$40,d2
		cmpi.w	#$7F,d0
		bne.s	loc_C39A
		addq.l	#6,sp
		rts
; ---------------------------------------------------------------------------

loc_C3B4:
		moveq	#0,d0
		move.b	$22(a6),d0
		neg.w	d0
		add.w	8(a6),d0
		moveq	#0,d1
		move.b	$23(a6),d1
		neg.w	d1
		add.w	$C(a6),d1
		bsr.w	sub_C116
		move.l	d3,-(sp)
		move.w	d2,-(sp)
		move.w	d5,-(sp)
		move.b	d2,($FFFFFAC5).w
		move.l	a0,($FFFFFACA).w
		moveq	#0,d2
		move.b	$22(a6),d2
		add.w	d2,d0
		add.w	d2,d0
		bsr.w	sub_C116
		move.b	d2,($FFFFFAC4).w
		move.l	a0,($FFFFFAC6).w
		move.w	d5,d0
		move.w	(sp)+,d1
		cmp.w	d1,d0
		blt.s	loc_C40E
		beq.s	loc_C41C
		sub.w	d1,$C(a6)
		move.w	(sp)+,d2
		move.b	d2,$2A(a6)
		move.l	(sp)+,d3
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C40E:
		sub.w	d0,$C(a6)
		move.b	d2,$2A(a6)
		addq.l	#6,sp
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C41C:
		moveq	#$FFFFFF80,d2
		cmpi.w	#$7F,d0
		bne.s	loc_C40E
		addq.l	#6,sp
		rts
; ---------------------------------------------------------------------------

loc_C428:
		moveq	#0,d0
		move.b	$22(a6),d0
		add.w	8(a6),d0
		moveq	#0,d1
		move.b	$23(a6),d1
		neg.w	d1
		add.w	$C(a6),d1
		bsr.w	sub_C048

loc_C442:
		move.l	d3,-(sp)
		move.w	d2,-(sp)
		move.w	d5,-(sp)
		move.b	d2,($FFFFFAC5).w
		move.l	a0,($FFFFFACA).w
		moveq	#0,d2
		move.b	$23(a6),d2
		add.w	d2,d1
		add.w	d2,d1
		bsr.w	sub_C048
		move.b	d2,($FFFFFAC4).w
		move.l	a0,($FFFFFAC6).w
		move.w	d5,d0
		move.w	(sp)+,d1
		cmp.w	d1,d0
		bgt.s	loc_C480
		beq.s	loc_C48E
		sub.w	d1,8(a6)
		move.w	(sp)+,d2
		move.b	d2,$2A(a6)
		move.l	(sp)+,d3
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C480:
		sub.w	d0,8(a6)
		move.b	d2,$2A(a6)
		addq.l	#6,sp
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C48E:
		moveq	#$FFFFFFC0,d2
		cmpi.w	#$FF80,d0
		bne.s	loc_C480
		addq.l	#6,sp
		rts

; =============== S U B	R O U T	I N E =======================================


sub_C49A:
		move.w	$24(a6),d4
		andi.w	#2,d4
		move.b	#8,($FFFFFAE8).w
		move.b	$2A(a6),d0
		addi.b	#$20,d0
		andi.w	#$40,d0
		lsr.w	#4,d0
		jmp	loc_C4BA(pc,d0.w)
; End of function sub_C49A

; ---------------------------------------------------------------------------

loc_C4BA:
		bra.w	loc_C4CA
; ---------------------------------------------------------------------------
		bra.w	loc_C524
; ---------------------------------------------------------------------------
		bra.w	loc_C580
; ---------------------------------------------------------------------------
		bra.w	loc_C5DC
; ---------------------------------------------------------------------------

loc_C4CA:
		moveq	#0,d0
		move.b	$22(a6),d0
		addq.w	#1,d0
		neg.w	d0
		add.w	8(a6),d0
		moveq	#0,d1
		move.b	$23(a6),d1
		add.w	$C(a6),d1
		subq.w	#8,d1
		bsr.w	sub_C1DA
		tst.w	d5
		bpl.s	loc_C4FC
		sub.w	d5,8(a6)
		clr.w	$2C(a6)
		clr.l	$18(a6)
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C4FC:
		moveq	#0,d0
		move.b	$22(a6),d0
		addq.w	#1,d0
		add.w	8(a6),d0
		bsr.w	sub_C048
		tst.w	d5
		bmi.s	loc_C520
		sub.w	d5,8(a6)
		clr.w	$2C(a6)
		clr.l	$18(a6)
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C520:
		moveq	#0,d5
		rts
; ---------------------------------------------------------------------------

loc_C524:
		moveq	#0,d0
		move.b	$22(a6),d0
		neg.w	d0
		add.w	8(a6),d0
		addq.w	#8,d0
		moveq	#0,d1
		move.b	$23(a6),d1
		addq.w	#1,d1
		neg.w	d1
		add.w	$C(a6),d1
		bsr.w	sub_C116
		tst.w	d5
		bpl.s	loc_C558
		sub.w	d5,$C(a6)
		clr.w	$2C(a6)
		clr.l	$1C(a6)
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C558:
		moveq	#0,d1
		move.b	$23(a6),d1
		addq.w	#1,d1
		add.w	$C(a6),d1
		bsr.w	sub_BF84
		tst.w	d5
		bmi.s	loc_C57C
		sub.w	d5,$C(a6)
		clr.w	$2C(a6)
		clr.l	$1C(a6)
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C57C:
		moveq	#0,d5
		rts
; ---------------------------------------------------------------------------

loc_C580:
		moveq	#0,d0
		move.b	$22(a6),d0
		addq.w	#1,d0
		neg.w	d0
		add.w	8(a6),d0
		moveq	#0,d1
		move.b	$23(a6),d1
		neg.w	d1
		add.w	$C(a6),d1
		addq.w	#8,d1
		bsr.w	sub_C1DA
		tst.w	d5
		bpl.s	loc_C5B4
		sub.w	d5,8(a6)
		clr.w	$2C(a6)
		clr.l	$18(a6)
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C5B4:
		moveq	#0,d0
		move.b	$22(a6),d0
		addq.w	#1,d0
		add.w	8(a6),d0
		bsr.w	sub_C048
		tst.w	d5
		bmi.s	loc_C5D8
		sub.w	d5,8(a6)
		clr.w	$2C(a6)
		clr.l	$18(a6)
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C5D8:
		moveq	#0,d5
		rts
; ---------------------------------------------------------------------------

loc_C5DC:
		moveq	#0,d0
		move.b	$22(a6),d0
		add.w	8(a6),d0
		subq.w	#8,d0
		moveq	#0,d1
		move.b	$23(a6),d1
		addq.w	#1,d1
		neg.w	d1
		add.w	$C(a6),d1
		bsr.w	sub_C116
		tst.w	d5
		bpl.s	loc_C60E
		sub.w	d5,$C(a6)
		clr.w	$2C(a6)
		clr.l	$1C(a6)
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C60E:
		moveq	#0,d1
		move.b	$23(a6),d1
		addq.w	#1,d1
		add.w	$C(a6),d1
		bsr.w	sub_BF84
		tst.w	d5
		bmi.s	loc_C632
		sub.w	d5,$C(a6)
		clr.w	$2C(a6)
		clr.l	$1C(a6)
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C632:
		moveq	#0,d5
		rts

; =============== S U B	R O U T	I N E =======================================


sub_C636:
		tst.l	$1C(a6)
		bpl.w	loc_C68A
		move.b	#8,($FFFFFAE8).w
		moveq	#0,d0
		move.b	$22(a6),d0
		neg.w	d0
		add.w	8(a6),d0
		moveq	#0,d1
		move.b	$23(a6),d1
		neg.w	d1
		add.w	$C(a6),d1
		bsr.w	sub_C116
		tst.w	d5
		bpl.s	loc_C66C
		sub.w	d5,$C(a6)
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C66C:
		moveq	#0,d0
		move.b	$22(a6),d0
		add.w	8(a6),d0
		bsr.w	sub_C116
		tst.w	d5
		bpl.s	loc_C686
		sub.w	d5,$C(a6)
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C686:
		moveq	#0,d5
		rts
; ---------------------------------------------------------------------------

loc_C68A:
		move.b	#$A,($FFFFFAE8).w
		moveq	#0,d0
		move.b	$22(a6),d0
		add.w	8(a6),d0
		moveq	#0,d1
		move.b	$23(a6),d1
		add.w	$C(a6),d1
		bsr.w	sub_BF84
		tst.w	d5
		bmi.s	loc_C6B4
		sub.w	d5,$C(a6)
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C6B4:
		moveq	#0,d0
		move.b	$22(a6),d0
		neg.w	d0
		add.w	8(a6),d0
		bsr.w	sub_BF84
		tst.w	d5
		bmi.s	loc_C6D0
		sub.w	d5,$C(a6)
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_C6D0:
		moveq	#0,d5
		rts
; End of function sub_C636


; =============== S U B	R O U T	I N E =======================================


sub_C6D4:
		move.l	$18(a6),d0
		bpl.s	loc_C6EC
		cmpi.l	#$FFF00000,d0
		bge.s	loc_C6FC
		move.l	#$FFF00000,$18(a6)
		bra.s	loc_C6FC
; ---------------------------------------------------------------------------

loc_C6EC:
		cmpi.l	#$100000,d0
		bcs.s	loc_C6FC
		move.l	#$100000,$18(a6)

loc_C6FC:
		move.l	$1C(a6),d0
		bpl.s	loc_C714
		cmpi.l	#$FFF00000,d0
		bge.s	loc_C724
		move.l	#$FFF00000,$1C(a6)
		rts
; ---------------------------------------------------------------------------

loc_C714:
		cmpi.l	#$100000,d0
		bcs.s	loc_C724
		move.l	#$100000,$1C(a6)

loc_C724:
		move.w	$2C(a6),d0
		bpl.s	loc_C738
		cmpi.w	#$F000,d0
		bge.s	locret_C744
		move.w	#$F000,$2C(a6)
		rts
; ---------------------------------------------------------------------------

loc_C738:
		cmpi.w	#$1000,d0
		bcs.s	locret_C744
		move.w	#$1000,$2C(a6)

locret_C744:
		rts
; End of function sub_C6D4

; ---------------------------------------------------------------------------

loc_C746:
		move.w	4(a6),d7
		ori.w	#$80,d7
		btst	#6,5(a6)
		beq.s	loc_C75A
		andi.w	#$FF7F,d7

loc_C75A:
		tst.w	$30(a6)
		beq.s	loc_C76C
		bmi.s	loc_C768
		subq.w	#1,$30(a6)
		bra.s	loc_C76C
; ---------------------------------------------------------------------------

loc_C768:
		clr.w	$30(a6)

loc_C76C:
		move.w	d7,4(a6)
		move.b	$25(a6),d0
		andi.b	#$80,d0
		move.b	$20(a6),d1
		andi.b	#$7F,d1
		or.b	d1,d0
		move.b	d0,$20(a6)
		tst.b	6(a6)
		bne.w	loc_C7BC
		cmpi.b	#$A,7(a6)
		beq.s	loc_C7BC
		move.w	($FFFFFAE0).w,d0
		cmpi.w	#$10,d0
		bcc.s	loc_C7BC
		movea.w	($FFFFD864).w,a0
		move.w	8(a6),d0
		sub.w	8(a0),d0
		smi	d0
		ext.w	d0
		ori.w	#1,d0
		add.w	d0,8(a6)
		sub.w	d0,8(a0)

loc_C7BC:
		bsr.w	sub_C6D4
		bsr.w	sub_C8CA
		tst.b	6(a6)
		bne.s	loc_C7D6
		lea	($FFFFD87C).w,a4
		moveq	#1,d2
		move.w	($FFFFD866).w,d0
		bra.s	loc_C7E0
; ---------------------------------------------------------------------------

loc_C7D6:
		lea	($FFFFD880).w,a4
		moveq	#2,d2
		move.w	($FFFFD868).w,d0

loc_C7E0:
		lea	off_C84A(pc,d0.w),a3
		movea.l	(a3),a0
		movea.l	$20(a3),a1
		movea.l	$40(a3),a2
		movea.l	$60(a3),a3
		move.w	$26(a6),d0			; load animation frame number?
		adda.w	(a0,d0.w),a0
		moveq	#0,d1
		move.b	$28(a6),d1
		move.b	3(a0,d1.w),d0
		cmp.b	1(a0),d1
		bls.s	loc_C818
		move.b	2(a0),d0
		move.b	d0,$28(a6)
		move.b	3(a0,d0.w),d0
		bra.s	loc_C82E
; ---------------------------------------------------------------------------

loc_C818:
		move.b	(a0),d1
		add.w	d1,$28(a6)
		move.b	$28(a6),d1
		cmp.b	1(a0),d1
		bls.s	loc_C832
		move.b	2(a0),$28(a6)

loc_C82E:
		clr.b	$29(a6)

loc_C832:
		add.w	d0,d0
		add.w	d0,d0
		adda.w	(a1,d0.w),a3
		adda.w	2(a1,d0.w),a2
		move.l	a2,(a4)
		or.b	d2,($FFFFD87A).w
		move.l	a3,obMap(a6)
		rts
; ---------------------------------------------------------------------------
off_C84A:	dc.l ANI_Sonic
		dc.l ANI_Tails
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l PLCMAP_Sonic_MainIndex
		dc.l PLCMAP_Tails_MainIndex
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l PLC_Sonic
		dc.l PLC_Tails
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l Map_Sonic
		dc.l MAP_Tails
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0

; =============== S U B	R O U T	I N E =======================================


sub_C8CA:
		tst.b	6(a6)
		bne.w	locret_C9DC
		disable_ints
		move.w	6(a6),d0
		move.w	($FFFFD81E).w,d1
		addi.w	#$C00,d1
		jsr	(sub_5090).l
		move.w	$24(a6),d0
		move.w	($FFFFD81E).w,d1
		addi.w	#$C08,d1
		jsr	(sub_5090).l
		move.w	$26(a6),d0
		move.w	($FFFFD81E).w,d1
		addi.w	#$C88,d1
		jsr	(sub_5090).l
		move.w	$28(a6),d0
		move.w	($FFFFD81E).w,d1
		addi.w	#$D08,d1
		jsr	(sub_5090).l
		moveq	#0,d0
		move.w	$2A(a6),d0
		move.w	($FFFFD81E).w,d1
		addi.w	#$C12,d1
		jsr	(sub_5090).l
		move.w	$2C(a6),d0
		move.w	($FFFFD81E).w,d1
		addi.w	#$C92,d1
		jsr	(sub_5090).l
		move.w	$2E(a6),d0
		move.w	($FFFFD81E).w,d1
		addi.w	#$D12,d1
		jsr	(sub_5090).l
		move.w	($FFFFFAC0).w,d0
		move.w	($FFFFD81E).w,d1
		addi.w	#$C9C,d1
		jsr	(sub_5090).l
		move.w	($FFFFFAC2).w,d0
		move.w	($FFFFD81E).w,d1
		addi.w	#$CA6,d1
		jsr	(sub_5090).l
		movea.l	($FFFFFAC6).w,a0
		move.w	(a0),d0
		move.w	($FFFFD81E).w,d1
		addi.w	#$D1C,d1
		jsr	(sub_5090).l
		movea.l	($FFFFFACA).w,a0
		move.w	(a0),d0
		move.w	($FFFFD81E).w,d1
		addi.w	#$D26,d1
		jsr	(sub_5090).l
		move.w	8(a6),d0
		move.w	($FFFFD81E).w,d1
		addi.w	#$C1C,d1
		jsr	(sub_5090).l
		move.w	$C(a6),d0
		move.w	($FFFFD81E).w,d1
		addi.w	#$C26,d1
		jsr	(sub_5090).l
		move.w	$30(a6),d0
		move.w	($FFFFD81E).w,d1
		addi.w	#$C30,d1
		jsr	(sub_5090).l
		enable_ints

locret_C9DC:
		rts
; End of function sub_C8CA


; =============== S U B	R O U T	I N E =======================================


sub_C9DE:
		lea	(vdp_control_port).l,a6
		stopZ80
		waitZ80
		move.w	#$8154,(a6)

loc_C9FA:
		move.b	($FFFFD87A).w,d3
		clr.b	($FFFFD87A).w
		lea	($FFFFD87C).w,a1

loc_CA06:
		lea	loc_CA2C(pc),a2
		moveq	#7,d4

loc_CA0C:
		lsr.w	#1,d3
		bcc.s	loc_CA16
		movea.l	(a1),a0
		move.w	(a2),d2
		bsr.s	sub_CA3C

loc_CA16:
		addq.w	#4,a1
		addq.w	#2,a2
		dbf	d4,loc_CA0C
		move.w	#$8164,(a6)
		startZ80
		rts
; End of function sub_C9DE

; ---------------------------------------------------------------------------
loc_CA2C:	dc.l $420
		dc.w 0
		dc.l $420
		dc.w 0
		dc.l $420

; =============== S U B	R O U T	I N E =======================================


sub_CA3C:
		move.l	#$94009300,d0
		move.b	(a0)+,d0
		swap	d0
		move.b	(a0)+,d0
		move.l	d0,(a6)
		move.w	(a0)+,d0
		swap	d0
		move.w	#$9600,d0
		move.b	(a0)+,d0
		move.l	d0,(a6)
		move.w	#$9500,d0
		move.b	(a0)+,d0
		swap	d0
		move.w	(a0)+,d0
		move.w	d0,d1
		add.w	d2,d0
		andi.w	#$3FFF,d0
		ori.w	#$4000,d0
		move.l	d0,(a6)
		rol.w	#2,d1
		andi.w	#3,d1
		ori.w	#$80,d1
		move.w	d1,-(sp)
		move.w	(sp)+,(a6)
		tst.w	(a0)+
		beq.s	sub_CA3C
		rts
; End of function sub_CA3C


; =============== S U B	R O U T	I N E =======================================


sub_CA82:
							; sub_B4EC+20p	...
		move.b	$20(a5),d2
		move.b	d2,$20(a6)

loc_CA8A:
		move.w	8(a5),d3
		btst	#3,d2
		bne.s	loc_CAB4
		add.w	d0,d3
		move.w	d3,8(a6)
		move.w	$C(a5),d3
		btst	#4,d2
		bne.s	loc_CAAC
		add.w	d1,d3
		move.w	d3,$C(a6)
		rts
; ---------------------------------------------------------------------------

loc_CAAC:
		sub.w	d1,d3
		move.w	d3,$C(a6)
		rts
; ---------------------------------------------------------------------------

loc_CAB4:
		sub.w	d0,d3
		move.w	d3,8(a6)
		move.w	$C(a5),d3
		btst	#4,d2
		bne.s	loc_CACC
		add.w	d1,d3
		move.w	d3,$C(a6)
		rts
; ---------------------------------------------------------------------------

loc_CACC:
		sub.w	d1,d3
		move.w	d3,$C(a6)
		rts
; End of function sub_CA82

; ---------------------------------------------------------------------------

loc_CAD4:
		movem.l	d0-d7,-(sp)
		jsr	(sub_EA3E).l
		cmp.w	8(a0),d0
		bne.s	loc_CAEA
		cmp.w	$C(a0),d1
		beq.s	loc_CB14

loc_CAEA:
		tst.w	-$20(sp)
		beq.s	loc_CB14
		move.w	d0,8(a0)
		move.w	d1,$C(a0)
		moveq	#0,d0
		move.w	d0,$2C(a0)
		move.l	d0,$18(a0)
		move.l	d0,$1C(a0)
		bset	#0,$25(a0)
		moveq	#-1,d0
		movem.l	(sp)+,d0-d7
		rts
; ---------------------------------------------------------------------------

loc_CB14:
		moveq	#0,d0
		movem.l	(sp)+,d0-d7
		rts

; =============== S U B	R O U T	I N E =======================================


loc_CB1C:
		move.l	d2,-(sp)
		move.l	$18(a0),d2
		add.l	d2,d0
		eor.l	d0,d2
		bpl.s	loc_CB2C
		eor.l	d0,d2
		sub.l	d2,d0

loc_CB2C:
		tst.l	d0
		bpl.s	loc_CB40
		cmpi.l	#$FFF00000,d0
		bge.s	loc_CB4E
		move.l	#$FFF00000,d0
		bra.s	loc_CB4E
; ---------------------------------------------------------------------------

loc_CB40:
		cmpi.l	#$100000,d0
		bcs.s	loc_CB4E
		move.l	#$100000,d0

loc_CB4E:
		move.l	d0,$18(a0)
		move.l	$1C(a0),d2
		add.l	d2,d1
		eor.l	d1,d2
		bpl.s	loc_CB60
		eor.l	d1,d2
		sub.l	d2,d1

loc_CB60:
		tst.l	d1
		bpl.s	loc_CB74
		cmpi.l	#$FFF00000,d1
		bge.s	loc_CB82
		move.l	#$FFF00000,d1
		bra.s	loc_CB82
; ---------------------------------------------------------------------------

loc_CB74:
		cmpi.l	#$100000,d1
		bcs.s	loc_CB82
		move.l	#$100000,d1

loc_CB82:
		move.l	d1,$1C(a0)
		move.b	#8,7(a0)
		move.l	(sp)+,d2
		rts
; End of function loc_CB1C


; =============== S U B	R O U T	I N E =======================================


loc_CB90:
		sub.w	d0,$32(a0)
		bclr	#0,$25(a0)
		move.b	#$10,7(a0)
		move.l	#$10000,$18(a0)
		move.l	#$FFFB0000,$1C(a0)
		movem.l	d0-a6,-(sp)
		movea.l	a0,a6
		bsr.w	sub_CC5C
		movem.l	(sp)+,d0-a6
		rts
; End of function loc_CB90


; =============== S U B	R O U T	I N E =======================================


sub_CBC0:
		move.l	$18(a6),d3
		move.l	$1C(a6),d4
		move.b	$2A(a6),d2
		btst	#3,$25(a6)
		beq.s	loc_CBD8
		addi.b	#-$80,d2

loc_CBD8:
		jsr	(sub_3F14).w
		move.w	$2C(a6),d2
		muls.w	d2,d0
		muls.w	d2,d1
		tst.w	d2
		beq.s	loc_CC0E
		asr.l	#6,d0
		asr.l	#6,d1
		add.l	d0,d3
		add.l	d1,d4
		move.l	d3,d2
		or.l	d4,d2
		beq.s	loc_CC0E
		move.b	$2B(a6),d2
		jsr	(sub_3F14).w
		move.w	$2E(a6),d2
		muls.w	d2,d0
		muls.w	d2,d1
		asr.l	#6,d0
		asr.l	#6,d1
		add.l	d0,d3
		add.l	d1,d4

loc_CC0E:
		tst.l	d3
		bpl.s	loc_CC22
		cmpi.l	#$FFF00000,d3
		bge.s	loc_CC30
		move.l	#$FFF00000,d3
		bra.s	loc_CC30
; ---------------------------------------------------------------------------

loc_CC22:
		cmpi.l	#$100000,d3
		bcs.s	loc_CC30
		move.l	#$100000,d3

loc_CC30:
		tst.l	d4
		bpl.s	loc_CC44
		cmpi.l	#$FFF00000,d4
		bge.s	loc_CC52
		move.l	#$FFF00000,d4
		bra.s	loc_CC52
; ---------------------------------------------------------------------------

loc_CC44:
		cmpi.l	#$100000,d4
		bcs.s	loc_CC52
		move.l	#$100000,d4

loc_CC52:
		add.l	d3,8(a6)
		add.l	d4,$C(a6)
		rts
; End of function sub_CBC0


; =============== S U B	R O U T	I N E =======================================


sub_CC5C:
		move.w	#$288,d6
		moveq	#$1F,d7

loc_CC62:
		moveq	#$C,d0
		jsr	(sub_1918).w
		bmi.s	locret_CCC8
		move.w	#$80,4(a0)			; "�"
		move.w	#$28,6(a0)
		move.w	#$28,6(a0)
		move.w	#$FF,$26(a0)
		move.w	8(a6),8(a0)
		move.w	$C(a6),$C(a0)
		move.w	d6,d2
		bmi.s	loc_CCB8
		jsr	(sub_3F14).w
		lsr.w	#8,d2
		ext.l	d0
		ext.l	d1
		asl.l	#2,d0
		asl.l	#2,d1
		asl.l	d2,d0
		asl.l	d2,d1
		move.l	d0,d3
		move.l	d1,d4
		addi.b	#$10,d6
		bcc.s	loc_CCB8
		subi.w	#$80,d6
		bcc.s	loc_CCB8
		move.w	#$288,d6

loc_CCB8:
		move.l	d4,$18(a0)
		move.l	d3,$1C(a0)
		neg.l	d4
		neg.w	d6
		dbf	d7,loc_CC62

locret_CCC8:
		rts
; End of function sub_CC5C


; =============== S U B	R O U T	I N E =======================================


sub_CCCA:
							; Field_PauseGame+110p ...
		movea.w	($FFFFD862).w,a0
		movea.w	($FFFFD864).w,a1
		move.w	8(a0),d0
		ext.l	d0
		move.w	8(a1),d1
		ext.l	d1
		add.l	d1,d0
		lsr.l	#1,d0
		subi.w	#$A0,d0				; "�"
		move.w	d0,($FFFFD830).w
		move.w	$C(a0),d0
		ext.l	d0
		move.w	$C(a1),d1
		ext.l	d1
		add.l	d1,d0
		lsr.l	#1,d0
		subi.w	#$70,d0				; "p"
		move.w	d0,($FFFFD832).w
		lea	loc_CFD0(pc),a2
		moveq	#0,d0
		move.w	d0,$2E(a0)
		move.w	d0,$2E(a1)
		move.w	8(a0),d1
		move.w	$C(a0),d2
		move.w	8(a1),d3
		move.w	$C(a1),d4
		jsr	(sub_41AA).w
		move.b	d0,$2B(a0)
		addi.b	#-$80,d0
		move.b	d0,$2B(a1)
		sub.w	d3,d1
		sub.w	d4,d2
		muls.w	d1,d1
		muls.w	d2,d2
		add.l	d2,d1
		move.l	d1,d0
		jsr	(word_42A0).w
		move.w	d0,($FFFFFAE0).w
		move.w	d0,d3
		sub.w	(a2),d3
		bmi.w	loc_CEF2
		cmp.w	2(a2),d3
		bcs.s	loc_CD80
		move.w	2(a2),d3
		move.b	$2B(a0),d2
		addi.b	#-$80,d2
		jsr	(sub_3F14).w
		move.w	(a2),d2
		add.w	2(a2),d2
		muls.w	d2,d0
		muls.w	d2,d1
		asl.l	#2,d0
		asl.l	#2,d1
		add.l	8(a1),d0
		add.l	$C(a1),d1
		move.l	d0,8(a0)
		move.l	d1,$C(a0)

loc_CD80:
		andi.w	#$FF,d3
		move.b	4(a2,d3.w),d3
		addq.w	#1,d3
		lsl.w	#3,d3
		move.b	$2B(a0),d2
		move.b	($FFFFD89E).w,d4
		andi.b	#$F,d4
		bne.w	loc_CE32
		btst	#0,$25(a0)
		bne.s	loc_CDBC
		jsr	(sub_3F14).w
		muls.w	d3,d0
		muls.w	d3,d1
		asr.l	#6,d0
		asr.l	#6,d1
		add.l	d0,$18(a0)
		add.l	d1,$1C(a0)
		bra.w	loc_CE36
; ---------------------------------------------------------------------------

loc_CDBC:
		sub.b	$2A(a0),d2
		cmpi.b	#$A0,d2
		bcs.w	loc_CE14
		cmpi.b	#$E0,d2
		bhi.w	loc_CE14
		move.b	#8,7(a0)
		move.b	$2A(a0),d2
		btst	#3,$25(a0)
		beq.s	loc_CDE6
		addi.b	#-$80,d2

loc_CDE6:
		jsr	(sub_3F14).w
		move.w	$2C(a0),d2
		muls.w	d2,d0
		muls.w	d2,d1
		move.l	d0,d4
		move.l	d1,d5
		move.b	$2B(a0),d2
		jsr	(sub_3F14).w
		muls.w	d3,d0
		muls.w	d3,d1
		add.l	d4,d0
		add.l	d5,d1
		asr.l	#6,d0
		asr.l	#6,d1
		move.l	d0,$18(a0)
		move.l	d1,$1C(a0)
		bra.s	loc_CE36
; ---------------------------------------------------------------------------

loc_CE14:
							; sub_CCCA+102j
		jsr	(sub_3F14).w
		muls.w	d3,d0
		lsl.l	#2,d0
		swap	d0
		btst	#3,$25(a0)
		beq.s	loc_CE2C
		sub.w	d0,$2C(a0)
		bra.s	loc_CE36
; ---------------------------------------------------------------------------

loc_CE2C:
		add.w	d0,$2C(a0)
		bra.s	loc_CE36
; ---------------------------------------------------------------------------

loc_CE32:
		move.w	d3,$2E(a0)

loc_CE36:
							; sub_CCCA+148j ...
		move.b	$2B(a1),d2
		tst.b	($FFFFD8AC).w
		bmi.s	loc_CE4E
		move.b	($FFFFD8AE).w,d4
		andi.b	#$F,d4
		bne.w	loc_CEEE
		bra.s	loc_CE5A
; ---------------------------------------------------------------------------

loc_CE4E:
		move.b	($FFFFD89E).w,d4
		andi.b	#$70,d4				; "p"
		bne.w	loc_CEEE

loc_CE5A:
		btst	#0,$25(a1)
		bne.s	loc_CE78
		jsr	(sub_3F14).w
		muls.w	d3,d0
		muls.w	d3,d1
		asr.l	#6,d0
		asr.l	#6,d1
		add.l	d0,$18(a1)
		add.l	d1,$1C(a1)
		bra.s	loc_CEF2
; ---------------------------------------------------------------------------

loc_CE78:
		sub.b	$2A(a1),d2
		cmpi.b	#$A0,d2
		bcs.w	loc_CED0
		cmpi.b	#$E0,d2
		bhi.w	loc_CED0
		move.b	#8,7(a1)
		move.b	$2A(a1),d2
		btst	#3,$25(a1)
		beq.s	loc_CEA2
		addi.b	#-$80,d2

loc_CEA2:
		jsr	(sub_3F14).w
		move.w	$2C(a1),d2
		muls.w	d2,d0
		muls.w	d2,d1
		move.l	d0,d4
		move.l	d1,d5
		move.b	$2B(a1),d2
		jsr	(sub_3F14).w
		muls.w	d3,d0
		muls.w	d3,d1
		add.l	d4,d0
		add.l	d5,d1
		asr.l	#6,d0
		asr.l	#6,d1
		move.l	d0,$18(a1)
		move.l	d1,$1C(a1)
		bra.s	loc_CEF2
; ---------------------------------------------------------------------------

loc_CED0:
							; sub_CCCA+1BEj
		jsr	(sub_3F14).w
		muls.w	d3,d0
		lsl.l	#2,d0
		swap	d0
		btst	#3,$25(a1)
		beq.s	loc_CEE8
		sub.w	d0,$2C(a1)
		bra.s	loc_CEF2
; ---------------------------------------------------------------------------

loc_CEE8:
		add.w	d0,$2C(a1)
		bra.s	loc_CEF2
; ---------------------------------------------------------------------------

loc_CEEE:
							; sub_CCCA+18Cj
		move.w	d3,$2E(a1)

loc_CEF2:
							; sub_CCCA+1ACj ...
		movea.w	($FFFFD854).w,a0
		movea.w	($FFFFD862).w,a1
		movea.w	($FFFFD864).w,a2
		move.l	8(a2),d1
		move.l	8(a1),d3
		sub.l	d1,d3
		asr.l	#3,d3
		move.l	$C(a2),d2
		move.l	$C(a1),d4
		sub.l	d2,d4
		asr.l	#3,d4
		btst	#0,($FFFFF001).w
		beq.s	loc_CF2A
		move.l	d3,d5
		move.l	d4,d6
		asr.l	#1,d5
		asr.l	#1,d6
		add.l	d5,d1
		add.l	d6,d2

loc_CF2A:
		addq.w	#2,$24(a0)
		move.w	$24(a0),d5
		lea	loc_CF90(pc),a3
		andi.w	#$1E,d5
		tst.w	(a3,d5.w)
		bpl.s	loc_CF46
		moveq	#0,d5
		move.w	d5,$24(a0)

loc_CF46:
		lea	($FFFFD854).w,a0

loc_CF4A:
							; sub_CCCA+2C2j
		move.w	(a0),d0
		beq.s	locret_CF8E
		movea.w	d0,a0
		move.l	d1,8(a0)
		move.l	d2,$C(a0)
		add.l	d3,d1
		add.l	d4,d2
		move.w	(a3,d5.w),d0
		btst	#0,($FFFFF001).w
		bne.s	loc_CF74
		tst.w	$20(a1)
		bpl.s	loc_CF7E
		ori.w	#$8000,d0
		bra.s	loc_CF7E
; ---------------------------------------------------------------------------

loc_CF74:
		tst.w	$20(a2)
		bpl.s	loc_CF7E
		ori.w	#$8000,d0

loc_CF7E:
							; sub_CCCA+2A8j ...
		move.w	d0,$20(a0)
		addq.w	#2,d5
		tst.w	(a3,d5.w)
		bpl.s	loc_CF4A
		moveq	#0,d5
		bra.s	loc_CF4A
; ---------------------------------------------------------------------------

locret_CF8E:
		rts
; End of function sub_CCCA

; ---------------------------------------------------------------------------
loc_CF90:	dc.w $5C2
		dc.w $5C2
		dc.w $5C6
		dc.w $5C6
		dc.w $5CA
		dc.w $5CA
		dc.w $5C6
		dc.w $5C6
		dc.w $5C2
		dc.w $5C2
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w $FFFF
		dc.w $FFFF
		dc.w $5C2
		dc.w $5C6
		dc.w $5CA
		dc.w $5CE
		dc.w $5D2
		dc.w $5CE
		dc.w $5CA
		dc.w $5C6
		dc.w $5C2
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w $FFFF
		dc.w $FFFF
		dc.w $FFFF
loc_CFD0:	dc.b   0
		dc.b $80
		dc.b   0
		dc.b $7F
		dc.b   0
		dc.b   2
		dc.b   4
		dc.b   6
		dc.b   8
		dc.b  $A
		dc.b  $C
		dc.b  $E
		dc.b $10
		dc.b $12
		dc.b $14
		dc.b $16
		dc.b $18
		dc.b $1A
		dc.b $1C
		dc.b $1E
		dc.b $20
		dc.b $22
		dc.b $24
		dc.b $26
		dc.b $28
		dc.b $2A
		dc.b $2C
		dc.b $2E
		dc.b $30
		dc.b $32
		dc.b $34
		dc.b $36
		dc.b $38
		dc.b $3A
		dc.b $3C
		dc.b $3E
		dc.b $40
		dc.b $42
		dc.b $44
		dc.b $46
		dc.b $48
		dc.b $4A
		dc.b $4C
		dc.b $4E
		dc.b $50
		dc.b $52
		dc.b $54
		dc.b $56
		dc.b $58
		dc.b $5A
		dc.b $5C
		dc.b $5E
		dc.b $60
		dc.b $62
		dc.b $64
		dc.b $66
		dc.b $68
		dc.b $6A
		dc.b $6C
		dc.b $6E
		dc.b $70
		dc.b $72
		dc.b $74
		dc.b $76
		dc.b $78
		dc.b $7A
		dc.b $7C
		dc.b $7E
		dc.b $80
		dc.b $82
		dc.b $84
		dc.b $86
		dc.b $88
		dc.b $8A
		dc.b $8C
		dc.b $8E
		dc.b $90
		dc.b $92
		dc.b $94
		dc.b $96
		dc.b $98
		dc.b $9A
		dc.b $9C
		dc.b $9E
		dc.b $A0
		dc.b $A2
		dc.b $A4
		dc.b $A6
		dc.b $A8
		dc.b $AA
		dc.b $AC
		dc.b $AE
		dc.b $B0
		dc.b $B2
		dc.b $B4
		dc.b $B6
		dc.b $B8
		dc.b $BA
		dc.b $BC
		dc.b $BE
		dc.b $C0
		dc.b $C2
		dc.b $C4
		dc.b $C6
		dc.b $C8
		dc.b $CA
		dc.b $CC
		dc.b $CE
		dc.b $D0
		dc.b $D2
		dc.b $D4
		dc.b $D6
		dc.b $D8
		dc.b $DA
		dc.b $DC
		dc.b $DE
		dc.b $E0
		dc.b $E2
		dc.b $E4
		dc.b $E6
		dc.b $E8
		dc.b $EA
		dc.b $EC
		dc.b $EE
		dc.b $F0
		dc.b $F2
		dc.b $F4
		dc.b $F6
		dc.b $F8
		dc.b $FA
		dc.b $FC
		dc.b $FE
		dc.b   0
		dc.b $80
		dc.b   0
		dc.b $7F
		dc.b   0
		dc.b   2
		dc.b   4
		dc.b   6
		dc.b   8
		dc.b  $A
		dc.b  $C
		dc.b  $E
		dc.b $10
		dc.b $12
		dc.b $14
		dc.b $16
		dc.b $18
		dc.b $1A
		dc.b $1C
		dc.b $1E
		dc.b $20
		dc.b $22
		dc.b $24
		dc.b $26
		dc.b $28
		dc.b $2A
		dc.b $2C
		dc.b $2E
		dc.b $30
		dc.b $32
		dc.b $34
		dc.b $36
		dc.b $38
		dc.b $3A
		dc.b $3C
		dc.b $3E
		dc.b $40
		dc.b $42
		dc.b $44
		dc.b $46
		dc.b $48
		dc.b $4A
		dc.b $4C
		dc.b $4E
		dc.b $50
		dc.b $52
		dc.b $54
		dc.b $56
		dc.b $58
		dc.b $5A
		dc.b $5C
		dc.b $5E
		dc.b $60
		dc.b $62
		dc.b $64
		dc.b $66
		dc.b $68
		dc.b $6A
		dc.b $6C
		dc.b $6E
		dc.b $70
		dc.b $72
		dc.b $74
		dc.b $76
		dc.b $78
		dc.b $7A
		dc.b $7C
		dc.b $7E
		dc.b $80
		dc.b $82
		dc.b $84
		dc.b $86
		dc.b $88
		dc.b $8A
		dc.b $8C
		dc.b $8E
		dc.b $90
		dc.b $92
		dc.b $94
		dc.b $96
		dc.b $98
		dc.b $9A
		dc.b $9C
		dc.b $9E
		dc.b $A0
		dc.b $A2
		dc.b $A4
		dc.b $A6
		dc.b $A8
		dc.b $AA
		dc.b $AC
		dc.b $AE
		dc.b $B0
		dc.b $B2
		dc.b $B4
		dc.b $B6
		dc.b $B8
		dc.b $BA
		dc.b $BC
		dc.b $BE
		dc.b $C0
		dc.b $C2
		dc.b $C4
		dc.b $C6
		dc.b $C8
		dc.b $CA
		dc.b $CC
		dc.b $CE
		dc.b $D0
		dc.b $D2
		dc.b $D4
		dc.b $D6
		dc.b $D8
		dc.b $DA
		dc.b $DC
		dc.b $DE
		dc.b $E0
		dc.b $E2
		dc.b $E4
		dc.b $E6
		dc.b $E8
		dc.b $EA
		dc.b $EC
		dc.b $EE
		dc.b $F0
		dc.b $F2
		dc.b $F4
		dc.b $F6
		dc.b $F8
		dc.b $FA
		dc.b $FC
		dc.b $FE
		dc.b   0
		dc.b $80
		dc.b   0
		dc.b $7F
		dc.b   0
		dc.b   2
		dc.b   4
		dc.b   6
		dc.b   8
		dc.b  $A
		dc.b  $C
		dc.b  $E
		dc.b $10
		dc.b $12
		dc.b $14
		dc.b $16
		dc.b $18
		dc.b $1A
		dc.b $1C
		dc.b $1E
		dc.b $20
		dc.b $22
		dc.b $24
		dc.b $26
		dc.b $28
		dc.b $2A
		dc.b $2C
		dc.b $2E
		dc.b $30
		dc.b $32
		dc.b $34
		dc.b $36
		dc.b $38
		dc.b $3A
		dc.b $3C
		dc.b $3E
		dc.b $40
		dc.b $42
		dc.b $44
		dc.b $46
		dc.b $48
		dc.b $4A
		dc.b $4C
		dc.b $4E
		dc.b $50
		dc.b $52
		dc.b $54
		dc.b $56
		dc.b $58
		dc.b $5A
		dc.b $5C
		dc.b $5E
		dc.b $60
		dc.b $62
		dc.b $64
		dc.b $66
		dc.b $68
		dc.b $6A
		dc.b $6C
		dc.b $6E
		dc.b $70
		dc.b $72
		dc.b $74
		dc.b $76
		dc.b $78
		dc.b $7A
		dc.b $7C
		dc.b $7E
		dc.b $80
		dc.b $82
		dc.b $84
		dc.b $86
		dc.b $88
		dc.b $8A
		dc.b $8C
		dc.b $8E
		dc.b $90
		dc.b $92
		dc.b $94
		dc.b $96
		dc.b $98
		dc.b $9A
		dc.b $9C
		dc.b $9E
		dc.b $A0
		dc.b $A2
		dc.b $A4
		dc.b $A6
		dc.b $A8
		dc.b $AA
		dc.b $AC
		dc.b $AE
		dc.b $B0
		dc.b $B2
		dc.b $B4
		dc.b $B6
		dc.b $B8
		dc.b $BA
		dc.b $BC
		dc.b $BE
		dc.b $C0
		dc.b $C2
		dc.b $C4
		dc.b $C6
		dc.b $C8
		dc.b $CA
		dc.b $CC
		dc.b $CE
		dc.b $D0
		dc.b $D2
		dc.b $D4
		dc.b $D6
		dc.b $D8
		dc.b $DA
		dc.b $DC
		dc.b $DE
		dc.b $E0
		dc.b $E2
		dc.b $E4
		dc.b $E6
		dc.b $E8
		dc.b $EA
		dc.b $EC
		dc.b $EE
		dc.b $F0
		dc.b $F2
		dc.b $F4
		dc.b $F6
		dc.b $F8
		dc.b $FA
		dc.b $FC
		dc.b $FE
		dc.b   0
		dc.b $80
		dc.b   0
		dc.b $7F
		dc.b   0
		dc.b   2
		dc.b   4
		dc.b   6
unk_D164:	dc.b   8
		dc.b  $A
		dc.b  $C
		dc.b  $E
		dc.b $10
		dc.b $12
		dc.b $14
		dc.b $16
		dc.b $18
		dc.b $1A
		dc.b $1C
		dc.b $1E
		dc.b $20
		dc.b $22
		dc.b $24
		dc.b $26
		dc.b $28
		dc.b $2A
		dc.b $2C
		dc.b $2E
		dc.b $30
		dc.b $32
		dc.b $34
		dc.b $36
		dc.b $38
		dc.b $3A
		dc.b $3C
		dc.b $3E
		dc.b $40
		dc.b $42
		dc.b $44
		dc.b $46
unk_D184:	dc.b $48
		dc.b $4A
		dc.b $4C
		dc.b $4E
		dc.b $50
		dc.b $52
		dc.b $54
		dc.b $56
		dc.b $58
		dc.b $5A
		dc.b $5C
		dc.b $5E
		dc.b $60
		dc.b $62
		dc.b $64
		dc.b $66
		dc.b $68
		dc.b $6A
		dc.b $6C
		dc.b $6E
		dc.b $70
		dc.b $72
		dc.b $74
		dc.b $76
		dc.b $78
		dc.b $7A
		dc.b $7C
		dc.b $7E
		dc.b $80
		dc.b $82
		dc.b $84
		dc.b $86
		dc.b $88
		dc.b $8A
		dc.b $8C
		dc.b $8E
		dc.b $90
		dc.b $92
		dc.b $94
		dc.b $96
		dc.b $98
		dc.b $9A
		dc.b $9C
		dc.b $9E
		dc.b $A0
		dc.b $A2
		dc.b $A4
		dc.b $A6
		dc.b $A8
		dc.b $AA
		dc.b $AC
		dc.b $AE
		dc.b $B0
		dc.b $B2
		dc.b $B4
		dc.b $B6
		dc.b $B8
		dc.b $BA
		dc.b $BC
		dc.b $BE
		dc.b $C0
		dc.b $C2
		dc.b $C4
		dc.b $C6
		dc.b $C8
		dc.b $CA
		dc.b $CC
		dc.b $CE
		dc.b $D0
		dc.b $D2
		dc.b $D4
		dc.b $D6
		dc.b $D8
		dc.b $DA
		dc.b $DC
		dc.b $DE
		dc.b $E0
		dc.b $E2
		dc.b $E4
		dc.b $E6
		dc.b $E8
		dc.b $EA
		dc.b $EC
		dc.b $EE
		dc.b $F0
		dc.b $F2
		dc.b $F4
		dc.b $F6
		dc.b $F8
		dc.b $FA
		dc.b $FC
		dc.b $FE

; =============== S U B	R O U T	I N E =======================================
; star tether

sub_D1E0:
		moveq	#7,d7

loc_D1E2:
		moveq	#8,d0
		jsr	(sub_1918).w
		bmi.s	locret_D202
		move.w	#$80,4(a0)			; "�"
		move.w	#$800,6(a0)
		move.l	#TethCodingValue,$10(a0)
		dbf	d7,loc_D1E2

locret_D202:
		rts
; End of function sub_D1E0

; ---------------------------------------------------------------------------
; this is the data that sets correct position and art for the tether stars

TethCodingValue:
		dc.w $00FC
		dc.w $0000
		dc.w $FCFF

; =============== S U B	R O U T	I N E =======================================


sub_D20A:
		lea	($FFFFD858).w,a6

loc_D20E:
		_move.w	0(a6),d0
		bne.s	loc_D216
		rts
; ---------------------------------------------------------------------------

loc_D216:
		movea.w	d0,a6
		moveq	#0,d0
		move.w	6(a6),d0
		jsr	loc_D224(pc,d0.w)
		bra.s	loc_D20E
; End of function sub_D20A

; ---------------------------------------------------------------------------

loc_D224:
		bra.w	loc_D2A8
		bra.w	loc_D394
		bra.w	loc_D484
		bra.w	loc_D574
		bra.w	locret_EBAC
		bra.w	loc_D660
		bra.w	loc_D770
		bra.w	loc_D884
		bra.w	loc_D990
		bra.w	locret_E2BC
		bra.w	loc_E2BE
		bra.w	locret_E352
		bra.w	locret_E354
		bra.w	loc_DAA0
		bra.w	loc_DB8C
		bra.w	loc_DC7C
		bra.w	loc_DD6C
		bra.w	loc_DE58
		bra.w	loc_DF68
		bra.w	loc_E07C
		bra.w	loc_E188
		bra.w	loc_E4FE
		bra.w	loc_E5A6
		bra.w	loc_E64E
		bra.w	loc_E6F6
		bra.w	loc_E79E
		bra.w	loc_E846
		bra.w	loc_E8EE
		bra.w	loc_E996
		bra.w	loc_E356
		bra.w	loc_E45A
		bra.w	locret_E4FA
		bra.w	locret_E4FC
; ---------------------------------------------------------------------------

loc_D2A8:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_D2D6
		move.l	#Map_SpringLR,obMap(a6)
		move.w	#$407,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#8,$22(a6)
		move.b	#$10,$23(a6)
		move.w	#0,$2A(a6)

loc_D2D6:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_D31C
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#0,d4
		beq.s	loc_D308
		cmpi.w	#2,d4
		beq.s	loc_D308
		bra.s	loc_D31C
; ---------------------------------------------------------------------------

loc_D308:
		ori.w	#1,$2A(a6)
		move.l	#$F0000,d0
		moveq	#0,d1
		jsr	(loc_CB1C).l

loc_D31C:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_D362
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#0,d4
		beq.s	loc_D34E
		cmpi.w	#2,d4
		beq.s	loc_D34E
		bra.s	loc_D362
; ---------------------------------------------------------------------------

loc_D34E:
		ori.w	#1,$2A(a6)
		move.l	#$F0000,d0
		moveq	#0,d1
		jsr	(loc_CB1C).l

loc_D362:
		move.w	$2A(a6),d0
		btst	#0,d0
		beq.s	loc_D388
		lea	(unk_42358).l,a0
		lea	(word_E298).l,a1
		bsr.w	sub_EB22
		cmpi.b	#$FF,d0
		bne.s	loc_D388
		andi.w	#$FFFE,$2A(a6)

loc_D388:
		bsr.w	loc_F2D0
		bcc.s	locret_D392
		bsr.w	sub_F286

locret_D392:
		rts
; ---------------------------------------------------------------------------

loc_D394:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_D3C2
		move.l	#Map_SpringLR,obMap(a6)
		move.w	#$C07,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#8,$22(a6)
		move.b	#$10,$23(a6)
		move.w	#0,$2A(a6)

loc_D3C2:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_D40A
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#1,d4
		beq.s	loc_D3F4
		cmpi.w	#3,d4
		beq.s	loc_D3F4
		bra.s	loc_D40A
; ---------------------------------------------------------------------------

loc_D3F4:
		ori.w	#1,$2A(a6)
		move.l	#$F0000,d0
		neg.l	d0
		moveq	#0,d1
		jsr	(loc_CB1C).l

loc_D40A:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_D452
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#1,d4
		beq.s	loc_D43C
		cmpi.w	#3,d4
		beq.s	loc_D43C
		bra.s	loc_D452
; ---------------------------------------------------------------------------

loc_D43C:
		ori.w	#1,$2A(a6)
		move.l	#$F0000,d0
		neg.l	d0
		moveq	#0,d1
		jsr	(loc_CB1C).l

loc_D452:
		move.w	$2A(a6),d0
		btst	#0,d0
		beq.s	loc_D478
		lea	(unk_42358).l,a0
		lea	(word_E298).l,a1
		bsr.w	sub_EB22
		cmpi.w	#$FF,d0
		bne.s	loc_D478
		andi.w	#$FFFE,$2A(a6)

loc_D478:
		bsr.w	loc_F2D0
		bcc.s	locret_D482
		bsr.w	sub_F286

locret_D482:
		rts
; ---------------------------------------------------------------------------

loc_D484:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_D4B2
		move.l	#Map_SpringUp,obMap(a6)
		move.w	#$407,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$10,$22(a6)
		move.b	#8,$23(a6)
		move.w	#0,$2A(a6)

loc_D4B2:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_D4FA
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#7,d4
		beq.s	loc_D4E4
		cmpi.w	#6,d4
		beq.s	loc_D4E4
		bra.s	loc_D4FA
; ---------------------------------------------------------------------------

loc_D4E4:
		ori.w	#1,$2A(a6)
		move.l	#$F0000,d1
		neg.l	d1
		moveq	#0,d0
		jsr	(loc_CB1C).l

loc_D4FA:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_D542
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#7,d4
		beq.s	loc_D52C
		cmpi.w	#6,d4
		beq.s	loc_D52C
		bra.s	loc_D542
; ---------------------------------------------------------------------------

loc_D52C:
		ori.w	#1,$2A(a6)
		move.l	#$F0000,d1
		neg.l	d1
		moveq	#0,d0
		jsr	(loc_CB1C).l

loc_D542:
		move.w	$2A(a6),d0
		btst	#0,d0
		beq.s	loc_D568
		lea	(unk_4235E).l,a0
		lea	(word_E2A4).l,a1
		bsr.w	sub_EB22
		cmpi.b	#$FF,d0
		bne.s	loc_D568
		andi.w	#$FFFE,$2A(a6)

loc_D568:
		bsr.w	loc_F2D0
		bcc.s	locret_D572
		bsr.w	sub_F286

locret_D572:
		rts
; ---------------------------------------------------------------------------

loc_D574:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_D5A2
		move.l	#Map_SpringUp,obMap(a6)
		move.w	#$1407,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$10,$22(a6)
		move.b	#8,$23(a6)
		move.w	#0,$2A(a6)

loc_D5A2:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_D5E8
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#4,d4
		beq.s	loc_D5D4
		cmpi.w	#5,d4
		beq.s	loc_D5D4
		bra.s	loc_D5E8
; ---------------------------------------------------------------------------

loc_D5D4:
		ori.w	#1,$2A(a6)
		move.l	#$F0000,d1
		moveq	#0,d0
		jsr	(loc_CB1C).l

loc_D5E8:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_D62E
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#5,d4
		beq.s	loc_D61A
		cmpi.w	#4,d4
		beq.s	loc_D61A
		bra.s	loc_D62E
; ---------------------------------------------------------------------------
loc_D61A:
		ori.w	#1,$2A(a6)
		move.l	#$F0000,d1
		moveq	#0,d0
		jsr	(loc_CB1C).l

loc_D62E:
		move.w	$2A(a6),d0
		btst	#0,d0
		beq.s	loc_D654
		lea	(unk_4235E).l,a0
		lea	(word_E2A4).l,a1
		bsr.w	sub_EB22
		cmpi.b	#$FF,d0
		bne.s	loc_D654
		andi.w	#$FFFE,$2A(a6)

loc_D654:
		bsr.w	loc_F2D0
		bcc.s	locret_D65E
		bsr.w	sub_F286

locret_D65E:
		rts
; ---------------------------------------------------------------------------

loc_D660:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_D68E
		move.l	#Map_SpringAngUp,obMap(a6)
		move.w	#$407,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$C,$22(a6)
		move.b	#$C,$23(a6)
		move.w	#0,$2A(a6)

loc_D68E:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_D6E6
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#2,d4
		beq.s	loc_D6CC
		cmpi.w	#6,d4
		beq.s	loc_D6CC
		cmpi.w	#7,d4
		beq.s	loc_D6CC
		cmpi.w	#0,d4
		beq.s	loc_D6CC
		bra.s	loc_D6E6
; ---------------------------------------------------------------------------

loc_D6CC:
		ori.w	#1,$2A(a6)
		move.l	#$A8F98,d0
		move.l	#$A8F98,d1
		neg.l	d1
		jsr	(loc_CB1C).l

loc_D6E6:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_D73E
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#2,d4
		beq.s	loc_D724
		cmpi.w	#6,d4
		beq.s	loc_D724
		cmpi.w	#7,d4
		beq.s	loc_D724
		cmpi.w	#0,d4
		beq.s	loc_D724
		bra.s	loc_D73E
; ---------------------------------------------------------------------------

loc_D724:
		ori.w	#1,$2A(a6)
		move.l	#$A8F98,d0
		move.l	#$A8F98,d1
		neg.l	d1
		jsr	(loc_CB1C).l

loc_D73E:
		move.w	$2A(a6),d0
		btst	#0,d0
		beq.s	loc_D764
		lea	(unk_42364).l,a0
		lea	(word_E2B0).l,a1
		bsr.w	sub_EB22
		cmpi.b	#$FF,d0
		bne.s	loc_D764
		andi.w	#$FFFE,$2A(a6)

loc_D764:
		bsr.w	loc_F2D0
		bcc.s	locret_D76E
		bsr.w	sub_F286

locret_D76E:
		rts
; ---------------------------------------------------------------------------

loc_D770:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_D79E
		move.l	#Map_SpringAngUp,obMap(a6)
		move.w	#$C07,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$C,$22(a6)
		move.b	#$C,$23(a6)
		move.w	#0,$2A(a6)

loc_D79E:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_D7F8
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#3,d4
		beq.s	loc_D7DC
		cmpi.w	#7,d4
		beq.s	loc_D7DC
		cmpi.w	#6,d4
		beq.s	loc_D7DC
		cmpi.w	#1,d4
		beq.s	loc_D7DC
		bra.s	loc_D7F8
; ---------------------------------------------------------------------------

loc_D7DC:
		ori.w	#1,$2A(a6)
		move.l	#$A8F98,d0
		move.l	#$A8F98,d1
		neg.l	d0
		neg.l	d1
		jsr	(loc_CB1C).l

loc_D7F8:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_D852
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#3,d4
		beq.s	loc_D836
		cmpi.w	#7,d4
		beq.s	loc_D836
		cmpi.w	#6,d4
		beq.s	loc_D836
		cmpi.w	#1,d4
		beq.s	loc_D836
		bra.s	loc_D852
; ---------------------------------------------------------------------------

loc_D836:
		ori.w	#1,$2A(a6)
		move.l	#$A8F98,d0
		move.l	#$A8F98,d1
		neg.l	d0
		neg.l	d1
		jsr	(loc_CB1C).l

loc_D852:
		move.w	$2A(a6),d0
		btst	#0,d0
		beq.s	loc_D878
		lea	(unk_42364).l,a0
		lea	(word_E2B0).l,a1
		bsr.w	sub_EB22
		cmpi.b	#$FF,d0
		bne.s	loc_D878
		andi.w	#$FFFE,$2A(a6)

loc_D878:
		bsr.w	loc_F2D0
		bcc.s	locret_D882
		bsr.w	sub_F286

locret_D882:
		rts
; ---------------------------------------------------------------------------

loc_D884:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_D8B2
		move.l	#Map_SpringAngUp,obMap(a6)
		move.w	#$1407,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$C,$22(a6)
		move.b	#$C,$23(a6)
		move.w	#0,$2A(a6)

loc_D8B2:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_D908
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#0,d4
		beq.s	loc_D8F0
		cmpi.w	#4,d4
		beq.s	loc_D8F0
		cmpi.w	#2,d4
		beq.s	loc_D8F0
		cmpi.w	#5,d4
		beq.s	loc_D8F0
		bra.s	loc_D908
; ---------------------------------------------------------------------------

loc_D8F0:
		ori.w	#1,$2A(a6)
		move.l	#$A8F98,d0
		move.l	#$A8F98,d1
		jsr	(loc_CB1C).l

loc_D908:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_D95E
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#0,d4
		beq.s	loc_D946
		cmpi.w	#4,d4
		beq.s	loc_D946
		cmpi.w	#2,d4
		beq.s	loc_D946
		cmpi.w	#5,d4
		beq.s	loc_D946
		bra.s	loc_D95E
; ---------------------------------------------------------------------------

loc_D946:
		ori.w	#1,$2A(a6)
		move.l	#$A8F98,d0
		move.l	#$A8F98,d1
		jsr	(loc_CB1C).l

loc_D95E:
		move.w	$2A(a6),d0
		btst	#0,d0
		beq.s	loc_D984
		lea	(unk_42364).l,a0
		lea	(word_E2B0).l,a1
		bsr.w	sub_EB22
		cmpi.b	#$FF,d0
		bne.s	loc_D984
		andi.w	#$FFFE,$2A(a6)

loc_D984:
		bsr.w	loc_F2D0
		bcc.s	locret_D98E
		bsr.w	sub_F286

locret_D98E:
		rts
; ---------------------------------------------------------------------------

loc_D990:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_D9BE
		move.l	#Map_SpringAngUp,obMap(a6)
		move.w	#$1C07,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$C,$22(a6)
		move.b	#$C,$23(a6)
		move.w	#0,$2A(a6)

loc_D9BE:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_DA16
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#1,d4
		beq.s	loc_D9FC
		cmpi.w	#5,d4
		beq.s	loc_D9FC
		cmpi.w	#3,d4
		beq.s	loc_D9FC
		cmpi.w	#4,d4
		beq.s	loc_D9FC
		bra.s	loc_DA16
; ---------------------------------------------------------------------------

loc_D9FC:
		ori.w	#1,$2A(a6)
		move.l	#$A8F98,d0
		move.l	#$A8F98,d1
		neg.l	d0
		jsr	(loc_CB1C).l

loc_DA16:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_DA6E
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#1,d4
		beq.s	loc_DA54
		cmpi.w	#5,d4
		beq.s	loc_DA54
		cmpi.w	#3,d4
		beq.s	loc_DA54
		cmpi.w	#4,d4
		beq.s	loc_DA54
		bra.s	loc_DA6E
; ---------------------------------------------------------------------------

loc_DA54:
		ori.w	#1,$2A(a6)
		move.l	#$A8F98,d0
		move.l	#$A8F98,d1
		neg.l	d0
		jsr	(loc_CB1C).l

loc_DA6E:
		move.w	$2A(a6),d0
		btst	#0,d0
		beq.s	loc_DA94
		lea	(unk_42364).l,a0
		lea	(word_E2B0).l,a1
		bsr.w	sub_EB22
		cmpi.b	#$FF,d0
		bne.s	loc_DA94
		andi.w	#$FFFE,$2A(a6)

loc_DA94:
		bsr.w	loc_F2D0
		bcc.s	locret_DA9E
		bsr.w	sub_F286

locret_DA9E:
		rts
; ---------------------------------------------------------------------------

loc_DAA0:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_DACE
		move.l	#Map_SpringLR,obMap(a6)
		move.w	#$2407,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#8,$22(a6)
		move.b	#$10,$23(a6)
		move.w	#0,$2A(a6)

loc_DACE:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_DB14
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#0,d4
		beq.s	loc_DB00
		cmpi.w	#2,d4
		beq.s	loc_DB00
		bra.s	loc_DB14
; ---------------------------------------------------------------------------

loc_DB00:
		ori.w	#1,$2A(a6)
		move.l	#ARTUNC_Tails,d0
		moveq	#0,d1
		jsr	(loc_CB1C).l

loc_DB14:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_DB5A
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#0,d4
		beq.s	loc_DB46
		cmpi.w	#2,d4
		beq.s	loc_DB46
		bra.s	loc_DB5A
; ---------------------------------------------------------------------------

loc_DB46:
		ori.w	#1,$2A(a6)
		move.l	#ARTUNC_Tails,d0
		moveq	#0,d1
		jsr	(loc_CB1C).l

loc_DB5A:
		move.w	$2A(a6),d0
		btst	#0,d0
		beq.s	loc_DB80
		lea	(unk_42358).l,a0
		lea	(word_E298).l,a1
		bsr.w	sub_EB22
		cmpi.b	#$FF,d0
		bne.s	loc_DB80
		andi.w	#$FFFE,$2A(a6)

loc_DB80:
		bsr.w	loc_F2D0
		bcc.s	locret_DB8A
		bsr.w	sub_F286

locret_DB8A:
		rts
; ---------------------------------------------------------------------------
; Object coding for Spring

loc_DB8C:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_DBBA
		move.l	#Map_SpringLR,obMap(a6)		; mappings to load for object
		move.w	#$2C07,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#8,$22(a6)
		move.b	#$10,$23(a6)
		move.w	#0,$2A(a6)

loc_DBBA:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_DC02
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#1,d4
		beq.s	loc_DBEC
		cmpi.w	#3,d4
		beq.s	loc_DBEC
		bra.s	loc_DC02
; ---------------------------------------------------------------------------

loc_DBEC:
		ori.w	#1,$2A(a6)
		move.l	#ARTUNC_Tails,d0
		neg.l	d0
		moveq	#0,d1
		jsr	(loc_CB1C).l

loc_DC02:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_DC4A
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#1,d4
		beq.s	loc_DC34
		cmpi.w	#3,d4
		beq.s	loc_DC34
		bra.s	loc_DC4A
; ---------------------------------------------------------------------------

loc_DC34:
		ori.w	#1,$2A(a6)
		move.l	#ARTUNC_Tails,d0
		neg.l	d0
		moveq	#0,d1
		jsr	(loc_CB1C).l

loc_DC4A:
		move.w	$2A(a6),d0
		btst	#0,d0
		beq.s	loc_DC70
		lea	(unk_42358).l,a0
		lea	(word_E298).l,a1
		bsr.w	sub_EB22
		cmpi.w	#$FF,d0
		bne.s	loc_DC70
		andi.w	#$FFFE,$2A(a6)

loc_DC70:
		bsr.w	loc_F2D0
		bcc.s	locret_DC7A
		bsr.w	sub_F286

locret_DC7A:
		rts
; ---------------------------------------------------------------------------

loc_DC7C:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_DCAA
		move.l	#Map_SpringUp,obMap(a6)
		move.w	#$2407,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$10,$22(a6)
		move.b	#8,$23(a6)
		move.w	#0,$2A(a6)

loc_DCAA:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_DCF2
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#7,d4
		beq.s	loc_DCDC
		cmpi.w	#6,d4
		beq.s	loc_DCDC
		bra.s	loc_DCF2
; ---------------------------------------------------------------------------

loc_DCDC:
		ori.w	#1,$2A(a6)
		move.l	#ARTUNC_Tails,d1
		neg.l	d1
		moveq	#0,d0
		jsr	(loc_CB1C).l

loc_DCF2:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_DD3A
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#7,d4
		beq.s	loc_DD24
		cmpi.w	#6,d4
		beq.s	loc_DD24
		bra.s	loc_DD3A
; ---------------------------------------------------------------------------

loc_DD24:
		ori.w	#1,$2A(a6)
		move.l	#ARTUNC_Tails,d1
		neg.l	d1
		moveq	#0,d0
		jsr	(loc_CB1C).l

loc_DD3A:
		move.w	$2A(a6),d0
		btst	#0,d0
		beq.s	loc_DD60
		lea	(unk_4235E).l,a0
		lea	(word_E2A4).l,a1
		bsr.w	sub_EB22
		cmpi.b	#$FF,d0
		bne.s	loc_DD60
		andi.w	#$FFFE,$2A(a6)

loc_DD60:
		bsr.w	loc_F2D0
		bcc.s	locret_DD6A
		bsr.w	sub_F286

locret_DD6A:
		rts
; ---------------------------------------------------------------------------

loc_DD6C:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_DD9A
		move.l	#Map_SpringUp,obMap(a6)
		move.w	#$3407,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$10,$22(a6)
		move.b	#8,$23(a6)
		move.w	#0,$2A(a6)

loc_DD9A:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_DDE0
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#4,d4
		beq.s	loc_DDCC
		cmpi.w	#5,d4
		beq.s	loc_DDCC
		bra.s	loc_DDE0
; ---------------------------------------------------------------------------

loc_DDCC:
		ori.w	#1,$2A(a6)
		move.l	#ARTUNC_Tails,d1
		moveq	#0,d0
		jsr	(loc_CB1C).l

loc_DDE0:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_DE26
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#5,d4
		beq.s	loc_DE12
		cmpi.w	#4,d4
		beq.s	loc_DE12
		bra.s	loc_DE26
; ---------------------------------------------------------------------------

loc_DE12:
		ori.w	#1,$2A(a6)
		move.l	#ARTUNC_Tails,d1
		moveq	#0,d0
		jsr	(loc_CB1C).l

loc_DE26:
		move.w	$2A(a6),d0
		btst	#0,d0
		beq.s	loc_DE4C
		lea	(unk_4235E).l,a0
		lea	(word_E2A4).l,a1
		bsr.w	sub_EB22
		cmpi.b	#$FF,d0
		bne.s	loc_DE4C
		andi.w	#$FFFE,$2A(a6)

loc_DE4C:
		bsr.w	loc_F2D0
		bcc.s	locret_DE56
		bsr.w	sub_F286

locret_DE56:
		rts
; ---------------------------------------------------------------------------

loc_DE58:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_DE86
		move.l	#Map_SpringAngUp,obMap(a6)
		move.w	#$2407,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$C,$22(a6)
		move.b	#$C,$23(a6)
		move.w	#0,$2A(a6)

loc_DE86:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_DEDE
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#2,d4
		beq.s	loc_DEC4
		cmpi.w	#6,d4
		beq.s	loc_DEC4
		cmpi.w	#7,d4
		beq.s	loc_DEC4
		cmpi.w	#0,d4
		beq.s	loc_DEC4
		bra.s	loc_DEDE
; ---------------------------------------------------------------------------

loc_DEC4:
		ori.w	#1,$2A(a6)
		move.l	#$32985,d0
		move.l	#$32985,d1
		neg.l	d1
		jsr	(loc_CB1C).l

loc_DEDE:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_DF36
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#2,d4
		beq.s	loc_DF1C
		cmpi.w	#6,d4
		beq.s	loc_DF1C
		cmpi.w	#7,d4
		beq.s	loc_DF1C
		cmpi.w	#0,d4
		beq.s	loc_DF1C
		bra.s	loc_DF36
; ---------------------------------------------------------------------------

loc_DF1C:
		ori.w	#1,$2A(a6)
		move.l	#$32985,d0
		move.l	#$32985,d1
		neg.l	d1
		jsr	(loc_CB1C).l

loc_DF36:
		move.w	$2A(a6),d0
		btst	#0,d0
		beq.s	loc_DF5C
		lea	(unk_42364).l,a0
		lea	(word_E2B0).l,a1
		bsr.w	sub_EB22
		cmpi.b	#$FF,d0
		bne.s	loc_DF5C
		andi.w	#$FFFE,$2A(a6)

loc_DF5C:
		bsr.w	loc_F2D0
		bcc.s	locret_DF66
		bsr.w	sub_F286

locret_DF66:
		rts
; ---------------------------------------------------------------------------

loc_DF68:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_DF96
		move.l	#Map_SpringAngUp,obMap(a6)
		move.w	#$2C07,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$C,$22(a6)
		move.b	#$C,$23(a6)
		move.w	#0,$2A(a6)

loc_DF96:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_DFF0
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#3,d4
		beq.s	loc_DFD4
		cmpi.w	#7,d4
		beq.s	loc_DFD4
		cmpi.w	#6,d4
		beq.s	loc_DFD4
		cmpi.w	#1,d4
		beq.s	loc_DFD4
		bra.s	loc_DFF0
; ---------------------------------------------------------------------------

loc_DFD4:
		ori.w	#1,$2A(a6)
		move.l	#$32985,d0
		move.l	#$32985,d1
		neg.l	d0
		neg.l	d1
		jsr	(loc_CB1C).l

loc_DFF0:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E04A
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#3,d4
		beq.s	loc_E02E
		cmpi.w	#7,d4
		beq.s	loc_E02E
		cmpi.w	#6,d4
		beq.s	loc_E02E
		cmpi.w	#1,d4
		beq.s	loc_E02E
		bra.s	loc_E04A
; ---------------------------------------------------------------------------

loc_E02E:
		ori.w	#1,$2A(a6)
		move.l	#$32985,d0
		move.l	#$32985,d1
		neg.l	d0
		neg.l	d1
		jsr	(loc_CB1C).l

loc_E04A:
		move.w	$2A(a6),d0
		btst	#0,d0
		beq.s	loc_E070
		lea	(unk_42364).l,a0
		lea	(word_E2B0).l,a1
		bsr.w	sub_EB22
		cmpi.b	#$FF,d0
		bne.s	loc_E070
		andi.w	#$FFFE,$2A(a6)

loc_E070:
		bsr.w	loc_F2D0
		bcc.s	locret_E07A
		bsr.w	sub_F286

locret_E07A:
		rts
; ---------------------------------------------------------------------------

loc_E07C:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_E0AA
		move.l	#Map_SpringAngUp,obMap(a6)
		move.w	#$3407,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$C,$22(a6)
		move.b	#$C,$23(a6)
		move.w	#0,$2A(a6)

loc_E0AA:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E100
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#0,d4
		beq.s	loc_E0E8
		cmpi.w	#4,d4
		beq.s	loc_E0E8
		cmpi.w	#2,d4
		beq.s	loc_E0E8
		cmpi.w	#5,d4
		beq.s	loc_E0E8
		bra.s	loc_E100
; ---------------------------------------------------------------------------

loc_E0E8:
		ori.w	#1,$2A(a6)
		move.l	#$32985,d0
		move.l	#$32985,d1
		jsr	(loc_CB1C).l

loc_E100:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E156
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#0,d4
		beq.s	loc_E13E
		cmpi.w	#4,d4
		beq.s	loc_E13E
		cmpi.w	#2,d4
		beq.s	loc_E13E
		cmpi.w	#5,d4
		beq.s	loc_E13E
		bra.s	loc_E156
; ---------------------------------------------------------------------------

loc_E13E:
		ori.w	#1,$2A(a6)
		move.l	#$32985,d0
		move.l	#$32985,d1
		jsr	(loc_CB1C).l

loc_E156:
		move.w	$2A(a6),d0
		btst	#0,d0
		beq.s	loc_E17C
		lea	(unk_42364).l,a0
		lea	(word_E2B0).l,a1
		bsr.w	sub_EB22
		cmpi.b	#$FF,d0
		bne.s	loc_E17C
		andi.w	#$FFFE,$2A(a6)

loc_E17C:
		bsr.w	loc_F2D0
		bcc.s	locret_E186
		bsr.w	sub_F286

locret_E186:
		rts
; ---------------------------------------------------------------------------

loc_E188:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_E1B6
		move.l	#Map_SpringAngUp,obMap(a6)
		move.w	#$3C07,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$C,$22(a6)
		move.b	#$C,$23(a6)
		move.w	#0,$2A(a6)

loc_E1B6:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E20E
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#1,d4
		beq.s	loc_E1F4
		cmpi.w	#5,d4
		beq.s	loc_E1F4
		cmpi.w	#3,d4
		beq.s	loc_E1F4
		cmpi.w	#4,d4
		beq.s	loc_E1F4
		bra.s	loc_E20E
; ---------------------------------------------------------------------------

loc_E1F4:
		ori.w	#1,$2A(a6)
		move.l	#$32985,d0
		move.l	#$32985,d1
		neg.l	d0
		jsr	(loc_CB1C).l

loc_E20E:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E266
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#1,d4
		beq.s	loc_E24C
		cmpi.w	#5,d4
		beq.s	loc_E24C
		cmpi.w	#3,d4
		beq.s	loc_E24C
		cmpi.w	#4,d4
		beq.s	loc_E24C
		bra.s	loc_E266
; ---------------------------------------------------------------------------

loc_E24C:
		ori.w	#1,$2A(a6)
		move.l	#$32985,d0
		move.l	#$32985,d1
		neg.l	d0
		jsr	(loc_CB1C).l

loc_E266:
		move.w	$2A(a6),d0
		btst	#0,d0
		beq.s	loc_E28C
		lea	(unk_42364).l,a0
		lea	(word_E2B0).l,a1
		bsr.w	sub_EB22
		cmpi.b	#$FF,d0
		bne.s	loc_E28C
		andi.w	#$FFFE,$2A(a6)

loc_E28C:
		bsr.w	loc_F2D0
		bcc.s	locret_E296
		bsr.w	sub_F286

locret_E296:
		rts
; ---------------------------------------------------------------------------
word_E298:	dc.w $601
		dc.w $602
		dc.w $600
		dc.w $82FF
		dc.w $100
		dc.w $8080
word_E2A4:	dc.w $601
		dc.w $602
		dc.w $600
		dc.w $82FF
		dc.w $100
		dc.w $8080
word_E2B0:	dc.w $601
		dc.w $802
		dc.w $600
		dc.w $82FF
		dc.w $100
		dc.w $8080
; ---------------------------------------------------------------------------

locret_E2BC:
		rts
; ---------------------------------------------------------------------------

loc_E2BE:
		subq.w	#1,$26(a6)
		bne.s	loc_E2C8
		jmp	(sub_1980).w
; ---------------------------------------------------------------------------

loc_E2C8:
		move.w	8(a6),d0
		move.w	$C(a6),d1
		jsr	(sub_1DA8).w
		beq.s	loc_E2E6
		move.l	$1C(a6),d6
		neg.l	d6
		move.l	d6,d7
		asr.l	#2,d7
		sub.l	d7,d6
		move.l	d6,$1C(a6)

loc_E2E6:
		move.w	d0,8(a6)
		move.w	d1,$C(a6)
		move.l	$18(a6),d0
		add.l	d0,8(a6)
		move.l	$1C(a6),d0
		addi.l	#$1800,d0
		move.l	d0,$1C(a6)
		add.l	d0,$C(a6)
		move.w	($FFFFF000).l,d0
		andi.w	#$C,d0
		add.w	d0,d0
		lea	word_E334(pc,d0.w),a0
		move.l	a0,$10(a6)
		btst	#6,5(a6)
		beq.s	loc_E32C
		bclr	#7,5(a6)
		rts
; ---------------------------------------------------------------------------

loc_E32C:
		bset	#7,5(a6)
		rts
; ---------------------------------------------------------------------------
word_E334:	dc.w $5F8
		dc.w $25F0
		dc.w $F8FF
		nop
		dc.w $5F8
		dc.w $25F4
		dc.w $F8FF
		nop
		dc.w $1F8
		dc.w $25B4
		dc.w $FCFF
		nop
		dc.w $5F8
		dc.w $2DF4
		dc.w $F8FF
; ---------------------------------------------------------------------------

locret_E352:
		rts
; ---------------------------------------------------------------------------

locret_E354:
		rts
; ---------------------------------------------------------------------------

loc_E356:
		tst.b	$28(a6)
		bne.s	loc_E37C
		move.w	#0,4(a6)
		move.w	#$2020,$22(a6)
		move.l	#word_E376,$10(a6)
		addq.b	#1,$28(a6)
		bra.s	loc_E37C
; ---------------------------------------------------------------------------
word_E376:
		dc.w $FF0
		dc.w $8001
		dc.w $F0FF
; ---------------------------------------------------------------------------

loc_E37C:
		jsr	(loc_F2D0).l
		bcc.s	loc_E38A
		jmp	(sub_F286).l
; ---------------------------------------------------------------------------

loc_E38A:
		movea.w	($FFFFD862).w,a0
		jsr	(sub_EAA0).l
		bcc.s	loc_E398
		bsr.s	sub_E3A8

loc_E398:
		movea.w	($FFFFD864).w,a0
		jsr	(sub_EAA0).l
		bcc.s	locret_E3A6
		bsr.s	sub_E3A8

locret_E3A6:
		rts

; =============== S U B	R O U T	I N E =======================================


sub_E3A8:
		move.w	8(a0),d0
		sub.w	8(a6),d0
		move.w	$C(a0),d1
		sub.w	$C(a6),d1
		moveq	#0,d2
		move.b	$29(a6),d2
		jmp	loc_E3DE(pc,d2.w)
; End of function sub_E3A8

; ---------------------------------------------------------------------------

loc_E3C2:
		bclr	#7,$25(a0)

loc_E3C8:
		bclr	#1,$25(a0)
		rts
; ---------------------------------------------------------------------------

loc_E3D0:
		bclr	#7,$25(a0)

loc_E3D6:
		bset	#1,$25(a0)
		rts
; ---------------------------------------------------------------------------

loc_E3DE:
		tst.w	d0
		bpl.s	loc_E3C8
		bra.s	loc_E3D6
; ---------------------------------------------------------------------------
		nop
		tst.w	d0
		bpl.s	loc_E3D6
		bra.s	loc_E3C8
; ---------------------------------------------------------------------------
		nop
		tst.w	d1
		bpl.s	loc_E3C8
		bra.s	loc_E3D6
; ---------------------------------------------------------------------------
		nop
		tst.w	d1
		bpl.s	loc_E3D6
		bra.s	loc_E3C8
; ---------------------------------------------------------------------------
		nop
		tst.w	d0
		bpl.s	loc_E3C2
		bra.s	loc_E44C
; ---------------------------------------------------------------------------
		nop
		tst.w	d0
		bpl.s	loc_E3D0
		bra.s	loc_E43E
; ---------------------------------------------------------------------------
		nop
		tst.w	d1
		bpl.s	loc_E3C2
		bra.s	loc_E44C
; ---------------------------------------------------------------------------
		nop
		tst.w	d1
		bpl.s	loc_E3D0
		bra.s	loc_E43E
; ---------------------------------------------------------------------------
		nop
		tst.w	d0
		bpl.s	loc_E43E
		bra.s	loc_E3D0
; ---------------------------------------------------------------------------
		nop
		tst.w	d0
		bpl.s	loc_E44C
		bra.s	loc_E3C2
; ---------------------------------------------------------------------------
		nop
		tst.w	d1
		bpl.s	loc_E43E
		bra.s	loc_E3D0
; ---------------------------------------------------------------------------
		nop
		tst.w	d1
		bpl.s	loc_E44C
		bra.s	loc_E3C2
; ---------------------------------------------------------------------------
		nop

loc_E43E:
		bset	#7,$25(a0)
		bclr	#1,$25(a0)
		rts
; ---------------------------------------------------------------------------

loc_E44C:
		bset	#7,$25(a0)
		bset	#1,$25(a0)
		rts
; ---------------------------------------------------------------------------

loc_E45A:
		tst.b	$28(a6)
		bne.s	loc_E480
		move.w	#0,4(a6)
		move.w	#$2020,$22(a6)
		move.l	#word_E47A,$10(a6)
		addq.b	#1,$28(a6)
		bra.s	loc_E480
; ---------------------------------------------------------------------------
word_E47A:
		dc.w $FF0
		dc.w $8001
		dc.w $F0FF
; ---------------------------------------------------------------------------

loc_E480:
		jsr	(loc_F2D0).l
		bcc.s	loc_E48E
		jmp	(sub_F286).l
; ---------------------------------------------------------------------------

loc_E48E:
		movea.w	($FFFFD862).w,a0
		jsr	(sub_EAA0).l
		bcc.s	loc_E49C
		bsr.s	sub_E4AC

loc_E49C:
		movea.w	($FFFFD864).w,a0
		jsr	(sub_EAA0).l
		bcc.s	locret_E4AA
		bsr.s	sub_E4AC

locret_E4AA:
		rts

; =============== S U B	R O U T	I N E =======================================


sub_E4AC:
		moveq	#0,d0
		move.b	$29(a6),d0
		jmp	loc_E4B6(pc,d0.w)
; End of function sub_E4AC

; ---------------------------------------------------------------------------

loc_E4B6:
		bra.s	loc_E4C8
; ---------------------------------------------------------------------------
		bra.s	loc_E4D6
; ---------------------------------------------------------------------------
		bra.s	loc_E4C2
; ---------------------------------------------------------------------------
		bra.s	loc_E4D0
; ---------------------------------------------------------------------------
		bra.s	loc_E4DE
; ---------------------------------------------------------------------------
		bra.s	loc_E4EC
; ---------------------------------------------------------------------------

loc_E4C2:
		bclr	#7,$25(a0)

loc_E4C8:
		bclr	#1,$25(a0)
		rts
; ---------------------------------------------------------------------------

loc_E4D0:
		bclr	#7,$25(a0)

loc_E4D6:
		bset	#1,$25(a0)
		rts
; ---------------------------------------------------------------------------

loc_E4DE:
		bset	#7,$25(a0)
		bclr	#1,$25(a0)
		rts
; ---------------------------------------------------------------------------

loc_E4EC:
		bset	#7,$25(a0)
		bset	#1,$25(a0)
		rts
; ---------------------------------------------------------------------------

locret_E4FA:
		rts
; ---------------------------------------------------------------------------

locret_E4FC:
		rts
; ---------------------------------------------------------------------------

loc_E4FE:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_E526
		move.l	#Map_SpikesUpLrg,obMap(a6)
		move.w	#$23BF,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$10,$22(a6)
		move.b	#$10,$23(a6)

loc_E526:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E560
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#7,d4
		beq.s	loc_E558
		cmpi.w	#6,d4
		beq.s	loc_E558
		bra.s	loc_E560
; ---------------------------------------------------------------------------

loc_E558:
		moveq	#1,d0
		jsr	(loc_CB90).l

loc_E560:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E59A
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#7,d4
		beq.s	loc_E592
		cmpi.w	#6,d4
		beq.s	loc_E592
		bra.s	loc_E59A
; ---------------------------------------------------------------------------

loc_E592:
		moveq	#1,d0
		jsr	(loc_CB90).l

loc_E59A:
		bsr.w	loc_F2D0
		bcc.s	locret_E5A4
		bsr.w	sub_F286

locret_E5A4:
		rts
; ---------------------------------------------------------------------------

loc_E5A6:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_E5CE
		move.l	#Map_SpikesUpLrg,obMap(a6)
		move.w	#$33BF,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$10,$22(a6)
		move.b	#$10,$23(a6)

loc_E5CE:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E608
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#5,d4
		beq.s	loc_E600
		cmpi.w	#4,d4
		beq.s	loc_E600
		bra.s	loc_E608
; ---------------------------------------------------------------------------

loc_E600:
		moveq	#1,d0
		jsr	(loc_CB90).l

loc_E608:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E642
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#5,d4
		beq.s	loc_E63A
		cmpi.w	#4,d4
		beq.s	loc_E63A
		bra.s	loc_E642
; ---------------------------------------------------------------------------

loc_E63A:
		moveq	#1,d0
		jsr	(loc_CB90).l

loc_E642:
		bsr.w	loc_F2D0
		bcc.s	locret_E64C
		bsr.w	sub_F286

locret_E64C:
		rts
; ---------------------------------------------------------------------------

loc_E64E:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_E676
		move.l	#Map_SpikesLR,obMap(a6)
		move.w	#$23BF,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$10,$22(a6)
		move.b	#$10,$23(a6)

loc_E676:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E6B0
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#2,d4
		beq.s	loc_E6A8
		cmpi.w	#0,d4
		beq.s	loc_E6A8
		bra.s	loc_E6B0
; ---------------------------------------------------------------------------

loc_E6A8:
		moveq	#1,d0
		jsr	(loc_CB90).l

loc_E6B0:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E6EA
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#2,d4
		beq.s	loc_E6E2
		cmpi.w	#0,d4
		beq.s	loc_E6E2
		bra.s	loc_E6EA
; ---------------------------------------------------------------------------

loc_E6E2:
		moveq	#1,d0
		jsr	(loc_CB90).l

loc_E6EA:
		bsr.w	loc_F2D0
		bcc.s	locret_E6F4
		bsr.w	sub_F286

locret_E6F4:
		rts
; ---------------------------------------------------------------------------

loc_E6F6:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_E71E
		move.l	#Map_SpikesLR,obMap(a6)
		move.w	#$2BBF,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$10,$22(a6)
		move.b	#$10,$23(a6)

loc_E71E:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E758
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#1,d4
		beq.s	loc_E750
		cmpi.w	#3,d4
		beq.s	loc_E750
		bra.s	loc_E758
; ---------------------------------------------------------------------------

loc_E750:
		moveq	#1,d0
		jsr	(loc_CB90).l

loc_E758:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E792
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#1,d4
		beq.s	loc_E78A
		cmpi.w	#3,d4
		beq.s	loc_E78A
		bra.s	loc_E792
; ---------------------------------------------------------------------------

loc_E78A:
		moveq	#1,d0
		jsr	(loc_CB90).l

loc_E792:
		bsr.w	loc_F2D0
		bcc.s	locret_E79C
		bsr.w	sub_F286

locret_E79C:
		rts
; ---------------------------------------------------------------------------

loc_E79E:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_E7C6
		move.l	#Map_SpikesAng,obMap(a6)
		move.w	#$2BBF,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$C,$22(a6)
		move.b	#$C,$23(a6)

loc_E7C6:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E800
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#6,d4
		beq.s	loc_E7F8
		cmpi.w	#2,d4
		beq.s	loc_E7F8
		bra.s	loc_E800
; ---------------------------------------------------------------------------

loc_E7F8:
		moveq	#1,d0
		jsr	(loc_CB90).l

loc_E800:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E83A
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#6,d4
		beq.s	loc_E832
		cmpi.w	#2,d4
		beq.s	loc_E832
		bra.s	loc_E83A
; ---------------------------------------------------------------------------

loc_E832:
		moveq	#1,d0
		jsr	(loc_CB90).l

loc_E83A:
		bsr.w	loc_F2D0
		bcc.s	locret_E844
		bsr.w	sub_F286

locret_E844:
		rts
; ---------------------------------------------------------------------------

loc_E846:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_E86E
		move.l	#Map_SpikesAng,obMap(a6)
		move.w	#$23BF,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$C,$22(a6)
		move.b	#$C,$23(a6)

loc_E86E:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E8A8
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#7,d4
		beq.s	loc_E8A0
		cmpi.w	#3,d4
		beq.s	loc_E8A0
		bra.s	loc_E8A8
; ---------------------------------------------------------------------------

loc_E8A0:
		moveq	#1,d0
		jsr	(loc_CB90).l

loc_E8A8:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E8E2
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#7,d4
		beq.s	loc_E8DA
		cmpi.w	#3,d4
		beq.s	loc_E8DA
		bra.s	loc_E8E2
; ---------------------------------------------------------------------------

loc_E8DA:
		moveq	#1,d0
		jsr	(loc_CB90).l

loc_E8E2:
		bsr.w	loc_F2D0
		bcc.s	locret_E8EC
		bsr.w	sub_F286

locret_E8EC:
		rts
; ---------------------------------------------------------------------------

loc_E8EE:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_E916
		move.l	#Map_SpikesAng,obMap(a6)
		move.w	#$3BBF,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$C,$22(a6)
		move.b	#$C,$23(a6)

loc_E916:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E950
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#0,d4
		beq.s	loc_E948
		cmpi.w	#4,d4
		beq.s	loc_E948
		bra.s	loc_E950
; ---------------------------------------------------------------------------

loc_E948:
		moveq	#1,d0
		jsr	(loc_CB90).l

loc_E950:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E98A
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#0,d4
		beq.s	loc_E982
		cmpi.w	#4,d4
		beq.s	loc_E982
		bra.s	loc_E98A
; ---------------------------------------------------------------------------

loc_E982:
		moveq	#1,d0
		jsr	(loc_CB90).l

loc_E98A:
		bsr.w	loc_F2D0
		bcc.s	locret_E994
		bsr.w	sub_F286

locret_E994:
		rts
; ---------------------------------------------------------------------------

loc_E996:
		moveq	#7,d0
		bclr	d0,$28(a6)
		beq.s	loc_E9BE
		move.l	#Map_SpikesAng,obMap(a6)
		move.w	#$33BF,$20(a6)
		move.w	#$8080,4(a6)
		move.b	#$C,$22(a6)
		move.b	#$C,$23(a6)

loc_E9BE:
		movea.w	($FFFFD862).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_E9F8
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#1,d4
		beq.s	loc_E9F0
		cmpi.w	#5,d4
		beq.s	loc_E9F0
		bra.s	loc_E9F8
; ---------------------------------------------------------------------------

loc_E9F0:
		moveq	#1,d0
		jsr	(loc_CB90).l

loc_E9F8:
		movea.w	($FFFFD864).w,a0
		move.w	#$F,d0
		jsr	(loc_CAD4).l
		beq.s	loc_EA32
		move.w	8(a6),d0
		move.w	$C(a6),d1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		bsr.w	sub_EB8C
		cmpi.w	#1,d4
		beq.s	loc_EA2A
		cmpi.w	#5,d4
		beq.s	loc_EA2A
		bra.s	loc_EA32
; ---------------------------------------------------------------------------

loc_EA2A:
		moveq	#1,d0
		jsr	(loc_CB90).l

loc_EA32:
		bsr.w	loc_F2D0
		bcc.s	locret_EA3C
		bsr.w	sub_F286

locret_EA3C:
		rts

; =============== S U B	R O U T	I N E =======================================


sub_EA3E:
		move.w	8(a0),d0
		move.w	$C(a0),d1
		move.w	8(a6),d2
		move.w	$C(a6),d3
		moveq	#0,d4
		moveq	#0,d5
		move.b	$22(a0),d4
		move.b	$22(a6),d5
		add.w	d5,d4
		move.w	d0,d5
		sub.w	d2,d5
		bpl.s	loc_EA64
		neg.w	d5

loc_EA64:
		sub.w	d5,d4
		bpl.s	loc_EA6A
		rts
; ---------------------------------------------------------------------------

loc_EA6A:
		moveq	#0,d6
		moveq	#0,d7
		move.b	$23(a0),d6
		move.b	$23(a6),d7
		add.w	d7,d6
		move.w	d1,d7
		sub.w	d3,d7
		bpl.s	loc_EA80
		neg.w	d7

loc_EA80:
		sub.w	d7,d6
		bpl.s	loc_EA86
		rts
; ---------------------------------------------------------------------------

loc_EA86:
		cmp.w	d4,d6
		bcc.s	loc_EA96
		bsr.w	sub_EB00
		move.w	d0,d1
		move.w	8(a0),d0
		rts
; ---------------------------------------------------------------------------

loc_EA96:
		bsr.w	sub_EADE
		move.w	$C(a0),d1
		rts
; End of function sub_EA3E


; =============== S U B	R O U T	I N E =======================================


sub_EAA0:
		moveq	#0,d1
		move.b	$22(a0),d1
		moveq	#0,d2
		move.b	$22(a6),d2
		add.w	d2,d1
		move.w	8(a0),d0
		sub.w	8(a6),d0
		bpl.s	loc_EABA
		neg.w	d0

loc_EABA:
		cmp.w	d1,d0
		bcs.s	loc_EAC0
		rts
; ---------------------------------------------------------------------------

loc_EAC0:
		moveq	#0,d1
		move.b	$23(a0),d1
		moveq	#0,d2
		move.b	$23(a6),d2
		add.w	d2,d1
		move.w	$C(a0),d0
		sub.w	$C(a6),d0
		bpl.s	loc_EADA
		neg.w	d0

loc_EADA:
		cmp.w	d1,d0
		rts
; End of function sub_EAA0


; =============== S U B	R O U T	I N E =======================================


sub_EADE:
		moveq	#0,d1
		move.b	$22(a0),d1
		moveq	#0,d2
		move.b	$22(a6),d2
		add.w	d1,d2
		move.w	8(a0),d0
		move.w	8(a6),d1
		cmp.w	d0,d1
		bpl.s	loc_EAFA
		neg.w	d2

loc_EAFA:
		move.w	d1,d0
		sub.w	d2,d0
		rts
; End of function sub_EADE


; =============== S U B	R O U T	I N E =======================================


sub_EB00:
		moveq	#0,d1
		move.b	$23(a0),d1
		moveq	#0,d2
		move.b	$23(a6),d2
		add.w	d1,d2
		move.w	$C(a0),d0
		move.w	$C(a6),d1
		cmp.w	d0,d1
		bpl.s	loc_EB1C
		neg.w	d2

loc_EB1C:
		move.w	d1,d0
		sub.w	d2,d0
		rts
; End of function sub_EB00


; =============== S U B	R O U T	I N E =======================================


sub_EB22:
		subq.b	#1,$26(a6)
		bpl.s	loc_EB2C
		clr.b	$27(a6)

loc_EB2C:
		beq.s	loc_EB30
		rts
; ---------------------------------------------------------------------------

loc_EB30:
		moveq	#0,d1
		moveq	#0,d2

loc_EB34:
		moveq	#0,d0
		move.b	$27(a6),d0
		move.b	(a1,d0.w),d1
		bmi.s	loc_EB58
		move.b	d1,$26(a6)
		move.b	1(a1,d0.w),d1
		add.w	d1,d1
		adda.w	(a0,d1.w),a0
		addq.b	#2,$27(a6)
		move.l	a0,$10(a6)
		rts
; ---------------------------------------------------------------------------

loc_EB58:
		add.b	d1,d1
		jmp	loc_EB5E(pc,d1.w)
; End of function sub_EB22

; ---------------------------------------------------------------------------

loc_EB5E:
		bra.s	loc_EB66
; ---------------------------------------------------------------------------
		bra.s	loc_EB6C
; ---------------------------------------------------------------------------
		bra.s	loc_EB78
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

loc_EB66:
		clr.b	$27(a6)
		bra.s	loc_EB34
; ---------------------------------------------------------------------------

loc_EB6C:
		move.b	1(a1,d0.w),d1
		add.b	d1,d1
		add.b	d1,$27(a6)
		bra.s	loc_EB34
; ---------------------------------------------------------------------------

loc_EB78:
		move.b	1(a1,d0.w),d1
		move.w	d1,-(sp)
		addq.b	#2,$27(a6)
		bsr.s	loc_EB34
		move.w	(sp)+,d0
		ori	#1,ccr
		rts

; =============== S U B	R O U T	I N E =======================================


sub_EB8C:
		moveq	#0,d4
		sub.w	d0,d2
		bcc.s	loc_EB98
		ori.w	#1,d4
		neg.w	d2

loc_EB98:
		sub.w	d1,d3
		bcc.s	loc_EBA2
		ori.w	#2,d4
		neg.w	d3

loc_EBA2:
		cmp.w	d2,d3
		bls.s	locret_EBAA
		ori.w	#4,d4

locret_EBAA:
		rts
; End of function sub_EB8C

; ---------------------------------------------------------------------------

locret_EBAC:
		rts

; =============== S U B	R O U T	I N E =======================================


Level_UpdateHUD:
		lea	($FFFFD85C).w,a6

loc_EBB2:
		_move.w	0(a6),d0
		bne.s	loc_EBBA
		rts
; ---------------------------------------------------------------------------

loc_EBBA:
		movea.w	d0,a6
		moveq	#0,d0
		move.b	6(a6),d0
		jsr	loc_EBC8(pc,d0.w)
		bra.s	loc_EBB2
; End of function Level_UpdateHUD

; ---------------------------------------------------------------------------

loc_EBC8:
		bra.w	loc_EBE0
; ---------------------------------------------------------------------------
		bra.w	loc_ED7C
; ---------------------------------------------------------------------------
		bra.w	loc_EE0C
; ---------------------------------------------------------------------------
		bra.w	loc_EE5C
; ---------------------------------------------------------------------------
		bra.w	loc_EEDA
; ---------------------------------------------------------------------------
		bra.w	loc_EF58
; ---------------------------------------------------------------------------

loc_EBE0:
		tst.w	($FFFFD834).w
		beq.s	loc_EC02
		movea.w	($FFFFD862).w,a0
		cmpi.w	#$8F,$C(a0)			; "�"
		bcs.s	loc_EBFE
		movea.w	($FFFFD864).w,a0
		cmpi.w	#$8F,$C(a0)			; "�"
		bcc.s	loc_EC02

loc_EBFE:
		bra.w	loc_EC20
; ---------------------------------------------------------------------------

loc_EC02:
		tst.w	$26(a6)
		bne.s	loc_EBFE
		move.w	$24(a6),d7
		addq.w	#1,d7
		cmpi.w	#$2D00,d7
		bhi.s	loc_EC20
		tst.w	($FFFFD834).w
		bne.s	loc_EC62
		cmpi.w	#$F00,d7
		bls.s	loc_EC62

loc_EC20:
		move.b	#bgm_GameOver,d0
		jsr	(PlayMusic).l
		move.w	#$300,d0		; this basically performs a spinlock for 12 seconds

.loop:
		bclr	#7,($FFFFFFC9).w

.wait:
		tst.b	($FFFFFFC9).w	
		bpl.s	.wait
		dbf	d0,.loop
		clr.w	(v_subgamemode).w
		move.w	($FFFFD834).w,d0
		addq.w	#1,d0
		andi.w	#1,d0
		move.w	d0,($FFFFD834).w
		clr.w	($FFFFD836).w
		move.w	#id_Field,(v_gamemode).w; change game mode to Field
		movea.l	(RomStart).w,sp		; set the stack pointer
		jmp	(MAINPROG).w		; jump to the main game loop
; ---------------------------------------------------------------------------

loc_EC62:
		move.w	d7,$24(a6)
		move.w	#$A500,d6
		move.w	d7,d0
		lsr.w	#6,d0
		ext.l	d0
		divu.w	#$A,d0
		swap	d0
		move.b	d0,d6
		add.b	d6,d6
		move.w	d6,($FFFFDA26).w
		swap	d0
		ext.l	d0
		divu.w	#6,d0
		move.b	d0,d6
		add.b	d6,d6
		move.w	d6,($FFFFDA0E).w
		swap	d0
		move.b	d0,d6
		add.b	d6,d6
		move.w	d6,($FFFFDA1E).w
		move.w	d7,d0
		andi.w	#$3F,d0
		move.b	unk_ECE6(pc,d0.w),d0
		move.b	d0,d6
		lsr.b	#4,d6
		add.b	d6,d6
		move.w	d6,($FFFFDA36).w
		move.b	d0,d6
		andi.b	#$F,d6
		add.b	d6,d6
		move.w	d6,($FFFFDA3E).w
		move.w	$24(a6),d0
		cmpi.w	#$2580,d0
		bcc.s	loc_ECCE
		tst.w	($FFFFD834).w
		bne.s	locret_ECE4
		cmpi.w	#$780,d0
		bcs.s	locret_ECE4

loc_ECCE:
		andi.w	#$F,d0
		bne.s	locret_ECE4
		move.w	#$2000,d0
		eor.w	d0,($FFFFD9F6).w
		eor.w	d0,($FFFFD9FE).w
		eor.w	d0,($FFFFDA06).w

locret_ECE4:
		rts
; ---------------------------------------------------------------------------
unk_ECE6:	dc.b   0
		dc.b   2
		dc.b   3
		dc.b   5
		dc.b   6
		dc.b   8
		dc.b   9
		dc.b $11
		dc.b $13
		dc.b $14
		dc.b $16
		dc.b $17
		dc.b $19
		dc.b $20
		dc.b $22				; "
		dc.b $23				; #
		dc.b $25				; %
		dc.b $27				; "
		dc.b $28				; (
		dc.b $30				; 0
		dc.b $31				; 1
		dc.b $33				; 3
		dc.b $34				; 4
		dc.b $36				; 6
		dc.b $38				; 8
		dc.b $39				; 9
		dc.b $41				; A
		dc.b $42				; B
		dc.b $44				; D
		dc.b $45				; E
		dc.b $47				; G
		dc.b $48				; H
		dc.b $50				; P
		dc.b $52				; R
		dc.b $53				; S
		dc.b $55				; U
		dc.b $56				; V
		dc.b $58				; X
		dc.b $59				; Y
		dc.b $61				; a
		dc.b $63				; c
		dc.b $64				; d
		dc.b $66				; f
		dc.b $67				; g
		dc.b $69				; i
		dc.b $70				; p
		dc.b $72				; r
		dc.b $73				; s
		dc.b $75				; u
		dc.b $77				; w
		dc.b $78				; x
		dc.b $80				; �
		dc.b $81				; �
		dc.b $83				; �
		dc.b $84				; �
		dc.b $86				; �
		dc.b $88				; �
		dc.b $89				; �
		dc.b $91				; �
		dc.b $92				; �
		dc.b $94				; �
		dc.b $95				; �
		dc.b $97				; �
		dc.b $99				; �

; =============== S U B	R O U T	I N E =======================================

sub_ED26:
		move.w	($FFFFD834).w,d0
		lsl.l	#1,d0
		jmp	loc_ED30(pc,d0.w)
; End of function sub_ED26

; ---------------------------------------------------------------------------

loc_ED30:
		bra.s	locret_ED34
; ---------------------------------------------------------------------------
		bra.s	loc_ED36
; ---------------------------------------------------------------------------

locret_ED34:
		rts
; ---------------------------------------------------------------------------

loc_ED36:
		moveq	#$10,d0
		jsr	(sub_1918).w
		bmi.w	loc_ED5E
		moveq	#0,d7
		move.w	($FFFFD83A).w,d7
		andi.w	#3,d7
		addq.w	#1,d7
		lsl.l	#2,d7
		move.b	d7,6(a0)
		move.w	#0,$26(a0)
		move.w	#0,$24(a0)

loc_ED5E:
		moveq	#$10,d0
		jsr	(sub_1918).w
		bmi.w	locret_ED7A
		move.b	#$14,6(a0)
		move.w	#0,$26(a0)
		move.w	#0,$24(a0)

locret_ED7A:
		rts
; ---------------------------------------------------------------------------

loc_ED7C:
		addq.w	#1,$24(a6)
		andi.w	#3,$24(a6)
		bne.s	loc_EDA6
		addq.w	#1,$26(a6)
		andi.w	#7,$26(a6)
		moveq	#0,d2
		move.w	$26(a6),d2
		lsl.l	#1,d2
		lea	($FFFFD3E4).w,a0
		move.w	word_EDE4(pc,d2.w),d0
		move.w	d0,$7A(a0)

loc_EDA6:
		addq.w	#1,$28(a6)
		andi.w	#7,$28(a6)
		bne.s	locret_EDE2
		addq.w	#1,$2A(a6)
		move.w	$2A(a6),d2
		cmpi.w	#6,d2
		bne.s	loc_EDC6
		move.w	#0,$2A(a6)

loc_EDC6:
		moveq	#0,d2
		move.w	$2A(a6),d2
		lsl.l	#1,d2
		lea	($FFFFD3E4).w,a0
		move.w	word_EDF4(pc,d2.w),d0
		move.w	d0,$7C(a0)
		move.w	word_EE00(pc,d2.w),d0
		move.w	d0,$7E(a0)

locret_EDE2:
		rts
; ---------------------------------------------------------------------------
word_EDE4:	dc.w $E
		dc.w $C
		dc.w $A
		dc.w 8
		dc.w 6
		dc.w 8
		dc.w $A
		dc.w $C
word_EDF4:	dc.w $A66
		dc.w $C66
		dc.w $C86
		dc.w $C88
		dc.w $A88
		dc.w $A68
word_EE00:	dc.w $C88
		dc.w $C86
		dc.w $C66
		dc.w $A66
		dc.w $A68
		dc.w $A88
; ---------------------------------------------------------------------------

loc_EE0C:
		lea	($FFFFD3E4).w,a0
		move.w	#6,d0
		move.w	d0,$7A(a0)
		addq.w	#1,$28(a6)
		andi.w	#7,$28(a6)
		bne.s	locret_EE4A
		addq.w	#1,$2A(a6)
		andi.w	#3,$2A(a6)
		moveq	#0,d2
		move.w	$2A(a6),d2
		lsl.l	#1,d2
		lea	($FFFFD3E4).w,a0
		move.w	word_EE4C(pc,d2.w),d0
		move.w	d0,$7C(a0)
		move.w	word_EE54(pc,d2.w),d0
		move.w	d0,$7E(a0)

locret_EE4A:
		rts
; ---------------------------------------------------------------------------
word_EE4C:	dc.w $800
		dc.w $820
		dc.w $840
		dc.w $820
word_EE54:	dc.w $840
		dc.w $820
		dc.w $800
		dc.w $820
; ---------------------------------------------------------------------------

loc_EE5C:
		addq.w	#1,$24(a6)
		andi.w	#3,$24(a6)
		bne.s	loc_EE86
		addq.w	#1,$26(a6)
		andi.w	#7,$26(a6)
		moveq	#0,d2
		move.w	$26(a6),d2
		lsl.l	#1,d2
		lea	($FFFFD3E4).w,a0
		move.w	word_EEBA(pc,d2.w),d0
		move.w	d0,$7A(a0)

loc_EE86:
		addq.w	#1,$28(a6)
		andi.w	#7,$28(a6)
		bne.s	locret_EEB8
		addq.w	#1,$2A(a6)
		andi.w	#3,$2A(a6)
		moveq	#0,d2
		move.w	$2A(a6),d2
		lsl.l	#1,d2
		lea	($FFFFD3E4).w,a0
		move.w	word_EECA(pc,d2.w),d0
		move.w	d0,$7C(a0)
		move.w	word_EED2(pc,d2.w),d0
		move.w	d0,$7E(a0)

locret_EEB8:
		rts
; ---------------------------------------------------------------------------
word_EEBA:	dc.w $E
		dc.w $C
		dc.w $A
		dc.w 8
		dc.w 6
		dc.w 8
		dc.w $A
		dc.w $C
word_EECA:	dc.w $828
		dc.w $628
		dc.w $62A
		dc.w $82A
word_EED2:	dc.w $62A
		dc.w $82A
		dc.w $828
		dc.w $628
; ---------------------------------------------------------------------------

loc_EEDA:
		addq.w	#1,$24(a6)
		andi.w	#3,$24(a6)
		bne.s	loc_EF04
		addq.w	#1,$26(a6)
		andi.w	#7,$26(a6)
		moveq	#0,d2
		move.w	$26(a6),d2
		lsl.l	#1,d2
		lea	($FFFFD3E4).w,a0
		move.w	word_EF38(pc,d2.w),d0
		move.w	d0,$7A(a0)

loc_EF04:
		addq.w	#1,$28(a6)
		andi.w	#7,$28(a6)
		bne.s	locret_EF36
		addq.w	#1,$2A(a6)
		andi.w	#3,$2A(a6)
		moveq	#0,d2
		move.w	$2A(a6),d2
		lsl.l	#1,d2
		lea	($FFFFD3E4).w,a0
		move.w	word_EF48(pc,d2.w),d0
		move.w	d0,$7C(a0)
		move.w	word_EF50(pc,d2.w),d0
		move.w	d0,$7E(a0)

locret_EF36:
		rts
; ---------------------------------------------------------------------------
word_EF38:	dc.w $E
		dc.w $C
		dc.w $A
		dc.w 8
		dc.w 6
		dc.w 8
		dc.w $A
		dc.w $C
word_EF48:	dc.w $200
		dc.w $400
		dc.w $600
		dc.w $400
word_EF50:	dc.w $600
		dc.w $400
		dc.w $200
		dc.w $400
; ---------------------------------------------------------------------------

loc_EF58:
		addq.w	#1,$28(a6)
		andi.w	#7,$28(a6)
		bne.s	locret_EFA2
		addq.w	#1,$2A(a6)
		andi.w	#7,$2A(a6)
		move.w	$2A(a6),d2
		cmpi.w	#6,d2
		bne.s	loc_EF7E
		move.w	#0,$2A(a6)

loc_EF7E:
		moveq	#0,d2
		move.w	$2A(a6),d2
		lsl.l	#1,d2
		lea	($FFFFD3E4).w,a0
		move.w	word_EFA4(pc,d2.w),d0
		move.w	d0,$54(a0)
		move.w	word_EFB4(pc,d2.w),d0
		move.w	d0,$56(a0)
		move.w	word_EFC4(pc,d2.w),d0
		move.w	d0,$58(a0)

locret_EFA2:
		rts
; ---------------------------------------------------------------------------
word_EFA4:	dc.w $EE
		dc.w $AC
		dc.w $68
		dc.w $46
		dc.w $24
		dc.w $46
		dc.w $68
		dc.w $AC
word_EFB4:	dc.w $6A
		dc.w $48
		dc.w $24
		dc.w $22
		dc.w $202
		dc.w $22
		dc.w $24
		dc.w $48
word_EFC4:	dc.w $2E
		dc.w $A
		dc.w 6
		dc.w 4
		dc.w 2
		dc.w 4
		dc.w 6
		dc.w $A

; =============== S U B	R O U T	I N E =======================================


sub_EFD4:
		moveq	#$10,d0
		jsr	(sub_1918).w
		bmi.w	loc_F0DE
		move.w	#0,4(a0)
		move.l	#0,$24(a0)
		lea	loc_F00E(pc),a1
		lea	($FFFFD9F2).w,a2
		move.w	#$67,d0				; "g"

loc_EFF8:
		move.w	(a1)+,(a2)+
		dbf	d0,loc_EFF8
		tst.w	($FFFFD834).w
		bne.s	loc_F00A
		move.b	#0,($FFFFDA85).w

loc_F00A:
		bra.w	loc_F0DE
; ---------------------------------------------------------------------------
loc_F00E:
		dc.w $90
		dc.w $D01
		dc.w $A514
		dc.w $98
		dc.w $90
		dc.w $D02
		dc.w $A528
		dc.w $C0
		dc.w $90
		dc.w $503
		dc.w $A530
		dc.w $E0
		dc.w $90
		dc.w $104
		dc.w $A500
		dc.w $F8
		dc.w $90
		dc.w 5
		dc.w $A54A
		dc.w $100
		dc.w $90
		dc.w $106
		dc.w $A500
		dc.w $108
		dc.w $90
		dc.w $107
		dc.w $A500
		dc.w $110
		dc.w $90
		dc.w 8
		dc.w $A54B
		dc.w $118
		dc.w $90
		dc.w $109
		dc.w $A500
		dc.w $120
		dc.w $90
		dc.w $10A
		dc.w $A500
		dc.w $128
		dc.w $A0
		dc.w $D0B
		dc.w $A534
		dc.w $98
		dc.w $A0
		dc.w $10C
		dc.w $A53C
		dc.w $B8
		dc.w $A0
		dc.w $10D
		dc.w $A500
		dc.w $D8
		dc.w $A0
		dc.w $10E
		dc.w $A570
		dc.w $E4
		dc.w $A0
		dc.w $10F
		dc.w $A502
		dc.w $F0
		dc.w $A0
		dc.w $110
		dc.w $A500
		dc.w $F8
		dc.w $A0
		dc.w $100
		dc.w $A500
		dc.w $100
		dc.w $D0
		dc.w $D12
		dc.w $A54C
		dc.w $EC
		dc.w $D0
		dc.w $113
		dc.w $A554
		dc.w $10C
		dc.w $80
		dc.w $714
		dc.w $C7F8
		dc.w $80
		dc.w $A0
		dc.w $715
		dc.w $C7F8
		dc.w $80
		dc.w $C0
		dc.w $716
		dc.w $C7F8
		dc.w $80
		dc.w $E0
		dc.w $717
		dc.w $C7F8
		dc.w $80
		dc.w $100
		dc.w $718
		dc.w $C7F8
		dc.w $80
		dc.w $120
		dc.w $719
		dc.w $C7F8
		dc.w $80
		dc.w $140
		dc.w $700
		dc.w $C7F8
		dc.w $80
; ---------------------------------------------------------------------------

loc_F0DE:
		disable_ints
		move.l	#ArtUnc_HUD,d0
		move.w	#$A000,d1
		move.w	#$800,d2
		jsr	(sub_5E8).w
		move.l	#$7F000003,(vdp_control_port).l
		move.l	#$DDDDDDDD,d0
		moveq	#$3F,d1

loc_F106:
		move.l	d0,(vdp_data_port).l
		dbf	d1,loc_F106
		enable_ints
		rts
; End of function sub_EFD4


; =============== S U B	R O U T	I N E =======================================


sub_F116:
		bsr.w	sub_F238
		move.w	d2,($FFFFD8E8).w
		move.w	d3,($FFFFD8EA).w
		bsr.w	sub_F1CA
		bsr.w	sub_F136
		rts
; End of function sub_F116


; =============== S U B	R O U T	I N E =======================================


sub_F12C:
		bsr.w	sub_F1CA
		bsr.w	sub_F136
		rts
; End of function sub_F12C


; =============== S U B	R O U T	I N E =======================================


sub_F136:
		movea.l	($FFFFD8EC).w,a0
		lea	($FFFFD8F2).w,a1
		moveq	#0,d5

loc_F140:
		move.b	(a1),d0
		addq.w	#1,d5
		cmpi.b	#$FF,d0
		beq.s	locret_F1C8
		andi.b	#$F,d0
		cmpi.b	#2,d0
		bne.s	loc_F1B8
		_move.w	0(a0),d0
		move.w	($FFFFD8DC).w,d1
		move.w	($FFFFD8E0).w,d2
		bsr.w	sub_F22C
		bcs.s	loc_F1B8
		move.w	2(a0),d0
		move.w	($FFFFD8DE).w,d1
		move.w	($FFFFD8E2).w,d2
		bsr.w	sub_F22C
		bcs.s	loc_F1B8
		movea.l	a1,a4
		lea	($FFFFD8F2).w,a3
		suba.l	a3,a4
		movea.l	a0,a5
		movea.l	a1,a6
		moveq	#$C,d0
		jsr	(sub_1918).w
		bmi.s	loc_F1B8
		move.w	4(a5),6(a0)
		_move.w	0(a5),8(a0)
		move.w	2(a5),$C(a0)
		move.w	a4,$24(a0)
		move.w	6(a5),$28(a0)
		movea.l	a5,a0
		movea.l	a6,a1
		move.b	(a1),d0
		andi.b	#$F0,d0
		ori.b	#1,d0
		move.b	d0,(a1)

loc_F1B8:
		adda.l	#8,a0
		adda.l	#1,a1
		bra.w	loc_F140
; ---------------------------------------------------------------------------

locret_F1C8:
		rts
; End of function sub_F136


; =============== S U B	R O U T	I N E =======================================


sub_F1CA:
		lea	($FFFFC9DE).w,a0
		_move.w	0(a0),d0
		move.w	$10(a0),d1
		addi.w	#$A0,d0				; "�"
		addi.w	#$70,d1				; "p"
		move.w	d0,($FFFFD8E4).w
		move.w	d1,($FFFFD8E6).w
		subi.w	#$140,d0
		bcc.s	loc_F1EE
		moveq	#0,d0

loc_F1EE:
		move.w	d0,($FFFFD8DC).w
		subi.w	#$E0,d1				; "�"
		bcc.s	loc_F1FA
		moveq	#0,d1

loc_F1FA:
		move.w	d1,($FFFFD8DE).w
		move.w	($FFFFD8E4).w,d0
		move.w	($FFFFD8E6).w,d1
		addi.w	#$140,d0
		cmp.w	($FFFFD8E8).w,d0
		bcs.s	loc_F214
		move.w	($FFFFD8E8).w,d0

loc_F214:
		move.w	d0,($FFFFD8E0).w
		addi.w	#$E0,d1				; "�"
		cmp.w	($FFFFD8EA).w,d1
		bcs.s	loc_F226
		move.w	($FFFFD8EA).w,d1

loc_F226:
		move.w	d1,($FFFFD8E2).w
		rts
; End of function sub_F1CA


; =============== S U B	R O U T	I N E =======================================


sub_F22C:
		sub.w	d1,d0
		sub.w	d1,d2
		cmp.w	d0,d2
		bcc.s	locret_F236
		rts
; ---------------------------------------------------------------------------

locret_F236:
		rts
; End of function sub_F22C


; =============== S U B	R O U T	I N E =======================================


sub_F238:
		move.l	a0,($FFFFD8EC).w
		lea	($FFFFD8F2).w,a0
		move.w	#$F,d7

loc_F244:
		move.w	#$FFFF,(a0)+
		move.w	#$FFFF,(a0)+
		move.w	#$FFFF,(a0)+
		move.w	#$FFFF,(a0)+
		move.w	#$FFFF,(a0)+
		move.w	#$FFFF,(a0)+
		move.w	#$FFFF,(a0)+
		move.w	#$FFFF,(a0)+
		dbf	d7,loc_F244
		movea.l	($FFFFD8EC).w,a0
		lea	($FFFFD8F2).w,a1

loc_F270:
		move.w	(a0),d0
		cmpi.w	#$FFFF,d0
		beq.s	locret_F284
		move.b	#2,(a1)+
		adda.l	#8,a0
		bra.s	loc_F270
; ---------------------------------------------------------------------------

locret_F284:
		rts
; End of function sub_F238


; =============== S U B	R O U T	I N E =======================================


sub_F286:
		move.w	$24(a6),d0
		lea	($FFFFD8F2).w,a0
		move.b	#2,(a0,d0.w)
		jsr	(sub_1980).w
		rts
; End of function sub_F286


; =============== S U B	R O U T	I N E =======================================


loc_F29A:
		move.w	4(a6),d0
		ori.w	#$80,d0
		move.w	d0,4(a6)
		rts
; End of function loc_F29A


; =============== S U B	R O U T	I N E =======================================


loc_F2A8:
		move.w	4(a6),d0
		andi.w	#$FF7F,d0
		move.w	d0,4(a6)
		rts
; End of function loc_F2A8

; ---------------------------------------------------------------------------
		move.w	$24(a6),d0
		lea	($FFFFD8F2).w,a1
		move.b	(a1,d0.w),d1
		andi.b	#$F0,d1
		move.b	d1,(a1,d0.w)
		jsr	(sub_1980).w
		rts

; =============== S U B	R O U T	I N E =======================================


loc_F2D0:
		move.w	8(a6),d0
		move.w	($FFFFD8DC).w,d1
		move.w	($FFFFD8E0).w,d2
		bsr.w	sub_F22C
		bcs.s	locret_F2F2
		move.w	$C(a6),d0
		move.w	($FFFFD8DE).w,d1
		move.w	($FFFFD8E2).w,d2
		bsr.w	sub_F22C

locret_F2F2:
		rts
; End of function loc_F2D0

; ---------------------------------------------------------------------------
		lea	($FFFFD8F2).w,a0
		move.w	$24(a6),d1
		move.b	d0,(a0,d1.w)
		rts
; ---------------------------------------------------------------------------
		lea	($FFFFD8F2).w,a0
		move.w	$24(a6),d1
		move.b	(a0,d1.w),d0
		rts
; ---------------------------------------------------------------------------
		jsr	(loc_F2D0).l
		bcs.s	loc_F320
		jsr	(loc_F29A).l
		rts
; ---------------------------------------------------------------------------

loc_F320:
		jsr	(loc_F2A8).l
		rts

; =============== S U B	R O U T	I N E =======================================


sub_F328:
		moveq	#0,d1
		move.w	#$20,d1
		movea.l	#ARTUNC_TitleCardBGAndPause,a0
		move.w	(a0),d2
		lsr.w	#1,d2
		adda.l	2(a0),a0
		move.l	a0,d0
		movem.l	d7/a6,-(sp)
		jsr	(sub_5E8).w
		movem.l	(sp)+,d7/a6
		moveq	#8,d0
		moveq	#$13,d1
		move.w	#$A001,d2
		move.w	($FFFFD81E).w,d3
		addi.w	#$40,d3
		jsr	(sub_86E).w
		moveq	#$28,d0
		moveq	#9,d1
		move.w	#$A001,d2
		move.w	($FFFFD81E).w,d3
		addi.w	#$980,d3
		jsr	(sub_86E).w
		rts
; End of function sub_F328


; =============== S U B	R O U T	I N E =======================================


sub_F374:
							; Level_PauseGame+70p
		tst.b	($FFFFFDC1).w
		bgt.s	loc_F37C
		bsr.s	sub_F328

loc_F37C:
		cmpi.b	#8,($FFFFFDC1).w
		bge.s	locret_F3B4
		move.b	#$11,($FFFFDA75).w
		addq.b	#2,($FFFFFDC1).w
		bra.s	loc_F3AA
; End of function sub_F374


; =============== S U B	R O U T	I N E =======================================


sub_F390:
		tst.b	($FFFFFDC1).w
		beq.s	locret_F3B4
		move.b	($FFFFDA85).w,($FFFFDA75).w
		subq.b	#2,($FFFFFDC1).w
		tst.b	($FFFFFDC1).w
		bgt.s	loc_F3AA
		bsr.w	sub_FA44

loc_F3AA:
		clr.w	d0
		move.b	($FFFFFDC1).w,d0
		jsr	loc_F3B6(pc,d0.w)

locret_F3B4:
		rts
; End of function sub_F390

; ---------------------------------------------------------------------------

loc_F3B6:
		bra.s	loc_F3C6
; ---------------------------------------------------------------------------
		bra.s	loc_F3E4
; ---------------------------------------------------------------------------
		bra.s	loc_F402
; ---------------------------------------------------------------------------
		bra.s	loc_F420
; ---------------------------------------------------------------------------
		bra.s	loc_F43E
; ---------------------------------------------------------------------------
		clr.w	($FFFFFDC1).w
		rts
; ---------------------------------------------------------------------------

loc_F3C6:
		move.w	#$9100,(vdp_control_port).l
		move.w	#$9100,($FFFFC9DA).w
		move.w	#$9200,(vdp_control_port).l
		move.w	#$9200,($FFFFC9DC).w
		rts
; ---------------------------------------------------------------------------

loc_F3E4:
		move.w	#$9193,(vdp_control_port).l
		move.w	#$9193,($FFFFC9DA).w
		move.w	#$929C,(vdp_control_port).l
		move.w	#$929C,($FFFFC9DC).w
		rts
; ---------------------------------------------------------------------------

loc_F402:
		move.w	#$9192,(vdp_control_port).l
		move.w	#$9192,($FFFFC9DA).w
		move.w	#$9299,(vdp_control_port).l
		move.w	#$9299,($FFFFC9DC).w
		rts
; ---------------------------------------------------------------------------

loc_F420:
		move.w	#$9191,(vdp_control_port).l
		move.w	#$9191,($FFFFC9DA).w
		move.w	#$9296,(vdp_control_port).l
		move.w	#$9296,($FFFFC9DC).w
		rts
; ---------------------------------------------------------------------------

loc_F43E:
		move.w	#$9190,(vdp_control_port).l
		move.w	#$9190,($FFFFC9DA).w
		move.w	#$9293,(vdp_control_port).l
		move.w	#$9293,($FFFFC9DC).w
		rts

; =============== S U B	R O U T	I N E =======================================


sub_F45C:

; FUNCTION CHUNK AT 0000F4D8 SIZE 0000000C BYTES

		moveq	#$B,d7
		lea	TitleCardBG_TileLocationArray(pc),a6

loc_F462:
		bsr.s	sub_F472
		dbf	d7,loc_F462
		jsr	VDPSetup_02
		bra.w	loc_F4D8
; End of function sub_F45C

; ---------------------------------------------------------------------------
		rts

; =============== S U B	R O U T	I N E =======================================


sub_F472:
		moveq	#0,d1
		move.w	(a6)+,d1
		movea.l	(a6)+,a0
		move.w	(a0),d2
		lsr.w	#1,d2
		adda.l	2(a0),a0
		move.l	a0,d0
		movem.l	d7/a6,-(sp)
		jsr	(sub_568).w
		movem.l	(sp)+,d7/a6
		rts
; End of function sub_F472

; ---------------------------------------------------------------------------
TitleCardBG_TileLocationArray:dc.w $40
		dc.l TCBG_Tile2
		dc.w $60
		dc.l TCBG_Tile3
		dc.w $80
		dc.l TCBG_Tile4
		dc.w $A0
		dc.l TCBG_Tile5
		dc.w $C0
		dc.l TCBG_Tile6
		dc.w $E0
		dc.l TCBG_Tile7
		dc.w $100
		dc.l TCBG_Tile8
		dc.w $120
		dc.l TCBG_Tile9
		dc.w $140
		dc.l TCBG_TileA
		dc.w $160
		dc.l TCBG_TileB
		dc.w $1A0
		dc.l TCBG_TileC
		dc.w $1E0
		dc.l TCBG_TileD
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_F45C

loc_F4D8:
		move.b	#1,($FFFFFDC2).w
		bsr.w	sub_F4E4
		rts
; END OF FUNCTION CHUNK	FOR sub_F45C

; =============== S U B	R O U T	I N E =======================================


sub_F4E4:
		clr.w	($FFFFFDC4).w
		clr.w	($FFFFFDC6).w
		clr.w	($FFFFFDC8).w
		clr.w	($FFFFFDCA).w
		clr.w	($FFFFFDCC).w
		clr.w	($FFFFFDCE).w
		rts
; End of function sub_F4E4


; =============== S U B	R O U T	I N E =======================================


sub_F4FE:
		bclr	#7,($FFFFFFC9).w

loc_F504:
		tst.b	($FFFFFFC9).w
		bpl.s	loc_F504
		move.w	($FFFFFDC4).w,d0
		cmpi.w	#$14,d0
		bge.s	locret_F536
		jsr	loc_F520(pc,d0.w)
		jsr	(BuildSprites).w
		bra.s	sub_F4FE
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

loc_F520:
		bra.w	loc_F59E
; ---------------------------------------------------------------------------
		bra.w	loc_F612
; ---------------------------------------------------------------------------
		bra.w	loc_F668
; ---------------------------------------------------------------------------
		bra.w	loc_F884
; ---------------------------------------------------------------------------
		bra.w	loc_F720
; ---------------------------------------------------------------------------
		clr.w	d0

locret_F536:
		rts
; End of function sub_F4FE


; =============== S U B	R O U T	I N E =======================================


sub_F538:
		bclr	#7,($FFFFFFC9).w

loc_F53E:
		tst.b	($FFFFFFC9).w
		bpl.s	loc_F53E
		jsr	(sub_96E).w
		jsr	(BuildSprites).w
		tst.b	($FFFFFDC2).w
		beq.s	loc_F562
		btst	#7,($FFFFC93D).w
		beq.s	sub_F538
		clr.b	($FFFFFDC2).w
		clr.w	($FFFFFDC4).w

loc_F562:
		move.w	($FFFFFDC4).w,d0
		cmpi.w	#$14,d0
		bge.s	locret_F58A
		jsr	loc_F574(pc,d0.w)
		bra.s	sub_F538
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

loc_F574:
		bra.w	loc_F7E8
; ---------------------------------------------------------------------------
		bra.w	loc_F8B2
; ---------------------------------------------------------------------------
		bra.w	loc_F6B8
; ---------------------------------------------------------------------------
		bra.w	loc_F63C
; ---------------------------------------------------------------------------
		bra.w	loc_F5C2
; ---------------------------------------------------------------------------
		clr.w	d0

locret_F58A:
		rts
; End of function sub_F538


; =============== S U B	R O U T	I N E =======================================


sub_F58C:
		moveq	#$28,d0
		moveq	#$20,d1
		move.w	#$8002,d2
		move.w	($FFFFD816).w,d3
		jsr	(sub_86E).w
		rts
; End of function sub_F58C

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_F4FE

loc_F59E:
		addq.w	#2,($FFFFFDC6).w
		moveq	#$40,d0
		move.w	($FFFFFDC6).w,d1
		move.w	#$8003,d2
		move.w	($FFFFD816).w,d3
		jsr	(sub_86E).w
		cmpi.w	#$20,($FFFFFDC6).w		; " "
		ble.s	locret_F5C0
		addq.w	#4,($FFFFFDC4).w

locret_F5C0:
		rts
; END OF FUNCTION CHUNK	FOR sub_F4FE
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_F538

loc_F5C2:
		subq.w	#2,($FFFFFDC6).w
		tst.w	($FFFFFDC6).w
		bge.s	loc_F5D8
		addq.w	#4,($FFFFFDC4).w
		move.w	($FFFFCA3C).w,($FFFFC9FC).w
		rts
; ---------------------------------------------------------------------------

loc_F5D8:
		lea	($FFFFC9DE).w,a1
		lea	(unk_0A00&$FFFFFF).l,a3
		lea	(unk_0B02&$FFFFFF).l,a4
		movea.l	a1,a5
		movea.l	a3,a0
		_move.w	0(a1),d0
		move.w	($FFFFFDC6).w,d1
		lsl.w	#3,d1
		add.w	$10(a1),d1
		move.w	$18(a1),d4
		jsr	(sub_1272).w
		movea.l	a0,a3
		disable_ints
		jsr	(sub_14E4).w
		move	#$2000,sr
		rts
; END OF FUNCTION CHUNK	FOR sub_F538
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_F4FE

loc_F612:
		addq.w	#2,($FFFFFDC8).w
		moveq	#2,d0
		moveq	#5,d1
		move.w	#$8004,d2
		moveq	#$28,d3
		sub.w	($FFFFFDC8).w,d3
		lsl.w	#1,d3
		add.w	($FFFFD816).w,d3
		jsr	(sub_86E).w
		cmpi.w	#$28,($FFFFFDC8).w
		blt.s	locret_F63A
		addq.w	#4,($FFFFFDC4).w

locret_F63A:
		rts
; END OF FUNCTION CHUNK	FOR sub_F4FE
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_F538

loc_F63C:
		subq.w	#2,($FFFFFDC8).w
		tst.w	($FFFFFDC8).w
		bge.s	loc_F652
		addq.w	#4,($FFFFFDC4).w
		move.w	#$104,($FFFFC9FC).w
		rts
; ---------------------------------------------------------------------------

loc_F652:
		moveq	#$28,d0
		sub.w	($FFFFFDC8).w,d0
		moveq	#5,d1
		move.w	#$8003,d2
		move.w	($FFFFD816).w,d3
		jsr	(sub_86E).w
		rts
; END OF FUNCTION CHUNK	FOR sub_F538
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_F4FE

loc_F668:
		addq.w	#1,($FFFFFDCA).w
		move.w	($FFFFFDCA).w,d0
		moveq	#$1C,d1
		move.w	#$8005,d2
		move.w	($FFFFD816).w,d3
		move.w	d3,-(sp)
		jsr	(sub_86E).w
		move.w	(sp)+,d3
		add.w	($FFFFFDCA).w,d3
		add.w	($FFFFFDCA).w,d3
		move.l	#$800B800C,d0
		moveq	#5,d1
		move.w	d3,-(sp)
		bsr.w	sub_F904
		move.w	(sp)+,d3
		move.l	#$800E800D,d0
		moveq	#$17,d1
		addi.w	#$280,d3
		bsr.w	sub_F904
		cmpi.w	#9,($FFFFFDCA).w
		blt.s	locret_F6B6
		addq.w	#4,($FFFFFDC4).w

locret_F6B6:
		rts
; END OF FUNCTION CHUNK	FOR sub_F4FE
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_F538

loc_F6B8:
		subq.w	#1,($FFFFFDCA).w
		cmpi.w	#$FFFF,($FFFFFDCA).w
		bge.s	loc_F6CA
		addq.w	#4,($FFFFFDC4).w
		rts
; ---------------------------------------------------------------------------

loc_F6CA:
		moveq	#1,d0
		moveq	#5,d1
		move.w	#$8004,d2
		move.w	($FFFFFDCA).w,d3
		addq.w	#1,d3
		lsl.w	#1,d3
		add.w	($FFFFD816).w,d3
		movem.w	d0/d3,-(sp)
		jsr	(sub_86E).w
		movem.w	(sp)+,d0/d3
		moveq	#$19,d1
		move.w	#$8003,d2
		move.w	d3,-(sp)
		addi.w	#$280,d3
		jsr	(sub_86E).w
		move.w	(sp)+,d3
		move.l	#$800B800C,d0
		moveq	#5,d1
		subq.w	#2,d3
		move.w	d3,-(sp)
		bsr.w	sub_F904
		move.w	(sp)+,d3
		move.l	#$800E800D,d0
		moveq	#$17,d1
		addi.w	#$280,d3
		bsr.w	sub_F904
		rts
; END OF FUNCTION CHUNK	FOR sub_F538
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_F4FE

loc_F720:
		addq.w	#1,($FFFFFDCC).w
		moveq	#1,d0
		moveq	#$28,d3
		sub.w	($FFFFFDCC).w,d3
		lsl.w	#1,d3
		add.w	($FFFFD816).w,d3
		moveq	#5,d1
		move.w	#$8007,d2
		movem.w	d0/d3,-(sp)
		jsr	(sub_86E).w
		movem.w	(sp)+,d0/d3
		moveq	#2,d1
		move.w	#$8009,d2
		movem.w	d0/d2-d3,-(sp)
		addi.w	#$280,d3
		jsr	(sub_86E).w
		movem.w	(sp)+,d0/d2-d3
		moveq	#$F,d1
		movem.w	d0/d3,-(sp)
		addi.w	#$480,d3
		jsr	(sub_86E).w
		movem.w	(sp)+,d0/d3
		moveq	#6,d1
		move.w	#$8008,d2
		addi.w	#$B00,d3
		jsr	(sub_86E).w
		moveq	#1,d1
		moveq	#$1C,d3
		sub.w	($FFFFFDCC).w,d3
		lsl.w	#7,d3
		add.w	($FFFFD816).w,d3
		moveq	#9,d0
		move.w	#$8006,d2
		movem.w	d1/d3,-(sp)
		jsr	(sub_86E).w
		movem.w	(sp)+,d1/d3
		move.l	#$800F8010,d0
		addi.w	#$12,d3
		movem.w	d1/d3,-(sp)
		bsr.w	sub_F904
		movem.w	(sp)+,d1/d3
		moveq	#$18,d0
		move.w	#$8009,d2
		addq.w	#2,d3
		movem.w	d1/d3,-(sp)
		jsr	(sub_86E).w
		movem.w	(sp)+,d1/d3
		moveq	#6,d0
		move.w	#$8008,d2
		addi.w	#$30,d3				; "0"
		jsr	(sub_86E).w
		cmpi.w	#6,($FFFFFDCC).w
		blt.s	locret_F7E6
		cmpi.w	#6,($FFFFFDCC).w
		blt.s	locret_F7E6
		addq.w	#4,($FFFFFDC4).w

locret_F7E6:
							; sub_F4FE+2E2j
		rts
; END OF FUNCTION CHUNK	FOR sub_F4FE
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_F538

loc_F7E8:
		subq.w	#1,($FFFFFDCC).w
		tst.w	($FFFFFDCC).w
		bge.s	loc_F7F8
		addq.w	#4,($FFFFFDC4).w
		rts
; ---------------------------------------------------------------------------

loc_F7F8:
		moveq	#6,d0
		sub.w	($FFFFFDCC).w,d0
		move.w	($FFFFD816).w,d3
		addi.w	#$44,d3				; "D"
		moveq	#5,d1
		move.w	#$8004,d2
		movem.w	d0/d3,-(sp)
		jsr	(sub_86E).w
		movem.w	(sp)+,d0/d3
		moveq	#2,d1
		move.w	#$8003,d2
		movem.w	d0/d2-d3,-(sp)
		addi.w	#$280,d3
		jsr	(sub_86E).w
		movem.w	(sp)+,d0/d2-d3
		moveq	#$13,d1
		sub.w	($FFFFFDCC).w,d1
		addi.w	#$480,d3
		jsr	(sub_86E).w
		moveq	#6,d1
		sub.w	($FFFFFDCC).w,d1
		move.w	($FFFFD816).w,d3
		addi.w	#$B00,d3
		moveq	#9,d0
		move.w	#$8005,d2
		movem.w	d1/d3,-(sp)
		jsr	(sub_86E).w
		movem.w	(sp)+,d1/d3
		move.l	#$800E800D,d0
		addi.w	#$12,d3
		movem.w	d1/d3,-(sp)
		subi.w	#$80,d3
		bsr.w	sub_F904
		movem.w	(sp)+,d1/d3
		moveq	#$18,d0
		move.w	#$8003,d2
		addq.w	#2,d3
		jsr	(sub_86E).w
		rts
; END OF FUNCTION CHUNK	FOR sub_F538
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_F4FE

loc_F884:
		addq.w	#3,($FFFFFDCE).w
		moveq	#3,d0
		moveq	#2,d1
		move.w	#$800A,d2
		moveq	#$28,d3
		sub.w	($FFFFFDCE).w,d3
		lsl.w	#1,d3
		addi.w	#$380,d3
		add.w	($FFFFD816).w,d3
		jsr	(sub_86E).w
		cmpi.w	#$21,($FFFFFDCE).w		; "!"
		blt.s	locret_F8B0
		addq.w	#4,($FFFFFDC4).w

locret_F8B0:
		rts
; END OF FUNCTION CHUNK	FOR sub_F4FE
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_F538

loc_F8B2:
		subq.w	#3,($FFFFFDCE).w
		tst.w	($FFFFFDCE).w
		bge.s	loc_F8C2
		addq.w	#4,($FFFFFDC4).w
		rts
; ---------------------------------------------------------------------------

loc_F8C2:
		moveq	#2,d1
		move.w	($FFFFD816).w,d3
		addi.w	#$380,d3
		addi.w	#$E,d3
		moveq	#$1E,d0
		sub.w	($FFFFFDCE).w,d0
		bne.s	loc_F8F8
		moveq	#2,d0
		move.w	#$8005,d2
		movem.w	d1/d3,-(sp)
		jsr	(sub_86E).w
		movem.w	(sp)+,d1/d3
		move.l	#$800E800D,d0
		addq.w	#4,d3
		bsr.w	sub_F904
		rts
; ---------------------------------------------------------------------------

loc_F8F8:
		move.w	#$8003,d2
		addq.w	#6,d3
		jsr	(sub_86E).w
		rts
; END OF FUNCTION CHUNK	FOR sub_F538

; =============== S U B	R O U T	I N E =======================================


sub_F904:
							; sub_F4FE+1A8p ...
		btst	#7,d3
		beq.s	loc_F90C
		swap	d0

loc_F90C:
		lsl.l	#2,d3
		lsr.w	#2,d3
		ori.w	#$4000,d3
		swap	d3
		andi.w	#3,d3
		lea	(vdp_data_port).l,a1
		move.w	#$8F80,(vdp_control_port).l
		move.w	#$8F80,($FFFFC9D6).w
		move.l	d3,4(a1)
		lsr.l	#1,d1

loc_F934:
		move.l	d0,(a1)
		dbf	d1,loc_F934
		move.w	#$8F02,(vdp_control_port).l
		move.w	#$8F02,($FFFFC9D6).w
		rts
; End of function sub_F904


; =============== S U B	R O U T	I N E =======================================


sub_F94A:
		move.w	#$FFFF,($FFFFF9C0).w
		rts
; End of function sub_F94A

; ---------------------------------------------------------------------------
		rts

; =============== S U B	R O U T	I N E =======================================


Level_AnimateBG:
		move.w	($FFFFD834).w,d0
		add.w	d0,d0
		lea	loc_F964(pc),a0
		adda.w	(a0,d0.w),a0
		jmp	(a0)
; End of function Level_AnimateBG

; ---------------------------------------------------------------------------
loc_F964:	dc.w locret_FA0A-loc_F964
		dc.w loc_FA0C-loc_F964
		dc.w locret_FA0A-loc_F964
		dc.w locret_FA0A-loc_F964
		dc.w locret_FA0A-loc_F964
		dc.w locret_FA0A-loc_F964
		dc.w locret_FA0A-loc_F964
		dc.w locret_FA0A-loc_F964
; ---------------------------------------------------------------------------

loc_F974:
		lea	($FFFFF9C0).w,a6
		move.w	(a6),d7
		bpl.w	loc_F9BC
		lea	2(a6),a5

loc_F982:
		move.w	(a0)+,d0
		beq.s	locret_FA04
		lea	-2(a0,d0.w),a1
		lea	(a5),a4
		clr.w	(a4)+
		move.l	a1,(a4)+
		move.b	(a1)+,(a4)+
		move.b	(a1)+,(a4)+
		move.w	(a1)+,(a4)+
		move.w	(a0)+,d0
		moveq	#0,d1
		move.b	(a0)+,d1
		add.w	d1,d1
		movea.w	loc_FA06(pc,d1.w),a2
		move.w	(a2),d1
		lsl.w	#5,d1
		add.w	d1,d0
		move.w	d0,(a4)+
		move.l	(a1)+,(a4)+
		move.b	(a0)+,d0
		add.b	6(a5),d0
		move.b	d0,(a5)
		lea	$10(a5),a5
		addq.w	#1,(a6)
		bra.s	loc_F982
; ---------------------------------------------------------------------------

loc_F9BC:
		move.w	(a6)+,d7

loc_F9BE:
		subq.b	#1,(a6)
		bne.s	loc_F9FC
		move.b	6(a6),(a6)
		moveq	#1,d0
		add.b	1(a6),d0
		cmp.b	7(a6),d0
		bcs.s	loc_F9D4
		moveq	#0,d0

loc_F9D4:
		move.b	d0,1(a6)
		add.w	d0,d0
		add.w	d0,d0
		movea.l	2(a6),a0
		move.l	4(a0,d0.w),d0
		move.w	$A(a6),d1
		move.w	8(a6),d2
		move.l	d0,$C(a6)
		movem.l	d7/a6,-(sp)
		jsr	(sub_568).w
		movem.l	(sp)+,d7/a6

loc_F9FC:
		lea	$10(a6),a6
		dbf	d7,loc_F9BE

locret_FA04:
		rts
; ---------------------------------------------------------------------------

loc_FA06:
		muls.w	loc_C442(pc),d4
locret_FA0A:
		rts
; ---------------------------------------------------------------------------

loc_FA0C:
		lea	TTZ_AniTileLocs(pc),a0
		bra.w	loc_F974
; ---------------------------------------------------------------------------
TTZ_AniTileLocs:dc.l $001023E0
		dc.l $00000016
		dc.l $29600101
		dc.l $00000000
		dc.l $04020100
		dc.l ARTUNC_TTZAnimatedFanFG1
		dc.l ARTUNC_TTZAnimatedFanFG2
		dc.l $02040200
		dc.l ARTUNC_TTZAnimatedTurbineBG1
		dc.l ARTUNC_TTZAnimatedTurbineBG2
		dc.l ARTUNC_TTZAnimatedTurbineBG3
		dc.l ARTUNC_TTZAnimatedTurbineBG4
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Some sort of DMA cue system for uncompressed art such as animated tiles and HUD
; ---------------------------------------------------------------------------

sub_FA44:
		move.w	UnkReps(pc),d7			; load number of repeat times (22) to d7
		lea	UnkReps+2(pc),a0		; load data location to a0

loc_FA4C:
		move.w	(a0)+,d1			; load VRam location
		add.w	($FFFFD81E).w,d1
		move.l	(a0)+,d0			; load art location to d0
		move.w	(a0)+,d2			; load size of art to d2
		movem.l	d7-a0,-(sp)			; store all register data to the stack pointer
		jsr	(sub_5E8).w			; dump art
		movem.l	(sp)+,d7-a0			; reload art from stack
		dbf	d7,loc_FA4C			; repeat til all uncompressed art is loaded to their respected locations
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Uncompressed Animated PLC Table
; ---------------------------------------------------------------------------

UnkReps:	dc.w $0022				; number of uncompressed art files to read
		dc.w $0000				; VRam location
		dc.l AniArt_Hud1to9_Sym			; "0" Hud	; location of Art
		dc.w $0020				; size of Art
		dc.w $0080
		dc.l AniArt_Hud1to9_Sym+$40		; "1" Hud
		dc.w $0020
		dc.w $0100
		dc.l AniArt_Hud1to9_Sym+$80		; "2" Hud
		dc.w $0020
		dc.w $0180
		dc.l AniArt_Hud1to9_Sym+$C0		; "3" Hud
		dc.w $0020
		dc.w $0200
		dc.l AniArt_Hud1to9_Sym+$100		; "4" Hud
		dc.w $0020
		dc.w $0280
		dc.l AniArt_Hud1to9_Sym+$140		; "5" Hud
		dc.w $0020
		dc.w $0300
		dc.l AniArt_Hud1to9_Sym+$180		; "6" Hud
		dc.w $0020
		dc.w $0380
		dc.l AniArt_Hud1to9_Sym+$1C0		; "7" Hud
		dc.w $0020
		dc.w $0400
		dc.l AniArt_Hud1to9_Sym+$200		; "8" Hud
		dc.w $0020
		dc.w $0480
		dc.l AniArt_Hud1to9_Sym+$240		; "9" Hud
		dc.w $0020
		dc.w $0500
		dc.l AniArt_Hud1to9_Sym+$280		; "!" Hud (Unused)
		dc.w $0020
		dc.w $0580
		dc.l AniArt_Hud1to9_Sym+$2C0		; """ (Minute/Second Symbol)
		dc.w $0020
		dc.w $0600
		dc.l AniArt_MiliSymbol			; "" (Second/Mili-Second Symbol)
		dc.w $0020
		dc.w $0680
		dc.l AniArt_RingSprites+$1C0		; Ring Sprite (Frame 3)
		dc.w $0020
		dc.w $0700
		dc.l AniArt_SLTime			; "/TIME" (Unused)
		dc.w $0020
		dc.w $0780
		dc.l ARTUNC_TTZAnimatedTurbineBG5	; animated turbine (Frame 8)
		dc.w $0020
		dc.w $0800
		dc.l ARTUNC_TTZAnimatedTurbineBG7	; animated turbine (Frame 7)
		dc.w $0020
		dc.w $0880
		dc.l ARTUNC_TTZAnimatedTurbineBG6	; animated turbine (Frame 6)
		dc.w $0020
		dc.w $0900
		dc.l AniArt_RingSprites+$80		; 5 Point Stars (Unused)
		dc.w $0020
		dc.w $0840
		dc.l AniArt_Tether			; Tether (Frame 1)
		dc.w $0010
		dc.w $08C0
		dc.l AniArt_Tether+$20			; Tether (Frame 2)
		dc.w $0010
		dc.w $0940
		dc.l AniArt_Tether+$40			; Tether (Frame 3)
		dc.w $0010
		dc.w $09C0
		dc.l AniArt_Tether+$60			; Tether (Frame 4)
		dc.w $0010
		dc.w $0980
		dc.l AniArt_MultiStars			; Vertical Star (Frame 1) (Unused)
		dc.w $0020
		dc.w $0A00
		dc.l AniArt_MultiStars+$40		; Horizontal Star (Frame 1) Vertical Star (Frame 2) (Unused)
		dc.w $0020
		dc.w $0A80
		dc.l AniArt_MultiStars+$C0		; Horizontal Star (Frame 2) (Unused) Chain? (Unused)
		dc.w $0040
		dc.w $0B00
		dc.l AniArt_MultiStars+$140		; Vertical and Horizontal White Star (Unused)
		dc.w $0040
		dc.w $0B80
		dc.l AniArt_MultiStars+$1C0		; More Chain Pieces? (Unused)
		dc.w $0040
		dc.w $0C00
		dc.l AniArt_MultiStars+$240		; Vertical and Horizontal White Star (Exact same design as the one before) (Unused)
		dc.w $0040
		dc.w $0C80
		dc.l AniArt_MultiStars+$2C0		; Vertical and Horizontal White Star (More Sparkly) (Unused)
		dc.w $0040
		dc.w $0D00
		dc.l AniArt_MultiStars+$340		; Centre of Night Sky Styled Star (Unused)
		dc.w $0040
		dc.w $0D80
		dc.l AniArt_MultiStars+$3C0		; Edges of Night Sky Styled Star (Unused)
		dc.w $0040
		dc.w $0E00
		dc.l AniArt_RingSprites+$C0		; Ring Sprite (Frame 1)
		dc.w $0040
		dc.w $0E80
		dc.l AniArt_RingSprites+$140		; Ring Sprite (Frame 2)
		dc.w $0040
		dc.w $0F00
		dc.l AniArt_RingSprites			; Stars (Ring Collect)
		dc.w $0040
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (0000FB82 - 0000FDAF)
; Striped out
; UnkData_0000FB82:
		binclude	"UnknownCodes/UnknownData_0000FB82.bin"
		even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (0000FDB0 - 0000FFFF)
; Striped out
; UnkData_0000FDB0:
		binclude	"UnknownCodes/UnknownData_0000FDB0.bin"
		even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Music Data (Z80 aligned to $00010000)
; ---------------------------------------------------------------------------
MusicBank:	startBank
Music81:	include	"Sound/Music/Mus81 - Electoria.asm"
Music82:	include	"Sound/Music/Mus82 - Walkin'.asm"
Music83:	include	"Sound/Music/Mus83 - Hyper-Hyper.asm"
Music84:	include	"Sound/Music/Mus84 - Evening Star.asm"
Music85:	include	"Sound/Music/Mus85 - Moonrise.asm"
Music86:	include	"Sound/Music/Mus86 - Game Over.asm"
		even
		finishBank
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (00011C66 - 00012250)
; Striped out
; UnkData_00011C66:
		binclude	"UnknownCodes/UnknownData_00011C66.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (00012251 - 000123FF)
; Striped out
; UnkData_00012251:
		binclude	"UnknownCodes/UnknownData_00012251.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (00012400 - 00012FFF)
; Striped out
; UnkData_00012400:
		binclude	"UnknownCodes/UnknownData_00012400.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (00013000 - 000145FF)
; Striped out
; UnkData_00013000:
		binclude	"UnknownCodes/UnknownData_00013000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (00014600 - 000150FF)
; Striped out
; UnkData_00014600:
		binclude	"UnknownCodes/UnknownData_00014600.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (00015100 - 0001562F)
; Striped out
; UnkData_00013000:
		binclude	"UnknownCodes/UnknownData_00015100.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $00016000, Unknown Data
; ---------------------------------------------------------------------------
	align $1000
; ---------------------------------------------------------------------------
; Data Location (00016000 - 00016703)
; Striped out
; UnkData_00016000:
		binclude	"UnknownCodes/UnknownData_00016000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $00018000, Sound Data (Unused by Z80)
; ---------------------------------------------------------------------------
SoundBank:	startBank
SoundA0:	include	"Sound/SFX/SndA0 - Jump.asm"	; Jump SFX (Same as Sonic CD FM NO.02)
SoundA1:	include	"Sound/SFX/SndA1 - Cash Register.asm" ; Cash Machine SFX (Same as Sonic 1 SFX C5)
SoundA2:	include	"Sound/SFX/SndA2.asm"		; strange noise (it has modulation of "01 01 28 00", which the "00" makes the modulation do nothing) (this MAY be a "get hit by spikes" SFX unfinished)
SoundA3:	include	"Sound/SFX/SndA3 - Bomb.asm"	; Bomb explode SFX (Same as Sonic 1 SFX C4)
SoundA4:	include	"Sound/SFX/SndA4 - Skid.asm"	; Skidding SFX (Same as Sonic 1 SFX A4)
SoundA5:	include	"Sound/SFX/SndA5 - Ring Loss.asm" ; Ring Loss SFX (Same as Sonic 1 SFX C6)
SoundA6:	include	"Sound/SFX/SndA6 - Ring.asm"	; Ring Collect SFX (Same as Sonic 1 SFX B5) (Plays on Right Speaker, may very well be the "right to left to right" speaker thing)
SoundA7:	include	"Sound/SFX/SndA7 - Break Item.asm" ; Destroy Badnik/Monitor SFX (Same a Sonic 3 SFX 3D)
SoundA8:	include	"Sound/SFX/SndA8 - Spring.asm"	; Spring SFX (Same as Sonic 3 SFX B1)
SoundA9:	include	"Sound/SFX/SndA9 - Lamppost.asm" ; Check Point SFX (Same as Sonic 1 SFX A1)
; ---------------------------------------------------------------------------
; these SFX below play Nothing (plays F2 straight away and does nothing)
; however they have the same SMPS Instrument in each of them ("blurrr.. (buzzer) noise with static")
; I'm asuming these are just simply blank SFX slots ready to be used when the sound
; programmers needed them.
; ---------------------------------------------------------------------------
SoundAA:	include	"Sound/SFX/SndAA.asm"
SoundAB:	include	"Sound/SFX/SndAB.asm"
SoundAC:	include	"Sound/SFX/SndAC.asm"
SoundAD:	include	"Sound/SFX/SndAD.asm"
SoundAE:	include	"Sound/SFX/SndAE.asm"
SoundAF:	include	"Sound/SFX/SndAF.asm"
		finishBank
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Uncompressed Hud Patterns (Unused)
; ---------------------------------------------------------------------------
; Uncompressed grahics that look like a mini version of a hud
; ---------------------------------------------------------------------------
; Data Location (00018341 - 00018740)
; Striped out
; UnkData_00018341:
		binclude	"UnknownCodes/UnknownData_00018341.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (00018741 - 0001C98F)
; Striped out
; UnkData_00018741:
		binclude	"UnknownCodes/UnknownData_00018741.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (0001C990 - 0001CD8F)
; Striped out
; UnkData_0001C990:
		binclude	"UnknownCodes/UnknownData_0001C990.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (0001CD90 - 0001F761)
; Striped out
; UnkData_0001CD90:
		binclude	"UnknownCodes/UnknownData_0001CD90.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; (The usual similar data)
; ---------------------------------------------------------------------------
; Data Location (0001F762 - 0001FB61)
; Striped out
; UnkData_0001F762:
		binclude	"UnknownCodes/UnknownData_0001F762.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (0001FB62 - 0001FFFF)
; Striped out
; UnkData_0001FB62:
		binclude	"UnknownCodes/UnknownData_0001FB62.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $00020000, PCM Voice Data
; ---------------------------------------------------------------------------
DACBank:	startBank
DAC_Sample1:	binclude	"Sound/DAC/Kick.dpcm"	; DAC 81 (Beat Sample)
DAC_Sample1_End:even
DAC_Sample2:	binclude	"Sound/DAC/Snare.dpcm"	; DAC 82 (Snare Sample)
DAC_Sample2_End:even
DAC_Sample3:	binclude	"Sound/DAC/Tom.dpcm"	; DAC 83-85 [Hi to Low pitches] (Timpani/Tom-beat Sample)
DAC_Sample3_End:even
; ---------------------------------------------------------------------------
; these two samples are read in the Z80 table and can be heard when note 86
; and 87 are triggered in the SMPS music (however they are not used in any of
; the SMPS music)
; ---------------------------------------------------------------------------
DAC_Sample4:	binclude	"Sound/DAC/Let's Go.dpcm" ; DAC 86 (Unknown voice "Let"s Go" or "Ley"k Go" in Japanese accent)
DAC_Sample4_End:even
DAC_Sample5:	binclude	"Sound/DAC/Hey.dpcm"	; DAC 87 (Unknown voice "Hey!" or "Hez!" in Japanese accent)
DAC_Sample5_End:even
		finishBank
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (000244A2 - 000247EF)
; Striped out
; UnkData_000244A2:
		binclude	"UnknownCodes/UnknownData_000244A2.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (000247F0 - 00026009)
; Striped out
; UnkData_000247F0:
		binclude	"UnknownCodes/UnknownData_000247F0.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (0002600A - 00028844)
; Striped out
; UnkData_0002600A:
		binclude	"UnknownCodes/UnknownData_0002600A.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (00028845 - 0002A222)
; Striped out
; UnkData_00028845:
		binclude	"UnknownCodes/UnknownData_00028845.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (0002A223 - 0002AC5F)
; Striped out
; UnkData_0002A223:
		binclude	"UnknownCodes/UnknownData_0002A223.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $0002C000, Unknown Data
; ---------------------------------------------------------------------------
	align $2000
; ---------------------------------------------------------------------------
; Data Location (0002C000 - 0002D1FF)
; Striped out
; UnkData_0002C000:
		binclude	"UnknownCodes/UnknownData_0002C000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $00030000, Used Multiple Data
; ---------------------------------------------------------------------------
	align $3000
; ---------------------------------------------------------------------------
ArtUnc_HUD:
	binclude	"artunc/Hud.bin"		; Hud Patterns
	even
; ---------------------------------------------------------------------------
ARTNEM_RingTetherStarsUnused:
	binclude	"artnem/Unused - Ring Tether Stars.bin" ; unused Ring tether stars
	even
; ---------------------------------------------------------------------------
ARTNEM_SSZ8x8_FG:
	binclude	"artnem/8x8 - SSZ FG.bin"	; 8x8 tiles for SSZ FG
	even
; ---------------------------------------------------------------------------
MAPENI_SSZ16x16_FG:
	binclude	"map16/SSZ FG.bin"		; 16x16 blocks for SSZ FG
	even
; ---------------------------------------------------------------------------
MAPENI_SSZ128x128_FG:
	binclude	"map128/SSZ FG.bin"		; 128x128 chunks for SSZ FG
	even
; ---------------------------------------------------------------------------
MAPENI_SSZLayout_FG:
	binclude	"levels/SSZ FG.bin"		; Layout for SSZ FG
	even
; ---------------------------------------------------------------------------
COL_SSZPrimary:
	binclude	"collide/ColSSZPrimary.bin"	; Primary Collisions for SSZ
	even
; ---------------------------------------------------------------------------
COL_SSZSecondary:
	binclude	"collide/ColSSZSecondary.bin"	; Secondary Collisions for SSZ
	even
; ---------------------------------------------------------------------------
ARTNEM_SSZ8x8_BG:
	binclude	"artnem/8x8 - SSZ BG.bin"	; 8x8 tiles for SSZ BG
	even
; ---------------------------------------------------------------------------
MAPENI_SSZ16x16_BG:
	binclude	"map16/SSZ BG.bin"		; 16x16 blocks for SSZ BG
	even
; ---------------------------------------------------------------------------
MAPENI_SSZ128x128_BG:
	binclude	"map128/SSZ BG.bin"		; 128x128 chunks for SSZ BG
	even
; ---------------------------------------------------------------------------
MAPENI_SSZLayout_BG:
	binclude	"levels/SSZ BG.bin"		; Layout for SSZ BG
	even
; ---------------------------------------------------------------------------
ARTNEM_TTZ8x8_FG:
	binclude	"artnem/8x8 - TTZ FG.bin"	; 8x8 tiles for TTZ FG
	even
; ---------------------------------------------------------------------------
MAPENI_TTZ16x16_FG:
	binclude	"map16/TTZ FG.bin"		; 16x16 blocks for TTZ FG
	even
; ---------------------------------------------------------------------------
MAPENI_TTZ128x128_FG:
	binclude	"map128/TTZ FG.bin"		; 128x128 chunks for TTZ FG
	even
; ---------------------------------------------------------------------------
MAPENI_TTZLayout_FG:
	binclude	"levels/TTZ FG.bin"		; Layout for TTZ FG
	even
; ---------------------------------------------------------------------------
COL_TTZPrimary:
	binclude	"collide/ColTTZPrimary.bin"	; Primary Collisions for TTZ
	even
; ---------------------------------------------------------------------------
COL_TTZSecondary:
	binclude	"collide/ColTTZSecondary.bin"	; Secondary Collisions for TTZ
	even
; ---------------------------------------------------------------------------
ARTNEM_TTZ8x8_BG:
	binclude	"artnem/8x8 - TTZ BG.bin"	; 8x8 tiles for TTZ BG
	even
; ---------------------------------------------------------------------------
MAPENI_TTZ16x16_BG:
	binclude	"map16/TTZ BG.bin"		; 16x16 blocks for TTZ BG
	even
; ---------------------------------------------------------------------------
MAPENI_TTZ128x128_BG:
	binclude	"map128/TTZ BG.bin"		; 128x128 chunks for TTZ BG
	even
; ---------------------------------------------------------------------------
MAPENI_TTZLayout_BG:
	binclude	"levels/TTZ BG.bin"		; Layout for TTZ BG
	even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Title Card and Pause Bar Patterns
; ---------------------------------------------------------------------------
; Note:
; in this section you'll notice the bytes...
;
;		dc.w 32
;		dc.l $6
;
; ...right before the art itself, allow me to explain what it is:
;
; "32" is the number of bytes long the current art tile(s) are
; "6" gets added to the address of the art label to tell the engine
; where the art is, (basically telling it to jump over that first word and
; long-word code to get to the art that is directly after it).
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
ARTUNC_TitleCardBGAndPause:
		dc.w 32					; 32 bytes (1 tile)
		dc.l 6					; jump forward 6 bytes to art
		binclude "artunc/TCBG1.bin"		; Yellow Pause Bar
; ---------------------------------------------------------------------------
TCBG_Tile2:
		dc.w 32					; 32 bytes (1 tile)
		dc.l 6					; jump forward 6 bytes to art
		binclude "artunc/TCBG2.bin"		; Title Card - Black tiles that appear to hide the level design before the title card appears
; ---------------------------------------------------------------------------
TCBG_Tile3:
		dc.w 32					; 32 bytes (1 tile)
		dc.l 6					; jump forward 6 bytes to art
		binclude "artunc/TCBG3.bin"		; Title Card - Dark Gray/Blue Bar that comes down first
; ---------------------------------------------------------------------------
TCBG_Tile4:
		dc.w 32					; 32 bytes (1 tile)
		dc.l 6					; jump forward 6 bytes to art
		binclude "artunc/TCBG4.bin"		; Title Card - Light Gray/Blue Bar that appears from top right
; ---------------------------------------------------------------------------
TCBG_Tile5:
		dc.w 32					; 32 bytes (1 tile)
		dc.l 6					; jump forward 6 bytes to art
		binclude "artunc/TCBG5.bin"		; Title Card - Pure White tiles that appear from the left
; ---------------------------------------------------------------------------
TCBG_Tile6:
		dc.w 32					; 32 bytes (1 tile)
		dc.l 6					; jump forward 6 bytes to art
		binclude "artunc/TCBG6.bin"		; Title Card - Faded Blue tiles that appear from the bottom that move over the Pure White tiles
; ---------------------------------------------------------------------------
TCBG_Tile7:
		dc.w 32					; 32 bytes (1 tile)
		dc.l 6					; jump forward 6 bytes to art
		binclude "artunc/TCBG7.bin"		; ??? (Unused)
; ---------------------------------------------------------------------------
TCBG_Tile8:
		dc.w 32					; 32 bytes (1 tile)
		dc.l 6					; jump forward 6 bytes to art
		binclude "artunc/TCBG8.bin"		; Title Card - Dark Blue tiles on bottom right
; ---------------------------------------------------------------------------
TCBG_Tile9:
		dc.w 32					; 32 bytes (1 tile)
		dc.l 6					; jump forward 6 bytes to art
		binclude "artunc/TCBG9.bin"		; Title Card - Light blue tiles that appear on the bottom and right
; ---------------------------------------------------------------------------
TCBG_TileA:
		dc.w 32					; 32 bytes (1 tile)
		dc.l 6					; jump forward 6 bytes to art
		binclude "artunc/TCBGA.bin"		; Title Card - Red thin bar that appears from the right
; ---------------------------------------------------------------------------
TCBG_TileB:
		dc.w 32*2				; 64 bytes (2 tiles)
		dc.l 6					; jump forward 6 bytes to art
		binclude "artunc/TCBGB.bin"		; Title Card - White Zig-Zag tiles that appear overlapping the light Gray/Blue Bar that appears from top right
; ---------------------------------------------------------------------------
TCBG_TileC:
		dc.w 32*2				; 64 bytes (2 tiles)
		dc.l 6					; jump forward 6 bytes to art
		binclude "artunc/TCBGC.bin"		; Title Card - White Zig-Zag tiles that appear overlapping middle section
; ---------------------------------------------------------------------------
TCBG_TileD:
		dc.w 32*2				; 64 bytes (2 tiles)
		dc.l 6					; jump forward 6 bytes to art
		binclude "artunc/TCBGD.bin"		; Title Card - Light blue Zig-Zag tiles (The Light blue tiles overlapping the white Zig-Zag tiles basically)
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Nemesis Compressed Object Patterns
; ---------------------------------------------------------------------------
ARTNEM_Springs:
	binclude	"artnem/Springs.bin"		; Red and Yellow Springs
	even
; ---------------------------------------------------------------------------
ARTNEM_SpikesHoz:
	binclude	"artnem/Spikes Horizontal.bin"	; Horizontal Spikes
	even
; ---------------------------------------------------------------------------
ARTNEM_SpikesVer:
	binclude	"artnem/Spikes Vertical.bin"	; Vertical Spikes
	even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Sprite Mappings - "Sprngs" and "Spikes" Objects
; ---------------------------------------------------------------------------
	include	"PLCMAPANI/MAP_Springs.asm"		; Spring Mappings
	include	"PLCMAPANI/MAP_Spikes.asm"		; Spikes Mappings
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data, Something to do with Sprite Mappings or PLC (Possibly an
; Index Block in here),
; ---------------------------------------------------------------------------

unk_42358:		dc.b $FF,$64,$FF,$70,$FF,$7C
unk_4235E:		dc.b $FF,$82,$FF,$8E,$FF,$9A
unk_42364:		dc.b $FF,$A0,$FF,$AC,$FF,$B8

; ===========================================================================
; ---------------------------------------------------------------------------
; Object Positions
; ---------------------------------------------------------------------------
; Format:	dc.w $XXXX,$YYYY,$AAAA,$FFFF
;
; XXXX 	=	Object X Position (If FFFF is placed in X position then it's the end of the list)
; YYYY	=	Object Y Position
; AAAA	=	Object ID (This cannot be an odd value or the engine will crash)
; FFFF	=	End of Object position code (Unless the object is a pathswapper)
;
; ---------------------------------------------------------------------------
; List of valid and invalid Object IDs
;
; AAAA -> 00	=	Red spring - Right
; AAAA -> 02	=	Red spring - Up
; AAAA -> 04	=	Red spring - Left
; AAAA -> 06	=	Blank
; AAAA -> 08	=	Red spring - Up (Duplicate; same as 02)
; AAAA -> 0A	=	Blank
; AAAA -> 0C	=	Red spring - Down
; AAAA -> 0E	=	Blank
; AAAA -> 10	=	Blank
; AAAA -> 12	=	Red spring - Angle Left/Up
; AAAA -> 14	=	Red spring - Angle Right/Up
; AAAA -> 16	=	(Crashes)
; AAAA -> 18	=	Red spring - Angle Left/Up
; AAAA -> 1A	=	(Crashes)
; AAAA -> 1C	=	Red spring - Angle Down/Right
; AAAA -> 1E	=	(Crashes)
; AAAA -> 20	=	Red spring - Angle Down/Left
; AAAA -> 22	=	(Crashes)
; AAAA -> 24	=	Blank
; AAAA -> 26	=	(Crashes)
; AAAA -> 28	=	A Ring that spawns when hit from spikes (Uncollectable)
; AAAA -> 2A	=	(Crashes)
; AAAA -> 2C	=	Blank
; AAAA -> 2E	=	Blank
; AAAA -> 30	=	Blank
; AAAA -> 32	=	(Crashes)
; AAAA -> 34	=	Yellow spring - Right
; AAAA -> 36	=	Yellow spring - Angle Right/Up
; AAAA -> 38	=	Yellow spring - Left
; AAAA -> 3A	=	Yellow spring - Angle Right/Up
; AAAA -> 3C	=	Yellow spring - Up
; AAAA -> 3E	=	Yellow spring - Angle Right/Up
; AAAA -> 40	=	Yellow spring - Down
; AAAA -> 42	=	Yellow spring - Angle Right/Up
; AAAA -> 44	=	Yellow spring - Angle Right/Up
; AAAA -> 46	=	(Crashes)
; AAAA -> 48	=	Yellow spring - Angle Left/Up
; AAAA -> 4A	=	(Crashes)
; AAAA -> 4C	=	Yellow spring - Angle Down/Right
; AAAA -> 4E	=	(Crashes)
; AAAA -> 50	=	Yellow spring - Angle Down/Left
; AAAA -> 52	=	Spikes - Up
; AAAA -> 54	=	Spikes - Up
; AAAA -> 56	=	Spikes - Down (This seems to lag the engine and cause gliches after a few seconds of being present)
; AAAA -> 58	=	Spikes - Down
; AAAA -> 5A	=	(Crashes)
; AAAA -> 5C	=	Spikes - Right
; AAAA -> 5E	=	(Crashes)
; AAAA -> 60	=	Spikes - Left
; AAAA -> 62	=	(Crashes)
; AAAA -> 64	=	Spikes - Angle Right/Up
; AAAA -> 66	=	Spikes - Angle Left/Up
; AAAA -> 68	=	Spikes - Angle Left/Up
; AAAA -> 6A	=	Spikes - Angle Down/Left
; AAAA -> 6C	=	Spikes - Angle Down/Right
; AAAA -> 6E	=	(Crashes)
; AAAA -> 70	=	Spikes Angle Down/Left
; AAAA -> 72+	=	These are either pathswappers, blank, invalid, gliches of previous objects, lag the engine, or crash (as far as I've seen)
;			note: some pathswappers crash on TTZ (Not sure why though)
; ---------------------------------------------------------------------------
; ===========================================================================
; --------------------------------------------------------------------------
Objpos_SSZ:
	binclude	"objpos/SSZ.bin"		; Speed Slider Zone"s Object Position
	even
; ---------------------------------------------------------------------------
Objpos_TTZ:
	binclude	"objpos/TTZ.bin"		; Techno Tower Zone"s Object Position
	even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; uncompressed Art (Used for animation)
; ---------------------------------------------------------------------------
ARTUNC_TTZAnimatedFanFG1:
	binclude	"artunc/TTZAnimatedFanFG1.bin"	; Fan tiles 1
	even
; ---------------------------------------------------------------------------
ARTUNC_TTZAnimatedFanFG2:
	binclude	"artunc/TTZAnimatedFanFG2.bin"	; Fan tiles 2
	even
; ---------------------------------------------------------------------------
ARTUNC_TTZAnimatedTurbineBG1:
	binclude	"artunc/TTZAnimatedTurbineBG1.bin" ; Turbine tiles 1
	even
; ---------------------------------------------------------------------------
ARTUNC_TTZAnimatedTurbineBG2:
	binclude	"artunc/TTZAnimatedTurbineBG2.bin" ; Turbine tiles 2
	even
; ---------------------------------------------------------------------------
ARTUNC_TTZAnimatedTurbineBG3:
	binclude	"artunc/TTZAnimatedTurbineBG3.bin" ; Turbine tiles 3
	even
; ---------------------------------------------------------------------------
ARTUNC_TTZAnimatedTurbineBG4:
	binclude	"artunc/TTZAnimatedTurbineBG4.bin" ; Turbine tiles 4
	even
; ---------------------------------------------------------------------------
ARTUNC_TTZAnimatedTurbineBG5:
	binclude	"artunc/TTZAnimatedTurbineBG5.bin" ; Turbine tiles 5
	even
; ---------------------------------------------------------------------------
ARTUNC_TTZAnimatedTurbineBG6:
	binclude	"artunc/TTZAnimatedTurbineBG6.bin" ; Turbine tiles 6
	even
; ---------------------------------------------------------------------------
ARTUNC_TTZAnimatedTurbineBG7:
	binclude	"artunc/TTZAnimatedTurbineBG7.bin" ; Turbine tiles 7
	even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Multiple Uncompressed Art (some of these are unused)
; ---------------------------------------------------------------------------
AniArt_Combi:						; "COMBI" (Unused)
	binclude	"artunc/Combi_Un.bin"
AniArt_Limits:						; "LIMITS" (Unused)
	binclude	"artunc/Limits_Un.bin"
AniArt_StripBlock:					; Striped Block (Unused)
	binclude	"artunc/StripBlock_Un.bin"
AniArt_Score:						; "SCORE" (Unused)
	binclude	"artunc/Score_Un.bin"
AniArt_Rings:						; "RINGS" (Unused)
	binclude	"artunc/Rings_Un.bin"
AniArt_SLTime:						; "/TIME" (Unused)
	binclude	"artunc/SLTime_Un.bin"
AniArt_Hud1to9_Sym:					; "0" to "9" Hud (Exclaimation Mark, and Minute/Second Symbol)
	binclude	"artunc/Hud0to9_Sym.bin"
AniArt_RingSprites:					; Ring Sprites
	binclude	"artunc/Spark_Ring.bin"
AniArt_Tether:						; Tether Star Sprites
	binclude	"artunc/Tether.bin"
AniArt_MultiStars:					; Multiple Stars (Unused)
	binclude	"artunc/MultipleStars_Un.bin"
AniArt_MiliSymbol:					; "" (Second/Mili-Second Symbol)
	binclude	"artunc/Hud_Sym2.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Field Data (Palettes, Art, Mappings)
; ---------------------------------------------------------------------------

PAL_RainbowField:
	binclude	"Palettes/PalRainbowField.bin"	; Palettes for Rainbow Field
	even
ARTCRA_RainbowField8x8:
	binclude	"artcra/Rainbow Field.bin"	; 8x8 tiles for Rainbow Field
	even
MAPUNC_RainbowFieldFG:
	binclude	"Uncompressed/MapuncRainbowFieldFG.bin" ; Screen Map Codes for Rainbow Field FG
	even
MAPUNC_RainbowFieldBG:
	binclude	"Uncompressed/MapuncRainbowFieldBG.bin" ; Screen Map Codes for Rainbow Field BG
	even
PAL_ElectricField:
	binclude	"Palettes/PalElectricField.bin"	; Palettes for Electric Field
	even
ARTCRA_ElectricField8x8:
	binclude	"artcra/Electric Field.bin"	; 8x8 tiles for Electric Field
	even
MAPUNC_ElectricFieldFG:
	binclude	"Uncompressed/MapuncElectricFieldFG.bin" ; Screen Map Codes for Electric Field FG
	even
MAPUNC_ElectricFieldBG:
	binclude	"Uncompressed/MapuncElectricFieldBG.bin" ; Screen Map Codes for Electric Field BG
	even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Large Section of Data, has 2 padded sections, and something that looks like
; uncompressed Tails mini art (May wanna look into this in the near future)
; ---------------------------------------------------------------------------
; Data Location (00054460 - 00025A3FF)
; Striped out
; UnkData_00054460:
		binclude	"UnknownCodes/UnknownData_00054460.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $00060000, Sonic"s Arms
; ---------------------------------------------------------------------------
	align $6000
; ---------------------------------------------------------------------------
ARTUNC_SonicArms:
	binclude	"artunc/SonicArms.bin"		; Sonic"s Arms
	even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $00064000, Tails" Arms
; ---------------------------------------------------------------------------
	align $1000
; ---------------------------------------------------------------------------
ARTUNC_TailsArms:
	binclude	"artunc/TailsArms.bin"		; Tails" Arms
	even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; PLC, Mappings & Main Index Block - Sonic"s Arm
; ---------------------------------------------------------------------------
PLCMAP_SonArm_MainIndex:
	include	"PLCMAPANI/PLCMAP_IndxBlck_SonicArm.asm"
; ---------------------------------------------------------------------------
PLC_SonicArm:
	include	"PLCMAPANI/PLC_SonicArm.asm"
; ---------------------------------------------------------------------------
Map_SonicArm:
	include	"PLCMAPANI/MAP_SonicArm.asm"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Animation, PLC, Mappings & Main Index Block - Sonic
; ---------------------------------------------------------------------------
ANI_Sonic:
	include	"PLCMAPANI/ANI_Sonic.asm"
; ---------------------------------------------------------------------------
PLCMAP_Sonic_MainIndex:
	include	"PLCMAPANI/PLCMAP_IndxBlck_Sonic.asm"
; ---------------------------------------------------------------------------
PLC_Sonic:
	include	"PLCMAPANI/PLC_Sonic.asm"
; ---------------------------------------------------------------------------
Map_Sonic:
	include	"PLCMAPANI/MAP_Sonic.asm"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; PLC, Mappings & Main Index Block - Tails" Arm
; ---------------------------------------------------------------------------
PLCMAP_TalArm_MainIndex:
	include	"PLCMAPANI/PLCMAP_IndxBlck_TailsArm.asm"
; ---------------------------------------------------------------------------
PLC_TailsArm:
	include	"PLCMAPANI/PLC_TailsArm.asm"
; ---------------------------------------------------------------------------
MAP_TailsArm:
	include	"PLCMAPANI/MAP_TailsArm.asm"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Animation, PLC, Mappings & Main Index Block - Tails
; ---------------------------------------------------------------------------
ANI_Tails:
	include	"PLCMAPANI/ANI_Tails.asm"
; ---------------------------------------------------------------------------
PLCMAP_Tails_MainIndex:
	include	"PLCMAPANI/PLCMAP_IndxBlck_Tails.asm"
; ---------------------------------------------------------------------------
PLC_Tails:
	include	"PLCMAPANI/PLC_Tails.asm"
; ---------------------------------------------------------------------------
MAP_Tails:
	include	"PLCMAPANI/MAP_Tails.asm"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Animation, PLC, Mappings & Main Index Block - Sonic Fields
; ---------------------------------------------------------------------------
ANI_SonicFields:
	include	"PLCMAPANI/ANI_SonicFields.asm"
; ---------------------------------------------------------------------------
PLCMAP_SonicFields_MainIndex:
	include	"PLCMAPANI/PLCMAP_IndxBlck_SonicFields.asm"
; ---------------------------------------------------------------------------
PLC_SonicFields:
	include	"PLCMAPANI/PLC_SonicFields.asm"
; ---------------------------------------------------------------------------
Map_SonicFields:
	include	"PLCMAPANI/MAP_SonicFields.asm"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Animation, PLC, Mappings & Main Index Block - Tails Fields
; ---------------------------------------------------------------------------
ANI_TailsFields:
	include	"PLCMAPANI/ANI_TailsFields.asm"
; ---------------------------------------------------------------------------
PLCMAP_TailsFields_MainIndex:
	include	"PLCMAPANI/PLCMAP_IndxBlck_TailsFields.asm"
; ---------------------------------------------------------------------------
PLC_TailsFields:
	include	"PLCMAPANI/PLC_TailsFields.asm"
; ---------------------------------------------------------------------------
Map_TailsFields:
	include	"PLCMAPANI/MAP_TailsFields.asm"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (00068FD6 - 0006AC5F)
; Striped out
; UnkData_00068FD6:
		binclude	"UnknownCodes/UnknownData_00068FD6.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $0006C000, Unknown Data
; ---------------------------------------------------------------------------
	align $2000
; ---------------------------------------------------------------------------
; Data Location (0006C000 - 0006CE07)
; Striped out
; UnkData_0006C000:
		binclude	"UnknownCodes/UnknownData_0006C000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (0006CE08 - 0006D1FF)
; Striped out
; UnkData_0006CE08:
		binclude	"UnknownCodes/UnknownData_0006CE08.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $00070000, Unknown Data
; ---------------------------------------------------------------------------
	align $4000
; ---------------------------------------------------------------------------
; Data Location (00070000 - 00071813)
; Striped out
; UnkData_00070000:
		binclude	"UnknownCodes/UnknownData_00070000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $00072000, Unknown Data
; ---------------------------------------------------------------------------
	align $800
; ---------------------------------------------------------------------------
; Data Location (00072000 - 00072763)
; Striped out
; UnkData_00072000:
		binclude	"UnknownCodes/UnknownData_00072000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $00074000, Unknown Data
; ---------------------------------------------------------------------------
	align $2000
; ---------------------------------------------------------------------------
; Data Location (00074000 - 0007562F)
; Striped out
; UnkData_00074000:
		binclude	"UnknownCodes/UnknownData_00074000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $00076000, Unknown Data
; ---------------------------------------------------------------------------
	align $1000
; ---------------------------------------------------------------------------
; Data Location (00076000 - 00076703)
; Striped out
; UnkData_00076000:
		binclude	"UnknownCodes/UnknownData_00076000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Uncompressed Art - Sonic
; ---------------------------------------------------------------------------
	align $10000
; ---------------------------------------------------------------------------
ARTUNC_Sonic:	binclude	"artunc/Sonic.bin"
		even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (0008C0A0 - 00090000)
; Striped out
; UnkData_0008C0A0:
		binclude	"UnknownCodes/UnknownData_0008C0A0.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Uncompressed Art - Sonic Fields
; ---------------------------------------------------------------------------
	align $4000
; ---------------------------------------------------------------------------
ARTUNC_SonicField:
		binclude	"artunc/SonicField.bin"
		even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (00093B20 - 0009562F)
; Striped out
; UnkData_00093B20:
		binclude	"UnknownCodes/UnknownData_00093B20.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $00096000, Unknown Data
; ---------------------------------------------------------------------------
	align $1000
; ---------------------------------------------------------------------------
; Data Location (00096000 - 00096703)
; Striped out
; UnkData_00096000:
		binclude	"UnknownCodes/UnknownData_00096000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Uncompressed Art - Unknown Unused Small Hud Patterns
; ---------------------------------------------------------------------------
	align $2000
; ---------------------------------------------------------------------------
ARTUNC_UnknownHud:
		binclude	"artunc/UnknownHud.bin"
		even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (00098740 - 0009FFFF)
; Striped out
; UnkData_00098740:
		binclude	"UnknownCodes/UnknownData_00098740.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Uncompressed Art - Tails
; ---------------------------------------------------------------------------
	align $10
; ---------------------------------------------------------------------------
ARTUNC_Tails:	binclude	"artunc/Tails.bin"
		even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $000AC000, Unknown Data
; ---------------------------------------------------------------------------
	align $1000
; ---------------------------------------------------------------------------
; Data Location (000AC000 - 000AD1F9)
; Striped out
; UnkData_000AC000:
		binclude	"UnknownCodes/UnknownData_000AC000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Uncompressed Art - Tails Field
; ---------------------------------------------------------------------------
	align $4000
; ---------------------------------------------------------------------------
ARTUNC_TailsField:
		binclude	"artunc/TailsField.bin"
		even
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Unknown Data
; ---------------------------------------------------------------------------
; Data Location (000B3820 - 000B562F)
; Striped out
; UnkData_000B3820:
		binclude	"UnknownCodes/UnknownData_000B3820.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $000B6000, Unknown Data
; ---------------------------------------------------------------------------
	align $1000
; ---------------------------------------------------------------------------
; Data Location (000B6000 - 000B6703)
; Striped out
; UnkData_000B6000:
		binclude	"UnknownCodes/UnknownData_000B6000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $000C0000, Unknown Data
; ---------------------------------------------------------------------------
	align $C000
; ---------------------------------------------------------------------------
; Data Location (000C0000 - 000CA887)
; Striped out
; UnkData_000C0000:
		binclude	"UnknownCodes/UnknownData_000C0000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $000CC000, Unknown Data
; ---------------------------------------------------------------------------
	align $2000
; ---------------------------------------------------------------------------
; Data Location (000CC000 - 000D58BF)
; Striped out
; UnkData_000CC000:
		binclude	"UnknownCodes/UnknownData_000CC000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $000D6000, Unknown Data
; ---------------------------------------------------------------------------
	align $1000
; ---------------------------------------------------------------------------
; Data Location (000D6000 - 000D6703)
; Striped out
; UnkData_000D6000:
		binclude	"UnknownCodes/UnknownData_000D6000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $000D8000, Unknown Data
; ---------------------------------------------------------------------------
	align $2000
; ---------------------------------------------------------------------------
; Data Location (000D8000 - 000DA3FF)
; Striped out
; UnkData_000D8000:
		binclude	"UnknownCodes/UnknownData_000D8000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $000E0000, Unknown Data
; ---------------------------------------------------------------------------
	align $7000
; ---------------------------------------------------------------------------
; Data Location (000E0000 - 000E3067)
; Striped out
; UnkData_000E0000:
		binclude	"UnknownCodes/UnknownData_000E0000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $000E4000, Unknown Data
; ---------------------------------------------------------------------------
	align $1000
; ---------------------------------------------------------------------------
; Data Location (000E4000 - 000E4EC7)
; Striped out
; UnkData_000E4000:
		binclude	"UnknownCodes/UnknownData_000E4000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $000E6000, Unknown Data
; ---------------------------------------------------------------------------
	align $2000
; ---------------------------------------------------------------------------
; Data Location (000E6000 - 000EAC5F)
; Striped out
; UnkData_000E6000:
		binclude	"UnknownCodes/UnknownData_000E6000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $000EC000, Unknown Data
; ---------------------------------------------------------------------------
	align $2000
; ---------------------------------------------------------------------------
; Data Location (000EC000 - 000ED1FF)
; Striped out
; UnkData_000EC000:
		binclude	"UnknownCodes/UnknownData_000EC000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $000F0000, Unknown Data
; ---------------------------------------------------------------------------
	align $3000
; ---------------------------------------------------------------------------
; Data Location (000F0000 - 000F1813)
; Striped out
; UnkData_000F0000:
		binclude	"UnknownCodes/UnknownData_000F0000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $000F2000, Unknown Data
; ---------------------------------------------------------------------------
	align $800
; ---------------------------------------------------------------------------
; Data Location (000F2000 - 000F2763)
; Striped out
; UnkData_000F2000:
		binclude	"UnknownCodes/UnknownData_000F2000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $000F4000, Unknown Data
; ---------------------------------------------------------------------------
	align $2000
; ---------------------------------------------------------------------------
; Data Location (000F4000 - 000F562F)
; Striped out
; UnkData_000F4000:
		binclude	"UnknownCodes/UnknownData_000F4000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $000F6000, Unknown Data
; ---------------------------------------------------------------------------
	align $1000
; ---------------------------------------------------------------------------
; Data Location (000F6000 - 000F6703)
; Striped out
; UnkData_000F6000:
		binclude	"UnknownCodes/UnknownData_000F6000.bin"
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Align to $00100000, End Of Rom
; ---------------------------------------------------------------------------
		cnop -1,2<<lastbit(*)
		dc.b $FF
		END
; ---------------------------------------------------------------------------
; ===========================================================================
