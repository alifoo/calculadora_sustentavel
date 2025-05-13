import java.awt.event.KeyEvent;
import java.io.*;
import java.net.*;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;
import http.requests.*;
PImage bg, startBg;
PFont myFont;

JSONObject json;
String userInput = "";
StringList questionsList;
boolean typing = false;
int inputX, inputY, inputW, inputH;
int resultadosBtnX, resultadosBtnY, resultadosBtnW, resultadosBtnH, resultadosBtnR;
int dicasBtnX, dicasBtnY, dicasBtnW, dicasBtnH, dicasBtnR;
int rankBtnX, rankBtnY, rankBtnW, rankBtnH, rankBtnR;
int startBtnX, startBtnY, startBtnW, startBtnH, startBtnR;
int exitBtnX, exitBtnY, exitBtnW, exitBtnH, exitBtnR;
int questionCounter = 0;
String currentQuestion = "";
Table table;
TableRow newRow;
int borderTimer = 0;
boolean gotResults = false;
boolean showedResults = false;
List<Map<String, Object>> analysis_results = new ArrayList<>();
String state;
boolean gotResponse = false;
String tips;
int startTime;
boolean loadingStarted = false;

void setup() {
  size(1280, 720);
  startBg = loadImage("firstscreen.png");
  bg = loadImage("defaultbg.png");
  myFont = createFont("barkerville-regular.ttf", 24);
  textFont(myFont);
  textAlign(CENTER, CENTER);
  textSize(20);

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
  dicasBtnY = resultadosBtnY + 60;
  dicasBtnR = 28;

  rankBtnW = 300;
  rankBtnH = 40;
  rankBtnX = (width - rankBtnW) / 2;
  rankBtnY = dicasBtnY + 60;
  rankBtnR = 28;

  startBtnW = 300;
  startBtnH = 40;
  startBtnX = (width - startBtnW) / 2;
  startBtnY = rankBtnY + 20;
  startBtnR = 28;

  exitBtnW = 300;
  exitBtnH = 40;
  exitBtnX = (width - exitBtnW) / 2;
  exitBtnY = startBtnY + 60;
  exitBtnR = 28;

  questionsList = new StringList("email", "curso", "nome");

  startTime = millis();
  state = "startScreen";
}

void draw() {
  if (state == "startScreen") {
    background(startBg);
  } else {
    background(bg);
  }
  
  if (questionCounter >= questionsList.size() && state == "answeringQuestions") {
    state = "waitingResults";
  }

  if (state == "startScreen") {
    drawButton(startBtnX, startBtnY, startBtnW, startBtnH, startBtnR, "Iniciar");
    drawButton(exitBtnX, exitBtnY, exitBtnW, exitBtnH, exitBtnR, "Sair");
  } else if (state == "answeringQuestions") {
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
    currentQuestion = questionsList.get(questionCounter);
    text("Insira o seu " + currentQuestion + ":", width / 2, inputY - 30);

    if (userInput.length() > 0) {
      text("Texto atual de input: " + userInput, width / 2, inputY + 80);
    }


  } else if (state == "waitingResults") {
    text("Você inseriu todas as informações necessárias para a avaliação.\nClique no botão abaixo para ver seus resultados.", width / 2, inputY - 30);
    drawButton(resultadosBtnX, resultadosBtnY, resultadosBtnW, resultadosBtnH, resultadosBtnR, "Exibir resultados");

  } else if (state == "showingResults") {
    if (!showedResults) {
      showResults(analysis_results);
    }
    drawButton(dicasBtnX, dicasBtnY, dicasBtnW, dicasBtnH, dicasBtnR, "Dicas de sustentabilidade");
    drawButton(rankBtnX, rankBtnY, rankBtnW, rankBtnH, rankBtnR, "Ver o rank dos cursos");

  } else if (state == "loadingTips") {
    text("Por favor, aguarde. Suas dicas estão sendo geradas.", width / 2, height / 2);
    if (!loadingStarted) {
      loadingStarted = true;
      thread("generateTips");
    }
  } else if (state == "showingTips") {
    showTips(tips);
  }
}

void drawButton(int x, int y, int w, int h, int r, String label) {
  fill(245);
  stroke(150);
  strokeWeight(1);
  rect(x, y, w, h, r);
  fill(0);
  text(label, x + w / 2, y + h / 2);
}

