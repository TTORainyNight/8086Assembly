DATA SEGMENT;���������߼���
    SINPUT DB 'Please input a string: $' ;�����ַ�������ʾ��
    SOUTPUT DB 'The changed string is: $'  ;����ַ�������ʾ��
    BUF1 DB 20H
        DB  0
        DB 20H DUP(0) ;����������
DATA ENDS;�����߼��ζ������

CODES SEGMENT
        ASSUME CS:CODES, DS:DATA
    START:
        MOV AX,DATA
        MOV DS,AX

        LEA DX,SINPUT
        MOV AH,09H
        INT 21H       ;��ʾ��Ϣ���

        LEA DX,BUF1
        MOV AH,0AH
        INT 21H       ;����

        MOV DL,0DH
        MOV AH,2
        INT 21H
        MOV DL,0AH
        MOV AH,2
        INT 21H
        MOV AH,09H
        LEA DX,SOUTPUT
        INT 21H       ;��ʾ��Ϣ���

        MOV DX,0
        MOV BX,10
        MOV SI,2
        MOV AX,0
        MOV CX, 200H    ;��ʼ����CX������

    REREAD:
        MOV AL,BUF1[SI]
        CMP AL,0DH
        JE  FINAL
        CMP AL,'z'
        JBE LESSZ          ;��֤С�ڵ���z
        JMP LOP
    LESSZ:
        CMP AL,'a'
        JGE GREATERA       ;��֤���ڵ���a
        JMP LOP
    GREATERA:
        SUB AL,32           ;ASCII��ת��д
    LOP:
        MOV DL,AL
        MOV AH,2
        INT 21H              ;ת�������
        INC SI
        DEC CX
        JZ FINAL             ;����������
        JMP REREAD

    FINAL:
        MOV AH,4CH
        INT 21H
CODES ENDS
    END START