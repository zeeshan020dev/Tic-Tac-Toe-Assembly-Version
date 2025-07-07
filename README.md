# Tic-Tac-Toe in x86 Assembly Language

A classic two-player Tic-Tac-Toe game implemented entirely in x86 Assembly language. This project is designed to run in a DOS environment and provides a simple, text-based interface for gameplay.

## 🌟 Features

* **Two-Player Gameplay:** Play against a friend, with Player 0 using 'X' and Player 1 using 'O'.
* **Text-Based Interface:** A clean and simple command-line interface.
* **Dynamic Game Board:** The 3x3 board is displayed and updated after each move.
* **Win Detection:** The game automatically checks for win conditions across all rows, columns, and diagonals.
* **Draw Detection:** Recognizes when the board is full and no player has won, resulting in a draw.
* **Clear Game Status:** Displays whose turn it is and announces the winner or a draw at the end of the game.

## 🛠️ How to Run

To run this game, you will need an x86 assembler (like MASM or TASM) and a DOS emulator (like DOSBox).

### Prerequisites

* **Assembler:** [MASM](https://www.masm32.com/) or [TASM](https://www.tasm.co.uk/).
* **DOS Emulator:** [DOSBox](https://www.dosbox.com/) is recommended for modern operating systems.

### Steps

1.  **Setup DOSBox:**
    * Install and run DOSBox.
    * Mount the directory containing the `.asm` file as your C: drive. For example, if your project is in `C:\dev\assembly`, you would type:
        ```
        mount c C:\dev\assembly
        c:
        ```

2.  **Assemble the Code:**
    * Use your assembler to create the object file (`.obj`). The filename in the example is `Tic Tac Toe (Assembly Language Project).asm`. You may want to rename it to something simpler like `tictac.asm`.
    * **Using MASM:**
        ```dos
        masm "Tic Tac Toe (Assembly Language Project).asm";
        ```
    * **Using TASM:**
        ```dos
        tasm "Tic Tac Toe (Assembly Language Project).asm"
        ```

3.  **Link the Object File:**
    * Create the executable file (`.exe`) from the object file.
    * **Using MASM's Linker:**
        ```dos
        link "Tic Tac Toe (Assembly Language Project).obj";
        ```
    * **Using TASM's Linker:**
        ```dos
        tlink "Tic Tac Toe (Assembly Language Project).obj"
        ```

4.  **Run the Game:**
    * Execute the newly created program.
        ```dos
        "Tic Tac Toe (Assembly Language Project).exe"
        ```

## 🎮 How to Play

1.  The game starts with **Player 0**.
2.  When prompted, enter a number from **1 to 9** to place your mark on the board. The positions correspond to the board as follows:

    ```
    1 | 2 | 3
    --+---+--
    4 | 5 | 6
    --+---+--
    7 | 8 | 9
    ```

3.  Player 0 places an **'X'** and Player 1 places an **'O'**.
4.  Players take turns until one player gets three of their marks in a row, column, or diagonal.
5.  If all nine squares are filled and no player has won, the game ends in a **draw**.

## 📂 Code Structure

The code is organized into data and code segments with clear procedures for each part of the game's logic.

* **`DATA SEGMENT`**:
    * Defines all the necessary variables, including the `GAME_BOARD`, player turn tracker (`PLAYER`), win/draw flags, and all the text strings displayed to the user.

* **`CODE SEGMENT`**:
    * **`START`**: The main entry point of the program. It initializes the game and enters the main loop.
    * **`MAIN_LOOP`**: The core of the game. It clears the screen, displays the board and player info, waits for input, updates the board, and checks for a win or draw condition.
    * **`CHANGE_PLAYER`**: Toggles the current player between '0' and '1'.
    * **`UPDATE_DRAW`**: Places the current player's mark ('X' or 'O') on the board at the selected position.
    * **`CHECK_LINE`, `CHECK_COLUMN`, `CHECK_DIAGONAL`**: A set of procedures that iterate through the board to check for a winning combination.
    * **`CHECK_DRAW`**: Scans the board to see if it's full, indicating a draw.
    * **`GAMEOVER` / `DRAW`**: Displays the final game result on the screen.
    * **Helper Procedures**: Includes functions for `PRINT` (displaying strings), `CLEAR_SCREEN`, and `READ_KEYBOARD` (getting user input).

---
*This project serves as a great example of game development and system-level programming using Assembly language.*
