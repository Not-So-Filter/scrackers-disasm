Evening_Star_Header:
	smpsHeaderStartSong 3, 1
	smpsHeaderVoice     Evening_Star_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $4A

	smpsHeaderDAC       Evening_Star_DAC
	smpsHeaderFM        Evening_Star_FM1,	$00, $10
	smpsHeaderFM        Evening_Star_FM2,	$00, $12
	smpsHeaderFM        Evening_Star_FM3,	$00, $12
	smpsHeaderFM        Evening_Star_FM4,	$00, $12
	smpsHeaderFM        Evening_Star_FM5,	$00, $1C
	smpsHeaderPSG       Evening_Star_PSG1,	$F4, $03, $00, $00
	smpsHeaderPSG       Evening_Star_PSG2,	$F4, $04, $00, $00
	smpsHeaderPSG       Evening_Star_PSG3,	$23, $01, $00, $00

; FM1 Data
Evening_Star_FM1:
	smpsSetvoice        $00
	dc.b	nEb2, $60, nD2, $60, nG1, $60, smpsNoAttack, $30, nG1, $08, nG2, $0C
	dc.b	nG1, $04, nBb1, $08, nA1, $04, nG1, $08, nF1, $04

Evening_Star_Jump01:
	smpsCall            Evening_Star_Call0A
	smpsChangeTransposition $FF
	smpsCall            Evening_Star_Call0A
	smpsChangeTransposition $F9
	smpsCall            Evening_Star_Call0A
	smpsCall            Evening_Star_Call0A
	smpsChangeTransposition $08
	smpsCall            Evening_Star_Call0A
	smpsChangeTransposition $FF
	smpsCall            Evening_Star_Call0A
	smpsChangeTransposition $F9
	smpsCall            Evening_Star_Call0A
	smpsChangeTransposition $08
	smpsCall            Evening_Star_Call0B
	smpsCall            Evening_Star_Call0A
	smpsChangeTransposition $FF
	smpsCall            Evening_Star_Call0A
	smpsChangeTransposition $F9
	smpsCall            Evening_Star_Call0A
	smpsChangeTransposition $08
	dc.b	nG1, $0C, nG1, nRst, $38, nG2, $04, nG1, $08, nF1, $04
	smpsCall            Evening_Star_Call0A
	smpsChangeTransposition $FF
	smpsCall            Evening_Star_Call0A
	smpsChangeTransposition $F9
	smpsCall            Evening_Star_Call0A
	smpsChangeTransposition $08
	smpsCall            Evening_Star_Call0B
	smpsJump            Evening_Star_Jump01

Evening_Star_Call0A:
	dc.b	nEb2, $0C, nEb2, nRst, $24, nEb2, $0C, nRst, $08, nEb2, $10
	smpsReturn

Evening_Star_Call0B:
	dc.b	nG1, $08, nG2, $0C, $04, nA1, $08, nA2, $0C, $04, nBb1, $08
	dc.b	nBb2, $0C, $04, nC2, $08, nC3, $0C, $04
	smpsReturn

; FM2 Data
Evening_Star_FM2:
	smpsSetvoice        $01
	smpsChangeTransposition $F9
	smpsCall            Evening_Star_Call06
	smpsChangeTransposition $04
	smpsCall            Evening_Star_Call07
	smpsChangeTransposition $FF
	smpsCall            Evening_Star_Call06
	smpsCall            Evening_Star_Call08
	smpsChangeTransposition $04
	smpsSetvoice        $02
	smpsFMAlterVol      $02

Evening_Star_Loop05:
	smpsCall            Evening_Star_Call01
	dc.b	nRst, $60
	smpsLoop            $00, $02, Evening_Star_Loop05
	smpsJump            Evening_Star_Loop05

Evening_Star_Call01:
	dc.b	nF4, $0C, nRst, nG4, nRst, nA4, $03, smpsNoAttack, nBb4, $11, nG4, $04
	dc.b	nRst, $0C, nC5, smpsNoAttack, $08, nRst, $04, nC5, $08, nRst, $04, nC5
	dc.b	$08, nRst, $04, nD5, $08, nRst, $04, nBb4, $03, smpsNoAttack, nC5, $05
	dc.b	nBb4, $04, nRst, $08, nG4, $1C, nF4, $0C, nRst, nG4, nRst, nBb4
	dc.b	$14, nG4, $04, nRst, $0C, nF5, smpsNoAttack, $08, nRst, $04, nG5, $08
	dc.b	nRst, $04, nF5, $08, nE5, $04, nRst, $08, nD5, $34, nRst, $0C
	dc.b	nBb4, $14, nRst, $04, nG4, $08, nRst, $04, nBb4, $14, nC5, $04
	dc.b	nRst, $0C, nF5, smpsNoAttack, $0C, nEb5, nD5, $08, nEb5, $04, nRst, $08
	dc.b	nC5, $03, smpsNoAttack, nD5, $09, nRst, $04, nC5, $0C, nBb4, $08, nC5
	dc.b	$0C, nG4, $04, smpsNoAttack, $14, nD5, $4C
	smpsReturn

