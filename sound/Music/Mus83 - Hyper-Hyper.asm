Hyper_Hyper_Header:
	smpsHeaderStartSong 3, 1
	smpsHeaderVoice     Hyper_Hyper_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $26

	smpsHeaderDAC       Hyper_Hyper_DAC
	smpsHeaderFM        Hyper_Hyper_FM1,	$00, $10
	smpsHeaderFM        Hyper_Hyper_FM2,	$00, $16
	smpsHeaderFM        Hyper_Hyper_FM3,	$00, $16
	smpsHeaderFM        Hyper_Hyper_FM4,	$00, $16
	smpsHeaderFM        Hyper_Hyper_FM5,	$00, $10
	smpsHeaderPSG       Hyper_Hyper_PSG1,	$00, $00, $00, $00
	smpsHeaderPSG       Hyper_Hyper_PSG2,	$00, $04, $00, $00
	smpsHeaderPSG       Hyper_Hyper_PSG3,	$23, $00, $00, $00

; FM1 Data
Hyper_Hyper_FM1:
	smpsSetvoice        $00
	dc.b	nRst, $60, nRst, nRst, nRst, $06, nG2, nRst, nG2, nRst, $18, nRst
	dc.b	$06, nG2, nF2, nD2, nRst, nG1, nRst, nG1
	smpsCall            Hyper_Hyper_Call0B

Hyper_Hyper_Loop06:
	smpsCall            Hyper_Hyper_Call0C
	dc.b	nRst, $30
	smpsCall            Hyper_Hyper_Call0C
	dc.b	nRst, $0C, nEb1, nRst, $06, nF1, $12
	smpsCall            Hyper_Hyper_Call0B
	smpsChangeTransposition $FE
	smpsCall            Hyper_Hyper_Call0C
	dc.b	nRst, $30
	smpsCall            Hyper_Hyper_Call0C
	smpsChangeTransposition $02
	dc.b	nRst, $0C, nAb1, nRst, $06, nBb1, $12
	smpsCall            Hyper_Hyper_Call0B
	smpsLoop            $00, $02, Hyper_Hyper_Loop06
	smpsJump            Hyper_Hyper_Loop06

Hyper_Hyper_Call0C:
	dc.b	nG1, $0C, nRst, $06, nF1, $0C, nRst, $06, nG1, $0C
	smpsReturn

Hyper_Hyper_Call0B:
	smpsCall            Hyper_Hyper_Call0C
	dc.b	nRst, $30
	smpsCall            Hyper_Hyper_Call0C
	dc.b	nRst, $06, nE3, nC3, nG2, nF2, nE2, nC2, nG1
	smpsReturn

; FM2 Data
Hyper_Hyper_FM2:
	smpsSetvoice        $01
	dc.b	nRst, $60, nRst, nRst, nRst, nRst, nRst, $30
	smpsCall            Hyper_Hyper_Call08

Hyper_Hyper_Jump02:
	smpsCall            Hyper_Hyper_Call09
	dc.b	nD4, $12, nC4, nD4, $0C
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nD4
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nBb3
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nBb3, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nC4, $12
	smpsCall            Hyper_Hyper_Call0A
	smpsChangeTransposition $FE
	smpsCall            Hyper_Hyper_Call09
	smpsChangeTransposition $02
	dc.b	nC4, $12, nBb3, nC4, $0C
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$0C
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nEb4
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nEb4, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nF4, $12
	smpsCall            Hyper_Hyper_Call0A
	smpsCall            Hyper_Hyper_Call09
	dc.b	nD4, $12, nC4, nD4, $0C
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nD4
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nBb3
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nBb3, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nC4, $12
	smpsCall            Hyper_Hyper_Call0A
	smpsChangeTransposition $FE
	smpsCall            Hyper_Hyper_Call09
	smpsChangeTransposition $02
	dc.b	nC4, $12, nBb3, nC4, $06, nRst, $12, nEb4, $0C
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nEb4, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nF4, $12
	smpsCall            Hyper_Hyper_Call0A
	smpsJump            Hyper_Hyper_Jump02

Hyper_Hyper_Call08:
	smpsSetvoice        $03
	dc.b	nF6, $06, nE6, nC6, nG5, nF5, nE5, nC5, nG4
	smpsSetvoice        $01
	smpsReturn

Hyper_Hyper_Call09:
	dc.b	nD4, $12, nC4, nD4, $0C, nF4, $12, nE4, nC4, $0C
	smpsReturn

