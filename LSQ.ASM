DATA SEGMENT
    PASSWORD DB 30 DUP(?),0DH   ;用户输入密码
    WRITE DB 'Please Input You Password:',0DH,0AH,'$'
    DISSP2 DB 'OK','$'
    DISSP3 DB 'Wrong','$'
    DISSP4 DB 'NO','$'
    ACCURACY DB '5201314',0DH    ;正确的密码
    COUNT EQU $-ACCURACY         ;密码长度
    SEPERATE DB 0DH,0AH,'$'
    TIMES DB 3                   ;尝试次数
DATA ENDS

CODE SEGMENT
        ASSUME CS:CODE, DS:DATA, ES:DATA
    START:
        MOV AX, DATA                     
        MOV DS, AX
        MOV ES, AX

        LEA SI, PASSWORD
        LEA DI, ACCURACY
        LEA DX, WRITE
        MOV AH,09H
        INT 21H
        MOV CX,20
        MOV BX,0    ;初始化

        CALL SUB1
        CALL SUB2
        CALL SUB3   ;主程序
    EXIT:
        MOV AX,4C00H
        INT 21H

SUB1 PROC     ;完成用户输入
    INPUT: 
        MOV AH, 7
        INT 21H
        MOV [SI], AL
        CMP AL,0DH  ;判断输入结束
        JE OVER
        CMP AL,08H
        JE DELETE   ;判断删除
        MOV AH, 2  ;输出*
        MOV DL, '*'      
        INT 21H
        INC SI
        INC BX 
        LOOP INPUT

    DELETE:
        CMP BX, 00H 
        JZ EXIT
        DEC BX
        MOV AH,3 
        INT 10H
        MOV AH,2 
        SUB DL,1
        INT 10H
        MOV AH,2 
        MOV DL,' '      
        INT 21H
        MOV BYTE PTR [SI],00H
        DEC SI

        MOV AH,3 
        INT 10H
        MOV AH,2
        SUB DL,1 
        INT 10H
        JMP INPUT
    OVER:
        RET
SUB1 ENDP

SUB2 PROC    ;判断密码正确性
        LEA DX, SEPERATE
        MOV AH,9
        INT 21H
        LEA SI, PASSWORD
        MOV CX,COUNT
        CLD
        REPZ CMPSB
        JNZ ERROR
        MOV AL, 00H
        RET
    ERROR:
        MOV AL, 0FFH    ;AL为出口参数
        RET
SUB2 ENDP

SUB3 PROC              ;结果输出
        CMP AL, 00H
        JE YESP

        MOV AX, 0     ;剩余次数判断
        LEA SI, TIMES
        MOV AL,[SI]
        DEC AL    ;自减1
        MOV [SI],AL
        CMP AL, 0
        JE PNO

        LEA DX, DISSP3     ;输出错误
        MOV AH,09H 
        INT 21H
        LEA DX, SEPERATE
        MOV AH,9
        INT 21H
        JMP START
    PNO:
        LEA DX, DISSP4     ;输出结束
        MOV AH,09H
        INT 21H
        JMP EXIT

    YESP:
        MOV DX,OFFSET DISSP2  ;输出正确
        MOV AH,09H
        INT 21H
        JMP EXIT
SUB3 ENDP

CODE ENDS
    END START