; ---------------------------------------------------------------------------
; Modified Type 1B Z80 Sound Driver
; ---------------------------------------------------------------------------
; Original disassembly from ValleyBell's SMPS Research Pack
; Full disassembly and documentation by Filter
; ---------------------------------------------------------------------------

; ===========================================================================

zTrack STRUCT DOTS
PlaybackControl	ds.b 1
VoiceControl	ds.b 1
TempoDivider	ds.b 1
DataPointerLow	ds.b 1
DataPointerHigh	ds.b 1
Transpose	ds.b 1
Volume		ds.b 1
ModulationCtrl	ds.b 1
VoiceIndex	ds.b 1
StackPointer	ds.b 1
AMSFMSPan	ds.b 1
DurationTimeout	ds.b 1
SavedDuration	ds.b 1
FreqLow		ds.b 1
FreqHigh	ds.b 1
VoiceSongID	ds.b 1
Detune		ds.b 1
PanAni1		ds.b 1
PanAni2		ds.b 1
PanAni3		ds.b 1
PanAni4		ds.b 1
PanAni5 	ds.b 1
PanAni6		ds.b 1
VolEnv		ds.b 1
HaveSSGEGFlag
FMVolEnv	ds.b 1
SSGEGPointerLow
FMVolEnvMask	ds.b 1
PSGNoise
SSGEGPointerHigh	ds.b 1
FeedbackAlgo	ds.b 1
TLPtrLow	ds.b 1
TLPtrHigh	ds.b 1
NoteFillTimeout	ds.b 1
NoteFillMaster	ds.b 1
ModulationPtrLow	ds.b 1
ModulationPtrHigh	ds.b 1
ModulationValLow
ModEnvSens	ds.b 1
ModulationValHigh	ds.b 1
ModulationWait	ds.b 1
ModEnvIndex	ds.b 1
ModulationDelta	ds.b 1
ModulationSteps	ds.b 1
LoopCounters	ds.w 1
VoicesLow	ds.b 1
VoicesHigh	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
zTrack ENDSTRUCT

	phase $1C00

	ds.l 1
zMusicBank	ds.b 1
zSoundBank	ds.b 1
zUnk_1C06	ds.b 1
	ds.w 1

zTempVariablesStart

zSoundQueueStart
zSoundQueue0	ds.b 1
zSoundQueue1	ds.b 1
zSoundQueue2	ds.b 1
zSoundQueue3	ds.b 1
zSoundQueueEnd

zFadeOutTimeout	ds.b 1
zFadeDelay	ds.b 1
zFadeDelayTimeout	ds.b 1
zPauseFlag	ds.b 1
zHaltFlag	ds.b 1
zFM3Settings	ds.b 1
zTempoAccumulator	ds.b 1
zCurrentTempo	ds.b 1
zUnk_1C15	ds.b 1
zCommunicationByte	ds.b 1
zUnk_1C17	ds.b 1
zUnk_1C18	ds.b 1
zUpdateSound	ds.b 1
zSpecSFXMode	ds.l 2
zSFXMode	ds.l 2
zMusicMode	ds.l 2
zSFXSaveIndex	ds.b 1
zSongPosition	ds.w 1
zTrackInitPos	ds.w 1
zVoiceTblPtr	ds.w 1
zSFXVoiceTblPtr	ds.w 1
zSFXTempoDivider	ds.b 1
zDACIndex	ds.b 1
	ds.b 1
	ds.b 1
	ds.b 1

; Now starts song and SFX z80 RAM
; Max number of music channels: 6 FM + 3 PSG or 1 DAC + 5 FM + 3 PSG
zTracksStart
zSongDAC	zTrack
zSongFM1	zTrack
zSongFM2	zTrack
zSongFM3	zTrack
zSongFM4	zTrack
zSongFM5	zTrack
zSongFM6	zTrack
zSongPSG1	zTrack
zSongPSG2	zTrack
zSongPSG3	zTrack
zTracksEnd
; This is RAM for backup of songs (when 1-up jingle is playing)
; and for SFX channels. Note these two overlap.
; Max number of SFX channels: 4 FM + 3 PSG
zTracksSFXStart
zSFX_FM3	zTrack
zSFX_FM4	zTrack
zSFX_FM5	zTrack
zSFX_FM6	zTrack
zSFX_PSG1	zTrack
zSFX_PSG2	zTrack
zSFX_PSG3	zTrack
zTracksSFXEnd

zTracksSpecSFXStart
zSpecSFX_FM3	zTrack
zTracksSpecSFXEnd

zTempVariablesEnd
	dephase
	!org	Z80_Driver

		save
		phase	0				; set Z80 location to 0
		cpu z80					; use Z80 cpu
		listing purecode			; add to listing file

zDAC_Status	=	1FFDh
zDAC_Sample	=	1FFFh
zStack		=	2000h
zYM2612_A0	=	4000h
zYM2612_D0	=	4001h
zYM2612_A1	=	4002h
zYM2612_D1	=	4003h
zBankRegister	=	6000h
zPSG		=	7F11h
zROMWindow	=	8000h

bankswitch macro
		ld	hl, zBankRegister
		ld	(hl), a
		rept 5
			rra
			ld	(hl), a
		endm
		xor	a
		rept 3
		ld	(hl), a
		endm
	endm

; macro to make a certain error message clearer should you happen to get it...
rsttarget macro {INTLABEL}
	if ($&7)||($>38h)
		fatal "Function __LABEL__ is at 0\{$}h, but must be at a multiple of 8 bytes <= 38h to be used with the rst instruction."
	endif
	if "__LABEL__"<>""
__LABEL__ label $
	endif
	endm

; function to turn a 68k address into a word the Z80 can use to access it
zmake68kPtr function addr,zROMWindow+(addr&7FFFh)

; function to turn a 68k address into a bank byte
zmake68kBank function addr,(((addr&3F8000h)/zROMWindow))

; Segment type:	Regular

loc_0:
		di
		di
		im	1
		jp	InitDriver
; ---------------------------------------------------------------------------
		align 8

; =============== S U B	R O U T	I N E =======================================


ReadPtrTable:	rsttarget
		ld	c, a
		ld	b, 0
		add	hl, bc
		add	hl, bc
		ld	a, (hl)
		inc	hl
		ld	h, (hl)
		ld	l, a
		ret
; End of function ReadPtrTable

; ---------------------------------------------------------------------------
		align 8

; =============== S U B	R O U T	I N E =======================================


WriteFMIorII:	rsttarget
		bit	2, (ix+zTrack.PlaybackControl)
		ret	nz
		add	a, (ix+zTrack.VoiceControl)
		bit	2, (ix+zTrack.VoiceControl)
		jr	nz, WriteFMIIPart
; End of function WriteFMIorII


; =============== S U B	R O U T	I N E =======================================


WriteFMI:
		ld	(zYM2612_A0), a
		ld	a, c
		ld	(zYM2612_D0), a
		ret
; End of function WriteFMI

; ---------------------------------------------------------------------------

WriteFMIIPart:
		sub	4

; =============== S U B	R O U T	I N E =======================================


WriteFMII:	rsttarget
		ld	(zYM2612_A1), a
		ld	a, c
		ld	(zYM2612_D1), a
		ret
; End of function WriteFMII

; ---------------------------------------------------------------------------

VInt:		rsttarget
		di
		push	af
		push	iy
		exx
		call	DoSoundQueue
		call	UpdateAll
		ld	a, (zDACIndex)
		or	a
		jp	z, loc_AB
		jp	m, loc_95
		ld	a, 2Bh
		ld	c, 80h
		call	WriteFMI
		ld	hl, zDACIndex
		ld	a, (hl)
		dec	a
		set	7, (hl)
		ld	hl, DAC_Index
		rst	ReadPtrTable
		ld	c, 80h
		ld	a, (hl)
		ld	(DACLoop+1), a
		ld	(loc_F11+1), a
		inc	hl
		ld	a, (hl)
		ld	(zSoundBank), a
		inc	hl
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		inc	hl
		ld	a, (hl)
		inc	hl
		ld	h, (hl)
		ld	l, a
		exx
		ld	hl, zSoundBank
		ld	a, (hl)
		bankswitch
		exx
		pop	iy
		pop	af
		pop	af
		jp	loc_EED
; ---------------------------------------------------------------------------

loc_95:
		ld	hl, zSoundBank
		ld	a, (hl)
		bankswitch

loc_AB:
		exx
		pop	iy
		pop	af
		ld	b, 1
		ret
; ---------------------------------------------------------------------------

InitDriver:
		ld	sp, zStack
		ld	c, 0

loc_B7:
		ld	b, 0

loc_B9:
		djnz	$
		dec	c
		jr	nz, loc_B7
		call	StopAllSound
		ld	a, zmake68kBank(MusicBank)
		ld	(zMusicBank), a
	if FixBugs
		ld	a, zmake68kBank(SoundBank)
	else
		; DANGER!
		; This is bugged, it adds 1 to the bank, which makes it point
		; to the DAC Index instead of the Sound Index.
		ld	a, zmake68kBank(SoundBank)+1
	endif
		ld	(zSoundBank), a

	if FixBugs
		ld	de, 0				; set DAC length to nothing
	endif
		; DANGER!
		; This is bugged, the DAC needs de to be cleared in order to
		; not continue checking if there is a sample. This leads to
		; constant crashes on hardware if nothing is played on the
                ; Sega Screen or anywhere that sound isn't being played.
		ld	hl, zSoundBank
	if ~~FixBugs
		ld	a, (hl)
	endif
		bankswitch
		ld	iy, DecTable
		ei
		jp	zPlayDigitalAudio

; =============== S U B	R O U T	I N E =======================================


UpdateAll:
		call	DoPause
		call	DoTempo
		call	DoFading
		call	PlaySoundID
		call	UpdateSFXTracks
		xor	a
		ld	(zUpdateSound), a		; 00 - Music Mode
		ld	hl, zMusicBank
		ld	a, (hl)
		bankswitch
		ld	ix, zTracksStart
		bit	7, (ix+zTrack.PlaybackControl)
		call	nz, DrumUpdateTrack
		ld	b, (zTracksEnd-zSongFM1)/zTrack.len
		ld	ix, zSongFM1
		jr	TrkUpdateLoop
; End of function UpdateAll


; =============== S U B	R O U T	I N E =======================================


UpdateSFXTracks:
		ld	a, 1
		ld	(zUpdateSound), a		; 01 - SFX Mode
		ld	hl, zBankRegister		; switch to Bank 018000
		xor	a				; Bank bits written: 003h
		ld	e, 1
		ld	(hl), e
		ld	(hl), e
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ld	ix, zTracksSFXStart
		ld	b, (zTracksSFXEnd-zTracksSFXStart)/zTrack.len
		call	TrkUpdateLoop
		ld	a, 80h
		ld	(zUpdateSound), a		; 80 - Special SFX Mode
		ld	b, 1
		ld	ix, zTracksSpecSFXStart
