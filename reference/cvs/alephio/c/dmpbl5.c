#if defined(ALEPH_DEC) && defined(MACRO)
;-----------------------------------------------------------------------
;       SUBROUTINE DMPBL5(A,B,NROW,NBITS,NCOL)
;C!     Decompress array A and store into array B
;CKEY PRESS DMPBL5 DECOMPRESS /INTERNAL
;
;       AUTHOR :    D.Harvatis    MAY 1989
;
;       INPUT :     A : Integer array that contains a compressed column.
;                NROW : Number of compressed values contained in the A
;                       array. Normaly it is the number of rows in the
;                       original BOS bank.
;                   L : number of bits for each number in the compressed
;                       array.
;                  NC : number of columns of the original BOS bank.
;
;       OUTPUT:     B : Integer array. Decompressed values are stored
;                       into this array by row (as in BOS arrays).
;                       That means that the first value extracted from
;                       the A array is stored in B(1), the second in
;                       B(NC+1), the Nth in B((N-1)*NC+1).
;
; Registers used :
;
;       R0  ->  NROW
;       R1  ->  NCOL
;       R2  ->  IB
;       R3  ->  A       (address of 1st array)
;       R4  ->  B       (address of 2nd array)
;       R5  ->  I       (bit possition) [0..31]
;       R6  ->  A(IA+1)
;       R7  ->  A(IA)
;       R8  ->  L       (field size)    [1..31]
;       R9  ->  M       (extracted integer)      [in DMPBL3 AND 4]
;       R10 ->  ILOW                             [in DMPBL3 AND 4]
;       R11 ->  FACT                             [in DMPBL4]
;
;-----------------------------------------------------------------------
#ifndef DOC
        .TITLE  DMPBL5
        .IDENT  /1.0/
        .PSECT  BLOW5
S16:    ASHL    #-1, R0, R5             ; R5=R0/2
        BEQL    LL16
L16:    MOVL    (R3)+, R7               ; R7=A(IA)
        EXTZV   #16, R8, R7, (R4)[R2]   ; extract upper bit field
        ADDL2   R1, R2                  ; increase R2 by NCOL
        MOVZWL  R7, (R4)[R2]            ; extract lower bit field
        ADDL2   R1, R2
        SOBGTR  R5, L16                 ; decrease R5, if R5>0 continue
LL16:   BICL2   #-2, R0                 ; R0=R0.AND.1
        BEQL    RTS                     ; if R0=0 return
        MOVL    (R3)+, R7
        EXTZV   #16, R8, R7, (R4)[R2]   ; extract last bit field
        RET
;
S8:     ASHL    #-2, R0, R5             ; R5=R0/4
        BEQL    LL8                     ; if R5=0 go to LL8
L8:     MOVL    (R3)+, R7               ; R7=A(IA)
        EXTZV   #24, R8, R7, (R4)[R2]   ; extract upper bit field
        ADDL2   R1, R2                  ; increase R2 by NCOL
        EXTZV   #16, R8, R7, (R4)[R2]
        ADDL2   R1, R2
        EXTZV   #8, R8, R7, (R4)[R2]
        ADDL2   R1, R2                  ; increase R2 by NCOL
        MOVZBL  R7, (R4)[R2]            ; extract lower bit field
        ADDL2   R1, R2
        SOBGTR  R5, L8                  ; decrease R5, if R5>0 continue
LL8:    BICL2   #-4, R0                 ; R0=R0.AND.3
        BEQL    RTS                     ; if R0=0 return
        MOVL    (R3)+, R7               ; R7=A(IA)
        EXTZV   #24, R8, R7, (R4)[R2]   ; extract upper bit field
        ADDL2   R1, R2                  ; increase R2 by NCOL
        DECL    R0                      ; decrease R0
        BEQL    RTS                     ; if R0=0 return
        EXTZV   #16, R8, R7, (R4)[R2]
        ADDL2   R1, R2
        DECL    R0                      ; decrease R0
        BEQL    RTS                     ; if R0=0 return
        EXTZV   #8, R8, R7, (R4)[R2]    ; extract last bit field
