DATA SEGMENT
    ORG 500H
    STR DB 01H,02H,03H,04H,05H,06H,07H,08H,09H,0AH
    RES DB 2 DUP(?)
    COUNT DB $-STR-2
DATA ENDS

CODE SEGMENT
        ASSUME  CS:CODE, DS:DATA
    BEGIN:
        MOV AX, DATA
        MOV DS, AX

        MOV CL, COUNT
        LEA SI, STR
        MOV BL, 0
    LOO:
        MOV DL, [SI]
        ADD BL, DL
        INC SI
        DEC CL
        JNZ LOO

        PUSH BX
        LEA SI, RES
        AND BL, 0FH
        MOV [SI], BL
        POP BX
        MOV CL, 4
        SHR BL, CL
        INC SI
        MOV [SI], BL

        MOV AX, 4C00H
        INT 21H
CODE ENDS
    END BEGIN
