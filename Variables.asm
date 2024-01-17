; VDP addressses
vdp_data_port:		equ $C00000
vdp_control_port:	equ $C00004

; Z80 addresses
z80_ram:		equ $A00000	; start of Z80 RAM
z80_dac_status:		equ z80_ram+zDAC_Status
z80_dac_sample:		equ z80_ram+zDAC_Sample
z80_ram_end:		equ $A02000	; end of non-reserved Z80 RAM
z80_version:		equ $A10001
z80_port_1_control:	equ $A10008
z80_expansion_control:	equ $A1000C
z80_bus_request:	equ $A11100
z80_reset:		equ $A11200


v_128x128:		equ $FF0D08
v_ngfx_buffer:		equ $FFFFD59A
v_gamemode:		equ $FFFFD822	; (2 bytes)