; FM3 Data
Evening_Star_FM3:
	smpsSetvoice        $01
	smpsCall            Evening_Star_Call06
	smpsCall            Evening_Star_Call07
	smpsCall            Evening_Star_Call06
	smpsCall            Evening_Star_Call08
	smpsFMAlterVol      $FB

Evening_Star_Loop04:
	smpsCall            Evening_Star_Call06
	smpsCall            Evening_Star_Call07
	smpsCall            Evening_Star_Call06
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nD4, $0C
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$08, $04
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$08
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$04
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$08
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$04
	smpsCall            Evening_Star_Call09
	smpsCall            Evening_Star_Call06
	smpsCall            Evening_Star_Call07
	smpsCall            Evening_Star_Call06
	smpsCall            Evening_Star_Call08
	smpsLoop            $01, $02, Evening_Star_Loop04
	smpsJump            Evening_Star_Loop04

Evening_Star_Call06:
	dc.b	nD4, $08
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$04
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$08, $04, $08, $04
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$0C
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nRst, $0C, nD4, $08, $04
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$08
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$04
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$08
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$04
	smpsReturn

Evening_Star_Call07:
	dc.b	nRst, $0C, nC4, $08, $04
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$08
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$04
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$08
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$04, $08, $04
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$08
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$04
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$0C
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$08, $04
	smpsReturn

Evening_Star_Call09:
	smpsFMAlterVol      $FE
	dc.b	nRst, $08, nF3, $04, nG3, $08, nBb3, $0C, nG3, $04, nBb3, $08
	dc.b	nC4, $04
	smpsFMAlterVol      $02
	smpsReturn

Evening_Star_Call08:
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nD4, $08
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$04
	smpsLoop            $00, $08, Evening_Star_Call08
	smpsReturn

; FM4 Data
Evening_Star_FM4:
	smpsSetvoice        $01
	smpsChangeTransposition $FC
	smpsCall            Evening_Star_Call02
	smpsChangeTransposition $FE
	smpsCall            Evening_Star_Call03
	smpsChangeTransposition $FD
	smpsCall            Evening_Star_Call02
	smpsCall            Evening_Star_Call04
	smpsChangeTransposition $09
	smpsFMAlterVol      $FB

Evening_Star_Loop03:
	smpsChangeTransposition $FC
	smpsCall            Evening_Star_Call02
	smpsChangeTransposition $FE
	smpsCall            Evening_Star_Call03
	smpsChangeTransposition $FD
	smpsCall            Evening_Star_Call02
	smpsChangeTransposition $09
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	nF3, $0C
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$08, $04
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$08
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$04
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$08
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$04
	smpsCall            Evening_Star_Call05
	smpsChangeTransposition $FC
	smpsCall            Evening_Star_Call02
	smpsChangeTransposition $FE
	smpsCall            Evening_Star_Call03
	smpsChangeTransposition $FD
	smpsCall            Evening_Star_Call02
	smpsCall            Evening_Star_Call04
	smpsChangeTransposition $09
	smpsLoop            $01, $02, Evening_Star_Loop03
	smpsJump            Evening_Star_Loop03

Evening_Star_Call05:
	smpsPan             panRight, $00
	smpsFMAlterVol      $08
	dc.b	nRst, $0B, nF3, $04, nG3, $08, nBb3, $0C, nG3, $04, nBb3, $08
	dc.b	nC4, $01
	smpsPan             panCenter, $00
	smpsFMAlterVol      $F8
	smpsReturn

Evening_Star_Call02:
	dc.b	nD4, $08
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$04
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$08, $04, $08, $04
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$0C
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nRst, $0C, nD4, $08, $04
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$08
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$04
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$08
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$04
	smpsReturn

Evening_Star_Call03:
	dc.b	nRst, $0C, nC4, $08, $04
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$08
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$04
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$08
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$04, $08, $04
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$08
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$04
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$0C
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$08, $04
	smpsReturn

