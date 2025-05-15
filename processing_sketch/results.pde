void getResults(List<Map<String, Object>> results) {
  if (!gotResults) {
    Map<String, Object> resultQuestion1 = new HashMap<>();
    resultQuestion1.put("pontos", 20);
    resultQuestion1.put("pergunta", "transporte semanal");

    Map<String, Object> resultQuestion2 = new HashMap<>();
    resultQuestion2.put("pontos", 20);
    resultQuestion2.put("pergunta", "consumo semanal de carne");

    results.add(resultQuestion1);
    results.add(resultQuestion2);
  }
}

void updateAnalysisResults() {
  analysis_results.clear();
  
  Map<String, Integer> categoryScores = new HashMap<>();

  // Transporte: questions 0-3 (max 20 points → scaled to 10)
  categoryScores.put("Transporte", (points[0] + points[1] + points[2] + points[3]) / 2);
  
  // Resíduos: questions 4,8,9 (max 15 points → scaled to 10)
  categoryScores.put("Resíduos", (points[4] + points[8] + points[9]) * 2 / 3);
  
  // Material: questions 5-6 (max 10 points)
  categoryScores.put("Material", (points[5] + points[6]));
  
  // Alimentação: question 7 (max 5 points → scaled to 10)
  categoryScores.put("Alimentação", points[7] * 2);
  
  // Energia: questions 9-10 (max 10 points)
  categoryScores.put("Energia", (points[9] + points[10]));
  
  // Água: questions 11-12 (max 10 points)
  categoryScores.put("Água", (points[11] + points[12]));
  
  // Roupas: question 13 (max 5 points → scaled to 10)
  categoryScores.put("Roupas", points[13] * 2);
  
  for (Map.Entry<String, Integer> entry : categoryScores.entrySet()) {
    Map<String, Object> result = new HashMap<>();
    result.put("pergunta", entry.getKey());
    result.put("pontos", entry.getValue());
    analysis_results.add(result);
  }
  
  gotResults = true;
}


