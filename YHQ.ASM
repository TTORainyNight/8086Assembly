DATA SEGMENT
        ORG 100H
        STR DB 'YhQ666!nB',-1   ;�����ݣ���-1����
        LENTH DB ?        ;�Ŵ�ѧ��ĸ����
        PRI DB 8 DUP(?)    ;�Ŷ����Ƶ�ASCII��
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
;ͳ�ƴ�д��ĸ����
        MOV BL, 0
        MOV CX, 200  ;CXԶ���ڴ����ȣ���ֹ��ѭ��
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
        JNZ LOOP_    ;��ѭ��ǿ���˳�
   END_:MOV LENTH, BL
        RET
COUNT_ ENDP

ASCII_ PROC
;������λת��Ϊ������ASCII��
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
;��λ���ASCII��
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