DATA SEGMENT
	M db 01H,02H,03H,04H,05H,06H,07H,08H,09H,0AH,0BH,0CH,0DH,0EH,0FH,10H,11H,12H,13H,14H
	N db 10H,01H,16H,05H,18H,19H,1AH,1BH,1CH,1DH
	K db 21 DUP(?)    ;储存M中有但N没有的数
	COUNT DB 0        ;记录K长度
DATA ENDS

CODE SEGMENT
        ASSUME CS:CODE,DS:DATA
	BEGIN:
		MOV AX, DATA
		MOV DS, AX

		MOV AX, 0  ;初始化
		MOV CX, 0
		MOV DX, 0
		LEA SI, M

		MOV CH, 21 ;遍历M数组的循环
		DEC SI     ;纠正首次循环
	L1:
		INC SI
		MOV CL, 10 ;遍历N数组的循环
		LEA DI, N
		DEC CH
		JE STO     ;检测M数组遍历完毕
	L2:
		MOV DL, [SI]
		MOV DH, [DI]
		CMP DL, DH    ;比较M和N
		JE L1         ;N中存在，则直接下一个
		DEC CL
		JE SAVEK      ;N遍历完毕且不存在，保存
		INC DI
		JMP L2

	SAVEK:            ;保存数到K
		PUSH DI       ;保护DI
		MOV AL, [COUNT]
		LEA DI, K
		XOR AH, AH
		ADD DI, AX
		MOV [DI], DL
		ADD COUNT, 1  ;K长度数组COUNT+1
		POP DI
		JMP L1

	STO:
		MOV AL, [COUNT]
		ADD AL, 6
		MOV BL, AL   ;转化为10进制
		
		MOV AL, BL
		MOV CL, 4
		SHR AL, CL
		ADD AL, 30H   ;取高位转化为ASCII码
		MOV DL, AL
		MOV AH, 2
		INT 21H

		MOV AL, BL
		AND AL, 0FH
		ADD AL, 30H   ;取低位转化为ASCII码
		MOV DL, AL
		MOV AH, 2
		INT 21H

		MOV AH, 4CH
		INT 21H
CODE ENDS
	END BEGIN