.MODEL SMALL          ; Define the memory model as small
STACK SEGMENT
    DW 128 DUP(?)     ; Define stack segment with 128 words
ENDS
DATA SEGMENT
    NEW_LINE DB 13,10,"$"              ; New line characters
    GAME_BOARD DB "_|_|_",13,10        ; Game board row 1
               DB "_|_|_",13,10        ; Game board row 2
               DB "_|_|_",13,10,"$"    ; Game board row 3
    GAME_POINTER DB 9 DUP (?)          ; Pointers to game board positions
    
    WIN_FLAG DB 0                      ; Win flag
    DRAW_FLAG DB 0                     ; Draw flag
    PLAYER DB "0 $"                    ; Current player
    GAMEOVER_MSG DB "GAME OVER",13,10,"$"  ; Game over message
    GAMESTART_MSG DB "TIC TAC TOE",13,10,"$"  ; Game start message
    PLAYER_MSG DB "PLAYER $"           ; Player message
    WIN_MSG DB "WINS $"                ; Win message
    DRAW_MSG DB "DRAW $"               ; Draw message
    TYPE_MSG DB "TYPE A POSITION: $"   ; Prompt for position input
ENDS
CODE SEGMENT

START:
.STARTUP

; Initialize game pointer
CALL SET_GAME_POINTER

;----------------------MAIN LOOP BEGINS----------------------

MAIN_LOOP:
CALL CLEAR_SCREEN    ; Clear screen

LEA DX,GAMESTART_MSG ; Load game start message
CALL PRINT           ; Print message

LEA DX,NEW_LINE      ; Load new line characters
CALL PRINT           ; Print new line

LEA DX,PLAYER_MSG    ; Load player message
CALL PRINT           ; Print player message
LEA DX,PLAYER        ; Load current player
CALL PRINT           ; Print current player

LEA DX,NEW_LINE      ; Load new line characters
CALL PRINT           ; Print new line

;---------------------- DISPLAYING BOARD ---------------

LEA DX,GAME_BOARD    ; Load game board
CALL PRINT           ; Print game board

LEA DX,NEW_LINE      ; Load new line characters
CALL PRINT           ; Print new line

LEA DX,TYPE_MSG      ; Load prompt for position input
CALL PRINT           ; Print prompt

; READ DRAW POSITION

CALL READ_KEYBOARD   ; Read keyboard input

; CALCULATE DRAW POSITION

SUB AL,49            ; Convert ASCII to integer (1-based index to 0-based index)
MOV BH,0             ; Clear BH register
MOV BL,AL            ; Move input to BL register

CALL UPDATE_DRAW     ; Update the game board with player's move

CALL CHECK           ; Check for win

; CHECK IF GAME ENDS

CMP WIN_FLAG,1       ; Check if win flag is set
JE GAMEOVER          ; If set, jump to GAMEOVER

CALL CHECK_DRAW      ; Check for draw

CMP DRAW_FLAG,1      ; Check if draw flag is set
JE DRAW              ; If set, jump to DRAW

CALL CHANGE_PLAYER   ; Change player
JMP MAIN_LOOP        ; Repeat main loop

;----------------------Main Loop Ends--------------------- 

;----------------------PLAYER TURN FUNCTION BEGINS---------------

CHANGE_PLAYER:
LEA SI,PLAYER        ; Load current player
XOR DS:[SI],1        ; Toggle player (0 to 1 or 1 to 0)
RET

UPDATE_DRAW:
MOV BL,GAME_POINTER[BX] ; Load game board position address
MOV BH,0                ; Clear BH register

LEA SI,PLAYER           ; Load current player

CMP DS:[SI],"0"         ; Check if player 0
JE DRAW_X

CMP DS:[SI],"1"         ; Check if player 1
JE DRAW_O

DRAW_X:
MOV CL,"X"              ; Set mark as X
JMP UPDATE

DRAW_O:
MOV CL,"O"              ; Set mark as O
JMP UPDATE

UPDATE:
MOV DS:[BX],CL          ; Update game board with player's mark
RET

;----------------------- PLAYER TURN FUNCTION ENDS ----------------