Evening_Star_Call04:
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	nD4, $08
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$04
	smpsLoop            $00, $08, Evening_Star_Call04
	smpsReturn

; FM5 Data
Evening_Star_FM5:
	smpsSetvoice        $02
	dc.b	nRst, $60, nRst, nRst, nRst
	smpsPan             panRight, $00
	smpsModSet          $05, $01, $03, $02

Evening_Star_Jump00:
	dc.b	nRst, $04
	smpsCall            Evening_Star_Call01
	dc.b	nRst, $60
	smpsCall            Evening_Star_Call01
	dc.b	nRst, $5C
	smpsJump            Evening_Star_Jump00

; Unreachable
	smpsStop

; PSG1 Data
Evening_Star_PSG1:
	smpsPSGvoice        sTone_04
	dc.b	nRst, $60, nRst, nRst, nRst, $30, nG3, $0C, nA3, nBb3, $08, nC4
	dc.b	$04, nD4, $08, nEb4, $04

Evening_Star_Jump03:
	dc.b	nF4, $60, smpsNoAttack, $18, nEb4, nD4, nEb4, nD4, $60, smpsNoAttack, $18, nC4
	dc.b	nBb3, nC4, nG3, $60, nFs3, $30, nD3, nG3, $60, nG3, $18, nA3
	dc.b	nBb3, nC4, nF4, $60, smpsNoAttack, $18, nEb4, nD4, nEb4, nD4, $60, smpsNoAttack
	dc.b	$30, nRst, $20, nBb3, $04, nC4, $08, nD4, $04, nG3, $60, nFs3
	dc.b	$30, nD3, nG3, $60, nG3, $18, nA3, nBb3, $0C, nC4, nD4, nEb4
	smpsJump            Evening_Star_Jump03

; PSG2 Data
Evening_Star_PSG2:
	smpsPSGvoice        sTone_04
	smpsModSet          $04, $01, $01, $03
	dc.b	nRst, $04, nRst, $60, nRst, nRst, nRst, $30, nG3, $0C, nA3, nBb3
	dc.b	$08, nC4, $04, nD4, $08, nEb4, $04

Evening_Star_Jump02:
	dc.b	nF4, $60, smpsNoAttack, $18, nEb4, nD4, nEb4, nD4, $60, smpsNoAttack, $18, nC4
	dc.b	nBb3, nC4, nG3, $60, nFs3, $30, nD3, nG3, $60, nG3, $18, nA3
	dc.b	nBb3, nC4, nF4, $60, smpsNoAttack, $18, nEb4, nD4, nEb4, nD4, $60, smpsNoAttack
	dc.b	$30, nRst, $20, nBb3, $04, nC4, $08, nD4, $04, nG3, $60, nFs3
	dc.b	$30, nD3, nG3, $60, nG3, $18, nA3, nBb3, $0C, nC4, nD4, nEb4
	smpsJump            Evening_Star_Jump02
	
; Unused
UnusedPSG2Loop00:
	dc.b	nG2, $08, $04, nD3, $08, nG2, $04
	smpsLoop            $00, $04, UnusedPSG2Loop00
	smpsReturn

; Unused
UnusedPSG2Loop01:
	dc.b	nFs2, $08, $04, nC3, $08, nFs2, $04
	smpsLoop            $00, $04, UnusedPSG2Loop01
	smpsReturn

; PSG3 Data
Evening_Star_PSG3:
	smpsPSGform         $E7

Evening_Star_Loop06:
	smpsPSGvoice        sTone_02
	dc.b	(nMaxPSG2-$23)&$FF, $08, $04
	smpsLoop            $00, $1F, Evening_Star_Loop06
	smpsPSGvoice        sTone_05
	dc.b	$0C

Evening_Star_Loop07:
	smpsCall            Evening_Star_Call0C
	smpsCall            Evening_Star_Call0D
	smpsLoop            $01, $04, Evening_Star_Loop07
	smpsCall            Evening_Star_Call0C
	smpsCall            Evening_Star_Call0D
	smpsCall            Evening_Star_Call0C
	smpsPSGvoice        sTone_02
	dc.b	(nMaxPSG2-$23)&$FF, $08, $04, $08, $04, $08, $04
	smpsPSGvoice        sTone_05
	dc.b	$08
	smpsPSGvoice        sTone_02
	dc.b	$04, nRst, $18, nRst, $08, (nMaxPSG2-$23)&$FF, $04
	smpsPSGvoice        sTone_05
	dc.b	$08
	smpsPSGvoice        sTone_02
	dc.b	$04
	smpsCall            Evening_Star_Call0C
	smpsCall            Evening_Star_Call0D
	smpsCall            Evening_Star_Call0C
	smpsCall            Evening_Star_Call0D
	smpsJump            Evening_Star_Loop07

