[org 0x0100]
jmp start
message: db 0xB3 ; string to be printed
length: dw 1
message1: db'"The Jaguars project"'
length1: dw 21

P1Msg: db 'Player 1 wins!!$'
P2Msg: db 'Player 2 wins!!$'
NMag: db 'Game has reached a Draw.$'
BoxCs: dw 842,876,910,1642,1676,1710,2442,2476,2510

val: db 0,0,0,0,0,0,0,0,0
Turn: db 1
;---------------------------------------------------------------------------
;subroutine to clear the screen
clrscr:	
	push ax
	mov ah,00	
	mov al,03h	; interrupt to clear screen
	int 10h		
	pop ax
	ret
;---------------------------------------------------------------------------
;subroutine if player 1 wins
winner_p1:
	pusha;pushing all registers
	push es		;	pushing the extra segment on stack
	push 0xb800		;	pointing to the video mode
	pop es;		popping the extra segment
	mov di, 3426;	moving 3246 to destination index
	mov si, P1Msg;moving the player winning 1 message
	mov ah, 0x20
p1l1:
	mov al, [si];moving the offset of player 1 wining message to al
	cmp al, '$';comparing the al register with '$'
	je player1_end 	;jump if above condtion satisfy
	mov [es:di],ax;showing the charater on the screen
	add di, 2;adding destination index 2
	inc si;incrementing in source index
	jmp p1l1
player1_end:
	pop es
	popa;popping all registers
	ret
;---------------------------------------------------------------------------
;subroutine if player 2 wins 
winner_p2:
	pusha;pushing all registers
	push es;	pushing the extra segment on stack
	push 0xb800;	pointing to the video mode
	pop es;		popping the extra segment
	mov di, 3426;	moving 3246 to destination index
	mov si, P2Msg;moving the player 2 wining message
	mov ah, 0x20;ascii for space" "
p2l2:
	mov al, [si];moving the offset of player 2 wining message to al
	cmp al, '$';comparing the al register with '$'
	je player2_end;jump to player2_end if above condtion satisfy
	mov [es:di],ax;showing the charater on the screen
	add di, 2;adding destination index 2
	inc si;incrementing in source index
	jmp p2l2;jumping to p2l2
player2_end:
	pop es
	popa;popping all registers
	ret
;---------------------------------------------------------------------------
;subroutine if draw
winner_p3:
	pusha;pushing all registers
	push es;	pushing the extra segment on stack
	push 0xb800;	pointing to the video mode
	pop es;		popping the extra segment
	mov di, 3416;	moving 3416 to destination index
	mov si, NMag;moving the player 2 wining message
	mov ah, 0x20;ascii for space" "
p3l3:
	mov al, [si];moving the offset of draw message to al
	cmp al, '$';comparing the al register with '$'
	je player3_end;jump to player3_end if above condtion satisfy
	mov [es:di],ax;showing the charater on the screen
	add di, 2;adding destination index 2
	inc si;incrementing in source index
	jmp p3l3;jumping to p3l3
player3_end:
	pop es
	popa;popping all registers
	ret
;---------------------------------------------------------------------------
wt_:	
	push bp;pushing bp to the stack
	mov bp, sp;moving stack pointer to the base pointer 
	pusha;pushing all the registers
	mov ax, 0
	mov bx, 8
w_:		
	mov al, [val+bx]
	cmp al, 0;comparing al with 0
	je W_ends; jump to W_ends if above condition satisfies
	dec bx
	cmp bx, -1
	je filled; jump to filled if above condition satisfies
	jmp w_
filled:
	mov ax, 1
	mov [bp+4], ax
W_ends:
	popa;popping all registers
	pop bp ;popping base pointer 
	ret
;---------------------------------------------------------------------------
position_turn:
	pusha;pushing all registers
	mov al, [Turn]
	cmp al, 1
	jne p1_turn;jumping to p1_turn if above condition satisfies 
	mov al, 2
	mov [Turn], al
	jmp exitS
