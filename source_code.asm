include irvine32.inc

.data
row_m1 dword ?                 ; Number of rows in matrix 1
column_m1 dword ?              ; Number of columns in matrix 1
row_m2 dword ?                 ; Number of rows in matrix 2
column_m2 dword ?              ; Number of columns in matrix 2
rowsize_m1 dword ?             ; Row size in bytes for matrix 1
rowsize_m2 dword ?             ; Row size in bytes for matrix 2
rowindex dword 0               ; Row index for loops
columnindex dword 0            ; Column index for loops
count dword 0                  ; Counter for loops
sum sdword ?                   ; Sum for addition and multiplication
x sdword ?                     ; Temporary storage for subtraction
r2 dword 0                     ; Row index for matrix 2 in multiplication
c2 dword 0                     ; Column index for matrix 2 in multiplication
product sdword ?               ; Product for multiplication
mystr byte "Rowsize : ",0
mystr1 byte "Columnsize : ",0
mystr2 byte "Matrix 1 : ",0
mystr3 byte "Matrix 2 : ",0
mystr4 byte "Invalid number of rows or columns of matrix 1 or matrix 2.Cannot perform the operation. ",0
mystr5 byte "1.Addition ",0
mystr6 byte "2.Subtraction ",0
mystr7 byte "3.Multiplication ",0
mystr8 byte "4.Exit ",0
mystr9 byte "Enter your choice ",0
mystr10 byte "   ",0
mystr11 byte "Matrix1 + Matrix2 : ",0
mystr12 byte "Matrix1 - Matrix2 : ",0
mystr14 byte "Matrix1 * Matrix2 : ",0
mystr15 byte "  ",0

matrix1 sdword 200 dup(?)      ; Matrix 1 storage
matrix2 sdword 200 dup(?)      ; Matrix 2 storage
light_yellow_bg byte 1Bh, '[', '1', '0', '3', 'm', 0   ; ANSI escape code for light green background
black_text byte 1Bh, '[', '3', '0', 'm', 0     ; ANSI escape code for black text color
reset_color byte 1Bh, '[', '0', 'm', 0  
prompt1 byte "+------------------------------------------------+",0
prompt2 byte "|               MATRIX OPERATIONS                |",0
mystr13 byte "                                                                                                 ",0

.code
matrixAddition proc
    mov eax, row_m1
    mov count, eax            ; Set count to the number of rows in matrix 1
    mov rowindex, 0           ; Initialize row index
    mov columnindex, 0        ; Initialize column index

additionmatrix:
    mov esi, offset matrix1   ; Set ESI to the start of matrix 1
    mov edi, offset matrix2   ; Set EDI to the start of matrix 2
    mov sum, 0                ; Initialize sum to 0

l12:
    mov eax, rowsize_m1
    mov ebx, rowindex
    mul ebx                   ; Calculate offset to the current row
    add esi, eax              ; Add offset to ESI
    mov eax, 05
    mov eax, columnindex
    mov ebx, 4
    mul ebx                   ; Calculate offset to the current column
    mov ebx, eax
    mov eax, 0
    mov eax, [esi+ebx]        ; Load element from matrix 1
    mov sum, eax              ; Store element in sum

    mov eax, 0

    mov eax, rowsize_m2
    mov ebx, rowindex
    mul ebx                   ; Calculate offset to the current row in matrix 2
    add edi, eax              ; Add offset to EDI
    mov eax, 0
    mov eax, columnindex
    mov ebx, 4
    mul ebx                   ; Calculate offset to the current column in matrix 2
    mov ebx, eax
    mov eax, 0
    mov eax, [edi+ebx]        ; Load element from matrix 2
    mov ebx, sum
    add eax, ebx              ; Add element from matrix 1 and matrix 2
    call writeint             ; Print the result
    mov eax, 0

    mov eax, column_m1
    cmp columnindex, eax
    jb increment_col
    jae increment_row