RTS:    RET
;
        .ENTRY  DMPBL5,^M<IV,R2,R3,R4,R5,R6,R7,R8>
        MOVL    B^4(AP), R3             ; R3 contains address of A array
        MOVL    B^8(AP), R4             ; R4 contains address of B array
        MOVL    @B^12(AP), R0           ; store NROW in R0
        MOVL    @B^16(AP), R8           ; store L in R8
        MOVL    @B^20(AP), R1           ; store NCOL in R1
        CLRL    R2                      ; R2 is IB
        CMPB    R8, #16
        BNEQ    C1
        BRW     S16                     ; if L=16 go to S16
C1:     CMPB    R8, #8
        BNEQ    C18
        BRW     S8                      ; if L=8 go to S8
C18:    CMPB    R8, #4
        BEQL    S4                      ; if L=4 go to S4
        MOVZBL  #32, R5                 ; R5=I=32
        MOVL    (R3)+, R7               ; R7=A(1)
        MOVL    (R3)+, R6               ; R6=A(2)
LOOP:   SUBB2   R8, R5                  ; R5=I=I-L
        BLSS    L101                    ; if L>I goto L101
        EXTZV   R5, R8, R7, (R4)[R2]    ; extract bit field
        ADDL2   R1, R2                  ; increase R2 by NCOL
        SOBGTR  R0, LOOP                ; decrease R0, if R0>0 continue
        RET
L101:   BICB2   #224, R5                ; R5=I=I.AND.31
        EXTZV   R5, R8, R6, (R4)[R2]
        MOVL    R6, R7
        MOVL    (R3)+, R6
        ADDL2   R1, R2                  ; increase R2 by NCOL
        SOBGTR  R0, LOOP                ; decrease R0, if R0>0 continue
        RET
;
S4:     ASHL    #-3, R0, R5             ; R5=R0/8
        BEQL    LL4
L4:     MOVL    (R3)+, R7               ; R7=A(IA)
        EXTZV   #28, R8, R7, (R4)[R2]   ; extract upper bit field
        ADDL2   R1, R2                  ; increase R2 by NCOL
        EXTZV   #24, R8, R7, (R4)[R2]
        ADDL2   R1, R2
        EXTZV   #20, R8, R7, (R4)[R2]
        ADDL2   R1, R2
        EXTZV   #16, R8, R7, (R4)[R2]
        ADDL2   R1, R2
        EXTZV   #12, R8, R7, (R4)[R2]
        ADDL2   R1, R2
        EXTZV   #8, R8, R7, (R4)[R2]
        ADDL2   R1, R2
        EXTZV   #4, R8, R7, (R4)[R2]
        ADDL2   R1, R2                  ; increase R2 by NCOL
        EXTZV   #0, R8, R7, (R4)[R2]    ; extract lower bit field
        ADDL2   R1, R2
        SOBGTR  R5, L4                  ; decrease R5, if R5>0 continue
LL4:    BICL2   #-8, R0                 ; R0=R0.AND.7
        BEQL    RTS4
        MOVL    (R3)+, R7               ; R7=A(IA)
        EXTZV   #28, R8, R7, (R4)[R2]
        ADDL2   R1, R2
        DECL    R0
        BEQL    RTS4
        EXTZV   #24, R8, R7, (R4)[R2]
        ADDL2   R1, R2
        DECL    R0
        BEQL    RTS4
        EXTZV   #20, R8, R7, (R4)[R2]
        ADDL2   R1, R2
        DECL    R0
        BEQL    RTS4
        EXTZV   #16, R8, R7, (R4)[R2]
        ADDL2   R1, R2
        DECL    R0
        BEQL    RTS4
        EXTZV   #12, R8, R7, (R4)[R2]
        ADDL2   R1, R2
        DECL    R0
        BEQL    RTS4
        EXTZV   #8, R8, R7, (R4)[R2]
        ADDL2   R1, R2                  ; increase R2 by NCOL
        DECL    R0
        BEQL    RTS4
        EXTZV   #4, R8, R7, (R4)[R2]    ; extract lower bit field
RTS4:   RET
#endif
#endif
#if defined(ALEPH_C)

/* DMPBL5(A,B,NROW,NBITS,NCOL) */

#include "cfromf.h"

#define WORDLENGTH 32

FORT_CALL(dmpbl5) (a,b,nr,l,nc)

int a[];
int b[];
int *nr;
int *l;
int *nc;