Hyper_Hyper_Call0A:
	smpsCall            Hyper_Hyper_Call09
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nC4, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nC4, $12, nD4, $18
	smpsCall            Hyper_Hyper_Call08
	smpsReturn

; FM3 Data
Hyper_Hyper_FM3:
	smpsSetvoice        $01
	dc.b	nRst, $60, nRst, nRst, nRst, nRst, nRst, $30
	smpsCall            Hyper_Hyper_Call06

Hyper_Hyper_Jump01:
	smpsCall            Hyper_Hyper_Call07
	dc.b	nA3, $12, nG3, nA3, $0C
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	nA3
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nG3
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	nG3, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nA3, $12
	smpsCall            Hyper_Hyper_Call07
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	nG3, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nG3, $12, nA3, $18
	smpsCall            Hyper_Hyper_Call06
	smpsChangeTransposition $FE
	smpsCall            Hyper_Hyper_Call07
	smpsChangeTransposition $02
	dc.b	nG3, $12, nF3, nG3, $0C
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	nG3, $0C
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nC4
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	nC4, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nD4, $12
	smpsCall            Hyper_Hyper_Call07
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	nG3, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nG3, $12, nA3, $18
	smpsCall            Hyper_Hyper_Call06
	smpsCall            Hyper_Hyper_Call07
	dc.b	nA3, $12, nG3, nA3, $0C
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	nA3
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nG3
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	nG3, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nA3, $12
	smpsCall            Hyper_Hyper_Call07
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	nG3, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nG3, $12, nA3, $18
	smpsCall            Hyper_Hyper_Call06
	smpsChangeTransposition $FE
	smpsCall            Hyper_Hyper_Call07
	smpsChangeTransposition $02
	dc.b	nG3, $12, nF3, nG3, $06, nRst, $12, nC4, $0C
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	nC4, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nD4, $12
	smpsCall            Hyper_Hyper_Call07
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	nG3, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nG3, $12, nA3, $18
	smpsCall            Hyper_Hyper_Call06
	smpsJump            Hyper_Hyper_Jump01

Hyper_Hyper_Call06:
	smpsSetvoice        $03
	smpsFMAlterVol      $05
	smpsPan             panLeft, $00
	dc.b	nRst, $05, nF6, $06, nE6, nC6, nG5
	smpsPan             panRight, $00
	dc.b	nF5, nE5, nC5, nG4, $01
	smpsSetvoice        $01
	smpsFMAlterVol      $FB
	smpsPan             panCenter, $00
	smpsReturn

Hyper_Hyper_Call07:
	dc.b	nG3, $12, nG3, nA3, $0C, nC4, $12, nC4, nG3, $0C
	smpsReturn

; FM4 Data
Hyper_Hyper_FM4:
	smpsSetvoice        $02
	dc.b	nRst, $04
	smpsFMAlterVol      $01

Hyper_Hyper_Loop05:
	smpsPan             panLeft, $00
	smpsCall            Hyper_Hyper_Call04
	smpsPan             panRight, $00
	smpsCall            Hyper_Hyper_Call04
	smpsLoop            $01, $0B, Hyper_Hyper_Loop05
	smpsPan             panLeft, $00
	smpsCall            Hyper_Hyper_Call04
	smpsPan             panRight, $00
	dc.b	nC3, $06, nF3, nD3, nG3, $02
	smpsPan             panCenter, $00
	smpsFMAlterVol      $FF
	smpsSetvoice        $01

Hyper_Hyper_Jump00:
	smpsCall            Hyper_Hyper_Call05
	dc.b	nG3, $12, nF3, nG3, $0C
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nG3, $0C
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nEb3
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nEb3, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nF3, $12
	smpsCall            Hyper_Hyper_Call05
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nF3, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nF3, $12, nG3, $48
	smpsChangeTransposition $FE
	smpsCall            Hyper_Hyper_Call05
	smpsChangeTransposition $02
	dc.b	nF3, $12, nEb3, nF3, $0C
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nF3, $0C
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nAb3
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nAb3, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nBb3, $12
	smpsCall            Hyper_Hyper_Call05
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nF3, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nF3, $12, nG3, $48
	smpsCall            Hyper_Hyper_Call05
	dc.b	nG3, $12, nF3, nG3, $0C
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nG3, $0C
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nEb3
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nEb3, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nF3, $12
	smpsCall            Hyper_Hyper_Call05
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nF3, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nF3, $12, nG3, $48
	smpsChangeTransposition $FE
	smpsCall            Hyper_Hyper_Call05
	smpsChangeTransposition $02
	dc.b	nF3, $12, nEb3, nF3, $06, nRst, $12, nAb3, $0C
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nAb3, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nBb3, $12
	smpsCall            Hyper_Hyper_Call05
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	nF3, $06
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nF3, $12, nG3, $48
	smpsJump            Hyper_Hyper_Jump00

