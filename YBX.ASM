DATA SEGMENT
        ORG 100H   ;偏移100H
        BUF1 DB 256 DUP(?) ;BUF1用来放数据
        COUNT EQU $-BUF1
        NUM DB 2 DUP(?)  ;NUM在BUF1的后面，用来放正负数量    
        PRI DB 4 DUP(?)  ;存放NUM的ASCII码，用来输出
DATA ENDS

CODE SEGMENT
        ASSUME CS:CODE,DS:DATA
  BEGIN:MOV AX,DATA
        MOV DS,AX

    ;数据输入
        LEA SI, BUF1
        MOV CX, COUNT
        MOV AL, 0000H
   NEXT:MOV [SI], AL
        INC AL
        INC SI
        DEC CX
        JNZ NEXT
    ;结果已保存至BUF1中

    ;数据查找
        MOV CX,COUNT
        XOR BX, BX
        XOR AL, AL
        LEA SI, BUF1
        DEC SI
        INC CX
  NEXT2:INC SI
        DEC CX
        JZ STO
        MOV AL,[SI]
        CMP AL,0
        JS FU
        INC BL
        JMP NEXT2
     FU:INC BH
        JMP NEXT2
        DEC BL   ;排除错误记录0
    STO:LEA SI,NUM
        MOV [SI], BL
        INC SI
        MOV [SI], BH
        ;结果已保存NUM中

        ;转化为ASCII码
        LEA SI, PRI
        XOR AL, AL

        MOV AL, [NUM]
        MOV CL, 4
        SHR AL, CL
        ADD AL, 30H
        MOV [SI], AL

        MOV AL, [NUM]
        AND AL, 0FH
        ADD AL, 30H
        INC SI
        MOV [SI], AL

        MOV AL, [NUM+1]
        MOV CL, 4
        SHR AL, CL
        ADD AL, 30H
        INC SI
        MOV [SI], AL

        MOV AL, [NUM+1]
        AND AL, 0FH
        ADD AL, 30H
        INC SI
        MOV [SI], AL

        ;输出到屏幕上
        LEA SI, PRI
        MOV CX, 4
   PRI_:MOV DL, [SI]
        MOV AH, 2
        INT 21H
        INC SI
        DEC CX
        JNZ PRI_

        MOV AH,4CH
        INT 21H
CODE ENDS
    END BEGIN