p1_turn:
	mov al, 1
	mov [Turn], al
exitS:
	popa;popping all registers
	ret
;---------------------------------------------------------------------------
;subroutine for winning
victory:	
	push bp;pushing bp to the stack
	mov bp, sp;moving stack pointer to the base pointer 
	pusha;pushing all registers
	;[1,1,1]
	;[0,0,0]
	;[0,0,0]
	mov ax, 0
	mov bx, 0
	mov al, [val]		; 0,1,2
	mov bl, [val+1]
	cmp al, bl
	jne control2
	mov bl, [val+2]
	cmp al, bl
	jne control2
	cmp al, 0
	je control2
	mov [bp+4], ax
	jmp victory_end
control2:
	;[1,0,0]
	;[1,0,0]
	;[1,0,0]
	mov al, [val]
	mov bl, [val+3]		;0,3,6
	cmp al, bl
	jne control3
	mov bl, [val+6]
	cmp al, bl
	jne control3
	cmp al, 0
	je control3
	mov [bp+4], ax
	jmp victory_end
control3:
	;[1,0,0]
	;[0,1,0]
	;[0,0,1]
	mov al, [val]
	mov bl, [val+4]		;0,4,8
	cmp al, bl
	jne control4
	mov bl, [val+8]
	cmp al, bl
	jne control4
	cmp al, 0
	je control4
	mov [bp+4], ax
	jmp victory_end
control4:
	;[0,0,1]
	;[0,1,0]
	;[1,0,0]
	mov al, [val+2]		;2,4,6
	mov bl, [val+4]
	cmp al, bl
	jne control5
	mov bl, [val+6]
	cmp al, bl
	jne control5
	cmp al, 0
	je control5
	mov [bp+4], ax
	jmp victory_end
control5:
	;[0,0,0]
	;[1,1,1]
	;[0,0,0]
	mov al, [val+3]		;3,4,5
	mov bl, [val+4]
	cmp al, bl
	jne control6
	mov bl, [val+5]
	cmp al, bl
	jne control6
	cmp al, 0
	je control6
	mov [bp+4], ax
	jmp victory_end
control6:
	;[0,0,0]
	;[0,0,0]
	;[1,1,1]
	mov al, [val+6]		;6,7,8
	mov bl, [val+7]
	cmp al, bl
	jne control7
	mov bl, [val+8]
	cmp al, bl
	jne control7
	cmp al, 0
	je control7
	mov [bp+4], ax
	jmp victory_end

control7:
	;[0,1,0]
	;[0,1,0]
	;[0,1,0]
	mov al, [val+1]		;1,4,7
	mov bl, [val+4]
	cmp al, bl
	jne control8
	mov bl, [val+7]
	cmp al, bl
	jne control8
	cmp al, 0
	je control8
	mov [bp+4], ax
	jmp victory_end
control8:	
	;[0,0,1]
	;[0,0,1]
	;[0,0,1]
	mov al, [val+2]		;2,5,8
	mov bl, [val+5]
	cmp al, bl
	jne victory_end
	mov bl, [val+8]
	cmp al, bl
	jne victory_end
	cmp al, 0
	je victory_end
	mov [bp+4], ax
victory_end:
	popa;popping all registers
	pop bp
	ret
;---------------------------------------------------------------------------
;subroutine for creating zero
Zero:
	push bp;pushing bp to the stack
	mov bp, sp;moving stack pointer to the base pointer 
	pusha;pushing all registers
	push es
	mov ah, 0x20
	mov al, 178
	mov bx, 0xb800
	mov es, bx
	mov di, [bp+4]
	mov bx, 2
	mov [es:di+bx], ax
	add bx, 2
	mov [es:di+bx], ax
	add bx, 162
	mov [es:di+bx], ax
	add bx, 158
	mov [es:di+bx], ax
	sub bx, 2
	mov [es:di+bx], ax
	sub bx, 162
	mov [es:di+bx], ax
