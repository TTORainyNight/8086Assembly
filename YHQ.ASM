DATA SEGMENT
        ORG 100H
        STR DB 'YhQ666!nB',-1   ;串内容，以-1结束
        LENTH DB ?        ;放大学字母个数
        PRI DB 8 DUP(?)    ;放二进制的ASCII码
DATA ENDS

CODE SEGMENT
        ASSUME CS:CODE,DS:DATA
  BEGIN:MOV AX,DATA
        MOV DS,AX

        LEA SI, STR
        CALL COUNT_
        CALL ASCII_
        CALL PRINT_
COUNT_ PROC
;统计大写字母个数
        MOV BL, 0
        MOV CX, 200  ;CX远大于串长度，防止死循环
  LOOP_:MOV AL, [SI]
        CMP AL, -1
        JE END_ 
        CMP AL, 'A'
        JB NEXT_ 
        CMP AL, 'Z'
        JA NEXT_
        INC BL
  NEXT_:INC SI
        DEC CX
        JNZ LOOP_    ;死循环强制退出
   END_:MOV LENTH, BL
        RET
COUNT_ ENDP

ASCII_ PROC
;字数按位转化为二进制ASCII码
        MOV AL, [LENTH]
        MOV BL, 30H
        MOV BH, 31H
        MOV CX, 8
        LEA SI, PRI

  LOOPA:RCL AL, 1
        JNC ZERO_
        MOV [SI], BH
        INC SI
        DEC CX
        JNZ LOOPA
        JMP STO
  ZERO_:MOV [SI], BL
        INC SI
        DEC CX
        JNZ LOOPA
        JMP STO
    STO:RET
        
ASCII_ ENDP

PRINT_ PROC
;按位输出ASCII码
        LEA SI, PRI
        MOV CX, 8
   PRI_:MOV DL, [SI]
        MOV AH, 2
        INT 21H
        INC SI
        DEC CX
        JNZ PRI_
PRINT_ ENDP
        MOV AH,4CH
        INT 21H
CODE ENDS
    END BEGIN