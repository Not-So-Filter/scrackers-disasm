; ===========================================================================
; ---------------------------------------------------------------------------
; Patter Load Cues - Sonic
; ---------------------------------------------------------------------------
; Guide as Documented by Hivebrain
;
;	Each load cue consists of ten bytes:
;
;		dc.w $QQQQ,$----,$RRR-,$DDDD,$EEEE
;
;	$QQQQ = Number of tiles to load from Rom
;	$RRR- = Location to start reading the tiles
; ---------------------------------------------------------------------------
; the rest were not mentioned on the guide, and I am asuming are:
; ---------------------------------------------------------------------------
;	$---- = Unknown
;	$DDDD = I think it's some sort of dumping location (to dump the art)
;	$EEEE = whether it's the last PLC section to use or not (00 Include next PLC section/FF End of PLC section)
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
PLCSon_Stand:		dc.w $1001,$9704,$0000,$D380,$FFFF
PLCSon_LookUp:		dc.w $F000,$9704,$0110,$D380,$FFFF
PLCSon_LookDown:	dc.w $E000,$9704,$0200,$D380,$FFFF
PLCSon_Hurt:		dc.w $2001,$9704,$02E0,$D380,$FFFF
PLCSon_Wait1:		dc.w $F000,$9704,$0400,$D380,$FFFF
PLCSon_Wait2:		dc.w $F000,$9704,$04F0,$D380,$FFFF
PLCSon_BlncIn1:		dc.w $1001,$9704,$05E0,$D380,$FFFF ; Balance in 1
PLCSon_BlncIn2:		dc.w $2001,$9704,$06F0,$D380,$FFFF ; Balance in 2
PLCSon_BlncIn3:		dc.w $2001,$9704,$0810,$D380,$FFFF ; Balance in 3
PLCSon_BlncOut1:	dc.w $2001,$9704,$0930,$D380,$FFFF ; Balance out 1
PLCSon_BlncOut2:	dc.w $1001,$9704,$0A50,$D380,$FFFF ; Balance out 2
PLCSon_BlncOut3:	dc.w $F000,$9704,$0B60,$D380,$FFFF ; Balance out 3
; ---------------------------------------------------------------------------
; Walking (Angle: 000* 180* degrees)
PLCSon_Walk5_000:	dc.w $6001,$9704,$0C50,$D380,$FFFF
PLCSon_Walk6_000:	dc.w $3001,$9704,$0DB0,$D380,$FFFF
PLCSon_Walk1_000:	dc.w $E000,$9704,$0EE0,$D380,$FFFF
PLCSon_Walk2_000:	dc.w $1001,$9704,$0FC0,$D380,$FFFF
PLCSon_Walk3_000:	dc.w $F000,$9704,$10D0,$D380,$FFFF
PLCSon_Walk4_000:	dc.w $1001,$9704,$11C0,$D380,$FFFF
; ---------------------------------------------------------------------------
; Walking (Angle: 045* 225* degrees)
PLCSon_Walk5_045:	dc.w $4001,$9704,$12D0,$D380,$FFFF
PLCSon_Walk6_045:	dc.w $6001,$9704,$1410,$D380,$FFFF
PLCSon_Walk1_045:	dc.w $0001,$9704,$1570,$D380,$FFFF
PLCSon_Walk2_045:	dc.w $4001,$9704,$1670,$D380,$FFFF
PLCSon_Walk3_045:	dc.w $3001,$9704,$17B0,$D380,$FFFF
PLCSon_Walk4_045:	dc.w $3001,$9704,$18E0,$D380,$FFFF
; ---------------------------------------------------------------------------
; Walking (Angle: 090* 270* degrees)
PLCSon_Walk5_090:	dc.w $6001,$9704,$1A10,$D380,$FFFF
PLCSon_Walk6_090:	dc.w $4001,$9704,$1B70,$D380,$FFFF
PLCSon_Walk1_090:	dc.w $E000,$9704,$1CB0,$D380,$FFFF
PLCSon_Walk2_090:	dc.w $1001,$9704,$1D90,$D380,$FFFF
PLCSon_Walk3_090:	dc.w $F000,$9704,$1EA0,$D380,$FFFF
PLCSon_Walk4_090:	dc.w $1001,$9704,$1F90,$D380,$FFFF
; ---------------------------------------------------------------------------
; Walking (Angle: 135* 315* degrees)
PLCSon_Walk5_135:	dc.w $4001,$9704,$20A0,$D380,$FFFF
PLCSon_Walk6_135:	dc.w $6001,$9704,$21E0,$D380,$FFFF
PLCSon_Walk1_135:	dc.w $1001,$9704,$2340,$D380,$FFFF
PLCSon_Walk2_135:	dc.w $3001,$9704,$2450,$D380,$FFFF
PLCSon_Walk3_135:	dc.w $3001,$9704,$2580,$D380,$FFFF
PLCSon_Walk4_135:	dc.w $3001,$9704,$26B0,$D380,$FFFF
; ---------------------------------------------------------------------------
PLCSon_Run1_000:	dc.w $2001,$9704,$27E0,$D380,$FFFF
PLCSon_Run1_045:	dc.w $2001,$9704,$2900,$D380,$FFFF
PLCSon_Run1_090:	dc.w $2001,$9704,$2A20,$D380,$FFFF
PLCSon_Run1_135:	dc.w $2001,$9704,$2B40,$D380,$FFFF
PLCSon_Run2_000:	dc.w $4001,$9704,$2C60,$D380,$FFFF
PLCSon_Run2_045:	dc.w $4001,$9704,$2DA0,$D380,$FFFF
PLCSon_Run2_090:	dc.w $4001,$9704,$2EE0,$D380,$FFFF
PLCSon_Run2_135:	dc.w $4001,$9704,$3020,$D380,$FFFF
PLCSon_Run3_000:	dc.w $2001,$9704,$3160,$D380,$FFFF
PLCSon_Run3_045:	dc.w $2001,$9704,$3280,$D380,$FFFF
PLCSon_Run3_090:	dc.w $2001,$9704,$33A0,$D380,$FFFF
PLCSon_Run3_135:	dc.w $2001,$9704,$34C0,$D380,$FFFF
PLCSon_Run4_000:	dc.w $4001,$9704,$35E0,$D380,$FFFF
PLCSon_Run4_045:	dc.w $4001,$9704,$3720,$D380,$FFFF
PLCSon_Run4_090:	dc.w $4001,$9704,$3860,$D380,$FFFF
PLCSon_Run4_135:	dc.w $4001,$9704,$39A0,$D380,$FFFF
; ---------------------------------------------------------------------------
PLCSon_Skid1:		dc.w $1001,$9704,$3AE0,$D380,$FFFF
PLCSon_Skid2:		dc.w $1001,$9704,$3BF0,$D380,$FFFF
PLCSon_Skid3:		dc.w $4001,$9704,$3D00,$D380,$FFFF
PLCSon_Pull1:		dc.w $0001,$9704,$3E40,$D380,$FFFF
PLCSon_Pull2:		dc.w $4001,$9704,$3F40,$D380,$FFFF
PLCSon_Roll1:		dc.w $0001,$9704,$4080,$D380,$FFFF
PLCSon_Roll2:		dc.w $0001,$9704,$4180,$D380,$FFFF
PLCSon_Roll3:		dc.w $0001,$9704,$4280,$D380,$FFFF
PLCSon_Roll4:		dc.w $0001,$9704,$4380,$D380,$FFFF
PLCSon_Roll5:		dc.w $0001,$9704,$4480,$D380,$FFFF
; ---------------------------------------------------------------------------
; Unused
PLCSon_Dizzy1:		dc.w $0001,$9704,$4580,$D380,$FFFF
PLCSon_Dizzy2:		dc.w $D000,$9704,$4680,$D380,$FFFF
PLCSon_Dizzy3:		dc.w $0001,$9704,$4750,$D380,$FFFF
PLCSon_Dizzy4:		dc.w $F000,$9704,$4850,$D380,$FFFF
PLCSon_Dizzy5:		dc.w $1001,$9704,$4940,$D380,$FFFF
PLCSon_Dizzy6:		dc.w $0001,$9704,$4A50,$D380,$FFFF
PLCSon_Climb1:		dc.w $2001,$9704,$4B50,$D380,$FFFF
PLCSon_Climb2:		dc.w $0001,$9704,$4C70,$D380,$FFFF
PLCSon_Climb3:		dc.w $F000,$9704,$4D70,$D380,$FFFF
PLCSon_Climb4:		dc.w $E000,$9704,$4E60,$D380,$FFFF
PLCSon_Climb5:		dc.w $2001,$9704,$4F40,$D380,$FFFF
PLCSon_Throw1:		dc.w $5001,$9704,$5060,$D380,$FFFF
PLCSon_Throw2:		dc.w $1001,$9704,$51B0,$D380,$FFFF
PLCSon_Throw3:		dc.w $3001,$9704,$52C0,$D380,$FFFF
PLCSon_Throw4:		dc.w $E000,$9704,$53F0,$D380,$FFFF
PLCSon_WallJump1:	dc.w $6001,$9704,$54D0,$D380,$FFFF
PLCSon_WallJump2:	dc.w $0001,$9704,$5630,$D380,$FFFF
PLCSon_WallJump3:	dc.w $2001,$9704,$5730,$D380,$FFFF
PLCSon_WallJump4:	dc.w $E000,$9704,$5850,$D380,$FFFF
PLCSon_WallJump5:	dc.w $2001,$9704,$5930,$D380,$FFFF
; ---------------------------------------------------------------------------
PLCSon_Spindash1:	dc.w $0001,$9704,$5A50,$D380,$FFFF
PLCSon_Spindash2:	dc.w $0001,$9704,$5B50,$D380,$FFFF
PLCSon_Spindash3:	dc.w $0001,$9704,$5C50,$D380,$FFFF
PLCSon_Spindash4:	dc.w $0001,$9704,$5D50,$D380,$FFFF
PLCSon_Spindash5:	dc.w $0001,$9704,$5E50,$D380,$FFFF
PLCSon_Spindash6:	dc.w $0001,$9704,$5F50,$D380,$FFFF
			even
; ---------------------------------------------------------------------------
; ===========================================================================
