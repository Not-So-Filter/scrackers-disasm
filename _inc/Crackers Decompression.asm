; ---------------------------------------------------------------------------
; Crackers Decompression Algorithm
; ---------------------------------------------------------------------------

CracDec:
		movem.l	d1-d7/a2,-(sp)
		move.w	(a0)+,d7
		move.w	d7,d2
		andi.w	#$3FFF,d7
		eor.w	d7,d2
		rol.w	#2,d2
		moveq	#4,d1
		sub.w	d2,d1
		moveq	#1,d2
		lsl.w	d1,d2
		subq.w	#1,d2

loc_8856:
		move.b	(a0)+,d5
		moveq	#7,d6

loc_885A:
		add.b	d5,d5
		bcs.w	loc_8870
		move.b	(a0)+,(a1)+
		dbf	d6,loc_885A
		dbf	d7,loc_8856
		movem.l	(sp)+,d1-d7/a2
		rts

loc_8870:
		moveq	#0,d3
		move.b	(a0)+,d3
		move.w	d3,d4
		lsr.w	d1,d3
		and.w	d2,d4
		neg.w	d3
		lea	-1(a1,d3.w),a2
		addq.w	#1,d4

loc_8882:
		move.b	(a2)+,(a1)+
		dbf	d4,loc_8882
		dbf	d6,loc_885A
		dbf	d7,loc_8856
		movem.l	(sp)+,d1-d7/a2
		rts