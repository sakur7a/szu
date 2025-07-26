.ORIG x3000
LD R6,stack_pointer     ; initialize the stack pointer
LD R1,entry
LD R2,start             ; x2000 д���ַ x0180 
STR R2,R1,#0            ; set up the keyboard interrupt vector table entry
LD R3,IE                ; ������0100 0000 0000 0000,ʹ��λ��Ϊ1,���ü����ж�
STI R3,KBSR             ; enable keyboard interrupts

begin                   ; start of actual user program to print ICS checkerboard
	AND R4,R4,#0           
	ADD R4,R4,#6
print_1                 ; ���￪ʼ��ӡ�����ICS
	BRz end1
	LEA R0,ICS_1
	PUTS
	JSR DELAY       ; ��ʱ�������ӡ̫��
       	ADD R4,R4,#-1   ; ������-1
	BRnzp print_1
end1	LD R0,enter
	OUT             ; ����س���׼����ӡ��һ��
	JSR DELAY

AND R4,R4,#0            ; ͬ��
ADD R4,R4,#5
print_2	
	BRz end2
	LEA R0,ICS_2
	PUTS
	JSR DELAY
	ADD R4,R4,#-1
	BRnzp print_2

end2	LD R0,enter
	OUT
	JSR DELAY
	BRnzp begin

HALT

DELAY   ST  R1, SaveR1    ;��ʱ�ӳ���
        LD  R1, COUNT
REP     ADD R1,R1,#-1
        BRp REP
        LD  R1, SaveR1
        RET

stack_pointer .fill x3000 ; ջָ��
entry    .fill x0180      ; �ڴ��ַx0180����ʼ��Ϊx2000��
start    .fill x2000      ; ��ʼֵx2000������x0180��
IE       .fill x4000      ; �ж�ʹ��ֵ��д��KBSR��
KBSR     .fill xFE00      ; ����״̬�Ĵ�����ַ
ICS_1    .STRINGZ "ICS   " 
ICS_2    .STRINGZ "   ICS" 
enter    .fill x000A      ; ���з���ASCII��0x0A��
COUNT    .fill #25000      ; ��ʱѭ������
SaveR1   .BLKW 1          ; ����R1����ʱ��ַ

.END
