
    AREA    |.text|, CODE, READONLY, ALIGN=2
	EXPORT __main

__main

; accesing SYSCTL_RCGC2_R location 
	mov   r0,#0x40000000
	mov	  r1,#0x0f0000
	ORR	  r1,r1,r0
	mov   r0,#0xe100
	ORR	  r1,r1,r0
	mov   r0,#0x08
	ORR	  r1,r1,r0
	
; set port f clock 0x20 
	mov   r0,#0x20
	STR   r0,[r1,#0x00]
	mov   r0,#0x00 
; wait 8 cycle to make clock work
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
;make r12 offest of the portf
	MOV   r0,#0x40000000
	mov	  r12,#0x020000
	ORR	  r12,r12,r0
	mov   r0,#0x5000
	ORR	  r12,r12,r0	
;open lock rigister GPIO_PORTF_LOCK_R	
	mov   r0,#0x4c000000
	mov	  r1,#0x4f0000
	ORR	  r1,r1,r0
	mov   r0,#0x4300
	ORR	  r1,r1,r0
	mov   r0,#0x4b
	ORR	  r1,r1,r0
	STR   r1,[r12,#0x520]
;enable changes on portf 
	mov   r0,#0x1f
	str   r0,[r12,#0x524]
;set dircation pf4,pf0 input , pf1,pf2,pf3 output
	mov   r0,#0x0e ;0 means input 1 mean output
	str   r0,[r12,#0x400]
;enable pull-up input pf4,pf1
	mov   r0,#0x11
	str   r0,[r12,#0x510]
;enable digital pins pf0:pf4
	mov   r0,#0x1f
	str   r0,[r12,#0x51c]
	
;store the possable conditions
	mov r1,#0x00 ; 2switch on >> blue
 	mov r2,#0x01 ; sw1 on >> red 
	mov r3,#0x10 ; sw2 on >> green
	mov r4,#0x11 ; 2switch off >> dark 
	
	
loop 
	;read pf4,pf0
	ldr r0,[r12,#0x3FC] ; read gpio_data
	and r0,#0x11 ; masking 
	cmp r0,r1
	BEQ blue
	
	cmp r0,r2
	BEQ red
	
	cmp r0,r3
	BEQ green
	
	cmp r0,r4
	BEQ dark
	
dark 
	mov r0,#0x00 ; dark
	str r0,[r12,#0x3FC]
	B loop
	
red 
	mov r0,#0x02 ; red
	str r0,[r12,#0x3FC]
	B loop
	
green 
	mov r0,#0x08 ; green
	str r0,[r12,#0x3FC]
	B loop
	
blue 
	mov r0,#0x04 ; blue
	str r0,[r12,#0x3FC]
	B loop
	
	END