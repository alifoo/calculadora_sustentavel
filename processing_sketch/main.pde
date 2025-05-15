void setup() {
  size(1280, 720);
  startBg = loadImage("firstscreen.png");
  tipsBg = loadImage("tipsbg.png");
  bg = loadImage("defaultbg.png");
  speakerIcon = loadImage("speaker.png");
  speakerIcon.resize(20, 20);
  myFont = createFont("barkerville-regular.ttf", 24);
  loading = new Movie(this, "carregamento.mp4");
  loading.loop();
  sheetFilename = "resultados_" + year() + nf(month(),2) + nf(day(),2) + ".csv";

   // inicializando valores de emissao
  initEmissoes();

  textFont(myFont);
  textAlign(CENTER, CENTER);
  textSize(18);

  inputW = 300;
  inputH = 40;
  inputX = (width - inputW) / 2;
  inputY = height / 2 - 60;

  resultadosBtnW = 300;
  resultadosBtnH = 40;
  resultadosBtnX = (width - resultadosBtnW) / 2;
  resultadosBtnY = inputY + 60;
  resultadosBtnR = 28;

  dicasBtnW = 300;
  dicasBtnH = 40;
  dicasBtnX = (width - dicasBtnW) / 2;
  dicasBtnY = resultadosBtnY + 150;
  dicasBtnR = 28;

  rankBtnW = 300;
  rankBtnH = 40;
  rankBtnX = (width - rankBtnW) / 2;
  rankBtnY = dicasBtnY + 60;
  rankBtnR = 28;

  startBtnW = 300;
  startBtnH = 40;
  startBtnX = (width - startBtnW) / 2;
  startBtnY = resultadosBtnY + 140;
  startBtnR = 28;

  exitBtnW = 300;
  exitBtnH = 40;
  exitBtnX = (width - exitBtnW) / 2;
  exitBtnY = startBtnY + 60;
  exitBtnR = 28;

  nextBtnW = 150;
  nextBtnH = 40;
  nextBtnX = width - 200;
  nextBtnY = height - 130;
  nextBtnR = 28;

  pdfBtnW = 300;
  pdfBtnH = 40;
  pdfBtnX = width/2 - 150;
  pdfBtnY = height - 130;
  pdfBtnR = 28;

  openPdfBtnW = 300;
  openPdfBtnH = 40;
  openPdfBtnX = width/2 - 150;
  openPdfBtnY = height - 230;
  openPdfBtnR = 28;

  ttsBtnW = 30;
  ttsBtnH = 30;
  ttsBtnX = width - ttsBtnW - 10;
  ttsBtnY = 10;
  ttsBtnR = 10;

  int btnWidth = 180;
  int btnHeight = 35;
  int btnRadius = 15;
  int btnSpacing = 15;

  exportPdfBtnW = exportSheetBtnW = btnWidth;
  exportPdfBtnH = exportSheetBtnH = btnHeight;
  exportPdfBtnR = exportSheetBtnR = btnRadius;

  exportPdfBtnX = width/2 - btnWidth - btnSpacing/2;
  exportSheetBtnX = width/2 + btnSpacing/2;
  exportPdfBtnY = exportSheetBtnY = height - 180;

  // segunda row dos botoes nos resultados
  tipsBtnW = rankBtnW = btnWidth;
  tipsBtnH = rankBtnH = btnHeight;
  tipsBtnR = rankBtnR = btnRadius;

  tipsBtnX = width/2 - btnWidth - btnSpacing/2;
  rankBtnX = width/2 + btnSpacing/2;
  tipsBtnY = rankBtnY = height - 130;

  questionsList = new StringList("email", "curso", "nome");

  startTime = millis();
  state = "startScreen";
}

void draw() {
  fill(47, 57, 17);
  background(bg);
  
  if (questionCounter >= questionsList.size() && state == "answeringInfo") {
    state = "answeringQuestions";
  }

  if (state == "startScreen") {
    background(startBg);
    drawButton(startBtnX, startBtnY, startBtnW, startBtnH, startBtnR, "Iniciar");
    drawButton(exitBtnX, exitBtnY, exitBtnW, exitBtnH, exitBtnR, "Sair");
  } else if (state == "answeringInfo") {
    if (typing) {
      fill(255);
      stroke(0, 0, 255);
    } else {
      fill(245);
      stroke(150);
    }

    rect(inputX, inputY, inputW, inputH);
    fill(0);
    textAlign(LEFT, CENTER);
    text(userInput, inputX + 10, inputY + inputH / 2);
    textAlign(CENTER, CENTER);

    if (typing && (frameCount % 60 < 30)) {
      float tw = textWidth(userInput);
      line(inputX + 10 + tw, inputY + 5, inputX + 10 + tw, inputY + inputH - 5);
    }

    text("Clique na caixa de texto e digite. Pressione ENTER para confirmar.", width / 2, inputY - 60);
    currentInfo = questionsList.get(questionCounter);
    text("Insira o seu " + currentInfo + ":", width / 2, inputY - 30);

  } else if (state == "answeringQuestions") {
    if (currentQuestion < questions.length) {
      showQuestion();
    } else {
      if (!done) {
        done = true;
      }
    }
  } else if (state == "waitingResults") {
    text("Você inseriu todas as informações necessárias para a avaliação.\nClique no botão abaixo para ver seus resultados.", width / 2, inputY - 30);
    drawButton(resultadosBtnX, resultadosBtnY, resultadosBtnW, resultadosBtnH, resultadosBtnR, "Exibir resultados");

  } else if (state == "showingResults") {
    showResults(analysis_results);
    return;
  } else if (state == "loadingTips") {
    if (tipsGenerated == true) {
      state = "showingTips";
      showTips(tips);
    } else {
      text("Por favor, aguarde. Suas dicas estão sendo geradas.", width / 2, height / 2);

      if (loadingMovieReady) {
        float movieRatio = (float)loading.width / loading.height;
        float displayWidth = 320;
        float displayHeight = displayWidth / movieRatio;

        imageMode(CENTER);
        image(loading, width / 2, height / 2 + 120, displayWidth - 200, displayHeight - 200);
        imageMode(CORNER);
      }

      if (!loadingStarted) {
        loadingStarted = true;
        thread("generateTips");
      }
    }
  } else if (state == "showingTips") {
    showTips(tips);
  } else if (state == "pdfExported") {
    showTips(tips);
  } else if (state == "resultsPDFExported") {
    drawResultsPDFExported();
  } else if (state == "sheetExported") {
    drawSheetExportedScreen();
  }

  verifyMouseOver();
}

void drawButton(int x, int y, int w, int h, int r, String label) {
  fill(245);
  stroke(150);
  strokeWeight(1);
  rect(x, y, w, h, r);
  fill(0);
  text(label, x + w / 2, y + h / 2);
}
