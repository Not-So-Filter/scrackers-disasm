; ===========================================================================
; ---------------------------------------------------------------------------
; Pattern Load Cues - Tails Fields
; ---------------------------------------------------------------------------
; Guide as documented by Hivebrain
;
;	Each load cue consists of ten bytes:
;
;		dc.w $QQQQ,$----,$RRR-,$DDDD,$EEEE
;
;	$QQQQ = Number of tiles to load from Rom
;	$RRR- = Location to start reading the tiles
; ---------------------------------------------------------------------------
; the rest were not mentioned on the guide, and I am assuming are:
; ---------------------------------------------------------------------------
;	$---- = Unknown
;	$DDDD = I think it's some sort of dumping location (to dump the art)
;	$EEEE = whether it's the last PLC section to use or not (00 Include next PLC section/FF End of PLC section)
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
PLCTalFld_StandForward:	dc.w $0001,$9705,$8000,$A400,$FFFF
PLCTalFld_StandLftRht:	dc.w $C000,$9705,$8100,$A400,$FFFF
PLCTalFld_StandBckward:	dc.w $0001,$9705,$81C0,$A400,$FFFF
; ---------------------------------------------------------------------------
PLCTalFld_WalkDwn_1:	dc.w $C000,$9705,$82C0,$A400,$FFFF
PLCTalFld_WalkDwn_2:	dc.w $0001,$9705,$8380,$A400,$FFFF
PLCTalFld_WalkDwn_3:	dc.w $C000,$9705,$8480,$A400,$FFFF
PLCTalFld_WalkDwn_4:	dc.w $C000,$9705,$8540,$A400,$FFFF
PLCTalFld_WalkDwn_5:	dc.w $0001,$9705,$8600,$A400,$FFFF
PLCTalFld_WalkDwn_6:	dc.w $0001,$9705,$8700,$A400,$FFFF
PLCTalFld_WalkDwn_7:	dc.w $C000,$9705,$8800,$A400,$FFFF
PLCTalFld_WalkDwn_8:	dc.w $C000,$9705,$88C0,$A400,$FFFF
; ---------------------------------------------------------------------------
PLCTalFld_WalkLR_1:	dc.w $3001,$9705,$8980,$A400,$FFFF
PLCTalFld_WalkLR_2:	dc.w $2001,$9705,$8AB0,$A400,$FFFF
PLCTalFld_WalkLR_3:	dc.w $2001,$9705,$8BD0,$A400,$FFFF
PLCTalFld_WalkLR_4:	dc.w $2001,$9705,$8CF0,$A400,$FFFF
PLCTalFld_WalkLR_5:	dc.w $3001,$9705,$8E10,$A400,$FFFF
PLCTalFld_WalkLR_6:	dc.w $2001,$9705,$8F40,$A400,$FFFF
PLCTalFld_WalkLR_7:	dc.w $2001,$9705,$9060,$A400,$FFFF
PLCTalFld_WalkLR_8:	dc.w $2001,$9705,$9180,$A400,$FFFF
; ---------------------------------------------------------------------------
PLCTalFld_WalkUp_1:	dc.w $C000,$9705,$92A0,$A400,$FFFF
PLCTalFld_WalkUp_2:	dc.w $0001,$9705,$9360,$A400,$FFFF
PLCTalFld_WalkUp_3:	dc.w $0001,$9705,$9460,$A400,$FFFF
PLCTalFld_WalkUp_4:	dc.w $0001,$9705,$9560,$A400,$FFFF
PLCTalFld_WalkUp_5:	dc.w $0001,$9705,$9660,$A400,$FFFF
PLCTalFld_WalkUp_6:	dc.w $0001,$9705,$9760,$A400,$FFFF
PLCTalFld_WalkUp_7:	dc.w $0001,$9705,$9860,$A400,$FFFF
PLCTalFld_WalkUp_8:	dc.w $0001,$9705,$9960,$A400,$FFFF
; ---------------------------------------------------------------------------
PLCTalFld_UncBall_1:	dc.w $9000,$9705,$9A60,$A400,$FFFF
PLCTalFld_UncBall_2:	dc.w $9000,$9705,$9AF0,$A400,$FFFF
PLCTalFld_UncBall_3:	dc.w $9000,$9705,$9B80,$A400,$FFFF
			even
; ---------------------------------------------------------------------------
; ===========================================================================
