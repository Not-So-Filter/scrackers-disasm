
	phase	$FFFF0000
v_startofram:	ds.b $200

v_systemstack:	ds.b $200
unk_0400:	ds.b $200
unk_0600:	ds.b $200
v_128x128:	equ $FF0D08
v_ngfx_buffer:	equ $FFFFD59A
v_gamemode:	equ $FFFFD822			; (2 bytes)
v_subgamemode =	v_gamemode+2
	dephase
	!org 0