Evening_Star_Call0C:
	smpsPSGvoice        sTone_02
	dc.b	(nMaxPSG2-$23)&$FF, $08, $04
	smpsLoop            $00, $08, Evening_Star_Call0C
	smpsReturn

Evening_Star_Call0D:
	smpsPSGvoice        sTone_02
	dc.b	(nMaxPSG2-$23)&$FF, $08, $04
	smpsLoop            $00, $07, Evening_Star_Call0D
	smpsPSGvoice        sTone_05
	dc.b	$0C
	smpsReturn

; DAC Data
Evening_Star_DAC:
	dc.b	nRst, $18, dKick
	smpsLoop            $00, $07, Evening_Star_DAC
	dc.b	dKick, $0C, dSnare, $08, $04, dHighTom, $08, dMidTom, $04, dLowTom, $08, $04

Evening_Star_Loop00:
	smpsCall            Evening_Star_Call00
	smpsLoop            $00, $08, Evening_Star_Loop00

Evening_Star_Loop01:
	smpsCall            Evening_Star_Call00
	smpsLoop            $00, $03, Evening_Star_Loop01
	dc.b	dKick, $0C, dKick, dSnare, $14, $04, nRst, $18, nRst, $08, dSnare, $04
	dc.b	$08, $04

Evening_Star_Loop02:
	smpsCall            Evening_Star_Call00
	smpsLoop            $00, $04, Evening_Star_Loop02
	smpsJump            Evening_Star_Loop00

Evening_Star_Call00:
	dc.b	dKick, $0C, dKick, dSnare, $24, dKick, $0C, dSnare, $08, dHighTom, $04, dMidTom
	dc.b	$08, dLowTom, $04
	smpsReturn

Evening_Star_Voices:
;	Voice $00
;	$29
;	$59, $54, $01, $02, 	$DF, $DF, $9F, $9F, 	$10, $0C, $03, $05
;	$12, $0F, $04, $07, 	$7F, $2F, $4F, $9F, 	$15, $1E, $1C, $80
	smpsVcAlgorithm     $01
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $05, $05
	smpsVcCoarseFreq    $02, $01, $04, $09
	smpsVcRateScale     $02, $02, $03, $03
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $03, $0C, $10
	smpsVcDecayRate2    $07, $04, $0F, $12
	smpsVcDecayLevel    $09, $04, $02, $07
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $1C, $1E, $15

;	Voice $01
;	$01
;	$75, $75, $71, $31, 	$D5, $55, $96, $94, 	$02, $0B, $05, $0D
;	$0A, $0A, $0F, $06, 	$FF, $2F, $3F, $6F, 	$25, $2B, $0F, $80
	smpsVcAlgorithm     $01
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $07, $07, $07
	smpsVcCoarseFreq    $01, $01, $05, $05
	smpsVcRateScale     $02, $02, $01, $03
	smpsVcAttackRate    $14, $16, $15, $15
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0D, $05, $0B, $02
	smpsVcDecayRate2    $06, $0F, $0A, $0A
	smpsVcDecayLevel    $06, $03, $02, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $0F, $2B, $25

;	Voice $02
;	$0D
;	$77, $65, $05, $15, 	$1F, $5F, $5F, $5F, 	$00, $10, $08, $10
;	$00, $03, $05, $04, 	$0F, $FC, $8C, $CC, 	$1F, $80, $80, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $01
	smpsVcUnusedBits    $00
	smpsVcDetune        $01, $00, $06, $07
	smpsVcCoarseFreq    $05, $05, $05, $07
	smpsVcRateScale     $01, $01, $01, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $10, $08, $10, $00
	smpsVcDecayRate2    $04, $05, $03, $00
	smpsVcDecayLevel    $0C, $08, $0F, $00
	smpsVcReleaseRate   $0C, $0C, $0C, $0F
	smpsVcTotalLevel    $80, $80, $80, $1F
	
;	Voice $03 (unused)
;	$3C
;	$01, $01, $01, $01, 	$1F, $1F, $1F, $1F, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$FF, $FF, $FF, $FF, 	$21, $80, $21, $80
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
	smpsVcDecayLevel    $0F, $0F, $0F, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $21, $80, $21