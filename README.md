# Homework 3
## Student Name   Robert Iakovlev
## Student ID         916 740 771

In ViewController, in the ViewDieLoad function, I am checking if there is a phone number in the Storage. If so, I truncate it getting rid of the first 2 digits (example +1 9167272727 -> 9167272727), and then check if this number is valid as ordinary phone number check. 

In VerificationViewController, I have added 2 delegates. One delegate is didPressBackSpace and another is for text field to be edited. didPressBackSpace is basically deletes the conten of the textfield if there is any content, or just change the responder to the previeous OPT field and enabling/disabling interactions for certain text fields. Textfield delegate function is needed to handle the OPT6 field to not let OPT6 to hold more than one digit no matter how many times the user enters them (example: OTP6 should avoid having 35. it can only hold at most one digit).

In HomeViewController, I have added some code to hide the navigation controller bar and some code to disign the screen better. I also added the array userAccounts that holds all of the acounts that user has. Besides that I have added the action to the text field that holds the name of the user and whenever it changes, it sets the new name for user using Api.setName().

The rest is following very closely to how it is instructed in the prompt.
