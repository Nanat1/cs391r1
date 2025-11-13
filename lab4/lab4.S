    .text
    .globl main
main:
    ############################################################
    # STEP 1: CLEAR (RESET) REGISTERS x1 - x31 USING R-TYPE OPS
    ############################################################
    xor  x1,  x0, x0    # x1  = 0
    sub  x2,  x0, x0    # x2  = 0
    or   x3,  x0, x0    # x3  = 0
    and  x4,  x0, x0    # x4  = 0
    sll  x5,  x0, x0    # x5  = 0
    srl  x6,  x0, x0    # x6  = 0
    sra  x7,  x0, x0    # x7  = 0
    xor  x8,  x0, x0    # x8  = 0
    sub  x9,  x0, x0    # x9  = 0
    or   x10, x0, x0    # x10 = 0
    and  x11, x0, x0    # x11 = 0
    sll  x12, x0, x0    # x12 = 0
    srl  x13, x0, x0    # x13 = 0
    sra  x14, x0, x0    # x14 = 0
    xor  x15, x0, x0    # x15 = 0
    sub  x16, x0, x0    # x16 = 0
    or   x17, x0, x0    # x17 = 0
    and  x18, x0, x0    # x18 = 0
    sll  x19, x0, x0    # x19 = 0
    srl  x20, x0, x0    # x20 = 0
    sra  x21, x0, x0    # x21 = 0
    xor  x22, x0, x0    # x22 = 0
    sub  x23, x0, x0    # x23 = 0
    or   x24, x0, x0    # x24 = 0
    and  x25, x0, x0    # x25 = 0
    sll  x26, x0, x0    # x26 = 0
    srl  x27, x0, x0    # x27 = 0
    sra  x28, x0, x0    # x28 = 0
    xor  x29, x0, x0    # x29 = 0
    sub  x30, x0, x0    # x30 = 0
    or   x31, x0, x0    # x31 = 0


    ############################################################
    # STEP 2: BUILD ASCII CONSTANTS IN REGISTERS x1 - x19
    # Each target is a 4-character chunk from the string:
    #   "CS391 Computer and Memory Architectures by Renato Mancuso and Sabrina Neuman"
    #
    # We construct each 32-bit constant with LUI + a mixture of
    # I-type (ADDI, XORI, ORI) and some "no-op" R-type instructions.
    ############################################################


    # x1 <- "CS39" => 0x43 53 33 39 => 0x43533339
    lui   x1, 0x43533          # x1 = 0x43533000
    add   x1, x1, x0           # R-type "no-op"
    ori   x1, x1, 0x339        # x1 = 0x43533339


    # x2 <- "1 Co" => 0x31 20 43 6F => 0x3120436F
    lui   x2, 0x31204          # x2 = 0x31204000
    sub   x2, x2, x0           # R-type "no-op"
    xori  x2, x2, 0x36F        # x2 = 0x3120436F


    # x3 <- "mput" => 0x6D 70 75 74 => 0x6D707574
    lui   x3, 0x6D707          # x3 = 0x6D707000
    xor   x3, x3, x0           # R-type "no-op"
    ori   x3, x3, 0x574        # x3 = 0x6D707574



    lui x16, 0x2 
    sw x3, 0(x16) 
    
    lui x16, 0x1 
    sw    x2, 0(x16)

    xor   x3, x0, x0
    xor   x2, x0, x0


    lui   x2, 0x123
    bne   x1, x2, my_tag



my_tag:
    
    lui x16, 0x1 
    lw    x2, 0(x16)

    lui x16, 0x2
    lw x3, 0(x16) 

    bgt x1, x2, my_second_tag

    xor   x2, x0, x0
    xor   x3, x0, x0