;----------------------  BOARD EVALUATION ----------------
CHECK:
CALL CHECK_LINE     ; Check rows for win
RET

CHECK_LINE:
MOV CX,0

CHECK_LINE_LOOP:
CMP CX,0            ; Check first row
JE FIRST_LINE

CMP CX,1            ; Check second row
JE SECOND_LINE

CMP CX,2            ; Check third row
JE THIRD_LINE

CALL CHECK_COLUMN   ; If no win in rows, check columns
RET

FIRST_LINE:
MOV SI,0            ; Set starting index for first row
JMP DO_CHECK_LINE

SECOND_LINE:
MOV SI,3            ; Set starting index for second row
JMP DO_CHECK_LINE

THIRD_LINE:
MOV SI,6            ; Set starting index for third row
JMP DO_CHECK_LINE

DO_CHECK_LINE:
INC CX

MOV BH,0
MOV BL,GAME_POINTER[SI] ; Load game board position
MOV AL,DS:[BX]          ; Get mark at position
CMP AL,"_"              ; Check if position is empty
JE CHECK_LINE_LOOP      ; If empty, continue checking

INC SI
MOV BL,GAME_POINTER[SI]
CMP AL,DS:[BX]
JNE CHECK_LINE_LOOP     ; If marks don't match, continue checking

INC SI
MOV BL,GAME_POINTER[SI]
CMP AL,DS:[BX]
JNE CHECK_LINE_LOOP     ; If marks don't match, continue checking

MOV WIN_FLAG,1          ; Set win flag
RET

CHECK_COLUMN:
MOV CX,0
CHECK_COLUMN_LOOP:
CMP CX,0            ; Check first column
JE FIRST_COLUMN

CMP CX,1            ; Check second column
JE SECOND_COLUMN

CMP CX,2            ; Check third column
JE THIRD_COLUMN

CALL CHECK_DIAGONAL ; If no win in columns, check diagonals
RET

FIRST_COLUMN:
MOV SI,0            ; Set starting index for first column
JMP DO_CHECK_COLUMN

SECOND_COLUMN:
MOV SI,1            ; Set starting index for second column
JMP DO_CHECK_COLUMN

THIRD_COLUMN:
MOV SI,2            ; Set starting index for third column
JMP DO_CHECK_COLUMN

DO_CHECK_COLUMN:
INC CX
MOV BH,0
MOV BL,GAME_POINTER[SI] ; Load game board position
MOV AL,DS:[BX]          ; Get mark at position
CMP AL,"_"              ; Check if position is empty
JE CHECK_COLUMN_LOOP    ; If empty, continue checking

ADD SI,3
MOV BL,GAME_POINTER[SI]
CMP AL,DS:[BX]
JNE CHECK_COLUMN_LOOP   ; If marks don't match, continue checking

ADD SI,3
MOV BL,GAME_POINTER[SI]
CMP AL,DS:[BX]
JNE CHECK_COLUMN_LOOP   ; If marks don't match, continue checking

MOV WIN_FLAG,1          ; Set win flag
RET

CHECK_DIAGONAL:
MOV CX,0
CHECK_DIAGONAL_LOOP:
CMP CX,0            ; Check first diagonal
JE FIRST_DIAGONAL

CMP CX,1            ; Check second diagonal
JE SECOND_DIAGONAL

RET

FIRST_DIAGONAL:
MOV SI,0            ; Set starting index for first diagonal
MOV DX,4            ; Set step size for first diagonal
JMP DO_CHECK_DIAGONAL

SECOND_DIAGONAL:
MOV SI,2            ; Set starting index for second diagonal
MOV DX,2            ; Set step size for second diagonal
JMP DO_CHECK_DIAGONAL

DO_CHECK_DIAGONAL:
INC CX
MOV BH,0
MOV BL,GAME_POINTER[SI] ; Load game board position
MOV AL,DS:[BX]          ; Get mark at position
CMP AL,"_"              ; Check if position is empty
JE  CHECK_DIAGONAL_LOOP ; If empty, continue checking