; End of function UpdateSFXTracks


; =============== S U B	R O U T	I N E =======================================


TrkUpdateLoop:
		push	bc
		bit	7, (ix+zTrack.PlaybackControl)
		call	nz, UpdateTrack
		ld	de, zTrack.len
		add	ix, de
		pop	bc
		djnz	TrkUpdateLoop
		ret
; End of function TrkUpdateLoop


; =============== S U B	R O U T	I N E =======================================


UpdateTrack:
		bit	7, (ix+zTrack.VoiceControl)
		jp	nz, UpdatePSGTrk
		call	TrackTimeout
		jr	nz, loc_181
		call	TrkUpdate_Proc
		bit	4, (ix+zTrack.PlaybackControl)
		ret	nz
		call	PrepareModulat
		call	DoPitchSlide			; also updates the frequency
		call	DoModulation
		call	SendFMFreq
		jp	DoNoteOn
; ---------------------------------------------------------------------------

loc_181:
		call	ExecPanAnim
		bit	4, (ix+zTrack.PlaybackControl)
		ret	nz
		call	DoFMVolEnv
		ld	a, (ix+zTrack.NoteFillTimeout)
		or	a
		jr	z, loc_198
		dec	(ix+zTrack.NoteFillTimeout)
		jp	z, DoNoteOff

loc_198:
		call	DoPitchSlide
		bit	6, (ix+zTrack.PlaybackControl)
		ret	nz
		call	DoModulation
; End of function UpdateTrack


; =============== S U B	R O U T	I N E =======================================


SendFMFreq:
		bit	2, (ix+zTrack.PlaybackControl)
		ret	nz
		bit	0, (ix+zTrack.PlaybackControl)
		jp	nz, loc_1B8

loc_1AF:
		ld	a, 0A4h
		ld	c, h
		rst	WriteFMIorII
		ld	a, 0A0h
		ld	c, l
		rst	WriteFMIorII
		ret
; ---------------------------------------------------------------------------

loc_1B8:
		ld	a, (ix+zTrack.VoiceControl)
		cp	2
		jr	nz, loc_1AF
		call	GetFM3FreqPtr
		ld	b, zSpecialFreqCommands_End-zSpecialFreqCommands
		ld	hl, zSpecialFreqCommands

loc_1C7:
		push	bc
		ld	a, (hl)
		inc	hl
		push	hl
		ex	de, hl
		ld	c, (hl)
		inc	hl
		ld	b, (hl)
		inc	hl
		ex	de, hl
		ld	l, (ix+zTrack.FreqLow)
		ld	h, (ix+zTrack.FreqHigh)
		add	hl, bc
		push	af
		ld	c, h
		call	WriteFMI
		pop	af
		sub	4
		ld	c, l
		call	WriteFMI
		pop	hl
		pop	bc
		djnz	loc_1C7
		ret
; End of function SendFMFreq

; ---------------------------------------------------------------------------
zSpecialFreqCommands:
		db 0ADh					; Operator 4 frequency MSB
		db 0AEh					; Operator 3 frequency MSB
		db 0ACh					; Operator 2 frequency MSB
		db 0A6h					; Operator 1 frequency MSB
zSpecialFreqCommands_End

; =============== S U B	R O U T	I N E =======================================


GetFM3FreqPtr:
		ld	de, zMusicMode
		ld	a, (zUpdateSound)
		or	a
		ret	z				; Music	Mode (00) - 1C2A
		ld	de, zSpecSFXMode
		ret	p				; Special SFX Mode (80)	- 1C1A
		ld	de, zSFXMode
		ret					; SFX Mode (01)	- 1C22
; End of function GetFM3FreqPtr


; =============== S U B	R O U T	I N E =======================================


TrkUpdate_Proc:
		ld	e, (ix+zTrack.DataPointerLow)
		ld	d, (ix+zTrack.DataPointerHigh)
		res	1, (ix+zTrack.PlaybackControl)
		res	4, (ix+zTrack.PlaybackControl)

loc_20B:
		ld	a, (de)
		inc	de
		cp	0E0h
		jp	nc, cfHandler
		ex	af, af'
		call	DoNoteOff
		call	DoPanAnimation
		ex	af, af'
		bit	3, (ix+zTrack.PlaybackControl)
		jp	nz, DoRawFreqMode
		or	a
		jp	p, SetDuration
		sub	81h
		jp	p, GetNote
		call	SetRest
		jr	loc_25D
; ---------------------------------------------------------------------------

GetNote:
		add	a, (ix+zTrack.Transpose)
		ld	hl, PSGFreqs
		push	af
		rst	ReadPtrTable
		pop	af
		bit	7, (ix+zTrack.VoiceControl)
		jr	nz, loc_257
		push	de
		ld	d, 8
		ld	e, 0Ch
		ex	af, af'
		xor	a

loc_245:
		ex	af, af'
		sub	e
		jr	c, loc_24E
		ex	af, af'
		add	a, d
		jr	loc_245
; ---------------------------------------------------------------------------
		ex	af, af'

loc_24E:
		add	a, e
		ld	hl, FMFreqs
		rst	ReadPtrTable
		ex	af, af'
		or	h
		ld	h, a
		pop	de

loc_257:
		ld	(ix+zTrack.FreqLow), l
		ld	(ix+zTrack.FreqHigh), h

loc_25D:
		bit	5, (ix+zTrack.PlaybackControl)
		jr	nz, loc_270
		ld	a, (de)
		or	a
		jp	p, loc_29C
		ld	a, (ix+zTrack.SavedDuration)
		ld	(ix+zTrack.DurationTimeout), a
		jr	loc_2A3
; ---------------------------------------------------------------------------

loc_270:
		ld	a, (de)
		inc	de
		ld	(ix+zTrack.Detune), a
		jr	loc_29B
; ---------------------------------------------------------------------------

DoRawFreqMode:
		ld	h, a
		ld	a, (de)
		inc	de
		ld	l, a
		or	h
		jr	z, loc_28A
		ld	a, (ix+zTrack.Transpose)
		ld	b, 0
		or	a
		jp	p, loc_288
		dec	b

loc_288:
		ld	c, a
		add	hl, bc

loc_28A:
		ld	(ix+zTrack.FreqLow), l
		ld	(ix+zTrack.FreqHigh), h
		bit	5, (ix+zTrack.PlaybackControl)
		jr	z, loc_29B
		ld	a, (de)
		inc	de
		ld	(ix+zTrack.Detune), a

loc_29B:
		ld	a, (de)

loc_29C:
		inc	de

SetDuration:
		call	TickMultiplier
		ld	(ix+zTrack.SavedDuration), a

loc_2A3:
		ld	(ix+zTrack.DataPointerLow),	e
		ld	(ix+zTrack.DataPointerHigh),	d
		ld	a, (ix+zTrack.SavedDuration)
		ld	(ix+zTrack.DurationTimeout), a
		bit	1, (ix+zTrack.PlaybackControl)
		ret	nz
		xor	a
		ld	(ix+zTrack.ModEnvIndex), a
		ld	(ix+zTrack.ModEnvSens), a
		ld	(ix+zTrack.VolEnv), a
		ld	a, (ix+zTrack.NoteFillMaster)
		ld	(ix+zTrack.NoteFillTimeout), a
		ret
; End of function TrkUpdate_Proc


; =============== S U B	R O U T	I N E =======================================


TickMultiplier:
		ld	b, (ix+zTrack.TempoDivider)
		dec	b
		ret	z
		ld	c, a

loc_2CB:
		add	a, c
		djnz	loc_2CB
		ret
; End of function TickMultiplier


; =============== S U B	R O U T	I N E =======================================


TrackTimeout:
		ld	a, (ix+zTrack.DurationTimeout)
		dec	a
		ld	(ix+zTrack.DurationTimeout), a
		ret
; End of function TrackTimeout

; ---------------------------------------------------------------------------

DoNoteOn:
		ld	a, (ix+zTrack.FreqLow)
		or	(ix+zTrack.FreqHigh)
		ret	z
		ld	a, (ix+zTrack.PlaybackControl)
		and	6
		ret	nz
		ld	a, (ix+zTrack.VoiceControl)
		or	0F0h
		ld	c, a
		ld	a, 28h
		call	WriteFMI
		ret

; =============== S U B	R O U T	I N E =======================================


DoNoteOff:
		ld	a, (ix+zTrack.PlaybackControl)
		and	6
		ret	nz

SendNoteOff:
		ld	c, (ix+zTrack.VoiceControl)
		bit	7, c
		ret	nz
; End of function DoNoteOff

FMNoteOff:
		ld	a, 28h
		call	WriteFMI
		res	6, (ix+zTrack.PlaybackControl)
		ret

; =============== S U B	R O U T	I N E =======================================


DoPanAnimation:
		ld	a, (ix+zTrack.PanAni1)
		dec	a
		ret	m
		jr	nz, loc_34C
		bit	1, (ix+zTrack.PlaybackControl)
		ret	nz

loc_312:
		dec	(ix+zTrack.PanAni6)
		ret	nz
		push	bc
		push	de
		push	hl
		ld	a, (ix+zTrack.PanAni5)
		ld	(ix+zTrack.PanAni6), a
		ld	a, (ix+zTrack.PanAni2)
		ld	hl, PanAniPtrList
		rst	ReadPtrTable
		ld	e, (ix+zTrack.PanAni3)
		inc	(ix+zTrack.PanAni3)
		ld	a, (ix+zTrack.PanAni4)
		dec	a
		cp	e
		jr	nz, loc_341
		dec	(ix+zTrack.PanAni3)
		ld	a, (ix+zTrack.PanAni1)
		cp	2
		jr	z, loc_341
		ld	(ix+zTrack.PanAni3), 0

loc_341:
		ld	d, 0
		add	hl, de
		ex	de, hl
		call	cfE0_Pan
		pop	hl
		pop	de
		pop	bc
		ret
; ---------------------------------------------------------------------------

loc_34C:
		xor	a
		ld	(ix+zTrack.PanAni3), a
; End of function DoPanAnimation


; =============== S U B	R O U T	I N E =======================================


ExecPanAnim:
		ld	a, (ix+zTrack.PanAni1)
		sub	2
		ret	m
		jr	loc_312
; End of function ExecPanAnim

