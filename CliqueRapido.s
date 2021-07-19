@Thiago Henrique Frois Menon Cunha - 2128080

.equ SWI_GetTick,0x6d @Obtém o horário do relógio em ms 
.equ SWI_CheckBlack, 0x202 @Verifica se o botão preto foi pressionado
.equ SWI_CheckBlue, 0x203 @Verifica se o botao preto foi pressionado
.equ SWI_DRAW_STRING, 0x204 @Mostra uma string no LCD
.equ SWI_DRAW_INT, 0x205 @Mostra um inteiro no LCD
.equ SWI_CLEAR_DISPLAY,0x206 @Limpa o LCD
.equ SWI_EXIT, 0x11 @Sai do programa
.equ SWI_SETSEG8,0x200 @Mostra o número no display de 8 segmentos
.equ SEG_A,0x80 
.equ SEG_B,0x40 
.equ SEG_C,0x20 
.equ SEG_D,0x08 
.equ SEG_E,0x04 
.equ SEG_F,0x02 
.equ SEG_G,0x01 
.equ SEG_P,0x10 
.equ BLUE_KEY_00, 0x01 @button(0)
.equ BLUE_KEY_01, 0x02 @button(1)
.equ BLUE_KEY_02, 0x04 @button(2)
.equ BLUE_KEY_03, 0x08 @button(3)
.equ BLUE_KEY_04, 0x10 @button(4)
.equ BLUE_KEY_05, 0x20 @button(5)
.equ BLUE_KEY_06, 0x40 @button(6)
.equ BLUE_KEY_07, 0x80 @button(7)
.equ BLUE_KEY_08, 1<<8 @button(8) 
.equ BLUE_KEY_09, 1<<9 @button(9)
.equ BLUE_KEY_10, 1<<10 @button(10)
.equ BLUE_KEY_11, 1<<11 @button(11)
.equ BLUE_KEY_12, 1<<12 @button(12)
.equ BLUE_KEY_13, 1<<13 @button(13)
.equ BLUE_KEY_14, 1<<14 @button(14)
.equ BLUE_KEY_15, 1<<15 @button(15)

mov r9,#1 @Variável que conta o número de rodadas

@Mostra string no LCD no formato - Rodadas  : 00.000 s
swi SWI_CLEAR_DISPLAY
mov r0,#4 
mov r1,#5
ldr r2,=rounds
swi SWI_DRAW_STRING

round: @Loop para jogar até que terminar o número de rodadas

@Mostra número de rodadas no LCD
mov r0,#11
mov r1,#5
mov r2,r9
swi SWI_DRAW_INT

@Loop para verificar se um botão preto foi pressionado
loopBlackButtonAux: 
    mov r0,#0
loopBlackButton:
    swi SWI_CheckBlack
    cmp r0,#0
    beq loopBlackButton

@Obtém o número aleatório, isto é, os 4 bits menos significativos do tick do relógio
swi SWI_GetTick
mov r1,#0
mov r2,#0
add r1,r1,r0,lsl #28
add r2,r2,r1,lsr #28

@Verifica qual número aleatório foi obtido
compareRandomNumber: 
    cmp r2,#0
    beq zero 
    cmp r2,#1
    beq one
    cmp r2,#2
    beq two  
    cmp r2,#3
    beq three 
    cmp r2,#4
    beq four
    cmp r2,#5
    beq five
    cmp r2,#6
    beq six
    cmp r2,#7
    beq seven 
    cmp r2,#8
    beq eight
    cmp r2,#9
    beq nine
    cmp r2,#10
    beq a
    cmp r2,#11
    beq b 
    cmp r2,#12
    beq c 
    cmp r2,#13
    beq d 
    cmp r2,#14
    beq e 
    cmp r2,#15
    beq f 

@Mostra no display de 8 segmentos o número aleatório obtido
zero:
    mov r1,#0
    mov r0,#0
    bl display8Segment
    b endcomp

one:
    mov r1,#0
    mov r0,#1
    bl display8Segment
    b endcomp

two:
    mov r1,#0
    mov r0,#2
    bl display8Segment
    b endcomp

three:
    mov r1,#0
    mov r0,#3
    bl display8Segment
    b endcomp

four:
    mov r1,#0
    mov r0,#4
    bl display8Segment
    b endcomp

five:
    mov r1,#0
    mov r0,#5
    bl display8Segment
    b endcomp

six:    
    mov r1,#0
    mov r0,#6
    bl display8Segment
    b endcomp

seven:
    mov r1,#0
    mov r0,#7
    bl display8Segment
    b endcomp

eight:
    mov r1,#0
    mov r0,#8
    bl display8Segment
    b endcomp

nine:
    mov r1,#0
    mov r0,#9
    bl display8Segment
    b endcomp

a:
    mov r1,#0
    mov r0,#10
    bl display8Segment
    b endcomp

b:
    mov r1,#0
    mov r0,#11
    bl display8Segment
    b endcomp

c:
    mov r1,#0
    mov r0,#12
    bl display8Segment
    b endcomp

d:
    mov r1,#0
    mov r0,#13
    bl display8Segment
    b endcomp

e:
    mov r1,#0
    mov r0,#14
    bl display8Segment
    b endcomp

f:
    mov r1,#0
    mov r0,#15
    bl display8Segment
    b endcomp

endcomp:

@Loop para verificar se um botão azul foi pressionado
loopBlueButtonAux:
    mov r7,r2 @Armazena o número aleatório
    swi SWI_GetTick @Tempo inicial
    mov r6,r0 
