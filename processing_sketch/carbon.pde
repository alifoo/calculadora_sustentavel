void initEmissoes() {
  // questão 1 - Transporte (kg CO2/km)
  emissoes.put("q1_1", 0.27);
  emissoes.put("q1_3", 0.03);
  emissoes.put("q1_5", 0.0);
  
  // questão 2 - Frequência transporte público (fator de uso)
  emissoes.put("q2_1", 1.0);
  emissoes.put("q2_3", 2.0);
  emissoes.put("q2_5", 4.0);
  
  // questão 3 - Distância (km)
  emissoes.put("q3_1", 13.5);
  emissoes.put("q3_3", 7.5);
  emissoes.put("q3_5", 2.5);
  
  // questão 4 - Aulas remotas (dias por semana)
  emissoes.put("q4_1", 2.0);
  emissoes.put("q4_3", 4.0);
  emissoes.put("q4_5", 7.0);
  
  // questão 5 - Resíduos (kg CO2/dia)
  emissoes.put("q5_1", 0.7);
  emissoes.put("q5_3", 0.4);
  emissoes.put("q5_5", 0.1);
  
  // questão 6 - Livros (kg CO2/livro)
  emissoes.put("q6_1", 1.0);
  emissoes.put("q6_3", 0.5);
  emissoes.put("q6_5", 0.02);
  
  // questão 7 - Materiais segunda mão (kg CO2)
  emissoes.put("q7_1", 1.0);
  emissoes.put("q7_3", 0.5);
  emissoes.put("q7_5", 0.1);
  
  // questão 8 - Carne vermelha (kg CO2/semana)
  emissoes.put("q8_1", 14.0);
  emissoes.put("q8_3", 7.0);
  emissoes.put("q8_5", 2.0);
  
  // questão 9 - Participação campanhas (pontos apenas)
  emissoes.put("q9_1", 0.0);
  emissoes.put("q9_3", 0.0);
  emissoes.put("q9_5", 0.0);
  
  // questão 10 - Economia de energia (kg CO2/dia)
  emissoes.put("q10_1", 1.0);
  emissoes.put("q10_3", 0.6);
  emissoes.put("q10_5", 0.3);
  
  // questão 11 - Lâmpadas eficientes (kg CO2/dia)
  emissoes.put("q11_1", 0.3);
  emissoes.put("q11_3", 0.15);
  emissoes.put("q11_5", 0.05);
  
  // questão 12 - Fechar chuveiro (kg CO2)
  emissoes.put("q12_1", 0.3);
  emissoes.put("q12_3", 0.2);
  emissoes.put("q12_5", 0.1);
  
  // questão 13 - Tempo de banho (kg CO2)
  emissoes.put("q13_1", 1.2);
  emissoes.put("q13_3", 0.8);
  emissoes.put("q13_5", 0.4);
  
  // questão 14 - Compra de roupas (kg CO2/dia)
  emissoes.put("q14_1", 0.5);
  emissoes.put("q14_3", 0.1);
  emissoes.put("q14_5", 0.02);
}