Hyper_Hyper_Call05:
	dc.b	nF3, $12, nF3, nF3, $0C, nG3, $12, nG3, nF3, $0C
	smpsReturn

Hyper_Hyper_Call04:
	dc.b	nC3, $06, nF3, nD3, nG3
	smpsReturn

; FM5 Data
Hyper_Hyper_FM5:
	smpsSetvoice        $02

Hyper_Hyper_Loop02:
	smpsCall            Hyper_Hyper_Call03
	smpsLoop            $01, $06, Hyper_Hyper_Loop02

Hyper_Hyper_Loop03:
	smpsCall            Hyper_Hyper_Call03
	smpsLoop            $01, $04, Hyper_Hyper_Loop03
	smpsChangeTransposition $FE
	smpsCall            Hyper_Hyper_Call03
	smpsCall            Hyper_Hyper_Call03
	smpsChangeTransposition $02
	smpsCall            Hyper_Hyper_Call03
	smpsCall            Hyper_Hyper_Call03

Hyper_Hyper_Loop04:
	smpsCall            Hyper_Hyper_Call03
	smpsLoop            $01, $04, Hyper_Hyper_Loop04
	smpsChangeTransposition $FE
	smpsCall            Hyper_Hyper_Call03
	smpsChangeTransposition $02
	dc.b	nBb2, $06, nEb3, nC3, nF3, nBb2, nEb3, nC3, nRst, nRst, nRst, nC3
	dc.b	nF3, nBb2, nEb3, nC3, nF3
	smpsCall            Hyper_Hyper_Call03
	smpsCall            Hyper_Hyper_Call03
	smpsJump            Hyper_Hyper_Loop03

Hyper_Hyper_Call03:
	dc.b	nC3, $06, nF3, nD3, nG3
	smpsLoop            $00, $04, Hyper_Hyper_Call03
	smpsReturn

; Unreachable
	smpsStop

; PSG1 Data
Hyper_Hyper_PSG1:
	smpsPSGvoice        sTone_03
	dc.b	nRst, $60, nRst, nRst, nRst, nRst
	smpsModSet          $01, $06, $01, $01
	smpsPSGAlterVol     $02
	dc.b	nE5, $60
	smpsModSet          $00, $00, $00, $00
	smpsPSGAlterVol     $FE

Hyper_Hyper_Jump04:
	smpsCall            Hyper_Hyper_Call0F
	dc.b	nRst, $0C, nC4, $18, nA3, $06, nRst, nC4, $12, nD4, $06, nRst
	dc.b	$0C, nEb4, smpsNoAttack, $0C, nD4, $06, nRst, nEb4, nD4, nRst, nC4, $12
	dc.b	nAb3, nBb3, nC4, $0C, nRst, nG3, nRst, nBb3, $03, smpsNoAttack, nB3, $0F
	dc.b	nG3, $06, nRst, $0C, nF3, smpsNoAttack, $06, nRst, nG3, $54
	smpsCall            Hyper_Hyper_Call0F
	dc.b	nRst, $0C, nC4, $18, nA3, $06, nRst, nC4, $12, nD4, $06, nRst
	dc.b	$0C, nEb4, smpsNoAttack, $0C, nD4, $06, nRst, nEb4, nD4, nRst, nC4, $06
	dc.b	nRst, $0C, nAb3, $12, nBb3, nC4, $0C, nRst, nG3, nRst, nBb3, $03
	dc.b	smpsNoAttack, nB3, $0F, nG3, $06, nRst, $0C, nF3, smpsNoAttack, $06, nRst, nG3
	dc.b	$54
	smpsJump            Hyper_Hyper_Jump04

Hyper_Hyper_Call10:
	dc.b	nF3, $0C, nRst, nG3, nRst, nBb3, $03, smpsNoAttack, nB3, $0F, nG3, $06
	dc.b	nRst, $0C
	smpsReturn

Hyper_Hyper_Call0F:
	smpsCall            Hyper_Hyper_Call10
	dc.b	nC4, $0C, smpsNoAttack, $0C, nB3, $06, nRst, nC4, nD4, nRst, nG3, $30
	dc.b	nRst, $06
	smpsCall            Hyper_Hyper_Call10
	dc.b	nF4, $0C, smpsNoAttack, $06, nRst, nG4, nRst, nF4, nE4, nRst, nD4, $30
	dc.b	nRst, $06
	smpsReturn

