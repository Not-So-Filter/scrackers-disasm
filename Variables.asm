
	phase	ramaddr($FFFF0000)
v_startofram:	ds.b $200

v_systemstack:	
unk_0200:	ds.b $200
unk_0400:	ds.b $200
unk_0600:	ds.b $200
unk_0800:	ds.b $200
unk_0A00:	ds.b $102
unk_0B02:	ds.b $82
unk_0B84:	ds.b $102
unk_0C86:	ds.b $82
v_128x128:	ds.b $BAF8
unk_C800:	ds.b $12
unk_C812:	ds.b 6
unk_C818:	ds.b 6
unk_C81E:	ds.b 6
unk_C824:	ds.b 6
unk_C82A:	ds.b 6
unk_C830:	ds.b 2
v_vdpindex:	ds.l 1
unk_C836:	ds.b 6
	ds.b $FA
unk_C936:	ds.b 1
unk_C937:	ds.b 1
unk_C938:	ds.b 1
v_ngfx_buffer:	equ ramaddr($FFFFD59A)
v_gamemode:	equ ramaddr($FFFFD822)			; (2 bytes)
v_subgamemode =	v_gamemode+2

v_titleselect:	equ ramaddr($FFFFD826)

v_menu_soundid:	equ ramaddr($FFFFD82A)

v_lagger:	equ ramaddr($FFFFFFC9)

v_text:		equ ramaddr($FFFFFFC0)
	dephase
	!org 0
