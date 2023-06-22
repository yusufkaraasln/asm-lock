# asm-lock

# Encrypted Door Application

This application contains a simple simulation of an encrypted door system. The user is prompted to enter a password, and when the correct password is entered, the door opens. If an incorrect password is entered, an error message is displayed to the user.

## How It Works

The application is written in Assembly language and can be executed using the emu8086 emulator. The process follows these steps:

1. The user is shown the message "Please enter your password."
2. The user enters the password and presses the ENTER key.
3. The entered password is checked:
   - If the correct password is entered, the message "Welcome" is displayed, and the user presses the ENTER key to proceed.
   - If an incorrect password is entered, an error message is displayed, and the user can choose to change the password by pressing the SPACE key.
4. If the user presses the SPACE key, they can enter a new password:
   - The message "Enter your new password:" is displayed.
   - The user enters the new password and presses the ENTER key.
   - The new password is accepted, and the message "Your password has been changed" is displayed.
5. If the user presses the ENTER key to continue, the program goes back to the initial screen, and the changed password is considered valid.

## Requirements

This application can be run using the emu8086 emulator. You can download the emulator from [this link](https://emu8086-microprocessor-emulator.tr.softonic.com/).

## How to Run

1. Download and install the emu8086 emulator on your computer.
2. Launch the emulator.
3. Create a new file and paste the provided [Assembly code](#assembly-code) into it.
4. Save the file and compile it.
5. When the program is executed, a password entry screen will appear in the emulator. You can enter passwords and observe the results.
