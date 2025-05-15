void drawResultsPDFExported() {
  background(240);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(24);
  text("PDF Exportado", width/2, height/2 - 60);
  
  textSize(16);
  text("Arquivo salvo como:", width/2, height/2 - 20);
  text(pdfFilename, width/2, height/2 + 10);
  
  drawButton(width/2 - 100, height/2 + 60, 200, 40, 15, "Abrir PDF");
  
  drawButton(width/2 - 100, height/2 + 120, 200, 40, 15, "Voltar");
}

void exportToPDF() {
  pdfFilename = generatePDFFilename();
  exportingPDF = true;
  redraw();
}

String generatePDFFilename() {
  TableRow row = table.getRow(table.getRowCount() - 1);
  String nome = row.getString("nome").replaceAll("\\s+", "_");
  
  String timestamp = year() + "" + nf(month(), 2) + "" + nf(day(), 2) + "_" + 
                    nf(hour(), 2) + "" + nf(minute(), 2) + "" + nf(second(), 2);
  
  return "dicas_sustentabilidade_" + nome + "_" + timestamp + ".pdf";
}

void exportPDF() {
  pdfFilename = generatePDFFilename();
  exportingPDF = true;
  
  // redraw para gerar o pdf
  redraw();
}

void movieEvent(Movie m) {
  m.read();
  loadingMovieReady = true;
}

void openPDF(String filename) {
  try {
    File pdfFile = new File(dataPath(filename));
    if (pdfFile.exists()) {
      if (Desktop.isDesktopSupported()) {
        Desktop.getDesktop().open(pdfFile);
      } else {
        println("Desktop class not supported - can't open PDF automatically");
      }
    } else {
      println("PDF file not found: " + pdfFile.getAbsolutePath());
    }
  } catch (Exception e) {
    println("Error opening PDF: " + e.getMessage());
    e.printStackTrace();
  }
}