; ---------------------------------------------------------------------------
PanAniPtrList:	dw byte_360, byte_361, byte_362, byte_363
byte_360:	db 0C0h
byte_361:	db  80h
byte_362:	db 0C0h
byte_363:	db  40h,0C0h, 80h

; =============== S U B	R O U T	I N E =======================================


DoFMVolEnv:
		ld	a, (ix+zTrack.FMVolEnv)
		or	a
		ret	z
		ret	m
		dec	a
		ld	hl, VolEnvPtrs
		rst	ReadPtrTable
		call	DoPSGVolEnv
		ld	h, (ix+zTrack.TLPtrHigh)
		ld	l, (ix+zTrack.TLPtrLow)
		ld	de, zFMInstrumentTLTable
		ld	b, zFMInstrumentTLTable_End-zFMInstrumentTLTable
		ld	c, (ix+zTrack.FMVolEnvMask)

loc_382:
		push	af
		sra	c
		push	bc
		jr	nc, loc_38E
		add	a, (hl)
		and	7Fh
		ld	c, a
		ld	a, (de)
		rst	WriteFMIorII

loc_38E:
		pop	bc
		inc	de
		inc	hl
		pop	af
		djnz	loc_382
		ret
; End of function DoFMVolEnv


; =============== S U B	R O U T	I N E =======================================


PrepareModulat:
		bit	7, (ix+zTrack.ModulationCtrl)
		ret	z
		bit	1, (ix+zTrack.PlaybackControl)
		ret	nz
		ld	e, (ix+zTrack.ModulationPtrLow)
		ld	d, (ix+zTrack.ModulationPtrHigh)
		push	ix
		pop	hl
		ld	b, 0
		ld	c, zTrack.ModulationWait
		add	hl, bc
		ex	de, hl
		ldi
		ldi
		ldi
		ld	a, (hl)
		srl	a
		ld	(de), a
		xor	a
		ld	(ix+zTrack.ModulationValLow), a
		ld	(ix+zTrack.ModulationValHigh), a
		ret
; End of function PrepareModulat


; =============== S U B	R O U T	I N E =======================================


DoModulation:
		ld	a, (ix+zTrack.ModulationCtrl)
		or	a
		ret	z
		cp	80h
		jr	nz, DoModEnv
		dec	(ix+zTrack.ModulationWait)
		ret	nz
		inc	(ix+zTrack.ModulationWait)
		push	hl
		ld	l, (ix+zTrack.ModulationValLow)
		ld	h, (ix+zTrack.ModulationValHigh)
		ld	e, (ix+zTrack.ModulationPtrLow)
		ld	d, (ix+zTrack.ModulationPtrHigh)
		push	de
		pop	iy
		dec	(ix+zTrack.ModEnvIndex)
		jr	nz, loc_3FC
		ld	a, (iy+1)
		ld	(ix+zTrack.ModEnvIndex), a
		ld	a, (ix+zTrack.ModulationDelta)
		ld	c, a
		and	80h
		rlca
		neg
		ld	b, a
		add	hl, bc
		ld	(ix+zTrack.ModulationValLow), l
		ld	(ix+zTrack.ModulationValHigh), h

loc_3FC:
		pop	bc
		add	hl, bc
		dec	(ix+zTrack.ModulationSteps)
		ret	nz
		ld	a, (iy+3)
		ld	(ix+zTrack.ModulationSteps), a

loc_408:
		ld	a, (ix+zTrack.ModulationDelta)
		neg

loc_40D:
		ld	(ix+zTrack.ModulationDelta), a
		ret
; ---------------------------------------------------------------------------

DoModEnv:
		dec	a
		ex	de, hl
		ld	hl, ModEnvPtrs
		rst	ReadPtrTable
		jr	loc_41C
; ---------------------------------------------------------------------------

loc_419:
		ld	(ix+zTrack.ModEnvIndex), a

loc_41C:
		push	hl
		ld	c, (ix+zTrack.ModEnvIndex)
		ld	b, 0
		add	hl, bc
		ld	a, (hl)
		pop	hl
		bit	7, a
		jp	z, ModEnv_Positive
		cp	82h
		jr	z, ModEnv_Jump2Idx		; 82	xx - jump to byte xx
		cp	80h
		jr	z, ModEnv_Reset			; 80 - loop back to beginning
		cp	84h
		jr	z, ModEnv_ChgMult		; 84 xx - change Modulation Multipler
		ld	h, 0FFh				; make HL negative (FFxx)
		jr	nc, ModEnv_Next
		set	6, (ix+zTrack.PlaybackControl)
		pop	hl
		ret
; ---------------------------------------------------------------------------

ModEnv_Jump2Idx:
		inc	bc
		ld	a, (bc)
		jr	loc_419
; ---------------------------------------------------------------------------

ModEnv_Reset:
		xor	a
		jr	loc_419
; ---------------------------------------------------------------------------

ModEnv_ChgMult:
		inc	bc
		ld	a, (bc)
		add	a, (ix+zTrack.ModEnvSens)
		ld	(ix+zTrack.ModEnvSens), a
		inc	(ix+zTrack.ModEnvIndex)
		inc	(ix+zTrack.ModEnvIndex)
		jr	loc_41C
; ---------------------------------------------------------------------------

ModEnv_Positive:
		ld	h, 0				; make HL positive (00xx)

ModEnv_Next:
		ld	l, a
		ld	b, (ix+zTrack.ModEnvSens)
		inc	b
		ex	de, hl

loc_45F:
		add	hl, de
		djnz	loc_45F
		inc	(ix+zTrack.ModEnvIndex)
		ret
; End of function DoModulation


; =============== S U B	R O U T	I N E =======================================


DoPitchSlide:
		ld	b, 0
		ld	a, (ix+zTrack.Detune)
		or	a
		jp	p, loc_470
		dec	b

loc_470:
		ld	h, (ix+zTrack.FreqHigh)
		ld	l, (ix+zTrack.FreqLow)
		ld	c, a
		add	hl, bc
		bit	7, (ix+zTrack.VoiceControl)
		jr	nz, loc_4A0
		ex	de, hl
		ld	a, 7
		and	d
		ld	b, a
		ld	c, e
		or	a
		ld	hl, 283h
		sbc	hl, bc
		jr	c, loc_492
		ld	hl, -57Bh
		add	hl, de
		jr	loc_4A0
; ---------------------------------------------------------------------------

loc_492:
		or	a
		ld	hl, 508h
		sbc	hl, bc
		jr	nc, loc_49F
		ld	hl, 57Ch
		add	hl, de
		ex	de, hl

loc_49F:
		ex	de, hl

loc_4A0:
		bit	5, (ix+zTrack.PlaybackControl)
		ret	z
		ld	(ix+zTrack.FreqHigh), h
		ld	(ix+zTrack.FreqLow), l
		ret
; End of function DoPitchSlide


; =============== S U B	R O U T	I N E =======================================


GetFMInsPtr:
		ld	hl, (zVoiceTblPtr)
		ld	a, (zUpdateSound)
		or	a
		jr	z, JumpToInsData		; Mode	00 (Music Mode)	- jump
		ld	l, (ix+zTrack.VoicesLow)	; load SFX track Instrument Pointer (Trk+2A/2B)
		ld	h, (ix+zTrack.VoicesHigh)

JumpToInsData:
		xor	a
		or	b
		ret	z
		ld	de, 25

loc_4C1:
		add	hl, de
		djnz	loc_4C1
		ret
; End of function JumpToInsData

; ---------------------------------------------------------------------------
zFMInstrumentRegTable:
		db 0B0h					; Feedback/Algorithm
zFMInstrumentOperatorTable:
		db  30h					; Detune/multiple operator 1
		db  38h					; Detune/multiple operator 3
		db  34h					; Detune/multiple operator 2
		db  3Ch					; Detune/multiple operator 4
zFMInstrumentRSARTable:
		db  50h					; Rate scaling/attack rate operator 1
		db  58h					; Rate scaling/attack rate operator 3
		db  54h					; Rate scaling/attack rate operator 2
		db  5Ch					; Rate scaling/attack rate operator 4
zFMInstrumentAMD1RTable:
		db  60h					; Amplitude modulation/first decay rate operator 1
		db  68h					; Amplitude modulation/first decay rate operator 3
		db  64h					; Amplitude modulation/first decay rate operator 2
		db  6Ch					; Amplitude modulation/first decay rate operator 4
zFMInstrumentD2RTable:
		db  70h					; Secondary decay rate operator 1
		db  78h					; Secondary decay rate operator 3
		db  74h					; Secondary decay rate operator 2
		db  7Ch					; Secondary decay rate operator 4
zFMInstrumentD1LRRTable:
		db  80h					; Secondary amplitude/release rate operator 1
		db  88h					; Secondary amplitude/release rate operator 3
		db  84h					; Secondary amplitude/release rate operator 2
		db  8Ch					; Secondary amplitude/release rate operator 4
zFMInstrumentOperatorTable_End

zFMInstrumentTLTable:
		db  40h					; Total level operator 1
		db  48h					; Total level operator 3
		db  44h					; Total level operator 2
		db  4Ch					; Total level operator 4
zFMInstrumentTLTable_End

zFMInstrumentSSGEGTable:
		db  90h					; SSG-EG operator 1
		db  98h					; SSG-EG operator 3
		db  94h					; SSG-EG operator 2
		db  9Ch					; SSG-EG operator 4
zFMInstrumentSSGEGTable_End

; =============== S U B	R O U T	I N E =======================================


SendFMIns:
		ld	de, zFMInstrumentRegTable
		ld	c, (ix+zTrack.AMSFMSPan)
		ld	a, 0B4h
		rst	WriteFMIorII
		call	WriteInsReg
		ld	(ix+zTrack.FeedbackAlgo), a
		ld	b, zFMInstrumentOperatorTable_End-zFMInstrumentOperatorTable

loc_4F3:
		call	WriteInsReg
		djnz	loc_4F3
		ld	(ix+zTrack.TLPtrLow), l
		ld	(ix+zTrack.TLPtrHigh), h
		jp	RefreshVolume
; End of function SendFMIns


; =============== S U B	R O U T	I N E =======================================


WriteInsReg:
		ld	a, (de)
		inc	de
		ld	c, (hl)
		inc	hl
		rst	WriteFMIorII
		ret
; End of function WriteInsReg


; =============== S U B	R O U T	I N E =======================================


PlaySoundID:
		ld	a, (zSoundQueue0)
		bit	7, a
		jp	z, StopAllSound			; 00-7F	- Stop All
		cp	bgm_Last+1Ah
		jp	c, zPlayMusic			; 80-9F	- Music
		cp	sfx_Last+1
		jp	c, PlaySFX			; 90-9F	- SFX
		cp	0E0h
		jp	c, PlaySpcSFX			; B0-DF	- Special SFX
		cp	0F9h
		jp	nc, StopAllSound

