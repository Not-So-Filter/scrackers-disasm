Snd03_Bomb_Header:
	smpsHeaderStartSong 3, 1
	if ~~fixBugs
	smpsHeaderVoice     Snd03_Bomb_Voices+$4000
	else
	smpsHeaderVoice     Snd03_Bomb_Voices
	endif
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	if ~~fixBugs
	smpsHeaderSFXChannel cFM5, Snd03_Bomb_FM5+$4000,	$00, $00
	else
	smpsHeaderSFXChannel cFM5, Snd03_Bomb_FM5,	$00, $00
	endif

; FM5 Data
Snd03_Bomb_FM5:
	smpsSetvoice        $00
	dc.b	nA0, $22
	smpsStop

Snd03_Bomb_Voices:
;	Voice $00
;	$FA
;	$21, $30, $10, $32, 	$1F, $1F, $1F, $1F, 	$05, $18, $05, $10
;	$0B, $1F, $10, $10, 	$1F, $2F, $4F, $2F, 	$0D, $07, $04, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $03
	smpsVcDetune        $03, $01, $03, $02
	smpsVcCoarseFreq    $02, $00, $00, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $10, $05, $18, $05
	smpsVcDecayRate2    $10, $10, $1F, $0B
	smpsVcDecayLevel    $02, $04, $02, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $04, $07, $0D