pop es
popa
pop bp
ret 2
;---------------------------------------------------------------------------
;subroutine for creating cross
Cross:	
	push bp;pushing bp to the stack
	mov bp, sp;moving stack pointer to the base pointer 
	pusha;pushing all registers
	push es
	mov ah, 0x20
	mov al, 178
	mov bx, 0xb800
	mov es, bx
	mov di, [bp+4]
	mov bx, 0
	mov [es:di+bx], ax
	add bx, 162
	mov [es:di+bx], ax
	add bx, 164
	mov [es:di+bx], ax
	sub bx, 320
	mov [es:di+bx], ax
	add bx, 158
	mov [es:di+bx], ax
	add bx, 156
	mov [es:di+bx], ax
pop es
popa
pop bp
ret 2
;---------------------------------------------------------------------------
;subroutine to set the background colour
clr:
	push es
	push ax
	push di
	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov di, 0 ; point di to top left column
next:
	mov ax,0420h;green colour on the background
	mov [es:di],ax;showing green colour the screen 
	add di, 1 ; move to next screen location
	cmp di, 4000 ; has the whole screen cleared
	jne next ; if no clear next position
	pop di
	pop ax
	pop es
	ret
;---------------------------------------------------------------------------
;subroutine for creating rectangle
printRectangle:
	push bp;pushing bp to the stack
	mov bp, sp;moving stack pointer to the base pointer 
	push es
	push ax
	push cx
	push si
	push di
	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov al, 80 ; load al with columns per row
	mul byte [bp+12] ; multiply with row number
	add ax, [bp+10] ; add col
	shl ax, 1 ; turn into byte offset
	mov di, ax ; point di to required location
	mov ah, [bp+4] ; load attribute in ah
	mov cx, [bp+6]
	sub cx, [bp+10]
topLine: 
	mov al, 0x5f ; ASCII of <->;
	mov [es:di], ax ; show this char on screen
	add di, 2 ; move to next screen location
	call sleep;
	loop topLine ; repeat the operation cx times
mov cx, [bp+8]
sub cx, [bp+12]
add di, 160
rightLine:
	mov al, 0xB3 ; ASCII of <|>;
	mov [es:di], ax ; show this char on screen
	add di, 160 ; move to next screen location
	call sleep;
	loop rightLine ; repeat the operation cx times
mov cx, [bp+6]
sub cx, [bp+10]
sub di, 2
bottomLine:
	mov al, 0x5f ; ASCII of <->;
	mov [es:di], ax ; show this char on screen
	sub di, 2 ; move to next screen location
	call sleep;
	loop bottomLine ; repeat the operation cx times
mov cx, [bp+8]
sub cx, [bp+12]
sub di, 160	
leftLine:
	mov al, 0xB3 ; ASCII of <|>;
	mov [es:di], ax ; show this char on screen
	sub di, 160 ; move to next screen location
	call sleep;
	loop leftLine ; repeat the operation cx times
pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 10
;---------------------------------------------------------------------------
;subroutine for sleep
sleep:
	push cx
	mov cx, 0xFFFF
delay:
	loop delay
	pop cx
	ret
;---------------------------------------------------------------------------
;subroutine for printing string
printstr:
	push bp;pushing bp to the stack
	mov bp, sp;moving stack pointer to the base pointer 
	push es
	push ax
	push cx
	push si
	push di
	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov al, 80 ; load al with columns per row
	mul byte [bp+10] ; multiply with y position
	add ax, [bp+12] ; add x position
	shl ax, 1 ; turn into byte offset
	mov di,ax ; point di to required location
	mov si, [bp+6] ; point si to string
	mov cx, [bp+4] ; load length of string in cx
	mov ah, [bp+8] ; load attribute in ah