my_second_tag:


    # x4 <- "er a" => 0x65 72 20 61 => 0x65722061
    lui   x4, 0x65722          # x4 = 0x65722000
    sub   x4, x4, x0           # no-op
    ori   x4, x4, 0x61         # x4 = 0x65722061


    # x5 <- "nd M" => 0x6E 64 20 4D => 0x6E64204D
    lui   x5, 0x6E642          # x5 = 0x6E642000
    or    x5, x5, x0           # no-op
    addi  x5, x5, 0x4D         # x5 = 0x6E64204D


    # x6 <- "emor" => 0x65 6D 6F 72 => 0x656D6F72
    lui   x6, 0x656D7          # x6 = 0x656D7000
    xor   x6, x6, x0           # no-op
    addi  x6, x6, -142         # x6 = 0x656D6F72


    # x7 <- "y Ar" => 0x79 20 41 72 => 0x79204172
    lui   x7, 0x79204          # x7 = 0x79204000
    or    x7, x7, x0           # no-op
    addi  x7, x7, 0x172        # x7 = 0x79204172


    # x8 <- "chit" => 0x63 68 69 74 => 0x63686974
    lui   x8, 0x63687          # x8 = 0x63687000
    and   x8, x8, x8           # R-type "no-op"
    addi  x8, x8, -140         # x8 = 0x63686974


    # x9 <- "ectu" => 0x65 63 74 75 => 0x65637475
    lui   x9, 0x65637          # x9 = 0x65637000
    sub   x9, x9, x0           # no-op
    addi  x9, x9, 0x475        # x9 = 0x65637475


    # x10 <- "res " => 0x72 65 73 20 => 0x72657320
    lui   x10, 0x72657         # x10 = 0x72657000
    sll   x10, x10, x0         # no-op
    addi  x10, x10, 0x320      # x10 = 0x72657320


    # x11 <- "by R" => 0x62 79 20 52 => 0x62792052
    lui   x11, 0x62792         # x11 = 0x62792000
    xor   x11, x11, x0         # no-op
    addi  x11, x11, 0x52       # x11 = 0x62792052


    # x12 <- "enat" => 0x65 6E 61 74 => 0x656E6174
    lui   x12, 0x656E6         # x12 = 0x656E6000
    sub   x12, x12, x0         # no-op
    addi  x12, x12, 0x174      # x12 = 0x656E6174


    # x13 <- "o Ma" => 0x6F 20 4D 61 => 0x6F204D61
    lui   x13, 0x6F205         # x13 = 0x6F205000
    or    x13, x13, x0         # no-op
    addi  x13, x13, -0x29F     # x13 = 0x6F204D61


    # x14 <- "ncus" => 0x6E 63 75 73 => 0x6E637573
    lui   x14, 0x6E637         # x14 = 0x6E637000
    and   x14, x14, x14        # no-op
    addi  x14, x14, 0x573      # x14 = 0x6E637573


    # x15 <- "o an" => 0x6F 20 61 6E => 0x6F20616E
    lui   x15, 0x6F206         # x15 = 0x6F206000
    xor   x15, x15, x0         # no-op
    addi  x15, x15, 0x16E      # x15 = 0x6F20616E


    # x16 <- "d Sa" => 0x64 20 53 61 => 0x64205361
    lui   x16, 0x64205         # x16 = 0x64205000
    sll   x16, x16, x0         # no-op
    addi  x16, x16, 0x361      # x16 = 0x64205361


    # x17 <- "brin" => 0x62 72 69 6E => 0x6272696E
    lui   x17, 0x62727         # x17 = 0x62727000
    sub   x17, x17, x0         # no-op
    addi  x17, x17, -0x92      # x17 = 0x6272696E


    # x18 <- "a Ne" => 0x61 20 4E 65 => 0x61204E65
    lui   x18, 0x61205         # x18 = 0x61205000
    or    x18, x18, x0         # no-op
    addi  x18, x18, -0x19B     # x18 = 0x61204E65


    # x19 <- "uman" => 0x75 6D 61 6E => 0x756D616E
    lui   x19, 0x756D6         # x19 = 0x756D6000
    xor   x19, x19, x0         # no-op
    addi  x19, x19, 0x16E      # x19 = 0x756D616E


    # Registers x20 - x31 remain 0 as set above.


    ############################################
    # STEP 3: HALT (INFINITE LOOP)
    ############################################
halt:
    j halt
    ebreak

