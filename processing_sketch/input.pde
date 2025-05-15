void processInput(String input) {
  println(currentInfo + " submitted: " + input);
  File f = new File(dataPath("new.csv"));

  if (!f.exists()) {
    table = new Table();
    table.addColumn("id");
    table.addColumn("email");
    table.addColumn("curso");
    table.addColumn("nome");

    TableRow newRow = table.addRow();
    table.setInt(table.getRowCount() - 1, "id", table.getRowCount());
    table.setString(table.getRowCount() - 1, currentInfo, input);
    saveTable(table, "data/new.csv");
  } else {
    table = loadTable("data/new.csv", "header");
    if (questionCounter != 0) {
      TableRow row = table.getRow(table.getRowCount() - 1);
      table.setString(table.getRowCount() - 1, currentInfo, input);
    } else {
      TableRow newRow = table.addRow();
      table.setInt(table.getRowCount() - 1, "id", table.getRowCount());
      table.setString(table.getRowCount() - 1, currentInfo, input);
    }
  }

  saveTable(table, "data/new.csv");
  questionCounter++;
  userInput = "";
}
