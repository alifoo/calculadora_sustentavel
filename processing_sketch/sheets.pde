void saveToSpreadsheet() {
  TableRow row = table.addRow();
  row.setInt("id", table.getRowCount());
  
  // Adiciona informações básicas
  row.setString("nome", table.getRow(table.getRowCount()-2).getString("nome"));
  row.setString("email", table.getRow(table.getRowCount()-2).getString("email"));
  row.setString("curso", table.getRow(table.getRowCount()-2).getString("curso"));
  
  // Adiciona as respostas
  for (int i = 0; i < answers.length; i++) {
    row.setInt("question_"+(i+1), answers[i]);
    row.setInt("points_"+(i+1), points[i]);
  }
  
  // Adiciona dados de pegada de carbono
  row.setFloat("pegada_total", pegadaTotalDia);
  row.setFloat("percentual_comparado", percentualComparado);
  
  String[] categorias = {"transporte", "residuos", "material", "alimentacao", "energia", "agua", "roupas"};
  for (int i = 0; i < categorias.length; i++) {
    row.setFloat("pegada_" + categorias[i], pegadaPorCategoria[i]);
  }
  
  saveTable(table, "data/results.csv");
  println("Dados salvos na planilha!");
}

void drawSheetExportedScreen() {
  background(240);
  fill(0);
  textAlign(CENTER, CENTER);
  
  textSize(24);
  text("Planilha Exportada", width/2, height/2 - 60);
  
  textSize(16);
  text("Arquivo salvo como:", width/2, height/2 - 20);
  text(sheetFilename, width/2, height/2 + 10);
  
  // Download button
  drawButton(width/2 - 100, height/2 + 60, 200, 40, 15, "Abrir Planilha");
  
  // Back button
  drawButton(width/2 - 100, height/2 + 120, 200, 40, 15, "Voltar");
}

void exportUserData() {
  // Create filename with timestamp
  sheetFilename = "resultado_usuario_" + year() + nf(month(),2) + nf(day(),2) + "_" + 
                 nf(hour(),2) + nf(minute(),2) + nf(second(),2) + ".csv";
  
  // Create new table for single user
  Table userTable = new Table();
  
  // Copy structure from main table
  for (int i = 0; i < table.getColumnCount(); i++) {
    userTable.addColumn(table.getColumnTitle(i));
  }
  
  // Get current user (last row)
  TableRow currentUser = table.getRow(table.getRowCount() - 1);
  TableRow newRow = userTable.addRow();
  
  // Copy all data
  for (int col = 0; col < table.getColumnCount(); col++) {
    String colName = table.getColumnTitle(col);
    
    switch(table.getColumnType(colName)) {
      case Table.INT:
        newRow.setInt(colName, currentUser.getInt(colName));
        break;
      case Table.FLOAT:
        newRow.setFloat(colName, currentUser.getFloat(colName));
        break;
      case Table.STRING:
        newRow.setString(colName, currentUser.getString(colName));
        break;
    }
  }
  
  // Save the file
  saveTable(userTable, "data/" + sheetFilename);
  sheetExported = true;
  state = "sheetExported";
}
