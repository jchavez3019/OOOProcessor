riscv_mp2test.s:
.align 4
.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:
    # Note that the comments in this file should not be taken as
    # an example of good commenting style!!  They are merely provided
    # in an effort to help you understand the assembly style.

    # Note that one/two/eight are data labels
    # lw  x1, threshold # X1 <- 0x80
    # lui  x2, 2       # X2 <= 2
    # lui  x3, 8     # X3 <= 8
    # srli x2, x2, 12
    # srli x3, x3, 12

    # addi x4, x3, 4    # X4 <= X3 + 2


    /* personal test code for checkpoint 2 */

    and x1, x2, x0
    and x2, x3, x0
    # and x3, x4, x0

    jal x7, jal_test_1

    addi x1, x1, 96 # 96 = 0x60
    jalr x7, x1, 24 # instruction 60 + 20
    addi x2, x2, 5

jal_test_1:

    addi x2, x2, 7 # this should be instruction 80

    addi x2, x2, 9

    # and x6, x0, x6
    # and x7, x0, x7
    # and x8, x0, x8
    # la x10, result

    # addi x1, x1, 11 # x1 = 11
    # addi x2, x2, 12
    # addi x3, x3, 13

    # add x4, x1, x2 # x4 = 23
    # add x5, x2, x3 # x5 = 25

# jal_test_1:

    # and x1, x2, x0
    # and x2, x3, x0
    # and x3, x4, x0

    # addi x1, x1, 2
    # addi x2, x2, 5
    # add x3, x1, x2
# 
# 
    # # /* x6 == 0000 001x xxxx; x7 == 1000 001x xxxx */
    # addi x6, x6, 1
    # slli x6, x6, 5
    # addi x6, x6, 1
    # slli x6, x6, 5
# 
    # addi x7, x7, 65
    # slli x7, x7, 5
    # addi x7, x7, 65
    # slli x7, x7, 5
# 
    # addi x8, x8, 73
    # slli x8, x8, 5
    # addi x8, x8, 73
    # slli x8, x8, 5
# 
    # sw x6, 0(x10)
    # sw x7, 0(x10)
    # sw x8, 0(x10)
# 
    # sw x1, 0(x6)
    # sw x2, 0(x7)
    # sw x3, 0(x8)
# 
    # lw x1, 0(x6)
    # lw x2, 0(x7)
    # lw x3, 0(x8)
# 
    # sw x1, 0(x10)
    # sw x2, 0(x10)
    # sw x3, 0(x10)
# 
    # lw x1, 0(x10)
    # lw x2, 0(x10)
    # lw x3, 0(x10)

#     addi x6, x6, 5
#     jal x7, jal_test_1  # jump to label and store pc+4 in x7 which should correspond to the next addition
#   
#     addi x6, x6, 5  # jalr should return us to this point
#     addi x6, x6, 5
#     addi x6, x6, 5
# 
#     sw x6, 0(x10) # x6 should be 26 which is x1a
# 
#     jal x0, load_store_tests  # move to next testing section
# jal_test_1:
#     addi x6, x6, 1  # at this point, x6 shoould be 6, not 11
#     la x10, result
#     sw x6, 0(x10)  # store results
#     sw x7, 0(x10)
# 
#     jalr x0, x7, 0
# 
#     addi x6, x6, 1
#     addi x6, x6, 1
# 
#     sw x6, 0(x10)  # x6 would be 13 if this point is reached which it shouldn't

# load_store_tests:
#     la x10, result
#
#     addi x6, x0, -13
#
#     sw x0, 0(x10)  # store 0 in x10
#     xor x11, x0, x6
#     addi x11, x11, 25  # have x11 hold 27 which is x1b
#
#     sb x6, 0(x10)
#     addi x10, x10, 1
#     sb x11, 0(x10)
#     addi x10, x10, 1
#     slli x11, x11, 8
#     add x11, x11, x6
#     sh x11, 0(x10)  # reults should be x1b1a_1b1a
#     addi x10, x10, -2
#     lw x11, result
#
#     lh x11, 0(x10)
#     or x11, x11, x11
#     addi x10, x10, 2
#     lb x11, 0(x10)
#     or x11, x11, x11
#     addi x10, x10, 1
#     lb x11, 0(x10)
#     or x11, x11, x11
#
#     addi x10, x10, -2
#
#     lhu x11, 0(x10)
#     or x11, x11, x11
#     addi x10, x10, 2
#     lbu x11, 0(x10)
#     or x11, x11, x11
#     addi x10, x10, 1
#     lbu x11, 0(x10)
#     or x11, x11, x11
#
#     jal x0, halt
#
#
#     /* end test code */
#
# loop1:
#     slli x3, x3, 1    # X3 <= X3 << 1
#     xori x5, x2, 127  # X5 <= XOR (X2, 7b'1111111)
#     addi x5, x5, 1    # X5 <= X5 + 1
#     addi x4, x4, 4    # X4 <= X4 + 8
#
#     bleu x4, x1, loop1   # Branch if last result was zero or positive.
#
#     andi x6, x3, 64   # X6 <= X3 + 64
#
#     auipc x7, 8         # X7 <= PC + 8
#     lw x8, good         # X8 <= 0x600d600d
#     la x10, result      # X10 <= Addr[result]
#     sw x8, 0(x10)       # [Result] <= 0x600d600d
#     lw x9, result       # X9 <= [Result]
#     bne x8, x9, deadend # PC <= bad if x8 != x9

halt:                 # Infinite loop to keep the processor
    beq x0, x0, halt  # from trying to execute the data below.
                      # Your own programs should also make use
                      # of an infinite loop at the end.

deadend:
    lw x8, bad     # X8 <= 0xdeadbeef
deadloop:
    beq x8, x8, deadloop

.section .rodata

bad:        .word 0xdeadbeef
threshold:  .word 0x00000040
result:     .word 0x00000000
good:       .word 0x600d600d