ADD SI,DX
MOV BL,GAME_POINTER[SI]
CMP AL,DS:[BX]
JNE CHECK_DIAGONAL_LOOP ; If marks don't match, continue checking

ADD SI,DX
MOV BL,GAME_POINTER[SI]
CMP AL,DS:[BX]
JNE CHECK_DIAGONAL_LOOP ; If marks don't match, continue checking

MOV WIN_FLAG,1          ; Set win flag
RET

;------------------------ DRAW CHECK FUNCTION ----------------

CHECK_DRAW:
LEA SI,GAME_BOARD    ; Load game board
MOV CX,9             ; Set loop counter to 9

CHECK_DRAW_LOOP:
MOV AL,DS:[SI]       ; Get mark at position
CMP AL,"_"           ; Check if position is empty
JE DRAW_NOT_FOUND    ; If empty, jump to DRAW_NOT_FOUND
ADD SI,2             ; Move to next position
LOOP CHECK_DRAW_LOOP ; Loop for 9 positions

MOV DRAW_FLAG,1      ; Set draw flag
RET

DRAW_NOT_FOUND:
RET

;------------------------ GAME OVER SCREEN DISPLAY FUNCTION ----------------

GAMEOVER:
CALL CLEAR_SCREEN    ; Clear screen

LEA DX,GAMESTART_MSG ; Load game start message
CALL PRINT           ; Print message

LEA DX,NEW_LINE      ; Load new line characters
CALL PRINT           ; Print new line

LEA DX,GAME_BOARD    ; Load game board
CALL PRINT           ; Print game board

LEA DX,NEW_LINE      ; Load new line characters
CALL PRINT           ; Print new line

LEA DX,GAMEOVER_MSG  ; Load game over message
CALL PRINT           ; Print game over message

LEA DX,PLAYER_MSG    ; Load player message
CALL PRINT           ; Print player message

LEA DX,PLAYER        ; Load current player
CALL PRINT           ; Print current player

LEA DX,WIN_MSG       ; Load win message
CALL PRINT           ; Print win message

JMP FIM

;------------------------ DRAW SCREEN DISPLAY FUNCTION ----------------

DRAW:
CALL CLEAR_SCREEN    ; Clear screen

LEA DX,GAMESTART_MSG ; Load game start message
CALL PRINT           ; Print message

LEA DX,NEW_LINE      ; Load new line characters
CALL PRINT           ; Print new line

LEA DX,GAME_BOARD    ; Load game board
CALL PRINT           ; Print game board

LEA DX,NEW_LINE      ; Load new line characters
CALL PRINT           ; Print new line

LEA DX,GAMEOVER_MSG  ; Load game over message
CALL PRINT           ; Print game over message

LEA DX,DRAW_MSG      ; Load draw message
CALL PRINT           ; Print draw message

JMP FIM              ; Jump to end loop

SET_GAME_POINTER:
LEA SI,GAME_BOARD    ; Load game board
LEA BX,GAME_POINTER  ; Load game pointer array

MOV CX,9             ; Set loop counter to 9

LOOP_1:
CMP CX,6             ; Check if at position 6
JE ADD_1

CMP CX,3             ; Check if at position 3
JE ADD_1

JMP ADD_2

ADD_1:
ADD SI,1             ; Adjust index for new line
JMP ADD_2

ADD_2:
MOV DS:[BX],SI       ; Store game board address in pointer array
ADD SI,2             ; Move to next position

INC BX               ; Increment pointer array index
LOOP LOOP_1          ; Loop for 9 positions

RET

PRINT:
MOV AH,09            ; Set function for printing string
INT 21H              ; DOS interrupt to print

RET

CLEAR_SCREEN:        ; CLEARING SCREEN AFTER EVERY MOVE

MOV AH,0FH           ; Get current video mode
INT 10H              ; BIOS video interrupt

MOV AH,0             ; Set video mode function
INT 10H              ; BIOS video interrupt

RET

READ_KEYBOARD:       ; TAKING INPUT FOR POSITIONS

MOV AH,01            ; Set function to read keyboard input
INT 21H              ; DOS interrupt to read character

RET

FIM:
JMP FIM              ; Infinite loop to end program

CODE ENDS
END START