increment_col:
    add columnindex, 1        ; Move to the next column
    mov sum, 0
    mov edx, offset mystr10
    call writestring
    jmp l12

increment_row:
    call crlf                 ; Print a newline
    add rowindex, 1           ; Move to the next row
    mov columnindex, 0
    sub count, 1
    cmp count, 0
    jbe exit_proc

    jmp additionmatrix

exit_proc:
    mov rowindex, 0           ; Reset row index
    mov columnindex, 0        ; Reset column index
    ret
matrixAddition endp

matrixSubtraction proc
    mov eax, row_m1
    mov count, eax            ; Set count to the number of rows in matrix 1
    mov rowindex, 0           ; Initialize row index
    mov columnindex, 0        ; Initialize column index

subtractionmatrix:
    mov esi, offset matrix1   ; Set ESI to the start of matrix 1
    mov edi, offset matrix2   ; Set EDI to the start of matrix 2
    mov x, 0                  ; Initialize x to 0

l13:
    mov eax, rowsize_m1
    mov ebx, rowindex
    mul ebx                   ; Calculate offset to the current row
    add esi, eax              ; Add offset to ESI
    mov eax, 0
    mov eax, columnindex
    mov ebx, 4
    mul ebx                   ; Calculate offset to the current column
    mov ebx, eax
    mov eax, 0
    mov eax, [esi+ebx]        ; Load element from matrix 1
    mov x, eax                ; Store element in x

    mov eax, 0

    mov eax, rowsize_m2
    mov ebx, rowindex
    mul ebx                   ; Calculate offset to the current row in matrix 2
    add edi, eax              ; Add offset to EDI
    mov eax, 0
    mov eax, columnindex
    mov ebx, 4
    mul ebx                   ; Calculate offset to the current column in matrix 2
    mov ebx, eax
    mov eax, 0
    mov eax, [edi+ebx]        ; Load element from matrix 2
    mov ebx, x
    sub ebx, eax              ; Subtract element of matrix 2 from matrix 1
    mov eax, ebx
    call writeint             ; Print the result
    mov eax, 0
    mov ebx, 0
    mov eax, column_m1
    cmp columnindex, eax
    jb increment_col1
    jae increment_row1

increment_col1:
    add columnindex, 1        ; Move to the next column
    mov x, 0
    mov edx, offset mystr10
    call writestring
    jmp l13

increment_row1:
    call crlf                 ; Print a newline
    add rowindex, 1           ; Move to the next row
    mov columnindex, 0
    sub count, 1
    cmp count, 0
    jbe exit_proc1
    jmp subtractionmatrix

exit_proc1:
    mov rowindex, 0           ; Reset row index
    mov columnindex, 0        ; Reset column index
    ret
matrixSubtraction endp

matrixMultiplication proc
    mov sum, 0                ; Initialize sum to 0
    mov rowindex, 0           ; Initialize row index
    mov columnindex, 0        ; Initialize column index
    mov r2, 0                 ; Initialize row index for matrix 2
    mov c2, 0                 ; Initialize column index for matrix 2

multiplicationmatrix:
    mov sum, 0                ; Initialize sum for each element in the result matrix

compute_element:
    mov esi, offset matrix1
    mov eax, rowsize_m1
    mov ebx, rowindex
    mul ebx                   ; Calculate offset to the current row in matrix 1
    add esi, eax              ; ESI points to the start of the current row in matrix 1
    mov eax, r2
    mov ebx, 4
    mul ebx                   ; Calculate offset to the current column in matrix 1
    add esi, eax              ; ESI points to matrix1[rowindex][r2]
    mov eax, [esi]            ; Load element from matrix 1
    mov product, eax

    mov edi, offset matrix2
    mov eax, rowsize_m2
    mov ebx, r2
    mul ebx                   ; Calculate offset to the current row in matrix 2
    add edi, eax              ; EDI points to the start of the current row in matrix 2
    mov eax, columnindex
    mov ebx, 4
    mul ebx                   ; Calculate offset to the current column in matrix 2
    add edi, eax              ; EDI points to matrix2[r2][columnindex]
    mov eax, [edi]            ; Load element from matrix 2
    imul eax, product         ; Multiply the elements
    add sum, eax              ; Add to sum

    mov eax, column_m1
    cmp r2, eax
    jl next_element           ; If not at the end of the row, continue to next element
    jmp output_element        ; If at the end, output the element