PlaySnd_Command:
		sub	0E0h
		ld	hl, CmdPtrTable
		rst	ReadPtrTable
		xor	a
		ld	(zUnk_1C18), a
		jp	(hl)
; ---------------------------------------------------------------------------
CmdPtrTable:	dw FadeOutMusic
		dw StopAllSound
		dw SilencePSG
		dw FadeInMusic
; ---------------------------------------------------------------------------

FadeInMusic:
		ld	ix, zTracksSFXEnd
		ld	b, 2
		ld	a, 80h
		ld	(zUpdateSound), a

loc_541:
		push	bc
		bit	7, (ix+zTrack.PlaybackControl)
		call	nz, loc_552
		ld	de, zTrack.len
		add	ix, de
		pop	bc
		djnz	loc_541
		ret
; ---------------------------------------------------------------------------

loc_552:
		push	hl
		push	hl
		jp	cfF2_StopTrk
; ---------------------------------------------------------------------------

zPlayMusic:
		sub	bgm_First
		ret	m
		ex	af, af'
		call	StopAllSound
		ex	af, af'
		push	af
		ld	hl, MusicBanks
		add	a, l
		ld	l, a
		adc	a, h
		sub	l
		ld	h, a
		ld	a, (hl)
		ld	(zMusicBank), a
		ld	hl, zMusicBank
		ld	a, (hl)
		bankswitch
		pop	af
		ld	hl, MusicIndex
		rst	ReadPtrTable
		push	hl
		push	hl
		ld	a, (hl)
		inc	hl
		ld	h, (hl)
		ld	l, a
		ld	(zVoiceTblPtr), hl
		pop	hl
		pop	iy
		ld	a, (iy+5)
		ld	(zTempoAccumulator), a
		ld	(zCurrentTempo), a
		ld	de, 6
		add	hl, de
		ld	(zSongPosition), hl
		ld	hl, FMInitBytes
		ld	(zTrackInitPos), hl
		ld	de, zTracksStart
		ld	b, (iy+2)
		ld	a, (iy+4)

loc_5B2:
		push	bc
		ld	hl, (zTrackInitPos)
		ldi
		ldi
		ld	(de), a
		inc	de
		ld	(zTrackInitPos), hl
		ld	hl, (zSongPosition)
		ldi
		ldi
		ldi
		ldi
		ld	(zSongPosition), hl
		call	FinishFMTrkInit
		pop	bc
		djnz	loc_5B2
		ld	a, (iy+3)
		or	a
		jp	z, ClearSoundID
		ld	b, a
		ld	hl, PSGInitBytes
		ld	(zTrackInitPos), hl
		ld	de, zSongPSG1
		ld	a, (iy+4)

loc_5E7:
		push	bc
		ld	hl, (zTrackInitPos)
		ldi
		ldi
		ld	(de), a
		inc	de
		ld	(zTrackInitPos), hl
		ld	hl, (zSongPosition)
		ld	bc, 6
		ldir
		ld	(zSongPosition), hl
		call	FinishTrkInit
		pop	bc
		djnz	loc_5E7
; End of function PlaySoundID

ClearSoundID:
		ld	a, 80h
		ld	(zSoundQueue0), a
		ret
; ---------------------------------------------------------------------------
FMInitBytes:	db  80h,   6
		db  80h,   0
		db  80h,   1
		db  80h,   2
		db  80h,   4
		db  80h,   5
		db  80h,   6
PSGInitBytes:	db  80h, 80h
		db  80h,0A0h
		db  80h,0C0h
; ---------------------------------------------------------------------------

PlaySpcSFX:
		ex	af, af'
		ld	hl, zBankRegister		; switch to Bank 018000
		xor	a				; Bank bits written: 003h
		ld	e, 1
		ld	(hl), e
		ld	(hl), e
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ex	af, af'
		sub	spec_First
		ex	af, af'
		ld	a, 80h
		ld	hl, SpecSoundIndex
		jr	loc_652
; ---------------------------------------------------------------------------

PlaySFX:
		ex	af, af'
		ld	hl, zBankRegister		; switch to Bank 018000
		xor	a				; Bank bits written: 003h
		ld	e, 1
		ld	(hl), e
		ld	(hl), e
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ex	af, af'
		sub	sfx_First
		ex	af, af'
		xor	a
		ld	hl, SoundIndex

loc_652:
		ld	(zUpdateSound), a
		ex	af, af'
		rst	ReadPtrTable
		push	hl
		ld	a, (hl)
		inc	hl
		ld	h, (hl)
		ld	l, a
		ld	(zSFXVoiceTblPtr), hl
		xor	a
		ld	(zUnk_1C15), a
		pop	hl
		push	hl
		pop	iy
		ld	a, (iy+2)
		ld	(zSFXTempoDivider), a
		ld	de, 4
		add	hl, de
		ld	b, (iy+3)

loc_674:
		push	bc
		push	hl
		inc	hl
		ld	c, (hl)
		call	GetSFXChnPtrs
		set	2, (hl)
		push	ix
		ld	a, (zUpdateSound)
		or	a
		jr	z, loc_688
		pop	hl
		push	iy

loc_688:
		pop	de
		pop	hl
		ldi
		ld	a, (de)
		cp	2
		call	z, ResetSpcFM3Mode
		ldi
		ld	a, (zSFXTempoDivider)
		ld	(de), a
		inc	de
		ldi
		ldi
		ldi
		ldi
		call	FinishFMTrkInit
		bit	7, (ix+zTrack.PlaybackControl)
		jr	z, loc_6B6
		ld	a, (ix+zTrack.VoiceControl)
		cp	(iy+1)
		jr	nz, loc_6B6
		set	2, (iy+0)

loc_6B6:
		push	hl
		ld	hl, (zSFXVoiceTblPtr)
		ld	a, (zUpdateSound)
		or	a
		jr	z, loc_6C4
		push	iy
		pop	ix

loc_6C4:
		ld	(ix+zTrack.VoicesLow), l
		ld	(ix+zTrack.VoicesHigh), h
		call	DoNoteOff
		call	DisableSSGEG
		pop	hl
		pop	bc
		djnz	loc_674
		jp	ClearSoundID

; =============== S U B	R O U T	I N E =======================================


GetSFXChnPtrs:
		bit	7, c
		jr	nz, loc_6E3
		ld	a, c
		bit	2, a
		jr	z, loc_6FA
		dec	a
		jr	loc_6FA
; ---------------------------------------------------------------------------

loc_6E3:
		ld	a, 1Fh
		call	SilencePSGChn
		ld	a, 0FFh
		ld	(zPSG), a
		ld	a, c
		srl	a
		srl	a
		srl	a
		srl	a
		srl	a
		add	a, 2

loc_6FA:
		sub	2
		ld	(zSFXSaveIndex), a
		push	af
		ld	hl, SFXChnPtrs
		rst	ReadPtrTable
		push	hl
		pop	ix				; IX - SFX Track
		pop	af
		push	af
		ld	hl, SpcSFXChnPtrs
		rst	ReadPtrTable
		push	hl
		pop	iy				; IY - Special SFX Track
		pop	af
		ld	hl, BGMChnPtrs
		rst	ReadPtrTable			; HL - Music Track
		ret
; End of function GetSFXChnPtrs


; =============== S U B	R O U T	I N E =======================================


FinishFMTrkInit:
		ex	af, af'
		xor	a
		ld	(de), a
		inc	de
		ld	(de), a
		inc	de
		ex	af, af'

FinishTrkInit:
		ex	de, hl
		ld	(hl), zTrack.len
		inc	hl
		ld	(hl), 0C0h
		inc	hl
		ld	(hl), 1
		ld	b, zTrack.len-zTrack.DurationTimeout-1

loc_728:
		inc	hl
		ld	(hl), 0
		djnz	loc_728
		inc	hl
		ex	de, hl
		ret
; End of function FinishTrkInit

; ---------------------------------------------------------------------------
SpcSFXChnPtrs:
		dw  zSpecSFX_FM3
		dw  zSpecSFX_FM3
		dw  zSpecSFX_FM3
		dw  zSpecSFX_FM3
		dw  zSpecSFX_FM3
		dw  zSpecSFX_FM3
		dw  zSpecSFX_FM3
		dw  zSpecSFX_FM3
SFXChnPtrs:
		dw  zSFX_FM3
		dw  zSFX_FM4
		dw  zSFX_FM5
		dw  zSFX_FM6
		dw  zSFX_PSG1
		dw  zSFX_PSG2
		dw  zSFX_PSG3
		dw  zSFX_PSG3
BGMChnPtrs:
		dw  zSongFM3
		dw  zSongFM4
		dw  zSongFM5
		dw  zSongFM6
		dw  zSongPSG1
		dw  zSongPSG2
		dw  zSongPSG3
		dw  zSongPSG3

; =============== S U B	R O U T	I N E =======================================


DoPause:
		ld	hl, zPauseFlag
		ld	a, (hl)
		or	a
		ret	z
		jp	m, UnpauseMusic
		pop	de
		dec	a
		ret	nz
		ld	(hl), 2
		jp	SilenceAll
; ---------------------------------------------------------------------------

UnpauseMusic:
		xor	a
		ld	(hl), a
		ld	a, (zFadeOutTimeout)
		or	a
		jp	nz, StopAllSound
		ld	ix, zTracksStart
		ld	b, (zSongPSG1-zTracksStart)/zTrack.len

loc_780:
		ld	a, (zHaltFlag)
		or	a
		jr	nz, locb_78C
		bit	7, (ix+zTrack.PlaybackControl)
		jr	z, loc_792

locb_78C:
		ld	c, (ix+zTrack.AMSFMSPan)
		ld	a, 0B4h
		rst	WriteFMIorII

loc_792:
		ld	de, zTrack.len
		add	ix, de
		djnz	loc_780
		ld	ix, zTracksSFXStart
		ld	b, (zTracksSpecSFXEnd-zTracksSFXStart)/zTrack.len

loc_79F:
		bit	7, (ix+zTrack.PlaybackControl)
		jr	z, loc_7B1
		bit	7, (ix+zTrack.VoiceControl)
		jr	nz, loc_7B1
		ld	c, (ix+zTrack.AMSFMSPan)
		ld	a, 0B4h
		rst	WriteFMIorII

loc_7B1:
		ld	de, zTrack.len
		add	ix, de
		djnz	loc_79F
		ret
; End of function DoPause

; ---------------------------------------------------------------------------