void mousePressed() {
  if (mouseOver(startBtnX, startBtnY, startBtnW, startBtnH) && state == "startScreen") {
    handleButtonClick();
    state = "answeringQuestions";
  }

  if (mouseX > inputX && mouseX < inputX + inputW && 
      mouseY > inputY && mouseY < inputY + inputH) {
    typing = true;
  } else {
    typing = false;
  }

  if (mouseOver(resultadosBtnX, resultadosBtnY, resultadosBtnW, resultadosBtnH) && state == "waitingResults") {
    handleButtonClick();
    if (!gotResults) {
      getResults(analysis_results);
      gotResults = true;
    }
    state = "showingResults";
  }

  if (mouseOver(dicasBtnX, dicasBtnY, dicasBtnW, dicasBtnH) && state == "showingResults") {
    handleButtonClick();
    state = "loadingTips";
  }

  if (mouseOver(rankBtnX, rankBtnY, rankBtnW, rankBtnH) && state == "showingResults") {
    handleButtonClick();
  }
}

boolean mouseOver(int x, int y, int w, int h) {
  return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
}

void handleButtonClick() {
  borderTimer = 5;
  if (borderTimer > 0) {
    stroke(35, 76, 125);
    strokeWeight(3);
    noFill();
    rect(mouseX - 150, mouseY - 20, 300, 40, 28);
    borderTimer -= 1;
  }
}

void keyPressed() {
  if (typing) {
    if (keyCode == BACKSPACE && userInput.length() > 0) {
      userInput = userInput.substring(0, userInput.length() - 1);
    } else if (keyCode == ENTER || keyCode == RETURN) {
      processInput(userInput);
    } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && keyCode != KeyEvent.VK_CAPS_LOCK && keyCode != KeyEvent.VK_META) {
      userInput += key;
    }
  }
}

void processInput(String input) {
  println(currentQuestion + " submitted: " + input);
  File f = new File(dataPath("new.csv"));

  if (!f.exists()) {
    table = new Table();
    table.addColumn("id");
    table.addColumn("email");
    table.addColumn("curso");
    table.addColumn("nome");

    TableRow newRow = table.addRow();
    table.setInt(table.getRowCount() - 1, "id", table.getRowCount());
    table.setString(table.getRowCount() - 1, currentQuestion, input);
    saveTable(table, "data/new.csv");
  } else {
    table = loadTable("data/new.csv", "header");
    if (questionCounter != 0) {
      TableRow row = table.getRow(table.getRowCount() - 1);
      table.setString(table.getRowCount() - 1, currentQuestion, input);
    } else {
      TableRow newRow = table.addRow();
      table.setInt(table.getRowCount() - 1, "id", table.getRowCount());
      table.setString(table.getRowCount() - 1, currentQuestion, input);
    }
  }

  saveTable(table, "data/new.csv");
  questionCounter++;
  userInput = "";
}

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

void showResults(List<Map<String, Object>> results) {
  if (results != null) {
    StringList showedResults = new StringList();
    for (Map<String, Object> result : results) {
      String msg = "Você conseguiu " + result.get("pontos") + " pts devido a seu " + result.get("pergunta");
      showedResults.append(msg);
    }
    int y = 60;
    for (int i = 0; i < showedResults.size(); i++) {
      fill(50);
      text(showedResults.get(i), width / 2, y);
      y += 30;
    }
  }
}

String askAI(String prompt) {
  try {
    URL url = new URL("http://localhost:8000/ask");
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("POST");
    conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
    conn.setDoOutput(true);

    JSONObject payload = new JSONObject();
    payload.setString("prompt", prompt);

    OutputStream os = conn.getOutputStream();
    byte[] input = payload.toString().getBytes("UTF-8");
    os.write(input, 0, input.length);
    os.flush();
    os.close();

    BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
    StringBuilder response = new StringBuilder();
    String line;
    while ((line = reader.readLine()) != null) {
      response.append(line);
    }
    reader.close();

    JSONObject jsonObj = parseJSONObject(response.toString());
    String reply = jsonObj.getString("response");

    gotResponse = true;
    state = "showingTips";

    return reply;
  } catch (Exception e) {
    e.printStackTrace();
    return "Erro ao comunicar com o servidor.";
  }
}

void generateTips() {
  tips = askAI("Quanto de carbono a queima da gasolina emite?");
  state = "showingTips";
}

void showTips(String tips) {
  if (tips != null) {
    float boxW = width * 0.8;
    float boxX = (width - boxW) / 2;
    float boxY = height / 2 - 100;

    fill(0); // or another color
    text(tips, boxX, boxY, boxW, 200); // x, y, w, h
  }
}
