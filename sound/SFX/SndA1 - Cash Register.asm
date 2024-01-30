Snd01_Cash_Register_Header:
	smpsHeaderStartSong 3, 1
	if ~~fixBugs
	smpsHeaderVoice     Snd01_Cash_Register_Voices+$4000
	else
	smpsHeaderVoice     Snd01_Cash_Register_Voices
	endif
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $03

	if ~~fixBugs
	smpsHeaderSFXChannel cFM5, Snd01_Cash_Register_FM5+$4000,	$00, $00
	smpsHeaderSFXChannel cFM4, Snd01_Cash_Register_FM4+$4000,	$00, $00
	smpsHeaderSFXChannel cPSG3, Snd01_Cash_Register_PSG3+$4000,	$00, $00
	else
	smpsHeaderSFXChannel cFM5, Snd01_Cash_Register_FM5,	$00, $00
	smpsHeaderSFXChannel cFM4, Snd01_Cash_Register_FM4,	$00, $00
	smpsHeaderSFXChannel cPSG3, Snd01_Cash_Register_PSG3,	$00, $00
	endif

; FM5 Data
Snd01_Cash_Register_FM5:
	smpsSetvoice        $00
	dc.b	nA0, $08, nRst, $02, nA0, $08
	smpsStop

; FM4 Data
Snd01_Cash_Register_FM4:
	smpsSetvoice        $01
	dc.b	nRst, $12, nA5, $55
	smpsStop

; PSG3 Data
Snd01_Cash_Register_PSG3:
	smpsPSGvoice        sTone_02
	smpsPSGform         $E7
	dc.b	nRst, $02, nF5, $05, nG5, $04, nF5, $05, nG5, $04
	smpsStop

Snd01_Cash_Register_Voices:
;	Voice $00
;	$3B
;	$03, $02, $02, $06, 	$18, $1A, $1A, $96, 	$17, $0E, $0A, $10
;	$00, $00, $00, $00, 	$FF, $FF, $FF, $FF, 	$00, $28, $39, $80
	smpsVcAlgorithm     $03
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $06, $02, $02, $03
	smpsVcRateScale     $02, $00, $00, $00
	smpsVcAttackRate    $16, $1A, $1A, $18
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $10, $0A, $0E, $17
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $0F, $0F, $0F, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $39, $28, $00

;	Voice $01
;	$04
;	$37, $72, $77, $49, 	$1F, $1F, $1F, $1F, 	$07, $0A, $07, $0D
;	$00, $0B, $00, $0B, 	$1F, $0F, $1F, $0F, 	$23, $80, $23, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $04, $07, $07, $03
	smpsVcCoarseFreq    $09, $07, $02, $07
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0D, $07, $0A, $07
	smpsVcDecayRate2    $0B, $00, $0B, $00
	smpsVcDecayLevel    $00, $01, $00, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $23, $80, $23

