import java.awt.event.KeyEvent;
import java.io.*;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;
import http.requests.*;
JSONObject json;
String userInput = "";
StringList questionsList;
boolean typing = false;
int inputX, inputY, inputW, inputH; // dimensoes da text box de input
int resultadosBtnX, resultadosBtnY, resultadosBtnW, resultadosBtnH, resultadosBtnR;
int dicasBtnX, dicasBtnY, dicasBtnW, dicasBtnH, dicasBtnR;
int rankBtnX, rankBtnY, rankBtnW, rankBtnH, rankBtnR;
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

  table = new Table();

  table.addColumn("id");
  table.addColumn("email");
  table.addColumn("curso");
  table.addColumn("nome");

  newRow = table.addRow();
  newRow.setInt("id", table.getRowCount());

  size(400, 300);
  inputX = 100;
  inputY = 120;
  inputW = 200;
  inputH = 30;

  resultadosBtnX = 100;
  resultadosBtnY = 160;
  resultadosBtnW = 190;
  resultadosBtnH = 30;
  resultadosBtnR = 28;
  
  dicasBtnX = 100;
  dicasBtnY = 210;
  dicasBtnW = 190;
  dicasBtnH = 30;
  dicasBtnR = 28;

  rankBtnX = 100;
  rankBtnY = 250;
  rankBtnW = 190;
  rankBtnH = 30;
  rankBtnR = 28;

  int padding = 10;
  int maxWidth = width - 2 * padding;
  int maxHeight = height - 2 * padding;

  questionsList = new StringList("email", "curso", "nome");
  
  textAlign(LEFT, CENTER);
  textSize(14);
  startTime = millis();
}

void draw() {
  background(240);

  if (questionCounter < questionsList.size()) {
    state = "answeringQuestions";
  } else {
    if (state == "answeringQuestions") {
      state = "waitingResults";
    }
  }

  if (state == "answeringQuestions") {
    if (typing) {
      fill(255);
      stroke(0, 0, 255); // borda azul se a box estiver ativa
    } else {
      fill(245);
      stroke(150);
    }

    rect(inputX, inputY, inputW, inputH);
    fill(0);
    text(userInput, inputX + 5, inputY + inputH/2);
    
    // o framecount aumenta em 1 toda vez que a funcao draw() roda em um ciclo de 0 a 59 frames.
    // por conta da condicao abaixo, os frames 0-29 sao true e 30-59 false. isso faz com que o line 'pisque'
    // posicao do line: x1, y1, x2, y2
    if (typing && (frameCount % 60 < 30)) {
      float textWidth = textWidth(userInput);
      line(inputX + 5 + textWidth, inputY + 5, inputX + 5 + textWidth, inputY + inputH - 5);
    }
    
    fill(50);
    text("Clique na caixa de texto e digite.\nPressione ENTER para confirmar.", 105, 60);
    
    currentQuestion = questionsList.get(questionCounter);
    text("Insira o seu " + currentQuestion + ":", 105, 105);

    if (userInput.length() > 0) {
      text("Texto atual de input: " + userInput, 60, 180);
    }
  } else if (state == "waitingResults") {
    text("Você inseriu todas as informações\nnecessárias para a avaliação.\n\nClique no botão abaixo para\nver seus resultados.", 105, 105);
    
    fill(245);
    stroke(150);
    strokeWeight(1);
    rect(resultadosBtnX, resultadosBtnY, resultadosBtnW, resultadosBtnH, resultadosBtnR);
    fill(0);
    text("Exibir resultados", resultadosBtnX + 50, resultadosBtnY + resultadosBtnH/2);

  } else if (state == "showingResults") {
    if (showedResults == false) {
      showResults(analysis_results);
    }

    fill(245);
    stroke(150);
    strokeWeight(1);
    rect(dicasBtnX, dicasBtnY, dicasBtnW, dicasBtnH, dicasBtnR);
    fill(0);
    text("Dicas de sustentabilidade", dicasBtnX + 20, dicasBtnY + dicasBtnH/2);

    fill(245);
    stroke(150);
    strokeWeight(1);
    rect(rankBtnX, rankBtnY, rankBtnW, rankBtnH, rankBtnR);
    fill(0);
    text("Ver o rank dos cursos", rankBtnX + 20, rankBtnY + rankBtnH/2);
  } else if (state == "loadingTips") {
    fill(50);
    text("Por favor, aguarde. Suas dicas estão sendo geradas.", 105, 105);
    if (!loadingStarted) {
      loadingStarted = true;
      thread("generateTips");
    }
  } else if (state == "showingTips") {
    showTips(tips);
  }
}

