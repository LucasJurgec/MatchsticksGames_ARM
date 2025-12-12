      MOV R1, #promptName // Load address of promptName string into R1
      STR R1, .WriteString // Print R1 to the screen
      MOV R0, #name     // sets user input location to name
      STR R0, .ReadString // reads the inputted string 
outerLoop:              // starts the outerLoop
      MOV R1, #promptMatches // load address of promptMatches
      STR R1, .WriteString // print the promptMatches on the screen
      LDR R9, .InputNum // reads number of matchsticks inputted by player
      CMP R9, #10       // checks if inputted number is greater than or equal to 10
      BLT outerLoop     // if not restarts the loop
      CMP R9, #100      // checks if inputted number is less than or equal to 100
      BGT outerLoop     // if not restarts the loop
      BL DrawMatchsticks // draws matchsticks
gameLoop:               // starts gameLoop that will display number of matchsticks left
      MOV R1, #name     // retrieve player name
      STR R1, .WriteString // display player name
      MOV R1, #afterNameThere // retrieve afterNameThere message
      STR R1, .WriteString // display afterNameThere message
      STR R9, .WriteUnsignedNum // display remaining matchsticks
      MOV R1, #remainMsg // retrieve remainMsg message
      STR R1, .WriteString // display remainMsg message
playerInput:            // players turn loop
      MOV R1, #name     // retrieve player name
      STR R1, .WriteString // display player name
      MOV R1, #removeMsg // retrieve removeMsg message
      STR R1, .WriteString // display removeMsg message
      LDR R4, .InputNum // read players input 
      CMP R4, #7        // checks if inputted number is less than or equal to 7
      BGT playerInput   // restarts playerInput loop if condition is met
      CMP R4, #1        // checks if inputted number is greater than or equal to 1
      BLT playerInput   // restarts playerInput loop if condition is met
      CMP R4, R9        // checks if the inputted number is greater than the number of matchsticks
      BGT playerInput   // restarts playerInput loop if condition is met
      SUB R9, R9, R4    // subtracts the number of matchsticks left by inputted number
      BL DrawMatchsticks // draws matchsticks
      CMP R9, #1        // checks if the number of matchsticks is 1
      BEQ playerWin     // exits loop and goes to playerWin
      CMP R9, #0        // checks if the number of matchsticks is 0
      BEQ draw          // exits loop and goes to draw
      MOV R1, #compTurnMsg // retrieve compTurnMsg message 
      STR R1, .WriteString // display compTurnMsg
select:                 // Computers turn randomiser
      LDR R4, .Random   // picks random number
      AND R4, R4, #7    // limits random number pick to 0-7
      CMP R4, #0        // checks if random number is 0
      BEQ select        // if so reselect number
      CMP R4, R9        // checks if random number is greater than the number of matchsticks left
      BGT select        // if so reselect number
      STR R4, .WriteUnsignedNum // display random number selected by computer
      MOV R1, #takenMsg // retrieve takenMsg message
      STR R1, .WriteString // display takenMsg message
      SUB R9, R9, R4    // subtract random number from number of matchsticks
      BL DrawMatchsticks
      CMP R9, #1        // checks if 1 matchstick is left
      BEQ compWin       // goes to compWin 
      CMP R9, #0        // checks if 0 matchsticks are left
      BEQ draw          // goes to draw
      B gameLoop        // returns to gameLoop
// win, lose and draw messages
playerWin:              // win message
      MOV R1, #name     // retrieve name
      STR R1, .WriteString // display name
      MOV R1, #winMsg   // retrieve winMsg message
      STR R1, .WriteString // display winMsg
      B goToEnd         // goes to goToEnd
compWin:                // lose message
      MOV R1, #name     // retrieve name
      STR R1, .WriteString // display name
      MOV R1, #loseMsg  // retrieve loseMsg message
      STR R1, .WriteString // display loseMsg
      B goToEnd         // goes to goToEnd