nextchar:
	mov al, [si] ; load next char of string
	mov [es:di], ax ; show this char on screen
	add di, 2 ; move to next screen location
	add si, 1 ; move to next char in string
	loop nextchar ; repeat the operation cx times
pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 10
;---------------------------------------------------------------------------
start: 
	call clrscr ; call the clrscr subroutine
	call clr
	mov ax, 1
	push ax ; push top	
	mov ax, 1
	push ax ; push left
	mov ax, 23
	push ax ; push bottom
	mov ax, 79
	push ax ; push right number
	mov ax, 24h ; Red FG
	push ax ; push attribute
	call printRectangle ; call the printstr subroutine

	mov ax, 2
	push ax ; push top	
	mov ax, 3
	push ax ; push left
	mov ax, 22
	push ax ; push bottom
	mov ax, 77
	push ax ; push right number
	mov ax, 24h; Red FG
	push ax ; push attribute
	call printRectangle ; call the printstr subroutine

	mov ax, 3
	push ax ; push top
	mov ax, 15
	push ax ; push left
	mov ax, 17
	push ax ; push bottom
	mov ax, 65
	push ax ; push right number
	mov ax, 0x25 ; Red FG
	push ax ; push attribute
	call printRectangle

	mov ax, 3
	push ax ; push top
	mov ax, 31
	push ax ; push left
	mov ax, 17
	push ax ; push bottom
	mov ax, 49
	push ax ; push right number
	mov ax, 0x25 ; Red FG
	push ax ; push attribute
	call printRectangle

	mov ax, 8
	push ax ; push top
	mov ax, 15
	push ax ; push left
	mov ax, 12
	push ax ; push bottom
	mov ax, 65
	push ax ; push right number
	mov ax, 0x25 ; Red FG
	push ax ; push attribute
	call printRectangle

	mov ax, 19
	push ax ; push top
	mov ax, 20
	push ax ; push left
	mov ax, 21
	push ax ; push bottom
	mov ax, 60
	push ax ; push right number
	mov ax, 0x28; Red FG
	push ax ; push attribute
	call printRectangle ; call the printstr subroutine

	mov ax, 30
	push ax ; push x position
	mov ax, 8
	push ax ; push y position
	mov ax, 0x25 ; blue on green attribute
	push ax ; push attribute
	mov ax, message
	push ax ; push address of message
	push word [length] ; push message length
	call printstr ; call the printstr subroutine

	mov ax, 49
	push ax ; push x position
	mov ax, 8
	push ax ; push y position
	mov ax, 0x25 ; blue on green attribute
	push ax ; push attribute
	mov ax, message
	push ax ; push address of message
	push word [length] ; push message length
	call printstr ; call the printstr subroutine

	mov ax, 49
	push ax ; push x position
	mov ax, 13
	push ax ; push y position
	mov ax, 0x25 ; blue on green attribute
	push ax ; push attribute
	mov ax, message
	push ax ; push address of message
	push word [length] ; push message length
	call printstr ; call the printstr subroutine

	mov ax, 30
	push ax ; push x position
	mov ax, 13
	push ax ; push y position
	mov ax, 0x25 ; blue on green attribute
	push ax ; push attribute
	mov ax, message
	push ax ; push address of message
	push word [length] ; push message length
	call printstr ; call the printstr subroutine

	mov ax, 65
	push ax ; push x position
	mov ax, 18
	push ax ; push y position
	mov ax, 0x25 ; blue on green attribute
	push ax ; push attribute
	mov ax, message
	push ax ; push address of message
	push word [length] ; push message length
	call printstr ; call the printstr subroutine

	mov ax, 14
	push ax ; push x position
	mov ax, 18
	push ax ; push y position
	mov ax, 0x25 ; blue on green attribute
	push ax ; push attribute
	mov ax, message
	push ax ; push address of message
	push word [length] ; push message length
	call printstr ; call the printstr subroutine

	mov ax, 49
	push ax ; push x position
	mov ax, 18
	push ax ; push y position
	mov ax, 0x25 ; blue on green attribute
	push ax ; push attribute
	mov ax, message
	push ax ; push address of message
	push word [length] ; push message length
	call printstr ; call the printstr subroutine

	mov ax, 30
	push ax ; push x position
	mov ax, 18
	push ax ; push y position
	mov ax, 0x25 ; blue on green attribute
	push ax ; push attribute
	mov ax, message
	push ax ; push address of message
	push word [length] ; push message length
	call printstr ; call the printstr subroutine

	mov ax, 60
	push ax ; push x position
	mov ax, 22
	push ax ; push y position
	mov ax, 0x28 ; blue on green attribute
	push ax ; push attribute
	mov ax, message
	push ax ; push address of message
	push word [length] ; push message length
	call printstr ; call the printstr subroutine

	mov ax, 19
	push ax ; push x position
	mov ax, 22
	push ax ; push y position
	mov ax, 0x28 ; blue on green attribute
	push ax ; push attribute
	mov ax, message
	push ax ; push address of message
	push word [length] ; push message length
	call printstr ; call the printstr subroutine

	mov ax, 0
	push ax ; push x position
	mov ax, 24
	push ax ; push y position
	mov ax, 0x24 ; blue on green attribute
	push ax ; push attribute
	mov ax, message
	push ax ; push address of message
	push word [length] ; push message length
	call printstr ; call the printstr subroutine

	mov ax, 2
	push ax ; push x position
	mov ax, 23
	push ax ; push y position
	mov ax, 0x24 ; blue on green attribute
	push ax ; push attribute
	mov ax, message
	push ax ; push address of message
	push word [length] ; push message length
	call printstr ; call the printstr subroutine

	mov ax, 79
	push ax ; push x position
	mov ax, 24
	push ax ; push y position
	mov ax, 0x24 ; blue on green attribute
	push ax ; push attribute
	mov ax, message
	push ax ; push address of message
	push word [length] ; push message length
	call printstr ; call the printstr subroutine

	mov ax, 77
	push ax ; push x position
	mov ax, 23
	push ax ; push y position
	mov ax, 0x24 ; blue on green attribute
	push ax ; push attribute
	mov ax, message
	push ax ; push address of message
	push word [length] ; push message length
	call printstr ; call the printstr subroutine

	mov ax, 30
	push ax ; push x position
	mov ax, 23
	push ax ; push y position
	mov ax, 0x21 ; blue on green attribute
	push ax ; push attribute
	mov ax, message1
	push ax ; push address of message
	push word [length1] ; push message length
	call printstr ; call the printstr subroutine
