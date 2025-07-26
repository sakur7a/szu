.ORIG x2000
; �Ĵ���������
ADD R6, R6, #-1
STR R0, R6, #0    
ADD R6, R6, #-1
STR R1, R6, #0    
ADD R6, R6, #-1
STR R2, R6, #0    
ADD R6, R6, #-1
STR R3, R6, #0    
ADD R6, R6, #-1
STR R4, R6, #0    
ADD R6, R6, #-1
STR R7, R6, #0    

; ��ʼ��
LD R4, BUFFER       ; R4 = ��������ʼ��ַ
LD R2, MAX_LENGTH   ; R2 = ����ַ���(31)

; ��ȡ����ѭ��
read_loop:
    LDI R1, KBSR         ; ������״̬
    BRzp read_loop       ; �ȴ�����
    
    LDI R0, KBDR         ; ��ȡ�ַ�
    
    ; ���س���
    LD R3, negEnter      ; R3 = -x000A (xFFF6)
    ADD R3, R0, R3       ; R0 - x000A
    BRz end_read         ; �ǻس��������ȡ
    
    ; �洢�������ַ�
........
    STR R0, R4, #0       ; �洢��������
    JSR OUTPUT_CHAR      ; ��������ӳ���
    
    ; ����ָ��ͼ�����
    ADD R4, R4, #1       ; ������ָ�����
    ADD R2, R2, #-1      ; ʣ�೤�ȼ�1
    BRp read_loop        ; ������пռ������ȡ

end_read:
    ; ����ַ�����ֹ��
    AND R3, R3, #0       ; R3 = 0 (x0000)
    STR R3, R4, #0       ; ��ӿ���ֹ��
    
    ; ��ӡ��ʼ���зָ���������
    LD R0, enter
    JSR OUTPUT_CHAR
    
    ; ���ô�ӡ������
    AND R2, R2, #0
    ADD R2, R2, #10      ; R2 = 10����ӡ10�Σ�

; ��ӡ�ַ���ѭ��
print_loop:
    LD R4, BUFFER         ; ���û�����ָ��
    
    ; ��ӡ�ַ�����ֱ��������ֹ����
    char_loop:
        LDR R0, R4, #0      ; ��ȡ�������ַ�
        BRz end_char        ; �������ַ�����
        
        JSR OUTPUT_CHAR     ; ����ַ�
        ADD R4, R4, #1      ; ָ�����
        BRnzp char_loop
    
    end_char:
        ; ��ӡ�ַ�������
        LD R0, enter
        JSR OUTPUT_CHAR
        
        ; ѭ������
        ADD R2, R2, #-1
        BRp print_loop

; �ָ��Ĵ���������
LDR R7, R6, #0      ; �ָ�R7
ADD R6, R6, #1
LDR R4, R6, #0      ; �ָ�R4
ADD R6, R6, #1
LDR R3, R6, #0      ; �ָ�R3
ADD R6, R6, #1
LDR R2, R6, #0      ; �ָ�R2
ADD R6, R6, #1
LDR R1, R6, #0      ; �ָ�R1
ADD R6, R6, #1
LDR R0, R6, #0      ; �ָ�R0
ADD R6, R6, #1
RTI                 ; ���жϷ���

; �ַ�����ӳ���
OUTPUT_CHAR          ; ���R0�е��ַ������޸�R0��
    ST R1, saveR1    ; ����R1
    ST R0, saveR0    ; ����R0
    output_wait:
        LDI R1, DSR      ; �����ʾ״̬
        BRzp output_wait  ; �ȴ���ʾ����
        STI R0, DDR      ; ����ַ�
    
    LD R0, saveR0    ; �ָ�R0
    LD R1, saveR1    ; �ָ�R1
    RET               ; ����

; ������
BUFFER      .BLKW 32     ; ��������32�֣�
MAX_LENGTH  .FILL #31    ; ����ַ���
enter       .FILL x000A  ; ���з�
negEnter    .FILL xFFF6  ; -x000A
KBSR        .FILL xFE00  ; ����״̬�Ĵ���
KBDR        .FILL xFE02  ; �������ݼĴ���
DSR         .FILL xFE04  ; ��ʾ״̬�Ĵ���
DDR         .FILL xFE06  ; ��ʾ���ݼĴ���
saveR0      .BLKW 1      ; ��ʱ����R0
saveR1      .BLKW 1      ; ��ʱ����R1
.END