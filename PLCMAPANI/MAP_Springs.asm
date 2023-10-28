; ===========================================================================
; ---------------------------------------------------------------------------
; Spring Mappings
; ---------------------------------------------------------------------------
; Left/Right Spring Mappings
Map_SpringLR:		dc.b $03,$F0,$00,$2D,$00,$00		; Normal
			dc.b $01,$F8,$00,$0E,$F8,$FF		; ''
			dc.b $03,$F8,$00,$2D,$F0,$00		; Pushed In
			dc.b $01,$F8,$00,$0E,$F8,$FF		; ''
			dc.b $03,$F0,$00,$2D,$10,$00		; Pushed Out
			dc.b $09,$F8,$00,$08,$F8,$FF		; ''
; ---------------------------------------------------------------------------
; Up Spring Mappings
Map_SpringUp:		dc.b $0C,$F8,$00,$29,$F0,$00		; Normal
			dc.b $04,$00,$00,$00,$F8,$FF		; ''
			dc.b $0C,$00,$00,$29,$F0,$00		; Pushed In
			dc.b $04,$00,$00,$00,$F8,$FF		; ''
			dc.b $0C,$E8,$00,$29,$F0,$00		; Pushed Out
			dc.b $06,$F0,$00,$02,$F8,$FF		; ''
; ---------------------------------------------------------------------------
; Angle/Up Spring Mappings
Map_SpringAngUp:	dc.b $0F,$F4,$00,$31,$EC,$00		; Normal
			dc.b $0A,$FC,$00,$10,$EC,$FF		; ''
			dc.b $0F,$F9,$00,$31,$E7,$00		; Pushed In
			dc.b $0A,$FC,$00,$10,$EC,$FF		; ''
			dc.b $0F,$E6,$00,$31,$FA,$00		; Pushed Out
			dc.b $0F,$F4,$00,$19,$EC,$FF		; ''
; ---------------------------------------------------------------------------
; Unused Mappings
			dc.b $03,$E0,$00,$2D,$E0,$FF		; Red Platform Piece From Left/Right Spring
			dc.b $0C,$F8,$00,$29,$F8,$FF		; Red Platform Piece From Up Spring
			dc.b $0F,$E0,$00,$31,$E0,$FF		; Red Platform Piece From Angle/Up Spring
; ---------------------------------------------------------------------------
; ===========================================================================