void mousePressed() {
  if (mouseX > inputX && mouseX < inputX + inputW && 
      mouseY > inputY && mouseY < inputY + inputH) {
    typing = true;
  } else {
    typing = false;
  }
  
  // Botão de mostrar resultados
  if (mouseX > resultadosBtnX && mouseX < resultadosBtnX + resultadosBtnW &&
      mouseY > resultadosBtnY && mouseY < resultadosBtnY + resultadosBtnH &&
      state == "waitingResults") {
    borderTimer = 5;
    if (borderTimer > 0) {
      stroke(35, 76, 125);
      strokeWeight(3);
      noFill();
      rect(resultadosBtnX, resultadosBtnY, resultadosBtnW, resultadosBtnH, resultadosBtnR);
      borderTimer -= 1;
    }

    if (gotResults == false) {
      getResults(analysis_results);
      gotResults = true;
    }
    state = "showingResults";
  }
  // Botao de mostrar dicas
  if (mouseX > dicasBtnX && mouseX < dicasBtnX + dicasBtnW &&
      mouseY > dicasBtnY && mouseY < dicasBtnY + dicasBtnH &&
      state == "showingResults") {
    borderTimer = 5;

    if (borderTimer > 0) {
      stroke(35, 76, 125);
      strokeWeight(3);
      noFill();
      rect(dicasBtnX, dicasBtnY, dicasBtnW, dicasBtnH, dicasBtnR);
      borderTimer -= 1;
    }
    state = "loadingTips";
    
  }
  // Botao de mostrar ranks
  if (mouseX > rankBtnX && mouseX < rankBtnX + rankBtnW &&
      mouseY > rankBtnY && mouseY < rankBtnY + rankBtnH &&
      state == "showingResults") {
    borderTimer = 5;
    if (borderTimer > 0) {
      stroke(35, 76, 125);
      strokeWeight(3);
      noFill();
      rect(rankBtnX, rankBtnY, rankBtnW, rankBtnH, rankBtnR);
      borderTimer -= 1;
    }
  }

}

void keyPressed() {
  if (typing) {
    // criando o comportamento de delecao. substring retorna uma parte da string original
    // entao colocando o endIndex com -1 retorna o input sem a ultima palavra
    if (keyCode == BACKSPACE) {
      if (userInput.length() > 0) {
        userInput = userInput.substring(0, userInput.length() - 1);
      }
    } else if (keyCode == ENTER || keyCode == RETURN) {
      processInput(userInput);
    } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && keyCode != KeyEvent.VK_CAPS_LOCK && keyCode != KeyEvent.VK_META) {
      // key = tecla digitada pelo usuario
      userInput += key;
    }
  }
}

void processInput(String input) {
  println(currentQuestion + " submitted: " + input);
  questionCounter += 1;

  newRow.setString(currentQuestion, userInput);
  saveTable(table, "data/new.csv");
  userInput = "";
}

void getResults(List<Map<String, Object>> results) {
  if (gotResults == false) {
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
      text(showedResults.get(i), 25, y);
      y += 20;
    }
    //showedResults = true;
  }
}


String askAI(String prompt) {
  PostRequest post = new PostRequest("http://localhost:8000/ask");
  post.addHeader("Content-Type", "application/json");

  String json = "{\"prompt\": \"" + prompt + "\"}";
  post.addData(json);
  post.send();

  String content = post.getContent();
  String reply = "";
  
  JSONObject jsonObj = parseJSONObject(content);
  if (jsonObj != null) {
    reply = jsonObj.getString("response");
  }
  gotResponse = true;
  state = "showingTips";
  
  return reply;
}

void generateTips() {
  tips = askAI("Quanto de carbono a queima da gasolina emite?");
  state = "showingTips";
}

void showTips(String tips) {
  if (tips != null) {
    fill(50);
    text(tips, 10, 10, width - 20, height - 20);
  }
}