;---------------------------------------------------------------------------
	mov ax, 1
	int 33h
	mov bx, 0
SGame:
	call Game
	push 0
	call wt_
	pop bx
	cmp bx, 1
	je loop2			
	push 0
	call victory
	pop ax
	cmp ax, 1
	jne loop1
	call winner_p1
	jmp end_of_program
loop1:	
	cmp ax, 2
	jne SGame
	call winner_p2
	jmp end_of_program
loop2:	
	call winner_p3
end_of_program:
	mov ax, 0x4c00 ; terminates
	int 0x21
;---------------------------------------------------------------------------
Game:
	pusha;pushing all registers
M1:	
	mov ax, 3
	int 33h;interrupt for mouse
	cmp cx, 112
	jb M1
	cmp cx, 524
	ja M1
	cmp dx, 32
	jb M1
	cmp dx, 150
	ja M1
	cmp bx, 1
	jne M1
	cmp dx, 72
	ja ROW2
	cmp cx, 240
	ja r_col2
	call square1
	popa;popping all registers
	ret
r_col2:
	cmp cx, 394
	ja r_col3
	call square2
	popa;popping all registers
	ret
r_col3:
	call square3
	popa;popping all registers
	ret
ROW2:
	cmp dx, 112
	ja ROW3
	cmp cx, 240
	ja row2_col2
	call square4
	popa;popping all registers
	ret
