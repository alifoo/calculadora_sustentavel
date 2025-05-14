void mousePressed() {
  if (mouseOver(startBtnX, startBtnY, startBtnW, startBtnH) && state == "startScreen") {
    state = "answeringInfo";
  }

  if (mouseOver(exitBtnX, exitBtnY, exitBtnW, exitBtnH) && state == "startScreen") {
    exit();
  }

  if (state == "answeringQuestions") {
    handleQuestionInteraction();
  }

  if (mouseX > inputX && mouseX < inputX + inputW && 
      mouseY > inputY && mouseY < inputY + inputH) {
    typing = true;
  } else {
    typing = false;
  }

  if (mouseOver(resultadosBtnX, resultadosBtnY, resultadosBtnW, resultadosBtnH) && state == "waitingResults") {
    state = "showingResults";
  }

  if (mouseOver(tipsBtnX, tipsBtnY, tipsBtnW, tipsBtnH) && state == "showingResults") {
    state = "loadingTips";
  }

  if (mouseOver(rankBtnX, rankBtnY, rankBtnW, rankBtnH) && state == "showingResults") {
    exit();
  }

  if (state == "showingTips") {
    if (mouseOver(width/2 - 150, height - 80, 300, 40)) {
      exitTipsScreen();
      state = "showingResults";
    } else if (mouseOver(pdfBtnX, pdfBtnY, pdfBtnW, pdfBtnH)) {
      exitTipsScreen();
      exportPDF();
    }
  }
  
  if (state == "pdfExported") {
    if (mouseOver(width/2 - 150, openPdfBtnY + 60, 300, 40)) {
      state = "showingTips";
    } else if (mouseOver(openPdfBtnX, openPdfBtnY, openPdfBtnW, openPdfBtnH)) {
      openPDF(pdfFilename);
    }
  }

  if ((state == "showingTips") && 
      mouseOver(ttsBtnX, ttsBtnY, ttsBtnW, ttsBtnH)) {
    if (!isSpeaking) {
      isSpeaking = true;
      thread("speakTips"); // speaking em thread separada
    } else {
      stopSpeaking();
      isSpeaking = false;
    }
  }
  if (state == "showingResults") {
    if (mouseOver(exportPdfBtnX, exportPdfBtnY, exportPdfBtnW, exportPdfBtnH)) {
       exportingPDF = true;
       redraw();
    } else if (mouseOver(exportSheetBtnX, exportSheetBtnY, exportSheetBtnW, exportSheetBtnH)) {
      exportUserData();
    }
  }
  
  if (state == "resultsPDFExported") {
    if (mouseOver(width/2 - 100, height/2 + 60, 200, 40)) {
      openPDF(pdfFilename);
    } 
    else if (mouseOver(width/2 - 100, height/2 + 120, 200, 40)) {
      state = "showingResults";
    }
  }

  if (state == "sheetExported") {
    if (mouseOver(width/2 - 100, height/2 + 60, 200, 40)) {
      // Open the spreadsheet file
      try {
        File file = new File(dataPath("") + "/" + sheetFilename);
        Desktop.getDesktop().open(file);
      } catch (IOException e) {
        println("Error opening file: " + e);
      }
    } 
    else if (mouseOver(width/2 - 100, height/2 + 120, 200, 40)) {
      state = "showingResults";
    }
  }
}

void verifyMouseOver() {
  if (mouseOver(startBtnX, startBtnY, startBtnW, startBtnH) && state == "startScreen") {
      mouseOverStroke(startBtnX, startBtnY, startBtnW, startBtnH, startBtnR);
  }
  if (mouseOver(exitBtnX, exitBtnY, exitBtnW, exitBtnH) && state == "startScreen") {
    mouseOverStroke(exitBtnX, exitBtnY, exitBtnW, exitBtnH, exitBtnR);
  }
  if (mouseOver(resultadosBtnX, resultadosBtnY, resultadosBtnW, resultadosBtnH) && state == "waitingResults") {
    mouseOverStroke(resultadosBtnX, resultadosBtnY, resultadosBtnW, resultadosBtnH, resultadosBtnR);
  }
  if (state == "answeringQuestions" && selectedAnswer != -1) {
    if (mouseOver(nextBtnX, nextBtnY, nextBtnW, nextBtnH)) {
      mouseOverStroke(nextBtnX, nextBtnY, nextBtnW, nextBtnH, nextBtnR);
    }
  }
  if (state == "showingTips") {
    if (mouseOver(width/2 - 150, height - 80, 300, 40)) {
      mouseOverStroke(width/2 - 150, height - 80, 300, 40, 28);
    }
    if (mouseOver(pdfBtnX, pdfBtnY, pdfBtnW, pdfBtnH)) {
      mouseOverStroke(pdfBtnX, pdfBtnY, pdfBtnW, pdfBtnH, pdfBtnR);
    }
    drawTTSButton(ttsBtnX, ttsBtnY, ttsBtnW, ttsBtnH, ttsBtnR);
    
    if (mouseOver(ttsBtnX, ttsBtnY, ttsBtnW, ttsBtnH)) {
      mouseOverStroke(ttsBtnX, ttsBtnY, ttsBtnW, ttsBtnH, ttsBtnR);
    }
  }
  if (state == "pdfExported") {
    if (mouseOver(width/2 - 150, openPdfBtnY + 60, 300, 40)) {
      mouseOverStroke(width/2 - 150, openPdfBtnY + 60, 300, 40, 28);
    }
    if (mouseOver(openPdfBtnX, openPdfBtnY, openPdfBtnW, openPdfBtnH)) {
      mouseOverStroke(openPdfBtnX, openPdfBtnY, openPdfBtnW, openPdfBtnH, openPdfBtnR);
    }
  }
  if (state == "resultsPDFExported") {
    if (mouseOver(width/2 - 100, height/2 + 60, 200, 40)) { // Open PDF button
      mouseOverStroke(width/2 - 100, height/2 + 60, 200, 40, 15);
    }
    if (mouseOver(width/2 - 100, height/2 + 120, 200, 40)) { // Back button
      mouseOverStroke(width/2 - 100, height/2 + 120, 200, 40, 15);
    }
  }
  
  if (state == "sheetExported") {
    if (mouseOver(width/2 - 100, height/2 + 60, 200, 40)) { // Open Sheet button
      mouseOverStroke(width/2 - 100, height/2 + 60, 200, 40, 15);
    }
    if (mouseOver(width/2 - 100, height/2 + 120, 200, 40)) { // Back button
      mouseOverStroke(width/2 - 100, height/2 + 120, 200, 40, 15);
    }
  }
}

boolean mouseOver(int x, int y, int w, int h) {
  return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
}

void mouseOverStroke(int x, int y, int w, int h, int r) {
  float savedWeight = g.strokeWeight;
  int savedColor = g.strokeColor;
  
  noFill();
  stroke(135, 193, 255);
  strokeWeight(3);
  rect(x, y, w, h, r);
  
  stroke(savedColor);
  strokeWeight(savedWeight);
}