next_element:
    inc r2                    ; Move to the next element in the row
    jmp compute_element

output_element:
    mov eax, sum
    call writeint             ; Print the computed sum
    mov edx, offset mystr10
    call writestring

    mov r2, 0                 ; Reset r2 for the next computation

    mov eax, column_m2
    cmp columnindex, eax
    jl next_column            ; If not at the end of the column, continue to next column

    call crlf                 ; Print a newline
    inc rowindex              ; Move to the next row
    mov columnindex, 0
    mov eax, row_m1
    cmp rowindex, eax
    jl multiplicationmatrix   ; If not at the end of the rows, continue

    jmp end_multiplication

next_column:
    inc columnindex           ; Move to the next column
    jmp multiplicationmatrix

end_multiplication:
    ret
matrixMultiplication endp

main proc
    ; Set the whole screen yellow
    mov edx, offset light_yellow_bg
    call writestring
    mov edx, offset black_text
    call writestring

    ; Fill the screen with yellow background and spaces
    mov ecx, 2000               ; Arbitrary large number to cover the screen
    fill_screen:
        mov edx, offset mystr13 ; mystr13 is just a string of spaces
        call writestring
        loop fill_screen

    ; Clear the screen and apply the yellow background
    call clrscr
    mov edx, offset light_yellow_bg
    call writestring
    mov edx, offset black_text
    call writestring

    ; Display prompts with yellow background
    mov ecx,31
    display:
        mov edx,offset mystr13
        call writestring
        loop display
        mov edx,offset mystr10
        call writestring
        call writestring

        
    mov edx,offset prompt1
    call writestring
    call crlf
    mov ecx,15
    display3:
        mov edx,offset mystr10
        call writestring
       loop display3
mov edx,offset mystr15
        call writestring
        call writestring

    mov edx,offset prompt2
    call writestring
    call crlf

    mov ecx,15
    display4:
        mov edx,offset mystr10
        call writestring
        loop display4