; PSG2 Data
Hyper_Hyper_PSG2:
	dc.b	nRst, $60, nRst, nRst, nRst, nRst
	smpsModSet          $01, $06, $01, $01
	smpsPSGAlterVol     $02
	dc.b	nRst, $04, nE5, $5C
	smpsModSet          $00, $00, $00, $00
	smpsPSGAlterVol     $FE
	smpsModSet          $01, $01, $01, $03

Hyper_Hyper_Jump03:
	dc.b	nRst, $06
	smpsCall            Hyper_Hyper_Call0F
	dc.b	nRst, $0C, nC4, $18, nA3, $06, nRst, nC4, $12, nD4, $06, nRst
	dc.b	$0C, nEb4, smpsNoAttack, $0C, nD4, $06, nRst, nEb4, nD4, nRst, nC4, $12
	dc.b	nAb3, nBb3, nC4, $0C, nRst, nG3, nRst, nBb3, $03, smpsNoAttack, nB3, $0F
	dc.b	nG3, $06, nRst, $0C, nF3, smpsNoAttack, $06, nRst, nG3, $54
	smpsCall            Hyper_Hyper_Call0F
	dc.b	nRst, $0C, nC4, $18, nA3, $06, nRst, nC4, $12, nD4, $06, nRst
	dc.b	$0C, nEb4, smpsNoAttack, $0C, nD4, $06, nRst, nEb4, nD4, nRst, nRst, $06
	dc.b	nRst, $0C, nAb3, $12, nBb3, nC4, $0C, nRst, nG3, nRst, nBb3, $03
	dc.b	smpsNoAttack, nB3, $0F, nG3, $06, nRst, $0C, nF3, smpsNoAttack, $06, nRst, nG3
	dc.b	$4E
	smpsJump            Hyper_Hyper_Jump03

; PSG3 Data
Hyper_Hyper_PSG3:
	smpsPSGform         $E7

Hyper_Hyper_Loop07:
	smpsCall            Hyper_Hyper_Call0D
	smpsLoop            $01, $05, Hyper_Hyper_Loop07
	smpsCall            Hyper_Hyper_Call0E

Hyper_Hyper_Loop08:
	smpsCall            Hyper_Hyper_Call0D
	smpsLoop            $01, $03, Hyper_Hyper_Loop08
	smpsCall            Hyper_Hyper_Call0E
	smpsLoop            $02, $02, Hyper_Hyper_Loop08

Hyper_Hyper_Loop09:
	smpsCall            Hyper_Hyper_Call0D
	smpsLoop            $01, $03, Hyper_Hyper_Loop09
	smpsCall            Hyper_Hyper_Call0E
	smpsCall            Hyper_Hyper_Call0D
	smpsPSGvoice        sTone_02
	dc.b	(nMaxPSG2-$23)&$FF, $06, $06
	smpsPSGvoice        sTone_05
	dc.b	$0C
	smpsPSGvoice        sTone_02
	dc.b	$06, $06, $06, nRst, nRst, $0C
	smpsPSGvoice        sTone_05
	dc.b	$0C
	smpsPSGvoice        sTone_02
	dc.b	$06, $06
	smpsPSGvoice        sTone_05
	dc.b	$0C
	smpsCall            Hyper_Hyper_Call0D
	smpsCall            Hyper_Hyper_Call0E
	smpsJump            Hyper_Hyper_Loop08

Hyper_Hyper_Call0D:
	smpsPSGvoice        sTone_02
	dc.b	(nMaxPSG2-$23)&$FF, $06, $06
	smpsPSGvoice        sTone_05
	dc.b	$0C
	smpsLoop            $00, $04, Hyper_Hyper_Call0D
	smpsReturn

Hyper_Hyper_Call0E:
	smpsPSGvoice        sTone_02
	dc.b	(nMaxPSG2-$23)&$FF, $04, $04, $04, $06, $06, $06, $06, $06, $06, $06, $06
	smpsPSGvoice        sTone_05
	dc.b	$0C, $0C, $0C
	smpsReturn

; DAC Data
Hyper_Hyper_DAC:
	smpsCall            Hyper_Hyper_Call00
	smpsCall            Hyper_Hyper_Call01
	smpsLoop            $00, $02, Hyper_Hyper_DAC
	smpsCall            Hyper_Hyper_Call00
	smpsCall            Hyper_Hyper_Call02