{

   int nrow;   /* r0 */
   int ib;     /* r2 */
   int i;      /* r5 - bit position [0..31] */
   int r6;     /* r6 */
   int r7;     /* r7 */
   int m;      /* r9 - extracted integer */
   int ilow;   /* r10 */
   int fact;   /* r11 */
   int aindex;
   int j;

       ib = 0;
       aindex = 0;
       nrow = *nr;

       if (*l == 16) goto s16;
       if (*l == 8) goto s8;
       if (*l == 4) goto s4;

       r7 = a[aindex++];
       r6 = a[aindex++];
       i = WORDLENGTH;

loop:  j = i;
       i = i - *l;
       if (i < 0) goto l101;
       extzv(i,*l,r7,&b[ib]);
       ib = ib + *nc;
       nrow--;
       if (nrow > 0) goto loop;
       return;

l101:  i = i & (WORDLENGTH - 1);
       extzv(i,*l,r6,&b[ib]);
       b[ib] = b[ib] | ((r7 & ((1 << j) - 1)) << (WORDLENGTH - i));
       r7 = r6;
       r6 = a[aindex++];
       ib = ib + *nc;
       nrow--;
       if (nrow > 0) goto loop;
       return;

s16:   i = nrow >> 1;
       if (i == 0) goto ll16;
l16:   r7 = a[aindex++];
       extzv(16,*l,r7,&b[ib]);
       ib = ib + *nc;
       b[ib] = r7 & 65535;
       ib = ib + *nc;
       i--;
       if (i > 0) goto l16;
ll16:  nrow = nrow & 1;
       if (nrow == 0) return;
       r7 = a[aindex++];
       extzv(16,*l,r7,&b[ib]);
       return;

s8:    i = nrow >> 2;
       if (i == 0) goto ll8;
l8:    r7 = a[aindex++];
       extzv(24,*l,r7,&b[ib]);
       ib = ib + *nc;
       extzv(16,*l,r7,&b[ib]);
       ib = ib + *nc;
       extzv(8,*l,r7,&b[ib]);
       ib = ib + *nc;
       b[ib] = r7 & 255;
       ib = ib + *nc;
       i--;
       if (i > 0) goto l8;
ll8:   nrow = nrow & 3;
       if (nrow == 0) return;
       r7 = a[aindex++];
       extzv(24,*l,r7,&b[ib]);
       ib = ib + *nc;
       nrow--;
       if (nrow == 0) return;
       extzv(16,*l,r7,&b[ib]);
       ib = ib + *nc;
       nrow--;
       if (nrow == 0) return;
       extzv(8,*l,r7,&b[ib]);
       return;

s4:    i = nrow >> 3;
       if (nrow == 0) goto ll4;
l4:    r7 = a[aindex++];
       extzv(28,*l,r7,&b[ib]);
       ib = ib + *nc;
       extzv(24,*l,r7,&b[ib]);
       ib = ib + *nc;
       extzv(20,*l,r7,&b[ib]);
       ib = ib + *nc;
       extzv(16,*l,r7,&b[ib]);
       ib = ib + *nc;
       extzv(12,*l,r7,&b[ib]);
       ib = ib + *nc;
       extzv(8,*l,r7,&b[ib]);
       ib = ib + *nc;
       extzv(4,*l,r7,&b[ib]);
       ib = ib + *nc;
       extzv(0,*l,r7,&b[ib]);
       ib = ib + *nc;
       i--;
       if (i > 0) goto l4;
ll4:   nrow = nrow & 7;
       if (nrow == 0) return;
       r7 = a[aindex++];
       extzv(28,*l,r7,&b[ib]);
       ib = ib + *nc;
       nrow--;
       if (nrow == 0) return;
       extzv(24,*l,r7,&b[ib]);
       ib = ib + *nc;
       nrow--;
       if (nrow == 0) return;
       extzv(20,*l,r7,&b[ib]);
       ib = ib + *nc;
       nrow--;
       if (nrow == 0) return;
       extzv(16,*l,r7,&b[ib]);
       ib = ib + *nc;
       nrow--;
       if (nrow == 0) return;
       extzv(12,*l,r7,&b[ib]);
       ib = ib + *nc;
       nrow--;
       if (nrow == 0) return;
       extzv(8,*l,r7,&b[ib]);
       ib = ib + *nc;
       nrow--;
       if (nrow == 0) return;
       extzv(4,*l,r7,&b[ib]);
       return;

}
#endif