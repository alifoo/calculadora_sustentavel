void generatePersonalizedTips() {
  TableRow row = table.getRow(table.getRowCount() - 1);
  String curso = row.getString("curso");
  String nome = row.getString("nome");
  
  StringBuilder promptBuilder = new StringBuilder();
  
  promptBuilder.append("PERGUNTAS E RESPOSTAS DO ESTUDANTE:\n\n");
  
  for (int i = 0; i < questions.length; i++) {
    String[] q = questions[i];
    int answerIndex = answers[i];
    
    promptBuilder.append("Pergunta: ").append(q[0]).append("\n");
    promptBuilder.append("Resposta: ").append(q[answerIndex + 1]).append("\n\n");
  }
  
  promptBuilder.append("Essas foram as respostas de um estudante da PUC-PR localizada em Curitiba-PR, ");
  promptBuilder.append("Prado Velho, do curso de ").append(curso).append(" chamado ").append(nome).append(".");
  promptBuilder.append("Além de chamá-lo pelo primeiro nome, se dirija a ele em primeira pessoa, em um tom pessoal e amigável. ");
  promptBuilder.append("Faça sugestões para que esse estudante torne a sua rotina mais sustentável ");
  promptBuilder.append("com base em informações sobre a localização mencionada e os hábitos do mesmo. ");
  promptBuilder.append("Dê no máximo 5 sugestões práticas e objetivas. ");
  promptBuilder.append("Sempre que der a sugestão, explique ao estudante como isso impacta ele mesmo e o mundo ao redor positivamente. ");
  promptBuilder.append("Antes das introduções práticas, escreva um pequeno parágrafo como se estivesse de fato lendo o que ele respondeu. ");
  promptBuilder.append("Use somente palavras em português do Brasil.");
  
  tips = askAI(promptBuilder.toString());
}

void showTips(String tips) {
  if ((tips != null) && (state == "showingTips")) {
    background(tipsBg);
    float boxW = width * 0.95;
    float boxX = (width - boxW) / 2;
    float boxY = 80;
    
    if (exportingPDF) {
      beginRecord(PDF, "data/" + pdfFilename);
      background(255);
    }

    fill(245);
    noStroke();
    rect(boxX - 20, boxY - 20, boxW + 40, height - 200, 10);
    
    fill(0);
    textAlign(CENTER, TOP);
    textSize(18);
    text("Dicas Personalizadas de Sustentabilidade", width/2, boxY);

    TableRow row = table.getRow(table.getRowCount() - 1);
    String nome = row.getString("nome");
    String curso = row.getString("curso");
    String email = row.getString("email");
    
    textSize(16);
    text("Aluno: " + nome + " | Curso: " + curso + " | Email: " + email, width/2, boxY + 35);
    
    // linha de separacao
    stroke(150);
    line(boxX, boxY + 60, boxX + boxW, boxY + 60);
    noStroke();
    
    // dicas em si
    textAlign(LEFT, TOP);
    textSize(14);
    fill(0);
    text(tips, boxX, boxY + 70, boxW, height - 250);
    
    // exporta e volta flag ao normal
    if (exportingPDF) {
      endRecord();
      exportingPDF = false;
      println("PDF saved to: data/" + pdfFilename);
      state = "pdfExported";
    } else {
      textAlign(CENTER, CENTER);
      textSize(14);
      drawButton(pdfBtnX, pdfBtnY, pdfBtnW, pdfBtnH, pdfBtnR, "Exportar para PDF");
      drawButton(width/2 - 150, height - 80, 300, 40, 28, "Voltar aos Resultados");
    }
  } else if ((tips != null) && (state == "pdfExported")) {
      textAlign(CENTER, CENTER);
      textSize(18);
      text("PDF gerado e salvo!", width / 2, height / 2);
      textSize(14);
      drawButton(openPdfBtnX, openPdfBtnY, openPdfBtnW, openPdfBtnH, openPdfBtnR, "Abrir PDF");
      drawButton(width/2 - 150, openPdfBtnY + 60, 300, 40, 28, "Voltar às dicas");
    }
}


void generateTips() {
  generatePersonalizedTips();
  state = "showingTips";
  tipsGenerated = true;
}

void exitTipsScreen() {
  if (isSpeaking) {
    stopSpeaking();
  }
}
