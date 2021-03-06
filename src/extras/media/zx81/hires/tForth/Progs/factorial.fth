CR .( LARGE FACTORIAL )

: TASK ;

: [COMPILE]  ( -- )             ( compile immediate words )
   ' , ; IMMEDIATE
: DEFINER ( -- )                ( the JUPITER ACE's DEFINER word )
   [COMPILE] : COMPILE CREATE ;
HEX
\ Set the SLOW mode
CODE SLOW  ( -- )
  D9 C,          \ exx
  CD C, F2B ,    \ call $f2b  ;SLOW
  D9 C,          \ exx
  NEXT           \ jp NEXT

\ Set the FAST mode
CODE FAST  ( -- )
  CD C, F23 ,    \ call $f23  ;FAST
  NEXT           \ jp NEXT
DECIMAL

: SPACES  ( n -- )
   ?DUP IF 0 DO SPACE LOOP THEN ;
: MOD /MOD DROP ;

\ : +! ( n adr -- )
\ DUP @ ROT + SWAP ! ;

: U.R ( u n -- )
 SWAP 0 <# #S #>
 ROT OVER -
 SPACES TYPE ;

DEFINER BYTE-ARRAY ( n -- )
 ALLOT
DOES> + ;                ( n -- adr )

4000 CONSTANT MAX-DIGITS
MAX-DIGITS BYTE-ARRAY F-BUFF
0 VARIABLE LAST ( Last buff element )

: *BUFF ( Multiplier )
 0                  ( Carry )
 LAST @ 1+ 0
 DO
  OVER I F-BUFF C@
  * + 10 /MOD
  SWAP I F-BUFF C!
 LOOP
 BEGIN ( Extend buffer to accept final carry )
  ?DUP
 WHILE
  10 /MOD SWAP
  1 LAST +!
  LAST @ DUP 1+
  MAX-DIGITS >
   IF
    ." Out of buffer" QUIT
   THEN
  F-BUFF C!
 REPEAT
 DROP ;

: SETUP
 1 0 F-BUFF C! ( Start buff=1 )
 0 LAST ! ;

: .FAC
 LAST @ 1+ 0
 DO
  LAST @ I -
  DUP 1+ 3 MOD
  0= I 0= 0= AND
  IF
   ASCII , EMIT
  THEN
  F-BUFF C@ 1 U.R
 LOOP SLOW ;

: FAC
 SETUP 1+ 1
 DO
  I *BUFF
 LOOP ;

: FACS
 SETUP 1+ 1 CR
 DO
  I *BUFF ." FACTORIAL"
  I 3 U.R
  ."  = " .FAC CR
 LOOP ;

CR .( 20 FACS)
20 FACS

CR .( 100 FAC .FAC) 
100 FAC .FAC
( 00:01:07 in SLOW mode )
( 00:00:42 in FAST mode )
 