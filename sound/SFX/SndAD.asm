Snd0D_Header:
	smpsHeaderStartSong 3, 1
	if ~~fixBugs
	smpsHeaderVoice     Snd0D_Voices+$4000
	else
	smpsHeaderVoice     Snd0D_Voices
	endif
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	if ~~fixBugs
	smpsHeaderSFXChannel cFM5, Snd0D_FM5+$4000,	$00, $00
	else
	smpsHeaderSFXChannel cFM5, Snd0D_FM5,	$00, $00
	endif

; FM5 Data
Snd0D_FM5:
	smpsStop

Snd0D_Voices:
;	Voice $00 (unused)
;	$3C
;	$01, $01, $01, $01, 	$1F, $1F, $1F, $1F, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $0F, 	$00, $80, $00, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $01, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $00, $80, $00