row2_col2:
	cmp cx, 394
	ja row2_col3
	call square5
	popa;popping all registers
	ret
row2_col3:
	call square6
	popa;popping all registers
	ret
ROW3:
	cmp cx, 240
	ja row3_col2
	call square7
	popa;popping all registers
	ret
row3_col2:
	cmp cx, 394
	ja row3_col3
	call square8
	popa;popping all registers
	ret
row3_col3:
	call square9
	popa;popping all registers
	ret
;---------------------------------------------------------------------------
;subroutine for boxes
square1:
	push ax;pushing ax to the stack
	mov al, [val]
	cmp al, 0
	jne BX1
	push word [BoxCs]
	mov al, [Turn]
	cmp al, 1
	jne x1
	call Zero
	jmp s1
x1:	
	call Cross
s1:
	mov [val], al
	call position_turn
BX1:
	pop ax
	ret

square2:
	push ax;pushing ax to the stack
	mov al, [val+1]
	cmp al, 0
	jne BX2
	push word [BoxCs+2]
	mov al, [Turn]
	cmp al, 1
	jne x2
	call Zero
	jmp s2
x2:
	call Cross
s2:	
	mov [val+1], al
	call position_turn
BX2:
	pop ax
	ret
square3:
	push ax;pushing ax to the stack
	mov al, [val+2]
	cmp al, 0
	jne BX3
	push word [BoxCs+4]
	mov al, [Turn]
	cmp al, 1
	jne x3
	call Zero
	jmp s3
x3:
	call Cross
s3:	
	mov [val+2], al
	call position_turn
BX3:
	pop ax
	ret
square4:
	push ax;pushing ax to the stack
	mov al, [val+3]
	cmp al, 0
	jne BX4
	push word [BoxCs+6]
	mov al, [Turn]
	cmp al, 1
	jne x4
	call Zero
	jmp s4
x4:
	call Cross
s4:
	mov [val+3], al
	call position_turn
BX4:
	pop ax
	ret
square5:
	push ax;pushing ax to the stack
	mov al, [val+4]
	cmp al, 0
	jne BX5
	push word [BoxCs+8]
	mov al, [Turn]
	cmp al, 1
	jne x5
	call Zero
	jmp s5
x5:
	call Cross
s5:	
	mov [val+4], al
	call position_turn
BX5:
	pop ax
	ret
square6:
	push ax;pushing ax to the stack
	mov al, [val+5]
	cmp al, 0
	jne BX6
	push word [BoxCs+10]
	mov al, [Turn]
	cmp al, 1
	jne x6
	call Zero
	jmp s6
x6:
	call Cross
s6:
	mov [val+5], al
	call position_turn
BX6:
	pop ax
	ret
square7:
	push ax;pushing ax to the stack
	mov al, [val+6]
	cmp al, 0
	jne BX7
	push word [BoxCs+12]
	mov al, [Turn]
	cmp al, 1
	jne x7
	call Zero
	jmp s7
x7:
	call Cross
s7:
	mov [val+6], al
	call position_turn
BX7:
	pop ax
	ret
square8:
	push ax;pushing ax to the stack
	mov al, [val+7]
	cmp al, 0
	jne BX8
	push word [BoxCs+14]
	mov al, [Turn]
	cmp al, 1
	jne x8
	call Zero
	jmp s8
x8:
	call Cross
s8:
	mov [val+7], al
	call position_turn
BX8:
	pop ax
	ret
square9:
	push ax;pushing ax to the stack
	mov al, [val+8]
	cmp al, 0
	jne BX9
	push word [BoxCs+16]
	mov al, [Turn]
	cmp al, 1
	jne x9
	call Zero
	jmp s9
x9:	
	call Cross
s9:	
	mov [val+8], al
	call position_turn
BX9:
	pop ax
	ret