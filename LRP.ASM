DATA SEGMENT
	M db 01H,02H,03H,04H,05H,06H,07H,08H,09H,0AH,0BH,0CH,0DH,0EH,0FH,10H,11H,12H,13H,14H
	N db 10H,01H,16H,05H,18H,19H,1AH,1BH,1CH,1DH
	K db 21 DUP(?)    ;����M���е�Nû�е���
	COUNT DB 0        ;��¼K����
DATA ENDS

CODE SEGMENT
        ASSUME CS:CODE,DS:DATA
	BEGIN:
		MOV AX, DATA
		MOV DS, AX

		MOV AX, 0  ;��ʼ��
		MOV CX, 0
		MOV DX, 0
		LEA SI, M

		MOV CH, 21 ;����M�����ѭ��
		DEC SI     ;�����״�ѭ��
	L1:
		INC SI
		MOV CL, 10 ;����N�����ѭ��
		LEA DI, N
		DEC CH
		JE STO     ;���M����������
	L2:
		MOV DL, [SI]
		MOV DH, [DI]
		CMP DL, DH    ;�Ƚ�M��N
		JE L1         ;N�д��ڣ���ֱ����һ��
		DEC CL
		JE SAVEK      ;N��������Ҳ����ڣ�����
		INC DI
		JMP L2

	SAVEK:            ;��������K
		PUSH DI       ;����DI
		MOV AL, [COUNT]
		LEA DI, K
		XOR AH, AH
		ADD DI, AX
		MOV [DI], DL
		ADD COUNT, 1  ;K��������COUNT+1
		POP DI
		JMP L1

	STO:
		MOV AL, [COUNT]
		ADD AL, 6
		MOV BL, AL   ;ת��Ϊ10����
		
		MOV AL, BL
		MOV CL, 4
		SHR AL, CL
		ADD AL, 30H   ;ȡ��λת��ΪASCII��
		MOV DL, AL
		MOV AH, 2
		INT 21H

		MOV AL, BL
		AND AL, 0FH
		ADD AL, 30H   ;ȡ��λת��ΪASCII��
		MOV DL, AL
		MOV AH, 2
		INT 21H

		MOV AH, 4CH
		INT 21H
CODE ENDS
	END BEGIN