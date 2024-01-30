Snd06_Ring_Header:
	smpsHeaderStartSong 3, 1
	if ~~fixBugs
	smpsHeaderVoice     Snd06_Ring_Voices+$4000
	else
	smpsHeaderVoice     Snd06_Ring_Voices
	endif
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	if ~~fixBugs
	smpsHeaderSFXChannel cFM5, Snd06_Ring_FM5+$4000,	$00, $05
	else
	smpsHeaderSFXChannel cFM5, Snd06_Ring_FM5,	$00, $05
	endif

; FM5 Data
Snd06_Ring_FM5:
	smpsPan             panRight, $00
	smpsSetvoice        $00
	dc.b	nE5, $05, nG5, $05, nC6, $1B
	smpsStop

Snd06_Ring_Voices:
;	Voice $00
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

