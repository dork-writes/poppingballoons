[org 0x0100]
    jmp start
    timer: dw 120
    tickcount: dw 0
    time: db 'Time:120 s',0
    length: dw 10
    score: db 'Score: 0',0
    length1: dw 8
    oldisr: dd 0
    seed: dw 0
    isSpawned: dw 0
    seed2: dw 0
    seed3: dw 0
    currScore: dw 0
    winScore: dw 500
    winString: db 'You Win!', 0
    winLength: dw 8
    loseString: db 'You Lose!', 0
    loseLength: dw 9
    loading: db 'Loading....',0
    llen: dw 11
    oldisr2: dd 0
    arr: dw 0, 0, 0, 0, 0
    popstring: db '|XXX|'
    ycor: dw 19,19,19,19,19
    scoreStr: db 'Your Score: ', 0
    scoreSlen: dw 12
    spray: dw 0, 0, 0, 0, 0
    numBalloons: dw 0
    notSpawned: dw 0, 0, 0, 0, 0 
    noSpawnNum: dw 0
    adding: dw 0
    lastcolour: dw 01100110b 


    pline:
        push bp
        mov bp, sp
        push ax
        push bx
        push cx
        push dx
        push si
        push di
        mov ax, 0xb800
        mov es, ax
        mov al, 80
        mov bl,2
        mul bl
        add ax, 5
        shl ax, 1
        mov di,ax
        mov cx, 10
        mov ax,0
        mov ah,00000111b
        mov al,'-'
        cld
        rep stosw
        mov al, 80
        mov bl,0
        mul bl
        add ax, 5
        shl ax, 1
        mov di,ax
        mov cx, 10
        mov ax,0
        mov ah,00000111b
        mov al,'-'
        cld
        rep stosw
        mov al, 80
        mov bl,0
        mul bl
        add ax, 3
        shl ax, 1
        mov di,ax
        mov cx, 3
        mov ax,0
        mov ah,00000111b
        mov al,'|'
        line1: 
            mov [es:di],ax
            add di,160
            loop line1
        mov al, 80
        mov bl,0
        mul bl
        add ax, 16
        shl ax, 1
        mov di,ax
        mov cx, 3
        mov ax,0
        mov ah,00000111b
        mov al,'|'
        line2: 
            mov [es:di],ax
            add di,160
            loop line2

        mov al, 80
        mov bl,2
        mul bl
        add ax, 65
        shl ax, 1
        mov di,ax
        mov cx, 10
        mov ax,0
        mov ah,00000111b
        mov al,'-'
        cld
        rep stosw
        mov al, 80
        mov bl,0
        mul bl
        add ax, 65
        shl ax, 1
        mov di,ax
        mov cx, 10
        mov ax,0
        mov ah,00000111b
        mov al,'-'
        cld
        rep stosw
        mov al, 80
        mov bl,0
        mul bl
        add ax, 63
        shl ax, 1
        mov di,ax
        mov cx, 3
        mov ax,0
        mov ah,00000111b
        mov al,'|'
        line7: 
            mov [es:di],ax
            add di,160
            loop line7
        mov al, 80
        mov bl,0
        mul bl
        add ax, 76
        shl ax, 1
        mov di,ax
        mov cx, 3
        mov ax,0
        mov ah,00000111b
        mov al,'|'
        line8: 
            mov [es:di],ax
            add di,160
            loop line8
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret 
    getSeed:
        mov ax, 25173
        mul word[seed]
        add ax, 13489
        mov word[seed], ax
        ret

    randomize:
        push bp
        mov bp, sp
        push ax
        mov ah, 0
        int 0x1A
        mov word[seed], dx
        call getSeed
        xor dx, dx
        mov cx, 5
        div cx
        mov word[bp + 4], dx
        mov word[seed], ax
        pop ax
        pop bp
        ret

    randomCharacter:
        push bp
        mov bp, sp
        ; push ax
        mov ah, 0
        int 0x1A
        call getSeed
        xor dx, dx
        mov cx, 26
        div cx
        add dx, 65
        mov word[bp + 4], dx
        ; pop ax
        pop bp
        ret

    printNum:
        push bp
        mov bp, sp
        push es
        push ax
        push cx
        push di
        push si
        push dx

        mov ax, 0xB800
        mov es, ax
        mov di, [bp + 6]
        add di,160
        mov ah, 0x07

        mov ax, [bp + 4]
        mov si, 10
        mov cx, 0

        cmp ax, 100
        jae separator
        mov word[es:di], 0x0730
        add di, 2
        cmp ax, 10
        jae separator
        mov word[es:di], 0x0730
        add di, 2

        separator:
            add cx, 1
            mov dx, 0
            div si
            push dx
            cmp ax, 0
            jne separator

        printing_number:
            xor ax, ax
            pop ax
            add al, 0x30
            mov ah, 0x07
            mov word[es:di], ax
            add di, 2
            loop printing_number

        pop dx
        pop si
        pop di
        pop cx
        pop ax
        pop es
        pop bp
        ret 4

    secondCounter:
        push ax
        push cx
        push dx
        cmp word[cs:timer], 0
        jne initiation
        jmp writeBack
        initiation:inc word [cs:tickcount];` increment tick count
        cmp word[cs:tickcount], 18
        jne writeBack
        dec word[cs:timer]
        mov word[cs:tickcount], 0
        mov di, 70
        add di, di
        push di
        push word[cs:timer]
        call printNum ; print tick count

        cmp word[cs:timer], 0
        writeBack:
        mov ax, [cs:tickcount]
        mul word[cs:timer]
        mov cx, 5
        xor dx, dx
        div cx
        mov word[seed2], dx
        mov ax, 25713
        mov cx, word[seed2]
        add cx, 1
        xor dx, dx
        div cx
        mov cx, 5
        xor dx, dx
        div cx
        mov word[seed3], dx
        mov al, 0x20
        out 0x20, al ; end of interrupt
        pop dx
        pop cx
        pop ax
        iret ; return from interrupt

    pstring:
        printstr: push bp
        mov bp, sp
        push es
        push ax
        push cx
        push si
        push di
        mov ax, 0xb800
        mov es, ax
        mov al, 80
        mul byte [bp+10]
        add ax, [bp+12]
        shl ax, 1
        mov di,ax
        mov si, [bp+6]
        mov cx, [bp+4]
        mov ah, [bp+8]
        cld
        nextchar:
            lodsb
            stosw
            loop nextchar
        pop di
        pop si
        pop cx
        pop ax
        pop es
        pop bp
        ret 10
    pbaloon:
        push bp
        mov bp, sp
        push ax
        push bx
        push cx
        push dx
        mov ah,06h
        mov al,3
        mov bh,[bp + 10]
        mov ch,4
        mov cl,[bp + 6];x1
        mov dh,24
        mov dl,[bp + 4];x2
        int 10h
        mov dh,23
        mov dl,[bp + 4]
        sub dl, 2
        mov bh,0
        mov ah,2
        int 10h
        mov ah,09h
        mov al,[bp + 8]
        mov bh,0
        mov bl,00001111b
        add bl,[bp + 10]
        mov cx,1
        int 10h
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret 8
    sleep:
		push cx
		mov cx, 0xFFFF
		delay:
			loop delay
			pop cx
			ret
    sleep2:
		push cx
		mov cx, 0x6666
		delay2:
			loop delay2
			pop cx
			ret
    clrscr:
        push es
        push ax
        push cx
        push di
        mov ax, 0xb800
        mov es, ax
        xor di, di ; point di to top left column
        mov ax, 0x0720 ; space char in normal attribute
        mov cx, 2000 ; number of screen locations
        cld ; auto increment mode
        rep stosw ; clear the whole screen
        pop di
        pop cx
        pop ax
        pop es
        ret
    scroll:
        push bp
        mov bp,sp
        push ax
        push bx
        push cx
        push dx
        mov cx, 8
        sleeping:
            call sleep
            loop sleeping
        mov ah,06h
        mov al,3
        mov bh,00000000b
        mov ch,4
        mov cl,[bp + 8]
        mov dh,[bp + 4]
        mov dl,[bp + 6]
        int 10h
        ;int 0x16
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret 6
    loadscreen:
        push es
        push si
        push di
        push ax
        push cx
        
        mov cx,5
        l1:
        mov ax,35
        push ax
        mov ax,13
        push ax
        mov ax,10001111b
        push ax
        mov ax,loading
        push ax
        push word[llen]
        call pstring
        
        mov ax, 0xb800
        mov es, ax
        mov di ,2450
        mov ah, 9
        mov al, '|' 
        push cx
        mov cx, 30
        nextchar3:
        mov [es:di],ax
        add di,2
        call sleep
        loop nextchar3
        pop cx
        loop l1

        pop cx
        pop ax
        pop di
        pop si
        pop es
        ret

    retasc:
        push bp
        mov bp,sp
        cmp word[bp+4], 16
        jne n1
        mov word[bp+4],81
        jmp ex

        n1:
        cmp word[bp+4], 17
        jne n2
        mov word[bp+4],87
        jmp ex
        n2:
        cmp word[bp+4], 18
        jne n3
        mov word[bp+4],69
        jmp ex
        n3:
        cmp word[bp+4], 19
        jne n4
        mov word[bp+4],82
        jmp ex
        n4:
        cmp word[bp+4], 20
        jne n5
        mov word[bp+4],84
        jmp ex
        n5:
        cmp word[bp+4], 21
        jne n6
        mov word[bp+4],89
        jmp ex
        n6:
        cmp word[bp+4], 22
        jne n7
        mov word[bp+4], 85
        jmp ex
        n7:
        cmp word[bp+4], 23
        jne n8
        mov word[bp+4],73
        jmp ex
        n8:
        cmp word[bp+4], 24
        jne n9
        mov word[bp+4],79
        jmp ex

        n9:
        cmp word[bp+4], 25
        jne n10
        mov word[bp+4],80
        jmp ex
        n10:
        cmp word[bp+4], 30
        jne n11
        mov word[bp+4],65
        jmp ex
        n11:
        cmp word[bp+4], 31
        jne n12
        mov word[bp+4],83
        jmp ex
        n12:
        cmp word[bp+4], 32
        jne n13
        mov word[bp+4],68
        jmp ex
        n13:
        cmp word[bp+4], 33
        jne n14
        mov word[bp+4],70
        jmp ex
        n14:
        cmp word[bp+4], 34
        jne n15
        mov word[bp+4],71
        jmp ex
        n15:
        cmp word[bp+4], 35
        jne n16
        mov word[bp+4],72
        jmp ex
        n16:
        cmp word[bp+4], 36
        jne n17
        mov word[bp+4],74
        jmp ex
        n17:
        cmp word[bp+4], 37
        jne n18
        mov word[bp+4],75
        jmp ex
        n18:
        cmp word[bp+4], 38
        jne n19
        mov word[bp+4],76
        jmp ex
        n19:
        cmp word[bp+4], 44
        jne n20
        mov word[bp+4],90
        jmp ex
        n20:
        cmp word[bp+4], 45
        jne n21
        mov word[bp+4],88
        jmp ex
        n21:
        cmp word[bp+4], 46
        jne n22
        mov word[bp+4],67
        jmp ex
        n22:
        cmp word[bp+4], 47
        jne n23
        mov word[bp+4],86
        jmp ex
        n23:
        cmp word[bp+4], 48
        jne n24
        mov word[bp+4],66
        jmp ex
        n24:
        cmp word[bp+4], 49
        jne n25
        mov word[bp+4],78
        jmp ex
        n25:
        cmp word[bp+4], 50
        jne ex
        mov word[bp+4],77
        ex:
        pop bp
        ret

    clrscrInRange:
        push bp
        mov bp, sp
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        mov ax, 0xB800
        mov es, ax
        mov ax, [bp + 4]
        add ax, ax
        mov di, ax
        add di, 160
        add di, 160
        add di, 160
        add di, 160
        mov cx, 21

        loopingg1:
            mov dx, 5
            push di
            loopingg2:
                mov word[es:di], 0x0720
                add di, 2
                sub dx, 1
                jnz loopingg2

            pop di
            add di, 160
            loop loopingg1

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret 2
    popanimation:
        push bp
        mov bp, sp
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        mov ax, 0xB800
        mov es, ax
        mov ax, [bp + 4]
        add ax, ax
        mov di, ax
        add di, 160

        mov cx, 25

        loopingg3:
            mov dx, 5
            mov bx,0
            push di
            loopingg4:
                mov ah,[bp+6]
                mov al,[popstring+bx]
                mov word[es:di], ax
                add bx,1
                add di, 2
                sub dx, 1
                jnz loopingg4

            pop di
            add di, 160
            call sleep2
            loop loopingg3
        
        call sleep
        call sleep
        call sleep
        call sleep
        push word[bp+4]
        call clrscrInRange
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret 4
    kbisr: 
        push ax
        push es
        mov ax, 0xb800
        mov es, ax ; point es to video memory
        in al, 0x60 ; read a char from keyboard port
        mov ah, 0
        push ax
        call retasc
        pop ax

        cmp ax, [arr]
        jne cmpo2
        mov word[arr], 0
        add word[currScore], 10
        push 24
        push word[currScore]
        call printNum
        push 00010001b
        push 12
        push word[ycor]
        call popanimation2
        jmp exit

        cmpo2: cmp ax, [arr + 2]
        jne cmpo3
        mov word[arr + 2], 0
        add word[currScore], 10
        push 24
        push word[currScore]
        call printNum
        push 00110011b
        push 25
        push word[ycor+2]
        call popanimation2
        jmp exit

        cmpo3: cmp ax, [arr + 4]
        jne cmpo4
        mov word[arr + 4], 0
        add word[currScore], 10
        push 24
        push word[currScore]
        call printNum
        push 01010101b
        push 38
        push word[ycor+4]
        call popanimation2
        jmp exit

        cmpo4: cmp ax, [arr + 6]
        jne cmpo5
        mov word[arr + 6], 0
        add word[currScore], 10
        push 24
        push word[currScore]
        call printNum
        push 01000100b
        push 51
        push word[ycor+6]
        call popanimation2
        jmp exit

        cmpo5: cmp ax, [arr + 8]
        jne exit
        mov word[arr + 8], 0
        add word[currScore], 10
        push 24
        push word[currScore]
        call printNum
        push word[lastcolour]
        push 64
        push word[ycor+8]
        call popanimation2
        exit: 
        mov al, 0x20
        out 0x20, al ; send EOI to PIC
        pop es
        pop ax
        iret ; return from interrupt 
        
    popanimation2:
        push bp
        mov bp, sp
        push ax
        push bx
        push cx
        push dx
        push si
        push di
        mov ax, 0xb800
        mov es, ax
        mov al, 80
        mul byte [bp+4]
        add ax, [bp+6]
        add ax,1
        shl ax, 1
        mov di,ax
        mov cx, 2
        push word[bp+6]
        call clrscrInRange
        looping5:
            mov dx, 3
            mov bx,0
            push di
            looping6:
                mov ah,[bp+8]
                mov al,'.'
                mov word[es:di], ax
                add bx,1
                add di, 2
                sub dx, 1
                jnz looping6

            pop di
            add di, 160
            loop looping5
            call sleep
            ; call sleep
            push word[bp+6]
            call clrscrInRange
        mov al, 80
        mul byte [bp+4]
        add ax, [bp+6]
        add ax,2
        shl ax, 1
        mov di,ax
        mov cx, 1
        push word[bp+6]
        call clrscrInRange
        looping7:
            mov dx, 2
            mov bx,0
            push di
            looping8:
                mov ah,[bp+8]
                mov al,'.'
                mov word[es:di], ax
                add bx,1
                add di, 2
                sub dx, 1
                jnz looping8

            pop di
            add di, 160
            loop looping7
            call sleep
            ; call sleep
            push word[bp+6]
            call clrscrInRange
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret 6

    draw1:
        push bx
        add word[numBalloons], 1
        mov word[spray], 1
        mov si, 00010000b
                        push 0
                        call randomCharacter
                        pop di
                        mov word[arr], di
                        mov ax, 12
                        mov bx, 16
                        push si
                        push di
                        push ax
                        push bx
                        call pbaloon
                        mov word[isSpawned], 1
                        mov dx,4
                        sub dx,[seed2]
                        mov ax,dx
                        mov cx,3
                        xor dx,dx
                        div cx
                        mov cx,dx
                        cmp cx,0
                        je popper1
                        mov bx,[ycor]
                        sub bx,cx
                        mov word[ycor],bx
                        sbb1:
                        mov ax,24
                        mov si, 12
                        mov di, 16
                        push si
                        push di
                        push ax
                        call scroll
                        loop sbb1
                        popper1: pop bx
                        ret




    draw2:
                            push bx
                            add word[numBalloons], 1
                            mov word[spray + 2], 1
                            mov si, 00110000b
                            push 0
                            call randomCharacter
                            pop di
                            mov word[arr + 2], di
                            mov ax, 25
                            mov bx, 29
                            push si
                            push di
                            push ax
                            push bx
                            call pbaloon
                            mov word[isSpawned], 1
                            mov dx,4
                            sub dx,[seed3]
                            mov ax,dx
                            mov cx,3
                            xor dx,dx
                            div cx
                            mov cx,dx
                            cmp cx,0
                            je popper2
                            mov bx,[ycor+2]
                            sub bx,cx
                            mov word[ycor+2],bx
                            sbb2:
                            mov ax,24
                            mov si, 25
                            mov di, 29
                            push si
                            push di
                            push ax
                            call scroll
                            loop sbb2
                            popper2: pop bx
                            ret

    draw3:
                            push bx
                            add word[numBalloons], 1
                            mov si, 01010000b
                            mov word[spray + 4], 1
                            push 0
                            call randomCharacter
                            pop di
                            mov word[arr + 4], di
                            mov ax, 38
                            mov bx, 42
                            push si
                            push di
                            push ax
                            push bx
                            call pbaloon
                            mov word[isSpawned], 1
                            mov dx,4
                            sub dx,[seed3]
                            mov ax,dx
                            mov cx,3
                            xor dx,dx
                            div cx
                            mov cx,dx
                            cmp cx,0
                            je popper3
                            mov bx,[ycor+4]
                            sub bx,cx
                            mov word[ycor+4],bx
                            sbb3:
                            mov ax,24
                            mov si, 38
                            mov di, 42
                            push si
                            push di
                            push ax
                            call scroll
                            loop sbb3
                            popper3: pop bx
                            ret

        draw4:
                        push bx
                        add word[numBalloons], 1
                        mov word[spray + 6], 1
                        mov si, 01000000b
                        push 0
                        call randomCharacter
                        pop di
                        mov word[arr + 6], di
                        mov ax, 51
                        mov bx, 55
                        push si
                        push di
                        push ax
                        push bx
                        call pbaloon
                        mov word[isSpawned], 1
                        mov dx,4
                        sub dx,[seed2]
                        mov ax,dx
                        mov cx,3
                        xor dx,dx
                        div cx
                        mov cx,dx
                        cmp cx,0
                        je popper4
                        mov bx,[ycor+6]
                        sub bx,cx
                        mov word[ycor+6],bx
                        sbb4:
                        mov ax,24
                        mov si, 51
                        mov di, 55
                        push si
                        push di
                        push ax
                        call scroll
                        loop sbb4
                        popper4: pop bx
                        ret

        draw5:
                            push bx
                            add word[numBalloons], 1
                            mov word[spray + 8], 1
                            mov si, 01100000b
                            push 0
                            call randomCharacter
                            pop di
                            mov word[arr + 8], di
                            mov ax, 64
                            mov bx, 68
                            push si
                            push di
                            push ax
                            push bx
                            call pbaloon
                            mov dx,4
                            sub dx,[seed3]
                            mov ax,dx
                            mov cx,3
                            xor dx,dx
                            div cx
                            mov cx,dx
                            cmp cx,0
                            je popper5
                            mov bx,[ycor+8]
                            sub bx,cx
                            mov word[ycor+8],bx
                            sbb5:
                            mov ax,24
                            mov si, 64
                            mov di, 68
                            push si
                            push di
                            push ax
                            call scroll
                            loop sbb5
                            popper5: pop bx
                            ret

    comparing:
            push bx
            mov bx, 0
            ch1:cmp word[spray], 1
            jne noB1
            jmp ch2
            noB1: mov word[notSpawned + bx], 1
            add bx, 2
            add word[noSpawnNum], 2

            ch2: cmp word[spray + 2], 1
            jne noB2
            jmp ch3
            noB2: mov word[notSpawned + bx], 2
            add bx, 2
            add word[noSpawnNum], 2

            ch3: cmp word[spray + 4], 1
            jne noB3
            jmp ch4
            noB3: mov word[notSpawned + bx], 3
            add bx, 2
            add word[noSpawnNum], 2

            ch4: cmp word[spray + 6], 1
            jne noB4
            jmp ch5
            noB4: mov word[notSpawned + bx], 4
            add bx, 2
            add word[noSpawnNum], 2

            ch5: cmp word[spray + 8], 1
            jne noB5
            jmp comend

            noB5: mov word[notSpawned + bx], 5
            add bx, 2
            add word[noSpawnNum], 2
            comend:pop bx
            ret

    clearingVar:
            mov word[isSpawned], 0
            mov word[arr], 0
            mov word[arr + 2], 0
            mov word[arr + 4], 0
            mov word[arr + 6], 0
            mov word[arr + 8], 0
            mov word[spray], 0
            mov word[spray + 2], 0
            mov word[spray + 4], 0
            mov word[spray + 6], 0
            mov word[spray + 8], 0
            mov word[notSpawned], 0
            mov word[notSpawned + 2], 0
            mov word[notSpawned + 4], 0
            mov word[notSpawned + 6], 0
            mov word[notSpawned + 8], 0
            mov word[noSpawnNum], 0
            mov word[numBalloons], 0
            ret

    clearingVar2:
            mov word[spray], 0
            mov word[spray + 2], 0
            mov word[spray + 4], 0
            mov word[spray + 6], 0
            mov word[spray + 8], 0
            mov word[notSpawned], 0
            mov word[notSpawned + 2], 0
            mov word[notSpawned + 4], 0
            mov word[notSpawned + 6], 0
            mov word[notSpawned + 8], 0
            mov word[numBalloons], 0
            mov word[noSpawnNum], 0
            ret

    clearingArr:
            cmp word[ycor], 5
            jae comy2
            mov word[arr], 0
            comy2: cmp word[ycor + 2], 5
            jae comy3
            mov word[arr + 2], 0
            comy3: cmp word[ycor + 4], 5
            jae comy4
            mov word[arr + 4], 0
            comy4: cmp word[ycor + 6], 5
            jae comy5
            mov word[arr + 6], 0
            comy5: cmp word[ycor + 8], 5
            jae return
            mov word[arr + 8], 0
            return:
            ret

    start:
        call clrscr
        call loadscreen
        call clrscr
        
        xor ax, ax
        mov es, ax
        cli
        mov ax, [es:8*4]
        mov word[oldisr], ax 
        mov ax, [es:8*4 + 2]
        mov word[oldisr + 2], ax 
        mov word[es:8*4], secondCounter
        mov word[es:8*4 + 2], cs
        sti
        call clrscr
        call pline
        sub dx, 1
        mov ax,65
        push ax
        mov ax,1
        push ax
        mov ax,00001111b
        push ax
        mov ax,time
        push ax
        push word[length]
        call pstring
        mov ax,5
        push ax
        mov ax,1
        push ax
        mov ax,00001111b
        push ax
        mov ax,score
        push ax
        push word[length1]
        call pstring
        mov di, 70
        add di, di
        push di
        push word[timer]
        call printNum
        mov di, 12
        add di, di
        push di
        push word[currScore]
        call printNum
        
        xor ax, ax
        mov es, ax ; point es to IVT base
        mov ax, [es:9*4]
        mov [oldisr2], ax ; save offset of old routine
        mov ax, [es:9*4+2]
        mov [oldisr2+2], ax ; save segment of old routine
        cli ; disable interrupts
        mov word [es:9*4], kbisr ; store offset at n*4
        mov [es:9*4+2], cs ; store segment at n*4+2
        sti ; enable interrupts 

        respawn:
        call clearingVar
        mov word[numBalloons], 0
        call pline
        cmp word[seed2], 0
        jne b2
        add word[numBalloons], 1
        mov word[spray], 1
        mov si, 00010000b
        push 0
        call randomCharacter
        pop di
        mov word[arr], di
        mov ax, 12
        mov bx, 16
        push si
        push di
        push ax
        push bx
        call pbaloon
        mov word[isSpawned], 1
        mov dx,4
        sub dx,[seed2]
        mov ax,dx
        mov cx,3
        xor dx,dx
        div cx
        mov cx,dx
        cmp cx,0
        je b2
        mov bx,[ycor]
        sub bx,cx
        mov word[ycor],bx
        sb1:
        mov ax,24
        mov si, 12
        mov di, 16
        push si
        push di
        push ax
        call scroll
        loop sb1

        b2: cmp word[seed2], 1
        jne b3
        add word[numBalloons], 1
        mov word[spray + 2], 1
        mov si, 00110000b
        push 0
        call randomCharacter
        pop di
        mov word[arr + 2], di
        mov ax, 25
        mov bx, 29
        push si
        push di
        push ax
        push bx
        call pbaloon
        mov word[isSpawned], 1
        mov dx,4
        sub dx,[seed2]
        mov ax,dx
        mov cx,3
        xor dx,dx
        div cx
        mov cx,dx
        cmp cx,0
        je b3
        mov bx,[ycor+2]
        sub bx,cx
        mov word[ycor+2],bx
        sb2:
        mov ax,24
        mov si, 25
        mov di, 29
        push si
        push di
        push ax
        call scroll
        loop sb2
        
        b3:
        cmp word[seed2], 2
        jne b4
        add word[numBalloons], 1
        mov si, 01010000b
        mov word[spray + 4], 1
        push 0
        call randomCharacter
        pop di
        mov word[arr + 4], di
        mov ax, 38
        mov bx, 42
        push si
        push di
        push ax
        push bx
        call pbaloon
        mov word[isSpawned], 1
        mov dx,4
        sub dx,[seed2]
        mov ax,dx
        mov cx,3
        xor dx,dx
        div cx
        mov cx,dx
        cmp cx,0
        je b4
        mov bx,[ycor+4]
        sub bx,cx
        mov word[ycor+4],bx
        sb3:
        mov ax,24
        mov si, 38
        mov di, 42
        push si
        push di
        push ax
        call scroll
        loop sb3

        b4: cmp word[seed2], 3
        jne b5
        add word[numBalloons], 1
        mov word[spray + 6], 1
        mov si, 01000000b
        push 0
        call randomCharacter
        pop di
        mov word[arr + 6], di
        mov ax, 51
        mov bx, 55
        push si
        push di
        push ax
        push bx
        call pbaloon
        mov word[isSpawned], 1
        mov dx,4
        sub dx,[seed2]
        mov ax,dx
        mov cx,3
        xor dx,dx
        div cx
        mov cx,dx
        cmp cx,0
        je b5
        mov bx,[ycor+6]
        sub bx,cx
        mov word[ycor+6],bx
        sb4:
        mov ax,24
        mov si, 51
        mov di, 55
        push si
        push di
        push ax
        call scroll
        loop sb4

        b5:
        cmp word[seed2], 4
        je helper
        cmp word[isSpawned], 1
        jne respawn
        helper: 
        cmp word[seed3], 2
        ja colour2
        colour1: mov si,01100000b
        mov word[lastcolour], si
        jmp nxt
        colour2: mov si,00100000b
        mov word[lastcolour], si
        nxt:add word[numBalloons], 1
        mov word[spray + 8], 1
        push 0
        call randomCharacter
        pop di
        mov word[arr + 8], di
        mov ax, 64
        mov bx, 68
        push si
        push di
        push ax
        push bx
        call pbaloon
        mov dx,4
        sub dx,[seed2]
        mov ax,dx
        mov cx,3
        xor dx,dx
        div cx
        mov cx,dx
        cmp cx,0
        je spawncheck
        mov bx,[ycor+8]
        sub bx,cx
        mov word[ycor+8],bx
        sb5:
        mov ax,24
        mov si, 64
        mov di, 68
        push si
        push di
        push ax
        call scroll
        loop sb5

        spawncheck:
            k1: cmp word[numBalloons], 3
            cre: jae cset
            call comparing               
            cmp word[noSpawnNum], 6
            jne moreSpawn
            cmp word[seed2], 2
            jbe v1
            sub word[noSpawnNum], 2
            jmp moreSpawn
            v1: mov word[adding], 2

            moreSpawn:
                mov bx, [adding]
                spawnsequence:
                    cmp word[notSpawned + bx], 1
                    jne com2
                    call draw1

                    com2:cmp word[notSpawned + bx], 2
                    jne com3
                    call draw2

                    com3:cmp word[notSpawned + bx], 3
                    jne com4
                    call draw3

                    com4:cmp word[notSpawned + bx], 4
                    jne com5
                    call draw4

                    com5:cmp word[notSpawned + bx], 5
                    jne nextseq
                    call draw5

                    nextseq:
                    add bx, 2
                    cmp bx, word[noSpawnNum]
                    jne spawnsequence
                    mov word[adding], 0

        cset:
            mov cx,9
            call clearingVar2

        scrolling:
            mov bx,0
            upycor:
            mov si,[ycor+bx]
            sub si,2
            mov word[ycor+bx],si
            add bx,2
            cmp bx,10
            jne upycor
            mov si, 1
            mov di, 80
            push si
            push di
            push ax
            call scroll
            sub ax,2
            call clearingArr
            sleeper: call sleep
            call sleep
            call sleep
            call sleep
            call sleep 
            call sleep 
            cmp word[timer], 0
            je ender
            loop scrolling
            call clearingVar
            mov bx,0
            upycor2:
                mov si,[ycor+bx]
                mov si,19
                mov word[ycor+bx],si
                add bx,2
                cmp bx,10
            jne upycor2
            next:
            cmp word[timer], 0
            ender: jnz respawn

        ending:
        call clrscr
        push 31
        push 13
        mov ax, 00001111b
        push ax
        mov ax, scoreStr
        push ax
        push word[scoreSlen]
        call pstring
        mov di, 2006
        push di
        push word[currScore]
        call printNum
        
        finish:
        xor ax, ax
        mov es, ax
        mov ax, [oldisr]
        mov word[es:8*4], ax
        mov ax, [oldisr + 2]
        mov word[es:8*4 + 2], ax
        xor ax, ax
        mov es, ax
        mov ax, [oldisr2]
        mov word[es:9*4], ax
        mov ax, [oldisr2 + 2]
        mov word[es:9*4 + 2], ax
        mov ax,0x4c00
        int 0x21
