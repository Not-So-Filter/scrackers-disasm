; ===========================================================================
; ---------------------------------------------------------------------------
; Pattern Load Cues - Sonic Fields
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
PLCSonFld_StandForward:	dc.w $1001,$9704,$8000,$A000,$FFFF ; standing (Facing forwards)
PLCSonFld_StandLftRht:	dc.w $F000,$9704,$8110,$A000,$FFFF ; standing (Facing left or right)
PLCSonFld_StandBckward:	dc.w $1001,$9704,$8200,$A000,$FFFF ; standing (facing backwards)
; ---------------------------------------------------------------------------
PLCSonFld_WalkDwn_1:	dc.w $D000,$9704,$8310,$A000,$FFFF ; Walk Down 1
PLCSonFld_WalkDwn_2:	dc.w $F000,$9704,$83E0,$A000,$FFFF ; Walk Down 2
PLCSonFld_WalkDwn_3:	dc.w $0001,$9704,$84D0,$A000,$FFFF ; Walk Down 3
PLCSonFld_WalkDwn_4:	dc.w $0001,$9704,$85D0,$A000,$FFFF ; Walk Down 4
PLCSonFld_WalkDwn_5:	dc.w $0001,$9704,$86D0,$A000,$FFFF ; Walk Down 5
PLCSonFld_WalkDwn_6:	dc.w $2001,$9704,$87D0,$A000,$FFFF ; Walk Down 6
PLCSonFld_WalkDwn_7:	dc.w $0001,$9704,$88F0,$A000,$FFFF ; Walk Down 7
PLCSonFld_WalkDwn_8:	dc.w $C000,$9704,$89F0,$A000,$FFFF ; Walk Down 8
; ---------------------------------------------------------------------------
PLCSonFld_WalkLR_1:	dc.w $1001,$9704,$8AB0,$A000,$FFFF ; Walk Left or Right 1
PLCSonFld_WalkLR_2:	dc.w $2001,$9704,$8BC0,$A000,$FFFF ; Walk Left or Right 2
PLCSonFld_WalkLR_3:	dc.w $1001,$9704,$8CE0,$A000,$FFFF ; Walk Left or Right 3
PLCSonFld_WalkLR_4:	dc.w $1001,$9704,$8DF0,$A000,$FFFF ; Walk Left or Right 4
PLCSonFld_WalkLR_5:	dc.w $0001,$9704,$8F00,$A000,$FFFF ; Walk Left or Right 5
PLCSonFld_WalkLR_6:	dc.w $0001,$9704,$9000,$A000,$FFFF ; Walk Left or Right 6
PLCSonFld_WalkLR_7:	dc.w $0001,$9704,$9100,$A000,$FFFF ; Walk Left or Right 7
PLCSonFld_WalkLR_8:	dc.w $1001,$9704,$9200,$A000,$FFFF ; Walk Left or Right 8
; ---------------------------------------------------------------------------
PLCSonFld_WalkUp_1:	dc.w $D000,$9704,$9310,$A000,$FFFF ; Walk Up 1
PLCSonFld_WalkUp_2:	dc.w $C000,$9704,$93E0,$A000,$FFFF ; Walk Up 2
PLCSonFld_WalkUp_3:	dc.w $0001,$9704,$94A0,$A000,$FFFF ; Walk Up 3
PLCSonFld_WalkUp_4:	dc.w $1001,$9704,$95A0,$A000,$FFFF ; Walk Up 4
PLCSonFld_WalkUp_5:	dc.w $1001,$9704,$96B0,$A000,$FFFF ; Walk Up 5
PLCSonFld_WalkUp_6:	dc.w $0001,$9704,$97C0,$A000,$FFFF ; Walk Up 6
PLCSonFld_WalkUp_7:	dc.w $0001,$9704,$98C0,$A000,$FFFF ; Walk Up 7
PLCSonFld_WalkUp_8:	dc.w $D000,$9704,$99C0,$A000,$FFFF ; Walk Up 8
; ---------------------------------------------------------------------------
PLCSonFld_UncBall_1:	dc.w $0001,$9704,$9A90,$A000,$FFFF ; Ball frame 1 (Rolling/jumping) (Unused)
PLCSonFld_UncBall_2:	dc.w $0001,$9704,$9B90,$A000,$FFFF ; Ball frame 2 (Rolling/jumping) (Unused)
PLCSonFld_UncBall_3:	dc.w $0001,$9704,$9C90,$A000,$FFFF ; Ball frame 3 (Rolling/jumping) (Unused)
			even
; ---------------------------------------------------------------------------
; ===========================================================================
