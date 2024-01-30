; VDP addressses
vdp_data_port:		equ $C00000
vdp_control_port:	equ $C00004

; Z80 addresses
z80_ram:		equ $A00000			; start of Z80 RAM
z80_dac_status:		equ z80_ram+zDAC_Status
z80_dac_sample:		equ z80_ram+zDAC_Sample
z80_ram_end:		equ $A02000			; end of non-reserved Z80 RAM
z80_version:		equ $A10001
z80_port_1_control:	equ $A10008
z80_expansion_control:	equ $A1000C
z80_bus_request:	equ $A11100
z80_reset:		equ $A11200

id_Sega:	equ ptr_GM_Sega-GameModeArray
id_Title:	equ ptr_GM_Title-GameModeArray
id_Field:	equ ptr_GM_Field-GameModeArray
id_Level:	equ ptr_GM_Level-GameModeArray
id_Null:	equ ptr_GM_Null-GameModeArray
id_LevelSelect:	equ ptr_GM_LevelSelect-GameModeArray
id_Options:	equ ptr_GM_Options-GameModeArray

; Object variables
obMap:		equ $10					; mappings address (4 bytes)

; Background music
bgm_First:	equ $81
bgm_Electoria:	equ ((ptr_mus81-MusicIndex)/2)+bgm_First
bgm_Walkin:	equ ((ptr_mus82-MusicIndex)/2)+bgm_First
bgm_HyperHyper:	equ ((ptr_mus83-MusicIndex)/2)+bgm_First
bgm_EveningStar:	equ ((ptr_mus84-MusicIndex)/2)+bgm_First
bgm_Moonrise:	equ ((ptr_mus85-MusicIndex)/2)+bgm_First
bgm_GameOver:	equ ((ptr_mus86-MusicIndex)/2)+bgm_First
bgm_Last:	equ ((ptr_musend-MusicIndex-2)/2)+bgm_First

; Sound effects
sfx_First:	equ $A0
sfx_Jump:	equ ((ptr_sndA0-SoundIndex)/2)+sfx_First
sfx_Cash:	equ ((ptr_sndA1-SoundIndex)/2)+sfx_First
sfx_A2:		equ ((ptr_sndA2-SoundIndex)/2)+sfx_First
sfx_Bomb:	equ ((ptr_sndA3-SoundIndex)/2)+sfx_First
sfx_Skid:	equ ((ptr_sndA4-SoundIndex)/2)+sfx_First
sfx_RingLoss:	equ ((ptr_sndA5-SoundIndex)/2)+sfx_First
sfx_Ring:	equ ((ptr_sndA6-SoundIndex)/2)+sfx_First
sfx_BreakItem:	equ ((ptr_sndA7-SoundIndex)/2)+sfx_First
sfx_Spring:	equ ((ptr_sndA8-SoundIndex)/2)+sfx_First
sfx_Lamppost:	equ ((ptr_sndA9-SoundIndex)/2)+sfx_First
sfx_AA:		equ ((ptr_sndAA-SoundIndex)/2)+sfx_First
sfx_AB:		equ ((ptr_sndAB-SoundIndex)/2)+sfx_First
sfx_AC:		equ ((ptr_sndAC-SoundIndex)/2)+sfx_First
sfx_AD:		equ ((ptr_sndAD-SoundIndex)/2)+sfx_First
sfx_AE:		equ ((ptr_sndAE-SoundIndex)/2)+sfx_First
sfx_AF:		equ ((ptr_sndAF-SoundIndex)/2)+sfx_First
sfx_Last:	equ ((ptr_sndend-SoundIndex-2)/2)+sfx_First

; Special sound effects
spec_First:	equ $D0
spec_Jump:	equ ((ptr_sndD0-SpecSoundIndex)/2)+spec_First
spec_Cash:	equ ((ptr_sndD1-SpecSoundIndex)/2)+spec_First
spec_Bomb:	equ ((ptr_sndD2-SpecSoundIndex)/2)+spec_First
spec_Last:	equ ((ptr_sndend-SpecSoundIndex-2)/2)+spec_First

flg_First:	= $E0
flg_FadeOut:	equ ((ptr_flgE0-CmdPtrTable)/2)+flg_First
flg_Stop:	equ ((ptr_flgE1-CmdPtrTable)/2)+flg_First
flg_StopPSG:	equ ((ptr_flgE2-CmdPtrTable)/2)+flg_First
flg_FadeIn:	equ ((ptr_flgE3-CmdPtrTable)/2)+flg_First
flg_Last:	equ ((ptr_flgend-CmdPtrTable)/2)+flg_First