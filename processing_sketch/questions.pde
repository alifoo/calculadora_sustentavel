void showQuestion() {
  String[] q = questions[currentQuestion];

  fill(0);
  textAlign(CENTER, CENTER);
  text("Questão " + (currentQuestion + 1) + "/" + questions.length, width / 2, 120);
  
  textAlign(CENTER, CENTER);
  text(q[0], width/2, 160);

  for (int i = 0; i < 3; i++) {
    int y = 260 + i * 80; // espacamento vertical uniforme com base na opcao
    
    // highlight da questao selecionada
    if (selectedAnswer == i) {
      fill(135, 193, 255, 100);
      stroke(0, 100, 255);
      strokeWeight(2);
    } else {
      fill(245);
      stroke(150);
      strokeWeight(1);
    }
    
    // option box
    rect(width/2 - 350, y, 700, 60, 10);
    
    // option text
    fill(0);
    textAlign(LEFT, CENTER);
    text(q[i + 1], width/2 - 330, y + 30);
    textAlign(CENTER, CENTER);
  }

  if (selectedAnswer != -1) {
    drawButton(nextBtnX, nextBtnY, nextBtnW, nextBtnH, nextBtnR, "Próxima");
  }
}

void handleQuestionInteraction() {
  int currentTime = millis();
  for (int i = 0; i < 3; i++) {
    int y = 260 + i * 80;
    if (mouseX > width/2 - 350 && mouseX < width/2 + 350 && 
        mouseY > y && mouseY < y + 60) {
      boolean isDoubleClick = (i == lastClickedOption) && (currentTime - lastClickTime < doubleClickSpeed);

      selectedAnswer = i;
      answers[currentQuestion] = i;
      
      String[] q = questions[currentQuestion];
      points[currentQuestion] = Integer.parseInt(q[i + 4]);
      answered[currentQuestion] = true;

      if (isDoubleClick) {
        advanceToNextQuestion();
      }

      lastClickedOption = i;
      lastClickTime = currentTime;
      return;
    }
  }

  if (selectedAnswer != -1 && 
      mouseX > nextBtnX && mouseX < nextBtnX + nextBtnW && 
      mouseY > nextBtnY && mouseY < nextBtnY + nextBtnH) {
    advanceToNextQuestion();
   }
}


void advanceToNextQuestion() {
  if (currentQuestion < questions.length - 1) {
      currentQuestion++;
      selectedAnswer = -1; // reseta selecao para a proxima questao

      // caso a questao ja tenha sido respondida (se implementarmos botao de voltar)
      if (answered[currentQuestion]) {
        selectedAnswer = answers[currentQuestion];
      }
    } else {
      saveResults();
      state = "waitingResults";
    }
}