FadeOutMusic:
		ld	a, 28h
		ld	(zFadeOutTimeout), a
		ld	a, 6
		ld	(zFadeDelayTimeout), a
		ld	(zFadeDelay), a

; =============== S U B	R O U T	I N E =======================================


StopDrumPSG:
		xor	a
		ld	(zTracksStart), a
		ld	(zSongFM6), a
		ld	(zSongPSG3), a
		ld	(zSongPSG1), a
		ld	(zSongPSG2), a
		jp	SilencePSG
; End of function StopDrumPSG


; =============== S U B	R O U T	I N E =======================================


DoFading:
		ld	hl, zFadeOutTimeout
		ld	a, (hl)
		or	a
		ret	z
		call	m, StopDrumPSG
		res	7, (hl)
		ld	a, (zFadeDelayTimeout)
		dec	a
		jr	z, loc_7EE
		ld	(zFadeDelayTimeout), a
		ret
; ---------------------------------------------------------------------------

loc_7EE:
		ld	a, (zFadeDelay)
		ld	(zFadeDelayTimeout), a
		ld	a, (zFadeOutTimeout)
		dec	a
		ld	(zFadeOutTimeout), a
		jr	z, StopAllSound
		ld	hl, zMusicBank
		ld	a, (hl)
		bankswitch
		ld	hl, zUnk_1C06
		inc	(hl)
		ld	ix, zTracksStart
		ld	b, 6

loc_81D:
		bit	7, (ix+zTrack.PlaybackControl)
		jr	z, loc_82E
		bit	2, (ix+zTrack.PlaybackControl)
		jr	nz, loc_82E
		push	bc
		call	RefreshVolume
		pop	bc

loc_82E:
		ld	de, zTrack.len
		add	ix, de
		djnz	loc_81D
		ret
; End of function DoFading


; =============== S U B	R O U T	I N E =======================================


StopAllSound:
		ld	hl, zTempVariablesStart
		ld	de, zTempVariablesStart+1
		ld	bc, zTempVariablesEnd-zTempVariablesStart-1
		ld	(hl), 0
		ldir
		ld	ix, FMInitBytes
		ld	b, 6

loc_849:
		push	bc
		call	SilenceFMChn
		call	DisableSSGEG
		inc	ix
		inc	ix
		pop	bc
		djnz	loc_849
		ld	b, 7
		xor	a
		ld	(zUnk_1C06), a
		ld	(zDACIndex), a
		ld	(zFadeOutTimeout), a
		call	SilencePSG
		ld	c, 0
		ld	a, 2Bh
		call	WriteFMI

ResetSpcFM3Mode:
		xor	a
		ld	(zFM3Settings), a
		ld	c, a
		ld	a, 27h
		call	WriteFMI
		jp	ClearSoundID
; End of function StopAllSound


; =============== S U B	R O U T	I N E =======================================


DisableSSGEG:
		ld	a, 90h
		ld	c, 0
		jp	SendAllFMOps
; End of function DisableSSGEG

; ---------------------------------------------------------------------------

SilenceAll:
		call	SilencePSG
		push	bc
		push	af
		ld	b, 3
		ld	a, 0B4h
		ld	c, 0

loc_88C:
		push	af
		call	WriteFMI
		pop	af
		inc	a
		djnz	loc_88C
		ld	b, 3
		ld	a, 0B4h

loc_898:
		push	af
		call	WriteFMII
		pop	af
		inc	a
		djnz	loc_898
		ld	c, 0
		ld	b, 7
		ld	a, 28h

loc_8A6:
		push	af
		call	WriteFMI
		inc	c
		pop	af
		djnz	loc_8A6
		pop	af
		pop	bc

; =============== S U B	R O U T	I N E =======================================


SilencePSG:
		push	bc
		ld	b, 4
		ld	a, 9Fh

loc_8B5:
		ld	(zPSG), a
		add	a, 20h
		djnz	loc_8B5
		pop	bc
		jp	ClearSoundID
; End of function SilencePSG


; =============== S U B	R O U T	I N E =======================================


DoTempo:
		ld	a, (zCurrentTempo)
		ld	hl, zTempoAccumulator
		add	a, (hl)
		ld	(hl), a
		ret	nc
		ld	hl, zTracksStart+zTrack.DurationTimeout
		ld	de, zTrack.len
		ld	b, (zTracksEnd-zTracksStart)/zTrack.len ; Number of tracks

loc_8D1:
		inc	(hl)
		add	hl, de
		djnz	loc_8D1
		ret
; End of function DoTempo


; =============== S U B	R O U T	I N E =======================================


DoSoundQueue:
		ld	a, r
		ld	(zUnk_1C17), a
		ld	de, zSoundQueue1
		ld	b, (zSoundQueueEnd-zSoundQueueStart)-1

loc_8E0:
		ld	a, (de)
		ld	c, a
		bit	7, a
		jr	z, loc_905
		sub	bgm_Last
		jp	c, loc_90B
		sub	1Ah
		ld	hl, SndPriorities
		add	a, l
		ld	l, a
		adc	a, h
		sub	l
		ld	h, a
		ld	a, (zUnk_1C18)
		cp	(hl)
		jr	z, loc_8FD
		jr	nc, loc_905

loc_8FD:
		ld	a, c
		ld	(zSoundQueue0), a
		ld	a, (hl)
		ld	(zUnk_1C18), a

loc_905:
		xor	a
		ld	(de), a
		inc	de
		djnz	loc_8E0
		ret
; ---------------------------------------------------------------------------

loc_90B:
		ld	a, c
		ld	(zSoundQueue0), a
		xor	a
		ld	(zUnk_1C18), a
		ld	de, zSoundQueue1
		ld	(de), a
		inc	de
		ld	(de), a
		inc	de
		ld	(de), a
		ret
; End of function DoSoundQueue


; =============== S U B	R O U T	I N E =======================================


SilenceFMChn:
		call	SetMaxRelRate
		ld	a, 40h
		ld	c, 7Fh
		call	SendAllFMOps
		ld	c, (ix+zTrack.VoiceControl)
		jp	FMNoteOff
; End of function SilenceFMChn


; =============== S U B	R O U T	I N E =======================================


SetMaxRelRate:
		ld	a, 80h
		ld	c, 0FFh
; End of function SetMaxRelRate


; =============== S U B	R O U T	I N E =======================================


SendAllFMOps:
		ld	b, 4

loc_932:
		push	af
		rst	WriteFMIorII
		pop	af
		add	a, 4
		djnz	loc_932
		ret
; End of function SendAllFMOps

; ---------------------------------------------------------------------------
PSGFreqs:	dw  3FFh, 3FFh,	3FFh, 3FFh, 3FFh, 3FFh,	3FFh, 3FFh, 3FFh, 3F7h,	3BEh, 388h
		dw  356h, 326h,	2F9h, 2CEh, 2A5h, 280h,	25Ch, 23Ah, 21Ah, 1FBh,	1DFh, 1C4h
		dw  1ABh, 193h,	17Dh, 167h, 153h, 140h,	12Eh, 11Dh, 10Dh, 0FEh,	0EFh, 0E2h
		dw  0D6h, 0C9h,	0BEh, 0B4h, 0A9h, 0A0h,	 97h,  8Fh,  87h,  7Fh,	 78h,  71h
		dw   6Bh,  65h,	 5Fh,  5Ah,  55h,  50h,	 4Bh,  47h,  43h,  40h,	 3Ch,  39h
		dw   36h,  33h,	 30h,  2Dh,  2Bh,  28h,	 26h,  24h,  22h,  20h,	 1Fh,  1Dh
		dw   1Bh,  1Ah,	 18h,  17h,  16h,  15h,	 13h,  12h,  11h,  10h,	   0,	 0
FMFreqs:	dw  284h, 2ABh,	2D3h, 2FEh, 32Dh, 35Ch,	38Fh, 3C5h, 3FFh, 43Ch,	47Ch, 4C0h

; =============== S U B	R O U T	I N E =======================================


DrumUpdateTrack:
		call	TrackTimeout
		call	z, DrumUpdate_Proc
		ret
; End of function DrumUpdateTrack


; =============== S U B	R O U T	I N E =======================================


DrumUpdate_Proc:
		ld	e, (ix+zTrack.DataPointerLow)
		ld	d, (ix+zTrack.DataPointerHigh)

loc_A07:
		ld	a, (de)
		inc	de
		cp	0E0h
		jp	nc, cfHandler_Drum
		or	a
		jp	m, loc_A16
		dec	de
		ld	a, (ix+zTrack.FreqLow)

loc_A16:
		ld	(ix+zTrack.FreqLow), a
		or	a
		jp	p, loc_A3E
		push	de
		sub	80h
		jp	z, loc_A38
		ld	hl, zSongFM6
		set	2, (hl)
		ex	af, af'
		call	DoNoteOff
		ex	af, af'
		ld	hl, zTracksStart
		bit	2, (hl)
		jp	nz, loc_A38
		ld	(zDACIndex), a

loc_A38:
		pop	de
		ld	hl, zSongFM6
		res	2, (hl)

loc_A3E:
		ld	a, (de)
		inc	de
		or	a
		jp	p, SetDuration
		dec	de
		ld	a, (ix+zTrack.SavedDuration)
		ld	(ix+zTrack.DurationTimeout), a
		jp	loc_2A3
; ---------------------------------------------------------------------------

cfHandler_Drum:
		ld	hl, cfReturn_Drum
		jp	loc_A5B
; ---------------------------------------------------------------------------

cfReturn_Drum:
		inc	de
		jp	loc_A07
; ---------------------------------------------------------------------------

cfHandler:
		ld	hl, cfReturn

loc_A5B:
		push	hl
		sub	0E0h
		ld	hl, cfPtrTable
		rst	ReadPtrTable
		ld	a, (de)
		jp	(hl)
; End of function DrumUpdate_Proc

; ---------------------------------------------------------------------------

cfReturn:
		inc	de
		jp	loc_20B
; ---------------------------------------------------------------------------
cfPtrTable:	dw cfE0_Pan
		dw cfE1_Detune
		dw cfE2_SetComm
		dw cfE3_SilenceTrk
		dw cfE4_PanAnim
		dw cfE5_ChgPFMVol
		dw cfE6_ChgFMVol
		dw cfE7_Hold
		dw cfE8_NoteStop
		dw cfE9_SetLFO
		dw cfEA_PlayDAC
		dw cfEB_LoopExit
		dw cfEC_ChgPSGVol
		dw cfED_FMChnWrite
		dw cfEE_FM1Write
		dw cfEF_SetIns
		dw cfF0_Mods.betup
		dw cfF1_ModTypePFM
		dw cfF2_StopTrk
		dw cfF3_PSGNoise
		dw cfF4_ModType
		dw cfF5_SetPSGIns
		dw cfF6_GoTo
		dw cfF7_Loop
		dw cfF8_GoSub
		dw cfF9_Return
		dw cfFA_TickMult
		dw cfFB_ChgTransp
		dw cfFC_PitchSlide
		dw cfFD_RawFrqMode
		dw cfFE_SpcFM3Mode
		dw cfMetaCoordFlag
