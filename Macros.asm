; calculates initial loop counter value for a dbf loop
; that writes n bytes total at 4 bytes per iteration
bytesToLcnt function n,n>>2-1

; calculates initial loop counter value for a dbf loop
; that writes n bytes total at 2 bytes per iteration
bytesToWcnt function n,n>>1-1

; calculates initial loop counter value for a dbf loop
; that writes n bytes total at x bytes per iteration
bytesToXcnt function n,x,n/x-1

; ---------------------------------------------------------------------------
; Fill portion of RAM with contents from d0
; input: start, end
; ---------------------------------------------------------------------------

FillRAM:	macro start,end
		lea	(start).w,a1
		move.w	#((end)-(start))/4-1,d1

.loop:
		move.l	d0,(a1)+
		dbf	d1,.loop

	if (end-start)&2
		move.w	d0,(a1)+
	endif

	if (end-start)&1
		move.b	d0,(a1)+
	endif
		endm

; ---------------------------------------------------------------------------
; start the Z80
; ---------------------------------------------------------------------------
startZ80:       macro
		move.w	#0,(z80_bus_request).l
		endm

; ---------------------------------------------------------------------------
; stop the Z80
; ---------------------------------------------------------------------------
stopZ80:        macro
		move.w	#$100,(z80_bus_request).l
		endm

; ---------------------------------------------------------------------------
; wait for Z80 to stop
; ---------------------------------------------------------------------------

waitZ80:	macro
.wait:		btst	#0,(z80_bus_request).l
		bne.s	.wait
		endm

; ---------------------------------------------------------------------------
; reset the Z80
; ---------------------------------------------------------------------------

resetZ80:	macro
		move.w	#$100,(z80_reset).l
		endm

resetZ80a:	macro
		move.w	#0,(z80_reset).l
		endm

; ---------------------------------------------------------------------------
; disable interrupts
; ---------------------------------------------------------------------------

disable_ints:	macro
		move	#$2700,sr
		endm

; ---------------------------------------------------------------------------
; enable interrupts
; ---------------------------------------------------------------------------

enable_ints:	macro
		move	#$2300,sr
		endm
		
; function to make a little-endian 16-bit pointer for the Z80 sound driver
z80_ptr function x,(x)<<8&$FF00|(x)>>8&$7F|$80

; Function to make a little endian (z80) pointer
k68z80Pointer function addr,((((addr&$7FFF)+$8000)<<8)&$FF00)+(((addr&$7FFF)+$8000)>>8)

little_endian function x,(x)<<8&$FF00|(x)>>8&$FF

startBank macro {INTLABEL}
	align	$8000
__LABEL__ label *
soundBankStart := __LABEL__
soundBankName := "__LABEL__"
    endm

DebugSoundbanks := 1

finishBank macro
	if * > soundBankStart + $8000
		fatal "soundBank \{soundBankName} must fit in $8000 bytes but was $\{*-soundBankStart}. Try moving something to the other bank."
	elseif (DebugSoundbanks<>0)&&(MOMPASS=1)
		message "soundBank \{soundBankName} has $\{$8000+soundBankStart-*} bytes free at end."
	endif
    endm
    
; sign-extends a 32-bit integer to 64-bit
; all RAM addresses are run through this function to allow them to work in both 16-bit and 32-bit addressing modes
ramaddr function x,(-(x&$80000000)<<1)|x   
    
; ---------------------------------------------------------------------------
; turn a sample rate into a djnz loop counter
; ---------------------------------------------------------------------------

pcmLoopCounter function sampleRate,baseCycles, 1+(53693175/15/(sampleRate)-(baseCycles)+(13/2))/13
dpcmLoopCounter function sampleRate, pcmLoopCounter(sampleRate,268/2) ; 268 is the number of cycles zPlayPCMLoop takes.