// funcao para converter os índices de resposta (0, 1, 2) para pontos
void calcularPegadaCarbono() {
  int[] pontuacoes = new int[questions.length];
  for (int i = 0; i < questions.length; i++) {
    pontuacoes[i] = answers[i] == 0 ? 1 : (answers[i] == 1 ? 3 : 5);
  }
  
  // dados para calculo das formulas
  float emissaoPorKm = emissoes.get("q1_" + pontuacoes[0]);
  float distancia = emissoes.get("q3_" + pontuacoes[2]);
  float frequenciaUsoTransporte = emissoes.get("q2_" + pontuacoes[1]);
  float aulasRemotas = emissoes.get("q4_" + pontuacoes[3]);
  
  // calcula pegada por categoria
  float pegadaTransporteDia = (emissaoPorKm * distancia * frequenciaUsoTransporte / 5) - 
                             ((aulasRemotas * emissaoPorKm * distancia) / 7);
  
  float pegadaResiduosDia = emissoes.get("q5_" + pontuacoes[4]);
  
  float pegadaMaterialDia = (emissoes.get("q6_" + pontuacoes[5]) + emissoes.get("q7_" + pontuacoes[6])) / 30;
  
  float pegadaAlimentacaoDia = emissoes.get("q8_" + pontuacoes[7]) / 7;
  
  float pegadaEnergiaDia = emissoes.get("q10_" + pontuacoes[9]) + emissoes.get("q11_" + pontuacoes[10]);
  
  float pegadaAguaDia = emissoes.get("q12_" + pontuacoes[11]) + emissoes.get("q13_" + pontuacoes[12]);
  
  float pegadaRoupasDia = emissoes.get("q14_" + pontuacoes[13]) / 30;
  
  pegadaPorCategoria[0] = pegadaTransporteDia;
  pegadaPorCategoria[1] = pegadaResiduosDia;
  pegadaPorCategoria[2] = pegadaMaterialDia;
  pegadaPorCategoria[3] = pegadaAlimentacaoDia;
  pegadaPorCategoria[4] = pegadaEnergiaDia;
  pegadaPorCategoria[5] = pegadaAguaDia;
  pegadaPorCategoria[6] = pegadaRoupasDia;
  
  pegadaTotalDia = pegadaTransporteDia + pegadaResiduosDia + pegadaMaterialDia + 
                  pegadaAlimentacaoDia + pegadaEnergiaDia + pegadaAguaDia + pegadaRoupasDia;
  
  percentualComparado = (pegadaTotalDia / 11.0) * 100;
  
  println("Pegada de carbono calculada:");
  println("Transporte: " + pegadaTransporteDia + " kg CO2/dia");
  println("Resíduos: " + pegadaResiduosDia + " kg CO2/dia");
  println("Material: " + pegadaMaterialDia + " kg CO2/dia");
  println("Alimentação: " + pegadaAlimentacaoDia + " kg CO2/dia");
  println("Energia: " + pegadaEnergiaDia + " kg CO2/dia");
  println("Água: " + pegadaAguaDia + " kg CO2/dia");
  println("Roupas: " + pegadaRoupasDia + " kg CO2/dia");
  println("Total: " + pegadaTotalDia + " kg CO2/dia");
  println("Percentual comparado à média: " + percentualComparado + "%");
}

void showCarbonResults() {
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(24);
  text("Resultado da sua Pegada de Carbono", width/2, 120);
  
  textSize(18);
  text("Sua pegada de carbono diária: " + nf(pegadaTotalDia, 0, 2) + " kg CO2/dia", width/2, 180);
  text("Comparado com a média brasileira (16.95 kg CO2/dia): " + nf(percentualComparado, 0, 1) + "%", width/2, 210);
  
  String[] categorias = {"Transporte", "Resíduos", "Material", "Alimentação", "Energia", "Água", "Roupas"};
  
  textAlign(LEFT, CENTER);
  textSize(16);
  
  float startY = 270;
  float rowHeight = 30;
  
  for (int i = 0; i < categorias.length; i++) {
    float yPos = startY + i * rowHeight;
    
    if (i % 2 == 0) {
      fill(240);
      noStroke();
      rect(width/2 - 350, yPos, 700, rowHeight);
    }
    
    fill(0);
    text(categorias[i], width/2 - 300, yPos + rowHeight/2);
    textAlign(RIGHT, CENTER);
    text(nf(pegadaPorCategoria[i], 0, 2) + " kg CO2/dia", width/2 + 300, yPos + rowHeight/2);
    textAlign(LEFT, CENTER);
  }
  
  // calculo resultado com base em pegada
  String classificacao = "";
  if (pegadaTotalDia < 3) {
    classificacao = "Excelente! Sua pegada está bem abaixo da média.";
  } else if (pegadaTotalDia < 6) {
    classificacao = "Muito bom! Sua pegada está abaixo da média.";
  } else if (pegadaTotalDia < 9) {
    classificacao = "Razoável. Sua pegada está próxima da média.";
  } else if (pegadaTotalDia < 12) {
    classificacao = "Atenção! Sua pegada está acima da média.";
  } else {
    classificacao = "Alerta! Sua pegada está muito acima da média.";
  }
  textAlign(CENTER, CENTER);
  fill(0);
  text(classificacao, width/2, startY + categorias.length * rowHeight + 30);
  
  drawButton(pdfBtnX, pdfBtnY, pdfBtnW, pdfBtnH, pdfBtnR, "Exportar PDF");
  drawButton(startBtnX, startBtnY, startBtnW, startBtnH, startBtnR, "Ver Dicas");
}
