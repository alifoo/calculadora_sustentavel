void keyPressed() {
  if (typing) {
    if (keyCode == BACKSPACE && userInput.length() > 0) {
      userInput = userInput.substring(0, userInput.length() - 1);
    } else if (keyCode == ENTER || keyCode == RETURN) {
      processInput(userInput);
    } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && keyCode != KeyEvent.VK_CAPS_LOCK && keyCode != KeyEvent.VK_META) {
      if (key != 'ˆ' && key != '^' && key != '˜' && key != '~' && key != CODED) {
        userInput += key;
      }
    } else if ((state == "answeringQuestions") && (keyCode == ENTER || keyCode == RETURN)) {
      if (selectedAnswer != -1) {
        advanceToNextQuestion();
      }
    }
  }
}