loopBlueButton:
    swi SWI_GetTick @Tempo atual
    sub r5,r0,r6 @Quanto tempo se passou desde o tempo inicial
    cmp r5,#50 
    bne notUpdate @Verifica se já passou 50 ms
    
    @Atualiza a contador de tempo em 50 ms
    add r8,r8,#50
    cmp r8,#1000
    bne notContSeg @Verifica se já passou 1 s

    mov r8,#0 @Zera o número de milissegundos acumulados
    add r4,r4,#1 @Atualiza o número de segundos
    
    notContSeg:

    @Gera um novo tempo inicial
    swi 0x6d
    mov r6,r0
    mov r5,#0  

    @Mostra no LCD o tempo acumulado
    mov r0,#15
    cmp r4,#10 @Verifica se o número de segundos tem dois dígitos
    blt notTwodigits
    mov r0,#14
    notTwodigits:
    mov r1,#5
    mov r2,r4
    swi SWI_DRAW_INT
    
    mov r0,#18
    cmp r8,#100 @Verifica se o número de milissegundos tem três digitos
    blt notThreedigits
    mov r0,#17
    notThreedigits:
    mov r1,#5
    mov r2,r8
    swi SWI_DRAW_INT
    

    notUpdate:

    swi SWI_CheckBlue
    cmp r0,#0
    beq loopBlueButton

@Verifica qual botão azul foi pressionado
bluekey:
    cmp r0,#BLUE_KEY_15
    beq FIFTEEN
    cmp r0,#BLUE_KEY_14
    beq FOURTEEN
    cmp r0,#BLUE_KEY_13
    beq THIRTEEN
    cmp r0,#BLUE_KEY_12
    beq TWELVE
    cmp r0,#BLUE_KEY_11
    beq ELEVEN
    cmp r0,#BLUE_KEY_10
    beq TEN
    cmp r0,#BLUE_KEY_09
    beq NINE
    cmp r0,#BLUE_KEY_08
    beq EIGHT
    cmp r0,#BLUE_KEY_07
    beq SEVEN
    cmp r0,#BLUE_KEY_06
    beq SIX
    cmp r0,#BLUE_KEY_05
    beq FIVE
    cmp r0,#BLUE_KEY_04
    beq FOUR
    cmp r0,#BLUE_KEY_03
    beq THREE
    cmp r0,#BLUE_KEY_02
    beq TWO
    cmp r0,#BLUE_KEY_01
    beq ONE
    cmp r0,#BLUE_KEY_00
    beq ZERO

@Transforma o botão pressionado em um inteiro
FIFTEEN:
    mov r0,#15
    b endcomp2  
FOURTEEN:
    mov r0,#14
    b endcomp2 
THIRTEEN:
    mov r0,#13
    b endcomp2 
TWELVE:
    mov r0,#12
    b endcomp2   
ELEVEN:
    mov r0,#11 
    b endcomp2   
TEN:
    mov r0,#10
    b endcomp2 
NINE:
    mov r0,#9
    b endcomp2 
EIGHT:
    mov r0,#8
    b endcomp2 
SEVEN:
    mov r0,#7
    b endcomp2 
SIX:
    mov r0,#6
    b endcomp2 
FIVE:
    mov r0,#5
    b endcomp2 
FOUR:
    mov r0,#4
    b endcomp2 
THREE:
    mov r0,#3
    b endcomp2 
TWO:
    mov r0,#2
    b endcomp2 
ONE:
    mov r0,#1
    b endcomp2 
ZERO:
    mov r0,#0
    b endcomp2 

endcomp2:

@Verifica se o botã azul pressionado foi o correto
compareButton:
    cmp r7,r0
    beq right 

@Mostra no LCD "Perdeu!"
wrong:
    swi SWI_CLEAR_DISPLAY
    mov r0,#4 
    mov r1,#5
    ldr r2,=youLost
    swi SWI_DRAW_STRING
    b final

@incrementa a rodada e volta para o início do loop, se não chegou ao fim do número de rodadas
right:
    cmp r9,#6
    beq final
    add r9,r9,#1
    mov r1,#0
    mov r0,#16
    bl display8Segment @Limpa o display de 8 segmentos
    b round

@Mostra o número no display de 8 segmentos
display8Segment:
    stmfd    sp!,{r0-r2,lr}
    ldr      r2,=digits
    ldr      r0,[r2,r0,lsl#2]
    tst      r1,#0x01 @if r1=1,
    swi      SWI_SETSEG8
    ldmfd    sp!,{r0-r2,pc}

final:
    mov r1,#0
    mov r0,#16
    bl display8Segment @Limpa display de 8 segmentos

.data
    rounds: .asciz "Rodada  : 00.000 s"
    youLost: .asciz "Perdeu!"
    digits:
        .word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_G @0
        .word SEG_B|SEG_C @1
        .word SEG_A|SEG_B|SEG_F|SEG_E|SEG_D @2
        .word SEG_A|SEG_B|SEG_F|SEG_C|SEG_D @3
        .word SEG_G|SEG_F|SEG_B|SEG_C @4
        .word SEG_A|SEG_G|SEG_F|SEG_C|SEG_D @5
        .word SEG_A|SEG_G|SEG_F|SEG_E|SEG_D|SEG_C @6
        .word SEG_A|SEG_B|SEG_C @7
        .word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_F|SEG_G @8
        .word SEG_A|SEG_B|SEG_F|SEG_G|SEG_C @9
        .word SEG_A|SEG_B|SEG_C|SEG_E|SEG_F|SEG_G @A
        .word SEG_C|SEG_D|SEG_E|SEG_F|SEG_G @B
        .word SEG_A|SEG_D|SEG_E|SEG_G @C
        .word SEG_B|SEG_C|SEG_D|SEG_E|SEG_F @D
        .word SEG_A|SEG_D|SEG_E|SEG_F|SEG_G @E
        .word SEG_A|SEG_E|SEG_F|SEG_G @F
        .word 0  @Blank display

.end

swi SWI_EXIT
