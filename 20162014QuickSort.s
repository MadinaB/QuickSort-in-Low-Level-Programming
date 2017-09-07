	.data
data:	.word 8,5,14,10,12,3,9,6,1,15,7,4,13,2,11
size:	.word 15
string1:		.asciiz	"\n   Quicksort in MIPS \n"
string2:		.asciiz	"Data before sorting: "
string3:		.asciiz	"Data after sorting: "
string4:		.asciiz	"\n"
string5:		.asciiz	" "
#input_end

               .text               
main:
li	$v0, 4	       # Quicksort in MIPS
la	$a0, string1   # Quicksort in MIPS
syscall	
li	$v0, 4	       # before qs
la	$a0, string2 
syscall	
	la 	$a0, data      # show us data before qs			
	lw 	$a1, size
        jal        debug
        

        la 	$a0, data				
	addi 	$a1, $zero, 0
	lw 	$a2, size				
	addi	$a2, $a2, -1   #end is 1 smaller than size
        jal       quick_sort    
li	$v0, 4	       # after qs
la	$a0, string3 
syscall	                                 
                                                                  
        la 	$a0, data      # show us data after qs				
	lw 	$a1, size                   
        jal        debug              
quick_sort:
    slt  $t0, $a1, $a2         #a1:start, a2:end
    beq  $t0, $zero, quicksort_end  #if(start >= end){exit quick_sort}
    # if(start < end){....   
    #  --->  partition(data, start, end)
    subu $sp, $sp, 16
    sw        $ra, 16($sp) # return address
    sw        $a0, 12($sp) # data
    sw        $a1, 8($sp)  # start
    sw        $a2, 4($sp)  # end 
    jal        partition  
    #  --->  partition(data, start, end)
    #  --->  quick_sort(data, start, pivot_position)
    subu $sp, $sp, 4
    sw        $v0, 4($sp)               # save return value of partition
    lw        $a0, 16($sp)              # data
    lw        $a1, 12($sp)              # start
    ori       $a2, $v0, 0               # pivot
    jal        quick_sort               # call Quicksort(data, start, pivot)
    #  --->  quick_sort(data, start, pivot_position)
    #  --->  quick_sort(data, pivot_position+1, end);
    lw        $a0, 16($sp)              # data
    lw        $t0, 4($sp)              
    addi        $a1, $t0, 1             # pivot+1
    lw        $a2, 8($sp)               # end
     jal        quick_sort              # Quicksort(A[], q+1, r)
    ori        $t0, $t0, 0              # nop

    addu        $sp, $sp, 20            # pop data, start, end, pivot, ra
    lw        $ra, 0($sp)  
    #  --->  quick_sort(data, pivot_position+1, end);
    
quicksort_end:
    jr 	$ra
partition:
               sll	 $t0, $a1,2      # t0 = a1 * 4                                             t0=a1 * 4    

               add       $t0, $t0, $a0   # t0 = data + t0
               lw        $t0, 0($t0)     # t0 = data[start]        : x

               addi      $t1, $a1, -1    # i = start-1                                             t1=i
               addi      $t2, $a2, 1     # j = end+1                                               t2=j
               
               sll	 $t3, $t1,2
               add       $t3, $t3, $a0   # t3 = address of data[i] to minimize the loop            t3= index i
               
               sll	 $t4, $t2,2
               add       $t4, $t4, $a0   # t4 = address of data[j]                                 t4= index j

Loop1:         addi      $t1, $t1, 1     # i = i+1                                                 
               addi      $t3, $t3, 4     # t3 = t3 + 4 : increase address index of data[i]
               lw        $t5, 0($t3)     # data[i]                                                 t5=data[i]
               slt       $t6, $t5, $t0   # data[i]< data[start]:x -> t6=1
               bne       $t6, $zero, Loop1                # if data[i] < x, branch to Loop2


Loop2:         addi      $t2, $t2, -1     # j = j-1
               addi      $t4, $t4, -4     # t4 = t4 - 4 : decrease address index of data[j]
               lw        $t5, 0($t4)      # data[j]                                                 t5=data[j]
               slt        $t6, $t0, $t5
               bne        $t6, $zero, Loop2                # if data[j] > x, branch to Loop1

               slt        $t5, $t1, $t2   # when i>=j we exit partition
               beq        $t5, $zero, partition_end        # if i >= j, branch to Partition_end

               lw        $t5, 0($t3)      # t5=data[i]
               lw        $t6, 0($t4)      # t6=data[j]
               sw        $t6, 0($t3)      # data[i]=t6
               sw        $t5, 0($t4)      # data[j]=t5                # swaping; temp=data[right];data[right]=data[left];data[left]=temp
               beq       $zero, $zero, Loop1

partition_end: addu      $v0, $zero, $t2                  # v0 = j; j=pivot
               jr        $ra                                # return 


debug:
               beq    $a1, $zero, debug_end           #  size == 0
               move        $s0, $a0                   # move data to s0
               move        $s1, $a1                   # move size to s1
               addi        $t0, $zero, 0              # t0 = 0

Loop3:         add       $t1, $s0, $t0                # t1 = base + t0
               lw        $a0, 0($t1)                  # load data to a0
               li        $v0,  1                      # v0 = 1
               syscall                                # print int
li	$v0, 4	       # space
la	$a0, string5   # space
syscall	
               
               addi        $s1, $s1, -1               # decreasing size
               addi        $t0, $t0, 4                # increasing index
               bne        $s1, $zero, Loop3           # looping

debug_end:    
li	$v0, 4	       
la	$a0, string4   
syscall	  #try to print here new lineeee                                        
               jr        $ra                                # return