cfMetaPtrTable:	dw cf00_SetTempo
		dw cf01_PlaySnd
		dw cf02_MusPause
		dw cf03_CopyMem
		dw cf04_TickMulAll
		dw cf05_SSGEG
		dw cf06_FMVolEnv
; ---------------------------------------------------------------------------

cfEA_PlayDAC:
		ld	(zDACIndex), a
		ld	hl, zTracksStart
		set	2, (hl)
		ret

; =============== S U B	R O U T	I N E =======================================


cfE0_Pan:
		ld	c, 3Fh

loc_AC1:
		ld	a, (ix+zTrack.AMSFMSPan)
		and	c
		ex	de, hl
		or	(hl)
		ld	(ix+zTrack.AMSFMSPan), a
		ld	c, a
		ld	a, 0B4h
		rst	WriteFMIorII
		ex	de, hl
		ret
; End of function cfE0_Pan

; ---------------------------------------------------------------------------

cfE9_SetLFO:
		ld	c, a
		ld	a, 22h
		call	WriteFMI
		inc	de
		ld	c, 0C0h
		jr	loc_AC1
; ---------------------------------------------------------------------------

cfE1_Detune:
		ld	(ix+zTrack.Detune), a
		ret
; ---------------------------------------------------------------------------

cfE2_SetComm:
		ld	(zCommunicationByte), a
		ret
; ---------------------------------------------------------------------------

cfE3_SilenceTrk:
		call	SilenceFMChn
		jp	cfF2_StopTrk
; ---------------------------------------------------------------------------

cfE4_PanAnim:
		push	ix
		pop	hl
		ld	bc, 11h
		add	hl, bc
		ex	de, hl
		ld	bc, 5
		ldir
		ld	a, 1
		ld	(de), a
		ex	de, hl
		dec	de
		ret
; ---------------------------------------------------------------------------

cfE5_ChgPFMVol:
		inc	de
		add	a, (ix+zTrack.Volume)
		ld	(ix+zTrack.Volume),	a
		ld	a, (de)

cfE6_ChgFMVol:
		bit	7, (ix+zTrack.VoiceControl)
		ret	nz
		add	a, (ix+zTrack.Volume)
		ld	(ix+zTrack.Volume),	a

; =============== S U B	R O U T	I N E =======================================


RefreshVolume:
		push	de
		ld	de, zFMInstrumentTLTable
		ld	l, (ix+zTrack.TLPtrLow)
		ld	h, (ix+zTrack.TLPtrHigh)
		ld	b, zFMInstrumentTLTable_End-zFMInstrumentTLTable ; Number of entries

loc_B1B:
		ld	a, (hl)
		or	a
		jp	p, loc_B33
		add	a, (ix+zTrack.Volume)
		jp	m, loc_B28
		ld	a, 0FFh

loc_B28:
		push	hl
		ld	hl, zUnk_1C06
		add	a, (hl)
		jp	m, loc_B32
		ld	a, 0FFh

loc_B32:
		pop	hl

loc_B33:
		and	7Fh
		ld	c, a
		ld	a, (de)
		rst	WriteFMIorII
		inc	de
		inc	hl
		djnz	loc_B1B
		pop	de
		ret
; End of function RefreshVolume

; ---------------------------------------------------------------------------

cfE7_Hold:
		set	1, (ix+zTrack.PlaybackControl)
		dec	de
		ret
; ---------------------------------------------------------------------------

cfE8_NoteStop:
		call	TickMultiplier
		ld	(ix+zTrack.NoteFillTimeout), a
		ld	(ix+zTrack.NoteFillMaster), a
		ret
; ---------------------------------------------------------------------------

cfEB_LoopExit:
		inc	de
		add	a, zTrack.LoopCounters
		ld	c, a
		ld	b, 0
		push	ix
		pop	hl
		add	hl, bc
		ld	a, (hl)
		dec	a
		jp	z, loc_B5F
		inc	de
		ret
; ---------------------------------------------------------------------------

loc_B5F:
		xor	a
		ld	(hl), a
		jp	cfF6_GoTo
; ---------------------------------------------------------------------------

cfEC_ChgPSGVol:
		bit	7, (ix+zTrack.VoiceControl)
		ret	z
		res	4, (ix+zTrack.PlaybackControl)
		dec	(ix+zTrack.VolEnv)
		add	a, (ix+zTrack.Volume)
		cp	0Fh
		jp	c, loc_B7A
		ld	a, 0Fh

loc_B7A:
		ld	(ix+zTrack.Volume),	a
		ret
; ---------------------------------------------------------------------------

cfED_FMChnWrite:
		call	ReadFMCommand
		rst	WriteFMIorII
		ret
; ---------------------------------------------------------------------------

cfEE_FM1Write:
		call	ReadFMCommand
		call	WriteFMI
		ret

; =============== S U B	R O U T	I N E =======================================


ReadFMCommand:
		ex	de, hl
		ld	a, (hl)
		inc	hl
		ld	c, (hl)
		ex	de, hl
		ret
; End of function ReadFMCommand

; ---------------------------------------------------------------------------

cfEF_SetIns:
		bit	7, (ix+zTrack.VoiceControl)
		jr	nz, loc_BC9
		call	SetMaxRelRate
		ld	a, (de)
		ld	(ix+zTrack.VoiceIndex),	a
		or	a
		jp	p, loc_BBF
		inc	de
		ld	a, (de)
		ld	(ix+zTrack.VoiceSongID), a

; =============== S U B	R O U T	I N E =======================================


SetInsFromSong:
		push	de
		ld	a, (ix+zTrack.VoiceSongID)
		sub	81h
		ld	hl, MusicIndex
		rst	ReadPtrTable
		ld	a, (hl)
		inc	hl
		ld	h, (hl)
		ld	l, a
		ld	a, (ix+zTrack.VoiceIndex)
		and	7Fh
		ld	b, a
		call	JumpToInsData
		jr	loc_BC4
; ---------------------------------------------------------------------------

loc_BBF:
		push	de
		ld	b, a
		call	GetFMInsPtr

loc_BC4:
		call	SendFMIns
		pop	de
		ret
; End of function SetInsFromSong

; ---------------------------------------------------------------------------

loc_BC9:
		or	a
		ret	p
		inc	de
		ret
; ---------------------------------------------------------------------------

cfF0_Mods.betup:
		ld	(ix+zTrack.ModulationPtrLow), e
		ld	(ix+zTrack.ModulationPtrHigh), d
		ld	(ix+zTrack.ModulationCtrl),	80h
		inc	de
		inc	de
		inc	de
		ret
; ---------------------------------------------------------------------------

cfF1_ModTypePFM:
		inc	de
		bit	7, (ix+zTrack.VoiceControl)
		jr	nz, cfF4_ModType
		ld	a, (de)

cfF4_ModType:
		ld	(ix+zTrack.ModulationCtrl),	a
		ret
; ---------------------------------------------------------------------------

cfF2_StopTrk:
		res	7, (ix+zTrack.PlaybackControl)
		ld	a, 1Fh
		ld	(zUnk_1C15), a
		call	DoNoteOff
		ld	c, (ix+zTrack.VoiceControl)
		push	ix
		call	GetSFXChnPtrs
		ld	a, (zUpdateSound)
		or	a
		jp	z, loc_C94
		xor	a
		ld	(zUnk_1C18), a
		bit	7, (iy+0)
		jr	z, loc_C1E
		ld	a, (ix+zTrack.VoiceControl)
		cp	(iy+1)
		jr	nz, loc_C1E
		push	iy
		ld	l, (iy+zTrack.VoicesLow)
		ld	h, (iy+zTrack.VoicesHigh)
		jr	loc_C22
; ---------------------------------------------------------------------------

loc_C1E:
		push	hl
		ld	hl, (zVoiceTblPtr)

loc_C22:
		pop	ix
		res	2, (ix+zTrack.PlaybackControl)
		bit	7, (ix+zTrack.VoiceControl)
		jr	nz, loc_C99
		bit	7, (ix+zTrack.PlaybackControl)
		jr	z, loc_C94
		ld	a, 2
		cp	(ix+zTrack.VoiceControl)
		jr	nz, loc_C48
		ld	a, 4Fh
		bit	0, (ix+zTrack.PlaybackControl)
		jr	nz, loc_C45
		and	0Fh

loc_C45:
		call	SendFM3SpcMode

loc_C48:
		ld	a, (ix+zTrack.VoiceIndex)
		or	a
		jp	p, loc_C54
		call	SetInsFromSong
		jr	loc_C91
; ---------------------------------------------------------------------------

loc_C54:
		ld	b, a
		push	hl
		ld	hl, zMusicBank
		ld	a, (hl)
		bankswitch
		pop	hl
		call	JumpToInsData
		call	SendFMIns
		push	hl
		ld	hl, zBankRegister		; switch to Bank 018000
		xor	a				; Bank bits written: 003h
		ld	e, 1
		ld	(hl), e
		ld	(hl), e
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		ld	(hl), a
		pop	hl
		ld	a, (ix+zTrack.FMVolEnv)
		or	a
		jp	p, loc_C94
		ld	e, (ix+zTrack.FMVolEnvMask)
		ld	d, (ix+zTrack.PSGNoise)

loc_C91:
		call	Sends.bSGEG

loc_C94:
		pop	ix
		pop	hl
		pop	hl
		ret
; ---------------------------------------------------------------------------

loc_C99:
		bit	0, (ix+zTrack.PlaybackControl)
		jr	z, loc_C94
		ld	a, (ix+zTrack.PSGNoise)
		or	a
		jp	p, loc_CA9
		ld	(zPSG), a

loc_CA9:
		jr	loc_C94
; ---------------------------------------------------------------------------

cfF3_PSGNoise:
		bit	2, (ix+zTrack.VoiceControl)
		ret	nz
		ld	a, 0DFh
		ld	(zPSG), a
		ld	a, (de)
		ld	(ix+zTrack.PSGNoise), a
		set	0, (ix+zTrack.PlaybackControl)
		or	a
		jr	nz, loc_CC6
		res	0, (ix+zTrack.PlaybackControl)
		ld	a, 0FFh

loc_CC6:
		ld	(zPSG), a
		ret
; ---------------------------------------------------------------------------