mov edx,offset mystr15
        call writestring
        call writestring
    mov edx,offset prompt1
    call writestring
    call crlf

    mov ecx,10
    display5:
        mov edx,offset mystr13
        call writestring
        loop display5

    call readchar

    ; Clear the screen and apply the yellow background again
    call clrscr
    mov edx, offset light_yellow_bg
    call writestring
    mov edx, offset black_text
    call writestring

    mov edx,offset mystr
    call writestring
    call readint
    call crlf
    mov row_m1,eax
    mov edx,offset mystr1
    call writestring
    call readint
    mov column_m1,eax
    mov ebx,4
    mul ebx
    mov rowsize_m1,eax
    sub column_m1,1
    call crlf

    mov ecx,row_m1
    l1:
    mov esi,offset matrix1
    l2:
    mov eax,rowsize_m1
    mov ebx,rowindex
    mul ebx
    add esi,eax

    mov eax,columnindex
    mov ebx,4
    mul ebx
    mov ebx,eax

    call readint
    mov [esi+ebx],eax
    mov eax,column_m1
    cmp columnindex,eax
    jb l3
    jmp l4

    l3:
    add columnindex,1
    jmp l2

    l4:
    call crlf
    add rowindex,1
    mov columnindex,0

    loop l1


    mov edx,offset mystr2
    call writestring
    call crlf
    mov rowindex,0
    mov columnindex,0
    mov ecx,row_m1

    display_matrix1:
    mov esi,offset matrix1

    l10:
    mov eax,rowsize_m1
    mov ebx,rowindex
    mul ebx
    add esi,eax
    mov eax,columnindex
    mov ebx,4
    mul ebx
    mov ebx,eax
    mov eax,[esi+ebx]
    call writeint
    mov eax,column_m1
    cmp columnindex,eax

    jb increment_cindex
    jmp increment_rindex

    increment_cindex:
    add columnindex,1
    mov edx,offset mystr10
    call writestring
    jmp l10

    increment_rindex:
    call crlf
    add rowindex,1
    mov columnindex,0

    loop display_matrix1

    mov edx,offset mystr
    call writestring
    call readint
    call crlf
    mov row_m2,eax
    mov edx,offset mystr1
    call writestring
    call readint
    mov column_m2,eax
    mov ebx,4
    mul ebx
    mov rowsize_m2,eax
    sub column_m2,1
    call crlf
    mov rowindex,0
    mov columnindex,0
    mov ecx,row_m2

    l5:
    mov edi,offset matrix2
    l6:
    mov eax,rowsize_m2
    mov ebx,rowindex
    mul ebx
    add edi,eax

    mov eax,columnindex
    mov ebx,4
    mul ebx
    mov ebx,eax
    call readint
    mov [edi + ebx],eax
    mov eax,column_m2
    cmp columnindex,eax
    jb l7
    jmp l8

    l7:
    add columnindex,1
    jmp l6

    l8:
    call crlf
    add rowindex,1
    mov columnindex,0

    loop l5

    mov edx,offset mystr3
    call writestring
    call crlf
    mov rowindex,0
    mov columnindex,0
    mov ecx,row_m2

    display_matrix2:
    mov esi,offset matrix2

    l11:
    mov eax,rowsize_m2
    mov ebx,rowindex
    mul ebx
    add esi,eax
    mov eax,columnindex
    mov ebx,4
    mul ebx
    mov ebx,eax
    mov eax,[esi+ebx]
    call writeint
    mov eax,column_m2
    cmp columnindex,eax

    jb increment_cindex_m2
    jmp increment_rindex_m2

    increment_cindex_m2:
    add columnindex,1
    mov edx,offset mystr10
    call writestring
    jmp l11

    increment_rindex_m2:
    call crlf
    add rowindex,1
    mov columnindex,0

    loop display_matrix2

    mov edx,offset mystr5
    call writestring
    call crlf
    mov edx,offset mystr6
    call writestring
    call crlf
    mov edx,offset mystr7
    call writestring
    call crlf
    mov edx,offset mystr8
    call writestring
    call crlf
    mov edx,offset mystr9
    call writestring
    call readint
    cmp eax,1
    je addition
    cmp eax,2
    je subtraction
    cmp eax,3
    je multiplication
    cmp eax,4
    je exit_main

    addition:
    mov eax,row_m1
    cmp eax,row_m2
    je checkforcolumn
    jmp invalid_size
    checkforcolumn:
    mov eax,column_m1
    cmp eax,column_m2
    je valid_size
    jmp invalid_size
    valid_size:
    mov edx,offset mystr11
    call writestring
    call crlf

    call matrixAddition
    jmp exit_main

    subtraction:
    mov eax,row_m1
    cmp eax,row_m2
    je checkforcolumn1
    jmp invalid_size
    checkforcolumn1:
    mov eax,column_m1
    cmp eax,column_m2
    je valid_size1
    jmp invalid_size
    valid_size1:
    mov edx,offset mystr12
    call writestring
    call crlf
    call matrixSubtraction
    jmp exit_main

    multiplication:
    add column_m1,1
    mov eax,row_m2
    cmp column_m1,eax
    je valid_for_multiplication
    jmp invalid_size
    valid_for_multiplication:
    mov edx,offset mystr14
    call writestring
    call crlf
    call matrixMultiplication
    jmp exit_main

    invalid_size:
    mov edx,offset mystr4
    call writestring

    exit_main:

    exit
main endp
end main