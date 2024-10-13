## predifined test input
.data
test_data1:   
    .word 0, 3, 4
test_data1_len: 
    .word 3
ans_data1:    
    .word 0, 4, 3

test_data2:
    .word 16, 8, 4, 2, 1
test_data2_len: 
    .word 5
ans_data2:    
    .word 1, 2, 4, 8, 16

test_data3:
    .word 0, 1, 2, 3, 4, 5, 6, 7, 8
test_data3_len: 
    .word 9
ans_data3:    
    .word 0, 1, 2, 4, 8, 3, 5, 6, 7

f_str:  .string " False\n"
t_str:  .string " True\n"
align_str:  .string "  "
.text

main: 
    ## first test data
    la a2, test_data2  ## get input test_data1
    la a3, test_data2_len ## get length of input test_data1
    lw a3, 0(a3)
    addi sp, sp, -12
    sw ra, 0(sp)    ## put return address into stack
    ## sw a0, 4(sp)    ## put return address into stack
    ## sw a1, 8(sp)    ## put return address into stack
    addi s0, a2, 0
    addi s1, x0, 0
    addi s2, a3, -1
    jal ra, quick_sort
    addi t2, x0, 0
    addi t1, a3, 0
    la t3, ans_data2
    jal ra, print_loop
    
    ## second test data
    la a2, test_data1    ## get input test_data1
    la a3, test_data1_len ## get length of input test_data1
    lw a3, 0(a3)
    addi sp, sp, -12
    sw ra, 0(sp)    ## put return address into stack
    ## sw a0, 4(sp)    ## put return address into stack
    ## sw a1, 8(sp)    ## put return address into stack
    addi s0, a2, 0
    addi s1, x0, 0
    addi s2, a3, -1
    jal ra, quick_sort
    addi t2, x0, 0
    addi t1, a3, 0
    la t3, ans_data1
    jal ra, print_loop
    
    ## third test data
    la a2, test_data3    ## get input test_data1
    la a3, test_data3_len ## get length of input test_data1
    lw a3, 0(a3)
    addi sp, sp, -12
    sw ra, 0(sp)    ## put return address into stack
    ## sw a0, 4(sp)    ## put return address into stack
    ## sw a1, 8(sp)    ## put return address into stack
    addi s0, a2, 0
    addi s1, x0, 0
    addi s2, a3, -1
    jal ra, quick_sort
    addi t2, x0, 0
    addi t1, a3, 0
    la t3, ans_data3
    jal ra, print_loop
    
    li a7, 10
    ecall
    
quick_sort:
    ## 3 parameters input in s0, s1, s2
    ## s0: arr pointer, s1: start, s2: end
    ## variable
    ## s3: pivot
    blt s2, s1, quick_sort_ret ## if start < end, return
    ## calculating pivot
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)
    jal ra, partition ## pivot return in s0
    addi s3, s0, 0 ## s3 is pivot
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
    ## pushing data(ret addr, arr pointer, start, end) into stack
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp) 
    addi s2, s3, -1    ## set s2 to be pivot-1
    jal ra, quick_sort    ## quick_sort_adv(arr, start, pivot-1);
    lw s2, 12(sp) ## get value of end
    addi s1, s3, 1 ## pivot + 1
    jal ra, quick_sort    ## quick_sort_adv(arr, pivot+1, end);
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    addi sp, sp, 16
    
quick_sort_ret:
    jr ra

partition:
    ## 3 parameters input in s0, s1, s2
    ## s0: arr pointer, s1: start, s2: end
    ## return in s0: value of pivot
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)
    sw t0, 16(sp)
    sw t1, 20(sp)
    sw t2, 24(sp)
    sw t3, 28(sp)
    addi t1, s1, 0    ## t1 saves idx variable (int idx = start;)
    slli t2, s1, 2    ## t2 is relative addr of arr[i]( arr[i] = s0 + t2)
    slli s2, s2, 2    ## end * 4 (making it can be compared to t2)
    add t0, s0, s2    ## get addr of arr[end], t1 = relative addr of arr[end]
    lw t0, 0(t0)      ## t0 = pivot = arr[end];
    ##jalr ra, x1, 0
    
partition_loop:
    bge t2, s2, partition_end    ## i >= end , loop break
    ## addr of arr[i]
    lw s0, 0(sp)    ## s0 = addr of head element
    add t3, s0, t2    ## get arr[i]
    lw s0, 0(t3)    ## s0 = arr[i]
    ## addi s0, s1, 0
    addi s1, t0, 0    ## s1 = pivot
    jal ra, comparing    ## comparing pivot and arr[i]
    bltz s0, ready_to_swap    ## if return of comparing < 0, swaping
    addi t2, t2, 4
    j partition_loop

ready_to_swap:
    lw s0, 0(sp)    ## s0 = addr of head element
    slli s1, t1, 2    ## s1 = idx*4
    addi s2, t2, 0    ## s1 = i*4
    add s2, s0, s2    ## s2 = s0 + i*4
    add s0, s0, s1    ## s0 = s0 + idx*4
    addi s1, s2, 0    ## s1 = s2 = s0 + i*4
    jal ra, swap
    addi t1, t1, 1
    addi t2, t2, 4
    lw s2, 8(sp)
    slli s2, s2, 2    ## end * 4 (making it can be compared to t2)
    j partition_loop