void showResults(List<Map<String, Object>> results) {
  background(tipsBg);
  if (exportingPDF && (state == "showingResults")) {
    background(255);
    pdfFilename = "resultados_" + year() + nf(month(),2) + nf(day(),2) + "_" + 
                 nf(hour(),2) + nf(minute(),2) + nf(second(),2) + ".pdf";
    beginRecord(PDF, "data/" + pdfFilename);
  }

  // Your existing results display code here...
  fill(0);
  fill(255);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("SEU RESULTADO", width/2, 40);  // Moved up
  
  // Calculate total score (sum of all points)
  int totalScore = 0;
  for (int p : points) {
    totalScore += p;
  }
  int maxPossibleScore = questions.length * 5;
  
  // Display scores and carbon info - moved up
  fill(47, 57, 17);
  textSize(18);  // Made smaller
  text("Pontuação Total: " + totalScore + "/" + maxPossibleScore, width/2, 80);
  
  textSize(14);  // Made smaller
  text("Sua pegada de carbono diária parcial: " + nf(pegadaTotalDia, 0, 2) + " kg CO2/dia", width/2, 110);
  text("Estimativa diária total incluindo outros fatores: " + nf(pegadaTotalDia + 8.0, 0, 2) + " kg CO2/dia", width/2, 135);
  
  String feedback;
  float percentage = (float)totalScore / maxPossibleScore * 100;
  
  if (percentage < 40) {
    feedback = "Você está começando sua jornada sustentável. Há muitas oportunidades para melhorar!";
  } else if (percentage < 70) {
    feedback = "Você está no caminho certo! Continue trabalhando para melhorar seus hábitos.";
  } else {
    feedback = "Parabéns! Você tem hábitos muito sustentáveis. Continue sendo um exemplo!";
  }
  
  text(feedback, width/2, 160);
  
  // Category results - adjusted spacing
  int startY = 190;  // Start higher
  int boxWidth = width - 120;  // Narrower
  int boxHeight = 30;  // Smaller
  int spacing = 45;  // Tighter spacing
  int maxBarWidth = boxWidth - 220;  // Reduced max bar width
  
  String[] categorias = {"Transporte", "Resíduos", "Material", "Alimentação", "Energia", "Água", "Roupas"};
  
  for (int i = 0; i < results.size(); i++) {
    Map<String, Object> result = results.get(i);
    String category = (String)result.get("pergunta");
    int score = (Integer)result.get("pontos");
    int maxForCategory = 10;
    
    fill(255);
    stroke(200);
    rect(60, startY + i*spacing, boxWidth, boxHeight, 5);
    
    // Category name with CO2 impact
    fill(47, 57, 17);
    textAlign(LEFT, CENTER);
    textSize(12);  // Smaller text
    if (i < categorias.length) {
      text(category + " (" + nf(pegadaPorCategoria[i], 0, 2) + " kg)", 70, startY + i*spacing + boxHeight/2);
    } else {
      text(category, 70, startY + i*spacing + boxHeight/2);
    }
    
    // Score bar - now properly constrained
    float barWidth = map(constrain(score, 0, 10), 0, 10, 0, maxBarWidth);
    if (score < 3) {
      fill(231, 76, 60); // vermelho
    } else if (score < 7) {
      fill(241, 196, 15); // amarelo
    } else {
      fill(148, 179, 49); // verde
    }
    noStroke();
    rect(220, startY + i*spacing + 5, barWidth, boxHeight - 10, 3);
    
    // Score text
    fill(47, 57, 17);
    textAlign(RIGHT, CENTER);
    text(score + "/" + maxForCategory, width - 80, startY + i*spacing + boxHeight/2);
  }
  if (exportingPDF && (state == "showingResults")) {
    endRecord();
    exportingPDF = false;
    state = "resultsPDFExported";
    return; // Skip drawing buttons when exporting
  }
  textAlign(CENTER, CENTER);
  textSize(14);
  
  // Export buttons (horizontal)
  drawButton(exportPdfBtnX, exportPdfBtnY, exportPdfBtnW, exportPdfBtnH, exportPdfBtnR, "Exportar PDF");
  drawButton(exportSheetBtnX, exportSheetBtnY, exportSheetBtnW, exportSheetBtnH, exportSheetBtnR, "Exportar Planilha");
  
  // Other buttons
  drawButton(tipsBtnX, tipsBtnY, tipsBtnW, tipsBtnH, tipsBtnR, "Dicas (AI)");
  drawButton(rankBtnX, rankBtnY, rankBtnW, rankBtnH, rankBtnR, "Sair");

  // Mouse over effects
  checkButtonHover();
}

void saveResults() {
  int totalScore = 0;
  for (int i = 0; i < points.length; i++) {
    totalScore += points[i];
  }
  
  // Pega row do user atual (ultima)
  TableRow row = table.getRow(table.getRowCount() - 1);
  
  // Add total score se n existir
  table.checkColumnIndex("total_score");
  row.setInt("total_score", totalScore);
  
  // Adiciona colunas para os valores de pegada de carbono
  table.checkColumnIndex("pegada_total");
  table.checkColumnIndex("percentual_comparado");
  
  // Calcular a pegada de carbono
  calcularPegadaCarbono();
  
  // Salvar valores na tabela
  row.setFloat("pegada_total", pegadaTotalDia);
  row.setFloat("percentual_comparado", percentualComparado);
  
  // Salvar as categorias de pegada
  String[] categorias = {"transporte", "residuos", "material", "alimentacao", "energia", "agua", "roupas"};
  for (int i = 0; i < categorias.length; i++) {
    table.checkColumnIndex("pegada_" + categorias[i]);
    row.setFloat("pegada_" + categorias[i], pegadaPorCategoria[i]);
  }
  
  // Salvar respostas individuais
  for (int i = 0; i < questions.length; i++) {
    String questionCol = "question_" + (i + 1);
    String pointsCol = "points_" + (i + 1);
    
    table.checkColumnIndex(questionCol);
    table.checkColumnIndex(pointsCol);
    
    row.setInt(questionCol, answers[i]);
    row.setInt(pointsCol, points[i]);
  }
  
  saveTable(table, "data/new.csv");
  
  updateAnalysisResults();
}