cfF5_SetPSGIns:
		bit	7, (ix+zTrack.VoiceControl)
		ret	z
		ld	(ix+zTrack.VoiceIndex),	a
		ret
; ---------------------------------------------------------------------------

cfF6_GoTo:
		ex	de, hl
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		dec	de
		ret
; ---------------------------------------------------------------------------

cfF7_Loop:
		inc	de
		add	a, zTrack.LoopCounters
		ld	c, a
		ld	b, 0
		push	ix
		pop	hl
		add	hl, bc
		ld	a, (hl)
		or	a
		jr	nz, loc_CE9
		ld	a, (de)
		ld	(hl), a

loc_CE9:
		inc	de
		dec	(hl)
		jp	nz, cfF6_GoTo
		inc	de
		ret
; ---------------------------------------------------------------------------

cfF8_GoSub:
		ld	c, a
		inc	de
		ld	a, (de)
		ld	b, a
		push	bc
		push	ix
		pop	hl
		dec	(ix+zTrack.StackPointer)
		ld	c, (ix+zTrack.StackPointer)
		dec	(ix+zTrack.StackPointer)
		ld	b, 0
		add	hl, bc
		ld	(hl), d
		dec	hl
		ld	(hl), e
		pop	de
		dec	de
		ret
; ---------------------------------------------------------------------------

cfF9_Return:
		push	ix
		pop	hl
		ld	c, (ix+zTrack.StackPointer)
		ld	b, 0
		add	hl, bc
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		inc	(ix+zTrack.StackPointer)
		inc	(ix+zTrack.StackPointer)
		ret
; ---------------------------------------------------------------------------

cfFA_TickMult:
		ld	(ix+zTrack.TempoDivider),	a
		ret
; ---------------------------------------------------------------------------

cfFB_ChgTransp:
		add	a, (ix+zTrack.Transpose)
		ld	(ix+zTrack.Transpose),	a
		ret
; ---------------------------------------------------------------------------

cfFC_PitchSlide:
		cp	1
		jr	nz, loc_D31
		set	5, (ix+zTrack.PlaybackControl)
		ret
; ---------------------------------------------------------------------------

loc_D31:
		res	1, (ix+zTrack.PlaybackControl)
		res	5, (ix+zTrack.PlaybackControl)
		xor	a
		ld	(ix+zTrack.Detune), a
		ret
; ---------------------------------------------------------------------------

cfFD_RawFrqMode:
		cp	1
		jr	nz, loc_D47
		set	3, (ix+zTrack.PlaybackControl)
		ret
; ---------------------------------------------------------------------------

loc_D47:
		res	3, (ix+zTrack.PlaybackControl)
		ret
; ---------------------------------------------------------------------------

cfFE_SpcFM3Mode:
		ld	a, (ix+zTrack.VoiceControl)
		cp	2
		jr	nz, SpcFM3_skip
		set	0, (ix+zTrack.PlaybackControl)
		ex	de, hl
		call	GetFM3FreqPtr
		ld	b, 4

loc_D5D:
		push	bc
		ld	a, (hl)
		inc	hl
		push	hl
		ld	hl, FM3_FreqVals
		add	a, a
		ld	c, a
		ld	b, 0
		add	hl, bc
		ldi
		ldi
		pop	hl
		pop	bc
		djnz	loc_D5D
		ex	de, hl
		dec	de
		ld	a, 4Fh

; =============== S U B	R O U T	I N E =======================================


SendFM3SpcMode:
		ld	(zFM3Settings), a
		ld	c, a
		ld	a, 27h
		call	WriteFMI
		ret
; End of function SendFM3SpcMode

; ---------------------------------------------------------------------------

SpcFM3_skip:
		inc	de
		inc	de
		inc	de
		ret
; ---------------------------------------------------------------------------
FM3_FreqVals:	dw 0, 132h, 18Eh, 1E4h,	234h, 27Eh, 2C2h, 2F0h
; ---------------------------------------------------------------------------

cfMetaCoordFlag:
		ld	hl, cfMetaPtrTable
		rst	ReadPtrTable
		inc	de
		ld	a, (de)
		jp	(hl)
; ---------------------------------------------------------------------------

cf00_SetTempo:
		ld	(zCurrentTempo), a
		ld	(zTempoAccumulator), a
		ret
; ---------------------------------------------------------------------------

cf01_PlaySnd:
		ld	(zSoundQueue0), a
		ret
; ---------------------------------------------------------------------------

cf02_MusPause:
		ld	(zHaltFlag), a
		or	a
		jr	z, loc_DC8
		push	ix
		push	de

loc_DAE:
		ld	ix, zTracksStart
		ld	b, (zTracksEnd-zTracksStart)/zTrack.len ; Number of tracks
		ld	de, zTrack.len

loc_DB7:
		res	7, (ix+zTrack.PlaybackControl)
		call	SendNoteOff
		add	ix, de
		djnz	loc_DB7
		pop	de
		pop	ix
		jp	SilencePSG
; ---------------------------------------------------------------------------

loc_DC8:
		push	ix
		push	de
		ld	ix, zTracksStart
		ld	b, (zTracksEnd-zTracksStart)/zTrack.len ; Number of tracks
		ld	de, zTrack.len

loc_DD4:
		set	7, (ix+zTrack.PlaybackControl)
		add	ix, de
		djnz	loc_DD4
		pop	de
		pop	ix
		ret
; ---------------------------------------------------------------------------

cf03_CopyMem:
		ex	de, hl
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		inc	hl
		ld	c, (hl)
		ld	b, 0
		inc	hl
		ex	de, hl
		ldir
		dec	de
		ret
; ---------------------------------------------------------------------------

cf04_TickMulAll:
		ld	b, (zTracksEnd-zTracksStart)/zTrack.len ; Number of tracks
		ld	hl, zTracksStart+zTrack.TempoDivider ; Want to change tempo dividers

.loop:
		push	bc				; Save bc
		ld	bc, zTrack.len			; Spacing between tracks
		ld	(hl), a				; Set tempo divider for track
		add	hl, bc				; Advance to next track
		pop	bc				; Restore bc
		djnz	.loop
		ret
; ---------------------------------------------------------------------------

cf05_SSGEG:
		ld	(ix+zTrack.HaveSSGEGFlag), 80h
		ld	(ix+zTrack.SSGEGPointerLow), e
		ld	(ix+zTrack.SSGEGPointerHigh), d

; =============== S U B	R O U T	I N E =======================================


Sends.bSGEG:
		ld	hl, zFMInstrumentSSGEGTable
		ld	b, zFMInstrumentSSGEGTable_End-zFMInstrumentSSGEGTable

loc_E0C:
		ld	a, (de)
		inc	de
		ld	c, a
		ld	a, (hl)
		inc	hl
		rst	WriteFMIorII
		djnz	loc_E0C
		dec	de
		ret
; End of function Sends.bSGEG

; ---------------------------------------------------------------------------

cf06_FMVolEnv:
		ld	(ix+zTrack.FMVolEnv), a
		inc	de
		ld	a, (de)
		ld	(ix+zTrack.FMVolEnvMask), a
		ret
; ---------------------------------------------------------------------------

UpdatePSGTrk:
		call	TrackTimeout
		jr	nz, loc_E31
		call	TrkUpdate_Proc
		bit	4, (ix+zTrack.PlaybackControl)
		ret	nz
		call	PrepareModulat
		jr	loc_E3D
; ---------------------------------------------------------------------------

loc_E31:
		ld	a, (ix+zTrack.NoteFillTimeout)
		or	a
		jr	z, loc_E3D
		dec	(ix+zTrack.NoteFillTimeout)
		jp	z, SetRest

loc_E3D:
		call	DoPitchSlide
		call	DoModulation
		bit	2, (ix+zTrack.PlaybackControl)
		ret	nz
		ld	c, (ix+zTrack.VoiceControl)
		ld	a, l
		and	0Fh
		or	c
		ld	(zPSG), a
		ld	a, l
		and	0F0h
		or	h
		rrca
		rrca
		rrca
		rrca
		ld	(zPSG), a
		ld	a, (ix+zTrack.VoiceIndex)
		or	a
		ld	c, 0
		jr	z, loc_E6E
		dec	a
		ld	hl, VolEnvPtrs
		rst	ReadPtrTable
		call	DoPSGVolEnv
		ld	c, a

loc_E6E:
		bit	4, (ix+zTrack.PlaybackControl)
		ret	nz
		ld	a, (ix+zTrack.Volume)
		add	a, c
		bit	4, a
		jr	z, loc_E7D
		ld	a, 0Fh

loc_E7D:
		or	(ix+zTrack.VoiceControl)
		add	a, 10h
		bit	0, (ix+zTrack.PlaybackControl)
		jr	nz, loc_E8C
		ld	(zPSG), a
		ret
; ---------------------------------------------------------------------------

loc_E8C:
		add	a, 20h
		ld	(zPSG), a
		ret
; ---------------------------------------------------------------------------

loc_E92:
		ld	(ix+zTrack.VolEnv), a

; =============== S U B	R O U T	I N E =======================================


DoPSGVolEnv:
		push	hl
		ld	c, (ix+zTrack.VolEnv)
		ld	b, 0
		add	hl, bc
		ld	a, (hl)
		pop	hl
		bit	7, a
		jr	z, VolEnv_Next
		cp	83h
		jr	z, VolEnv_Off			; 83 - stop the	tone
		cp	81h
		jr	z, VolEnv_Hold			; 81 - hold the	envelope at current level
		cp	80h
		jr	z, VolEnv_Reset			; 80 - loop back to beginning
		inc	bc
		ld	a, (bc)
		jr	loc_E92
; ---------------------------------------------------------------------------

VolEnv_Off:
		set	4, (ix+zTrack.PlaybackControl)
		pop	hl
		jp	SetRest
; ---------------------------------------------------------------------------

VolEnv_Reset:
		xor	a
		jr	loc_E92
; ---------------------------------------------------------------------------

VolEnv_Hold:
		pop	hl
		set	4, (ix+zTrack.PlaybackControl)
		ret
; ---------------------------------------------------------------------------

VolEnv_Next:
		inc	(ix+zTrack.VolEnv)
		ret
; End of function DoPSGVolEnv


; =============== S U B	R O U T	I N E =======================================


SetRest:
		set	4, (ix+zTrack.PlaybackControl)
		bit	2, (ix+zTrack.PlaybackControl)
		ret	nz
; End of function SetRest


; =============== S U B	R O U T	I N E =======================================


SilencePSGChn:
		ld	a, 1Fh
		add	a, (ix+zTrack.VoiceControl)
		or	a
		ret	p
		ld	(zPSG), a
		bit	0, (ix+zTrack.PlaybackControl)
		ret	z
		ld	a, 0FFh
		ld	(zPSG), a
		ret
