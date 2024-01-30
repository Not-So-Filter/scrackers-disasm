Snd00_Jump_Header:
	smpsHeaderStartSong 3, 1
	if ~~fixBugs
	smpsHeaderVoice     Snd00_Jump_Voices+$4000
	else
	smpsHeaderVoice     Snd00_Jump_Voices
	endif
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	if ~~fixBugs
	smpsHeaderSFXChannel cFM6, Snd00_Jump_FM6+$4000,	$EB, $09
	else
	smpsHeaderSFXChannel cFM6, Snd00_Jump_FM6,	$EB, $09
	endif

; FM6 Data
Snd00_Jump_FM6:
	smpsSetvoice        $00
	smpsFMAlterVol      $05
	dc.b	nF3, $05
	smpsFMAlterVol      $FB
	smpsModSet          $02, $01, $34, $FF
	dc.b	nBb3, $15
	smpsStop

Snd00_Jump_Voices:
;	Voice $00
;	$0C
;	$08, $08, $08, $08, 	$1F, $1F, $1F, $1F, 	$00, $0A, $00, $0A
;	$00, $00, $00, $0A, 	$FF, $FF, $FF, $FF, 	$55, $81, $33, $81
	smpsVcAlgorithm     $04
	smpsVcFeedback      $01
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $08, $08, $08, $08
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $00, $0A, $00
	smpsVcDecayRate2    $0A, $00, $00, $00
	smpsVcDecayLevel    $0F, $0F, $0F, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $81, $33, $81, $55

