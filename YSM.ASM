DATA SEGMENT;定义数据逻辑段
    SINPUT DB 'Please input a string: $' ;输入字符串的提示语
    SOUTPUT DB 'The changed string is: $'  ;输出字符串的提示语
    BUF1 DB 20H
        DB  0
        DB 20H DUP(0) ;定义数据区
DATA ENDS;数据逻辑段定义结束

CODES SEGMENT
        ASSUME CS:CODES, DS:DATA
    START:
        MOV AX,DATA
        MOV DS,AX

        LEA DX,SINPUT
        MOV AH,09H
        INT 21H       ;提示信息输出

        LEA DX,BUF1
        MOV AH,0AH
        INT 21H       ;输入

        MOV DL,0DH
        MOV AH,2
        INT 21H
        MOV DL,0AH
        MOV AH,2
        INT 21H
        MOV AH,09H
        LEA DX,SOUTPUT
        INT 21H       ;提示信息输出

        MOV DX,0
        MOV BX,10
        MOV SI,2
        MOV AX,0
        MOV CX, 200H    ;初始化，CX防卡死

    REREAD:
        MOV AL,BUF1[SI]
        CMP AL,0DH
        JE  FINAL
        CMP AL,'z'
        JBE LESSZ          ;验证小于等于z
        JMP LOP
    LESSZ:
        CMP AL,'a'
        JGE GREATERA       ;验证大于等于a
        JMP LOP
    GREATERA:
        SUB AL,32           ;ASCII码转大写
    LOP:
        MOV DL,AL
        MOV AH,2
        INT 21H              ;转换后输出
        INC SI
        DEC CX
        JZ FINAL             ;防卡死出口
        JMP REREAD

    FINAL:
        MOV AH,4CH
        INT 21H
CODES ENDS
    END START