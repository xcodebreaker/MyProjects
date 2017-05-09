bits 16
ma:
	cli
	;WRITE YOUR CODE HERE
	  mov ax,13 	; mode = 13h 
      int 10h 	; call bios service
	;enable mouse
	  xor         eax, eax
      call        WriteMouseWait
      mov         al, 0xa8
      out         0x64, al
	; call        MouseRead  ;;;error here 
	    
	  ;restore default settings
	   mov         al, 0xf6
       call        MouseWrite
	   
     call         MouseRead
      mov         byte [packetsize], 3
      or         al, al
      jz         noZaxis
      mov         byte [packetsize], 4
noZaxis:   ;enable 4th and 5th buttons
      mov         al, 0F3h
      call         MouseWrite
      mov         al, 200
      call         MouseWrite
      mov         al, 0F3h
      call         MouseWrite
      mov         al, 200
      call         MouseWrite
      mov         al, 0F3h
      call         MouseWrite
      mov         al, 80
      call         MouseWrite
      mov         al, 0F2h
      call         MouseWrite
     ;call         MouseRead

      ;set sample rate
      mov         al, 0F3h
      call         MouseWrite
      mov         al, byte[samplerate] ;200
      call         MouseWrite
      ;set resolution
      mov         al, 0E8h
      call         MouseWrite
      mov         al, byte [resolution] ;3
      call         MouseWrite
      ;set scaling 1:1
      mov         al, 0E6h
      call         MouseWrite
     
	   ;enable mouse
	  mov         al, 0xf4
      call        MouseWrite
	   
	   
	   
	   ;Main
	  
	   xor         ecx, ecx
       xor         eax, eax
	   
	  waitkey: 
	  in          al, 0x64
      and         al, 0x01
      jz          waitkey
	 
	 
	 
   call clearMouse
   
   
   
	xor ax,ax
	xor dx,dx
	
	  call        MouseRead
      mov         byte [k], al
	  call        MouseRead
					movsx dx,al
					mov ax,dx
      add         [x], ax
	  mov word ax,[x]
	  cmp word [x],0
	  mov dx,0
	  cmovle  ax,dx
	  mov word [x],ax
	  
	  mov word ax,[x]
	  cmp word [x],314
	  mov dx,314
	  cmovge  ax,dx
	  mov word [x],ax
	 
	 
	xor ax,ax
	xor dx,dx
      call        MouseRead
					movsx dx,al
					mov ax,dx
      sub         [y], ax 
	  mov word ax,[y]
	  cmp word [y],0
	  mov dx,0
	  cmovle  ax,dx
	  mov word [y],ax
	  
	  mov word ax,[y]
	  cmp word [y],192
	  mov dx,192
	  cmovge  ax,dx
	  mov word [y],ax
	  call        MouseRead
      mov         byte [z], al
	
	;call show
    call drawMouse
   
   
      
	 be:
	  
	  jmp waitkey
	  
	  ret
	  

	  
WriteMouseWait:
	  mov        ecx, 1000
	strt1:  
      in         al, 0x64
      and        al, 0x02
      jz         fin1    ;;;;;;;;;;;;;;
      dec        ecx
	  cmp        ecx,0
	  jnz        strt1
	  
    fin1:
	  ret
	  
ReadMouseWait:
	  mov        ecx, 1000
	strt2:  
      in         al, 0x64
      and        al, 0x01
      jnz        fin2    ;;;;;;;;;;;;;;
      dec        ecx
	  cmp        ecx,0
	  jnz        strt2
	  ;call       Errorread
    fin2:
	  ret
	
	MouseRead:
      call         ReadMouseWait
      in           al, 0x60
      ret
	
	MouseWrite:
      mov         dh, al
      call         WriteMouseWait
      mov         al, 0xd4
      out         0x64, al
      call         WriteMouseWait
      mov         al, dh
      out         0x60, al
      ;no ret, fall into read code to read ack
      call         ReadMouseWait
      in         al, 0x60
      ret
	 
	  
	  drawMouse:
		
		xor edx,edx
		loop1:
		xor ecx,ecx
			loop2:
				mov al,[pointer+edx*8+ecx]
				push cx
				push dx
				add dx,[y]
				add cx,[x]
				mov ah,0Ch
				int 10h
				pop dx
				pop cx
				inc cx
				cmp cx,8
				
				jl loop2
				inc dx
			cmp dx,8
			 
			jl loop1
			ret
	  
	clearMouse:
		
		xor edx,edx
		loop3:
		xor ecx,ecx
			loop4:
				mov al,0
				push cx
				push dx
				add dx,[y]
				add cx,[x]
				mov ah,0Ch
				int 10h
				pop dx
				pop cx
				inc cx
				cmp cx,8
				
				jl loop4
				inc dx
			cmp dx,8
			 
			jl loop3
			ret




x: dw 0      ;position on x,y,z axis
y: dw 0
z: dw 0
k: dw 0
packetsize: db 0
resolution: db 3
samplerate: db 200
string : db "",10,13,0
string2 : db " ",10,13,0
pointer :
db 15,8,0,0,0,0,0,0,15,15,8,0,0,0,0,0,15,15,15,8,0,0,0,0,15,15,15,15,8,0,0,0,15,15,15,15,15,8,0,0,15,15,15,8,0,0,0,0,15,8,15,15,8,0,0,0,8,0,0,15,8,0,0,0


	