draw:                   // draw message
      MOV R1, #drawMsg  // retrieve drawMsg message
      STR R1, .WriteString // display drawMsg
      B goToEnd         // goes to goToEnd
goToEnd:
      B playAgainPrompt // goes to playAgainPrompt
playAgainPrompt:        // asks if user wants to play again
      MOV R1, #againPrompt // retrieve againPrompt message
      STR R1, .WriteString // display againPrompt
      MOV R0, #againPlay // sets user input location to againPlay
      STR R0, .ReadString // reads the inputted string
      MOV R3, #againPlay // sets againPlay to R3
      LDRB R2, [R3]     // will only read first letter inputted
      CMP R2, #0x79     // checks if first inputted letter is "y"
      BEQ outerLoop     // restarts game
      CMP R2, #0x59     // checks if first inputted letter is "Y"
      BEQ outerLoop     // restarts game
      CMP R2, #0x6E     // checks if first inputted letter is "n"
      BEQ quitGame      // ends game
      CMP R2, #0x4E     // checks if first inputted letter is "N"
      BEQ quitGame      // ends game
      B playAgainPrompt // if none are inputted restarts the playAgainPrompt
quitGame:               // ends game
      MOV R1, #endMsg   // retrieves endMsg message
      STR R1, .WriteString // displays endMsg
      HALT
DrawMatchsticks:
      PUSH {LR, R8, R9, R10, R11, R12} // saves these
      MOV R0, #0        // clears the screen
      STR R0, .ClearScreen // clears the screen to display the new matchsticks
      MOV R8, #0        // matchstick counter starts at 0
      MOV R10, #3       // sets the pixel colour to black
DrawLoop:               // loop to draw matchsticks
      CMP R8, R9        // compares index to number of matchsticks
      BEQ DrawDone      // if index equals number of matchsticks goes to DrawDone
      MOV R1, R8        // copys matchstick number to R1
      MOV R2, #0        // sets row number to 0
DivLoop:                // loop to make matchsticks appear in rows of 10
      CMP R1, #10       // checks if matchstick count is less than 10
      BLT DivDone       // goes to DivDone
      SUB R1, R1, #10   // subtract 10 from matchstick count
      ADD R2, R2, #1    // adds 1 to matchstick count
      B DivLoop         // restarts DivLoop
DivDone: 
      MOV R3, R1        // R3 = col
      ADD R5, R3, R3    // R5 = col * 2
      ADD R3, R5, R3    // R3 = col * 3
      MOV R4, R2        // R4 = row
      ADD R6, R4, R4    // R6 = row * 2
      ADD R4, R6, R4    // R4 = row * 3
      ADD R3, R3, #1    // col*3 + 1
      ADD R4, R4, #1    // row*3 + 1
      MOV R0, #.PixelScreen
      LSL R12, R4, #6   // row * 64
      ADD R12, R12, R3  // + col
      LSL R12, R12, #2  // * 4 (bytes per pixel)
      ADD R0, R0, R12
      STR R10, [R0]     // draw pixel
      ADD R8, R8, #1    // next matchstick
      B DrawLoop
DrawDone:               // finishes drawing
      POP {R8, R9, R10, R11, R12, PC} // returns the values
promptName: .ASCIZ "What is your name?\n"
promptMatches: .ASCIZ "How many matchsticks (10-100)?\n"
name: .BLOCK 128
afterNameThere: .ASCIZ ", there are "
remainMsg: .ASCIZ "matchsticks left\n"
removeMsg: .ASCIZ ", how many should be removed (1-7)?\n"
compTurnMsg: .ASCIZ "Computer Player's turn\n"
takenMsg: .ASCIZ " taken by Computer.\n"
winMsg: .ASCIZ ", YOU WIN!\n"
loseMsg: .ASCIZ ", YOU LOSE!\n"
drawMsg: .ASCIZ "It's a draw!\n"
againPrompt: .ASCIZ "Play again (y/n)?\n"
againPlay: .BLOCK 128
endMsg: .ASCIZ "Thank you for playing\n"
