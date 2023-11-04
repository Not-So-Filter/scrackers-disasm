; VDP addressses
vdp_data_port:		equ $C00000
vdp_control_port:	equ $C00004

soundqueue0:	equ $1C0A
ym2612_a0:	equ $4000
ym2612_d0:	equ $4001
ym2612_a1:	equ $4002
ym2612_d1:	equ $4003


; Z80 addresses
z80_ram:		equ $A00000	; start of Z80 RAM
z80_soundqueue0:	equ z80_ram+soundqueue0
z80_dac_status:		equ z80_ram+$1FFD
z80_dac_sample:		equ z80_ram+$1FFF
z80_ram_end:		equ z80_ram+$2000	; end of non-reserved Z80 RAM
z80_version:		equ $A10001
z80_port_1_control:	equ $A10008
z80_expansion_control:	equ $A1000C
z80_bus_request:	equ $A11100
z80_reset:		equ $A11200

v_ngfx_buffer:		equ $FFFFD59A