partition_end:
    ##  swap(&arr[idx], &arr[end]);
    lw s0, 0(sp)
    slli s1, t1, 2    ## idx*4
    addi s2, t2, 0    ## i*4
    add s2, s0, s2    ## s2 = s0 + i*4
    add s0, s0, s1    ## s0 = s0 + idx*4
    addi s1, s2, 0    ## s1 = s2 = s0 + i*4
    ## lw s2, 8(sp)
    ## lw s0, 0(sp)
    ## slli s1, s2, 2
    ## add s1, s0, s1
    jal ra, swap
    addi s0, t1, 0 ## return idx
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    lw t0, 16(sp)
    lw t1, 20(sp)
    lw t2, 24(sp)
    lw t3, 28(sp) 
    addi sp, sp, 32
    jr ra
    
comparing:
    ## input s0, s1, return in s0
    addi sp, sp, -20
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)
    sw t3, 16(sp)
    
    addi t0, s0, 0    ## storing a
    addi t1, s1, 0    ## storing b
    jal ra, counting_one
    addi t2, s0, 0    ## counting_one(a)
    addi s0, s1, 0
    jal ra, counting_one
    ## t0 is a, s0 is counting_one(b), 
    ## t1 is b, t2 is counting_one(a)
    sub t3, t2, s0
    beqz t3, ret_comp_same_one
    addi s0, t3, 0
    j comparing_end
    
ret_comp_same_one:
    sub s0, t0, t1
    
comparing_end:
    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw t2, 12(sp)
    lw t3, 16(sp)
    addi sp, sp, 20
    jr ra

swap:
    ## 2 input parameter addr of a and addr of b(s0, s1)
    ## no return
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)
    
    lw t0, 0(s0)
    lw t1, 0(s1)
    sw t0, 0(s1)
    sw t1, 0(s0)
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8
    jr ra

counting_one:
    ## input in s0, return in s0
    addi sp, sp, -20
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw s0, 8(sp)
    sw t1, 12(sp)
    sw t2, 16(sp)
    addi t0, x0, 0    ## int num = 0;
    jal ra, bl_clz_ini
    li t1, 32
    sub t1, t1, s0    ## t1 is len (int len = 32-count_leading_zeros(val);)
    lw s0, 8(sp)    ## get original input val or s0 is count_leading_zeros(val)
    
counting_one_loop:
    bltz t1, counting_one_end    ## i < 0, loop breaking
    andi t2, s0, 1     ## t2 = val&1;
    add t0, t0, t2    ## num += t2;
    srli s0, s0, 1    ## val>>=1;
    addi t1, t1, -1   ## i--
    j counting_one_loop
    
counting_one_end:
    addi s0, t0, 0
    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 12(sp)
    lw t2, 16(sp)
    ## lw s0, 8(sp)
    addi sp, sp, 20
    jr ra
    
## brenchless CLZ part
bl_clz_ini:
    ## variable s0, t0, t1
    addi sp, sp, -16    # adding space of 5 words in stack (s0-s3 and ra) 
    sw ra, 0(sp)        # store register to stack
    sw s0, 4(sp)
    sw t0, 8(sp)
    sw t1, 12(sp)
    
bl_clz_calculating:
    srli t0, s0, 1
    or s0, t0, s0
    srli t0, s0, 2
    or s0, t0, s0
    srli t0, s0, 4
    or s0, t0, s0
    srli t0, s0, 8
    or s0, t0, s0
    srli t0, s0, 16
    or s0, t0, s0
    srli t0, s0, 1
    li t1, 0x55555555
    and t0, t0, t1
    sub s0, s0, t0
    srli t0, s0, 2
    li t1, 0x33333333
    and t0, t0, t1
    and s0, s0, t1
    add s0, s0, t0
    srli t0, s0, 4
    add s0, s0, t0
    li t1, 0x0f0f0f0f
    and s0, s0, t1
    srli t0, s0, 8
    add s0, t0, s0
    srli t0, s0, 16
    add s0, t0, s0
    andi s0, s0, 0x3f
    li t1, 32
    sub s0, t1, s0
    lw t0, 8(sp)
    lw t1, 12(sp)
    addi sp, sp, 16     # adding space of 5 words in stack (s0-s3 and ra) 
    jr ra
    
print_loop:
    bge t2, t1, end_loop    # checking whether index >= number of elements in array
    lw a0, 0(a2)            # print element in array
    li a7, 1    
    ecall
    
    ## print space
    li a0, 32
    li a7, 11               
    ecall
    
    # print correct ans
    lw a0, 0(t3)
    li a7, 1    
    ecall
    
    # check answer (t4 for tmp comparing variable)
    lw t4, 0(a2)
    bne t4, a0, fail       # if element != correct element, jump to fail part
    la a0, t_str           # if element == correct element, console log " True\n"
    li a7, 4               
    ecall
    addi a2, a2, 4        # addr = addr + 4 (addr of calculating result)
    addi t3, t3, 4        # addr = addr + 4 (addr of answer)
    addi t2, t2, 1        # index = index + 1
    j print_loop          # keeping print elements

end_loop:
    la a0, t_str         # console log " True\n"
    li a7, 4             # 
    ecall
    jr ra

fail:
    la a0, f_str          # load address of ' False\n' into a0
    li a7, 4              # print string
    ecall
    li a7, 10             # exit program
    ecall