; End of function SilencePSGChn

; ---------------------------------------------------------------------------

zPlayDigitalAudio:
		di					; 4
		ld	a, 2Bh				; 7
		ld	c, 0				; 7
		call	WriteFMI			; 17

loc_EED:
		ei					; 4
		ld	a, d				; 4
		or	e				; 4
		jr	z, loc_EED			; 7
		ei					; 4

DACLoop:
		ld	b, 0Ah				; 7

loc_EF5:
		djnz	$				; 8
		ld	a, (hl)				; 7
		rlca					; 4
		rlca					; 4
		rlca					; 4
		rlca					; 4
		and	0Fh				; 7
		ld	(loc_F02+2), a			; 13
		ld	a, c				; 4

loc_F02:
		add	a, (iy+0)			; 19
		ld	c, a				; 4
		ld	a, 2Ah				; 7
		di					; 4
		ld	(zYM2612_A0), a			; 13
		ld	a, c				; 4
		ld	(zYM2612_D0), a			; 13
		ei					; 4

loc_F11:
		ld	b, 0Ah				; 7

loc_F13:
		djnz	$				; 8
		ld	a, (hl)				; 7
		and	0Fh				; 7
		ld	(loc_F1C+2), a			; 13
		ld	a, c				; 4

loc_F1C:
		add	a, (iy+0)			; 19
		ld	c, a				; 4
		ld	a, 2Ah				; 7
		di					; 4
		ld	(zYM2612_A0), a			; 13
		ld	a, c				; 4
		ld	(zYM2612_D0), a			; 13
		ei					; 4
		inc	hl				; 6
		ld	a, h				; 4
		or	l				; 4
		jp	nz, .loc_F52			; 10
							; 268 cycles in total
		ld	hl, zROMWindow
		di
		exx
		ld	hl, zSoundBank
		inc	(hl)
		ld	hl, zSoundBank
		ld	a, (hl)
		bankswitch
		exx
		ei

.loc_F52:
		dec	de
		ld	a, d
		or	e
		jp	nz, DACLoop
		ld	hl, zTracksStart
		res	2, (hl)
		xor	a
		ld	(zDACIndex), a
		jp	zPlayDigitalAudio
; ---------------------------------------------------------------------------
; ===========================================================================
; JMan2050's DAC decode lookup table
; ===========================================================================
DecTable:
		db	   0,	 1,   2,   4,   8,  10h,  20h,  40h
		db	 80h,	-1,  -2,  -4,  -8, -10h, -20h, -40h
VolEnvPtrs:	dw PSG1,PSG2,PSG3,PSG4,PSG5,PSG6
		dw PSG7,PSG8,PSG9,PSGA,PSGB,PSGC
PSG1:		binclude "PSG/PSG 1.bin"
PSG2:		binclude "PSG/PSG 2.bin"
PSG3:		binclude "PSG/PSG 3.bin"
PSG4:		binclude "PSG/PSG 4.bin"
PSG5:		binclude "PSG/PSG 5.bin"
PSG6:		binclude "PSG/PSG 6.bin"
PSG7:		binclude "PSG/PSG 7.bin"
PSG8:		binclude "PSG/PSG 8.bin"
PSG9:		binclude "PSG/PSG 9.bin"
PSGA:		binclude "PSG/PSG A.bin"
PSGB:		binclude "PSG/PSG B.bin"
PSGC:		binclude "PSG/PSG C.bin"
ModEnvPtrs:	dw byte_1024, byte_1030, byte_103D, byte_1049, byte_108B
		dw byte_10C0, byte_10FD, byte_1117, byte_1131, byte_1139
byte_1024:	db  40h, 60h, 70h, 60h,	50h, 30h, 10h,-10h,-30h,-50h,-70h
		db  83h
byte_1030:	db    0,   2,	4,   6,	  8, 0Ah, 0Ch, 0Eh, 10h, 12h, 14h
		db  18h
		db  81h
byte_103D:	db    0,   0,	1,   3,	  1,   0,  -1,	-3,  -1,   0
		db  82h, 02h
byte_1049:	db    0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0
		db    0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0
		db    0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0
		db    0,   0,	0,   0,	  0,   0,   0,	 2,   4,   6,	8
		db  0Ah, 0Ch, 0Ah,   8,	  6,   4,   2,	 0,  -2,  -4,  -6
		db   -8,-0Ah,-0Ch,-0Ah,	 -8,  -6,  -4,	-2,   0
		db  82h, 29h
byte_108B:	db    0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0
		db    0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0
		db    0,   0,	0,   0,	  0,   0,   2,	 4,   6,   8, 0Ah
		db  0Ch, 0Ah,	8,   6,	  4,   2,   0,	-2,  -4,  -6,  -8
		db -0Ah,-0Ch,-0Ah,  -8,	 -6,  -4,  -2
		db  82h, 1Bh
byte_10C0:	db    0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0
		db    0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0
		db    0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0
		db    0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0
		db    0,   0,	0,   0,	  0,   0,   3,	 6,   3,   0,  -3
		db   -6,  -6,  -3,   0
		db  82h, 33h
byte_10FD:	db    0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0
		db    0,   0,	0,   0,	  0,   2,   4,	 2,   0,  -2,  -4
		db   -2,   0
		db  82h, 11h
byte_1117:	db   -2,  -1,	0,   0,	  0,   0,   0,	 0,   0,   0,	0
		db    0,   0,	0,   0,	  0,   0,   0,	 1,   1,   0,	0
		db   -1,  -1
		db  82h, 11h
byte_1131:	db    3,   2,	1,   0,	  0,   0,   1
		db  81h
byte_1139:	db    0,   0,	0,   0,	  1,   1,   1,	 1,   2,   2,	1
		db    1,   1,	0,   0,	  0
		db  84h, 01h, 82h, 04h
MusicBanks:
	; The way that this works is that each individual music track has it's own bank
	; that it uses for finding and playing music from banks.
	rept 6
		db zmake68kBank(MusicBank)
	endm
MusicIndex:
ptr_mus81:	dw zmake68kPtr(Music81)
ptr_mus82:	dw zmake68kPtr(Music82)
ptr_mus83:	dw zmake68kPtr(Music83)
ptr_mus84:	dw zmake68kPtr(Music84)
ptr_mus85:	dw zmake68kPtr(Music85)
ptr_mus86:	dw zmake68kPtr(Music86)
ptr_musend

SoundIndex:
		; DANGER!
		; These pointers along with the pointers inside of the SFX are
		; all half a bank too long!
		; To fix this, remove the +4000h and +$4000 from both the pointers
		; here and in the SMPS data itself.
ptr_sndA0:	dw zmake68kPtr(SoundA0)+4000h
ptr_sndA1:	dw zmake68kPtr(SoundA1)+4000h
ptr_sndA2:	dw zmake68kPtr(SoundA2)+4000h
ptr_sndA3:	dw zmake68kPtr(SoundA3)+4000h
ptr_sndA4:	dw zmake68kPtr(SoundA4)+4000h
ptr_sndA5:	dw zmake68kPtr(SoundA5)+4000h
ptr_sndA6:	dw zmake68kPtr(SoundA6)+4000h
ptr_sndA7:	dw zmake68kPtr(SoundA7)+4000h
ptr_sndA8:	dw zmake68kPtr(SoundA8)+4000h
ptr_sndA9:	dw zmake68kPtr(SoundA9)+4000h
ptr_sndAA:	dw zmake68kPtr(SoundAA)+4000h
ptr_sndAB:	dw zmake68kPtr(SoundAB)+4000h
ptr_sndAC:	dw zmake68kPtr(SoundAC)+4000h
ptr_sndAD:	dw zmake68kPtr(SoundAD)+4000h
ptr_sndAE:	dw zmake68kPtr(SoundAE)+4000h
ptr_sndAF:	dw zmake68kPtr(SoundAF)+4000h
ptr_sndend

SpecSoundIndex:
		; DANGER!
		; Once again, these pointers along with the pointers inside of the
		; SFX are all half a bank too long!
		; To fix this, remove the +4000h and +$4000 from both the pointers
		; here and in the SMPS data itself.
ptr_sndD0:	dw zmake68kPtr(SoundA0)+4000h
ptr_sndD1:	dw zmake68kPtr(SoundA1)+4000h
ptr_sndD2:	dw zmake68kPtr(SoundA3)+4000h
ptr_specend

SndPriorities:	db 7Fh,	7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh,	7Fh, 7Fh
		db 7Fh,	7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh,	7Fh, 7Fh
		db 7Fh,	7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh,	7Fh, 7Fh
		db 7Fh,	7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh,	7Fh, 7Fh
		db 7Fh,	7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh,	7Fh, 7Fh
		db 7Fh,	7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh,	7Fh, 7Fh
		db 7Fh,	7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh,	7Fh, 7Fh
		db 7Fh,	7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh,	7Fh, 7Fh
		db 7Fh
DAC_Index:	dw .dac81
		dw .dac82
		dw .dac83
		dw .dac84
		dw .dac85
		dw .dac86
		dw .dac87
.dac81:		db dpcmLoopCounter(4800)
		db zmake68kBank(DACBank)
		dw DAC_Sample1_End-DAC_Sample1
		dw zmake68kPtr(DAC_Sample1)
.dac82:		db dpcmLoopCounter(14000)
		db zmake68kBank(DACBank)
		dw DAC_Sample2_End-DAC_Sample2
		dw zmake68kPtr(DAC_Sample2)
.dac83:		db dpcmLoopCounter(14000)
		db zmake68kBank(DACBank)
		dw DAC_Sample3_End-DAC_Sample3
		dw zmake68kPtr(DAC_Sample3)
.dac84:		db dpcmLoopCounter(12000)
		db zmake68kBank(DACBank)
		dw DAC_Sample3_End-DAC_Sample3
		dw zmake68kPtr(DAC_Sample3)
.dac85:		db dpcmLoopCounter(11000)
		db zmake68kBank(DACBank)
		dw DAC_Sample3_End-DAC_Sample3
		dw zmake68kPtr(DAC_Sample3)
.dac86:		db dpcmLoopCounter(14000)
		db zmake68kBank(DACBank)
		dw DAC_Sample4_End-DAC_Sample4
		dw zmake68kPtr(DAC_Sample4)
.dac87:		db dpcmLoopCounter(14000)
		db zmake68kBank(DACBank)
		dw DAC_Sample5_End-DAC_Sample5
		dw zmake68kPtr(DAC_Sample5)

		restore
		padding	off
		dephase					; reset to 68K location
