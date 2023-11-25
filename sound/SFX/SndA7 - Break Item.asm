Snd07_Header:
	smpsHeaderStartSong 3, 1
	smpsHeaderVoice     Snd07_Voices+$4000
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM5, Snd07_FM5+$4000,	$00, $00
	smpsHeaderSFXChannel cFM6, Snd07_FM6+$4000,	$00, $0B

; FM5 Data
Snd07_FM5:
	smpsModSet          $03, $01, $72, $0B
	smpsSetvoice        $00
	dc.b	nA4, $16
	smpsStop

; FM6 Data
Snd07_FM6:
	smpsSetvoice        $01
	dc.b	nB3, $13
	smpsStop

Snd07_Voices:
;	Voice $00
;	$3C
;	$0F, $01, $03, $01, 	$1F, $1F, $1F, $1F, 	$19, $12, $19, $0E
;	$05, $12, $00, $0F, 	$0F, $7F, $FF, $FF, 	$00, $80, $00, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $03, $01, $0F
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0E, $19, $12, $19
	smpsVcDecayRate2    $0F, $00, $12, $05
	smpsVcDecayLevel    $0F, $0F, $07, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $00, $80, $00

;	Voice $01
;	$3C
;	$0F, $00, $00, $00, 	$1F, $1A, $18, $1C, 	$17, $11, $1A, $0E
;	$00, $0F, $14, $10, 	$1F, $9F, $9F, $2F, 	$07, $80, $26, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $00, $00, $0F
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1C, $18, $1A, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0E, $1A, $11, $17
	smpsVcDecayRate2    $10, $14, $0F, $00
	smpsVcDecayLevel    $02, $09, $09, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $26, $80, $07