Hyper_Hyper_Loop00:
	smpsCall            Hyper_Hyper_Call00
	smpsCall            Hyper_Hyper_Call01
	smpsLoop            $00, $03, Hyper_Hyper_Loop00
	smpsCall            Hyper_Hyper_Call00
	smpsCall            Hyper_Hyper_Call02

Hyper_Hyper_Loop01:
	smpsCall            Hyper_Hyper_Call00
	smpsCall            Hyper_Hyper_Call01
	smpsLoop            $00, $02, Hyper_Hyper_Loop01
	smpsCall            Hyper_Hyper_Call00
	dc.b	dKick, $12, $06, dSnare, $0C, dKick, nRst, dSnare, $06, dKick, dSnare, dSnare
	dc.b	$0C, dSnare, $06
	smpsCall            Hyper_Hyper_Call00
	smpsCall            Hyper_Hyper_Call02
	smpsJump            Hyper_Hyper_Loop00

Hyper_Hyper_Call00:
	dc.b	dKick, $12, $06, dSnare, $0C, dKick, nRst, dKick, dSnare, $06, dKick, $12
	smpsReturn

Hyper_Hyper_Call01:
	dc.b	dKick, $12, $06, dSnare, $0C, dKick, nRst, dKick, $06, dKick, dSnare, dKick
	dc.b	$0C, dSnare, $06
	smpsReturn

Hyper_Hyper_Call02:
	dc.b	dKick, $0C, dSnare, $06, dKick, dSnare, $0C, dSnare, $04, dSnare, dSnare, dSnare
	dc.b	$06, dSnare, dSnare, dSnare, dHighTom, dHighTom, dMidTom, dLowTom
	smpsReturn

Hyper_Hyper_Voices:
;	Voice $00
;	$3B
;	$58, $31, $04, $02, 	$DF, $9F, $9F, $9F, 	$14, $08, $0E, $07
;	$10, $0E, $0F, $07, 	$6F, $7F, $3F, $8F, 	$05, $14, $18, $80
	smpsVcAlgorithm     $03
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $03, $05
	smpsVcCoarseFreq    $02, $04, $01, $08
	smpsVcRateScale     $02, $02, $02, $03
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $07, $0E, $08, $14
	smpsVcDecayRate2    $07, $0F, $0E, $10
	smpsVcDecayLevel    $08, $03, $07, $06
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $18, $14, $05

;	Voice $01
;	$2C
;	$34, $75, $34, $36, 	$1F, $5D, $9F, $5C, 	$03, $0C, $03, $0C
;	$02, $06, $02, $06, 	$AF, $8F, $AF, $8F, 	$1A, $80, $27, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $03
	smpsVcCoarseFreq    $06, $04, $05, $04
	smpsVcRateScale     $01, $02, $01, $00
	smpsVcAttackRate    $1C, $1F, $1D, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0C, $03, $0C, $03
	smpsVcDecayRate2    $06, $02, $06, $02
	smpsVcDecayLevel    $08, $0A, $08, $0A
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $27, $80, $1A

;	Voice $02
;	$3A
;	$07, $06, $02, $01, 	$5F, $5F, $5F, $9F, 	$09, $02, $0A, $AC
;	$02, $16, $54, $09, 	$5F, $7F, $AF, $6F, 	$18, $17, $1B, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00, $01, $00, $00, $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $02, $06, $07
	smpsVcRateScale     $02, $01, $01, $01
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $01, $00, $00, $00
	smpsVcDecayRate1    $0C, $0A, $02, $09
	smpsVcDecayRate2    $09, $54, $16, $02
	smpsVcDecayLevel    $06, $0A, $07, $05
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $1B, $17, $18

;	Voice $03
;	$2D
;	$77, $65, $05, $15, 	$1F, $5F, $5F, $5F, 	$00, $03, $03, $05
;	$00, $01, $02, $01, 	$0F, $1C, $1C, $1C, 	$22, $83, $80, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $01, $00, $06, $07
	smpsVcCoarseFreq    $05, $05, $05, $07
	smpsVcRateScale     $01, $01, $01, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $03, $03, $00
	smpsVcDecayRate2    $01, $02, $01, $00
	smpsVcDecayLevel    $01, $01, $01, $00
	smpsVcReleaseRate   $0C, $0C, $0C, $0F
	smpsVcTotalLevel    $80, $80, $83, $22

