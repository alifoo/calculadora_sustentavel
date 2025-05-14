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
int nextBtnX, nextBtnY, nextBtnW, nextBtnH, nextBtnR; // Next button dimensions
int questionCounter = 0;
String currentInfo = "";
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


String[][] questions = {
  // Pergunta, Opção 1, Opção 2, Opção 3, Pontuação 1, 2, 3
  { "Com que frequência você consome carne vermelha?",
    "Todos os dias", "Algumas vezes por semana", "Raramente ou nunca", "1", "3", "5" },

  { "Você consome produtos orgânicos ou de agricultura familiar?",
    "Nunca", "Às vezes", "Sempre que possível", "1", "3", "5" },

  { "Como você geralmente vai até a universidade?",
    "Carro sozinho", "Carona ou app", "Transporte público ou bicicleta/a pé", "1", "2", "5" },

  { "Com que frequência você usa transporte público ou modos ativos?",
    "Quase nunca", "Algumas vezes/semana", "Quase sempre", "1", "3", "5" },

  { "Você fecha o chuveiro ao se ensaboar?",
    "Nunca", "Às vezes", "Sempre", "1", "3", "5" },

  { "Quanto tempo dura seu banho?",
    "Mais de 15 minutos", "10-15 minutos", "Menos de 10 minutos", "1", "3", "5" },

  { "Você desliga luzes e eletrônicos quando não usa?",
    "Nunca", "Às vezes", "Sempre", "1", "3", "5" },

  { "Você usa lâmpadas LED ou de baixo consumo?",
    "Não sei / Não uso", "Algumas", "Sim, todas", "1", "3", "5" },

  { "Você separa o lixo reciclável?",
    "Nunca", "Às vezes", "Sempre", "1", "3", "5" },

  { "Você evita uso de descartáveis?",
    "Não me preocupo", "Tento evitar às vezes", "Evito sempre", "1", "3", "5" }
};

int selectedAnswer = -1; // No answer selected initially
boolean[] answered = new boolean[questions.length]; // Track if each question has been answered

int currentQuestion = 0;
int[] answers = new int[questions.length];
int[] points = new int[questions.length];
boolean done = false;


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

  nextBtnW = 150;
  nextBtnH = 40;
  nextBtnX = width - 200;
  nextBtnY = height - 130;
  nextBtnR = 28;

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

    if (userInput.length() > 0) {
      text("Texto atual de input: " + userInput, width / 2, inputY + 80);
    }
  } else if (state == "answeringQuestions") {
    if (currentQuestion < questions.length) {
      showQuestion();
    } else {
      if (!done) {
        //salvarCSV();
        done = true;
      }
      //showResult();
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
  } else if (state == "showingLeaderboard") {

  }
  verifyMouseOver();
}

void showQuestion() {
  String[] q = questions[currentQuestion];

  fill(0);
  textAlign(CENTER, CENTER);
  text("Questão " + (currentQuestion + 1) + "/" + questions.length, width / 2, 120);
  
  textAlign(CENTER, CENTER);
  text(q[0], width/2, 160);

  for (int i = 0; i < 3; i++) {
    int y = 260 + i * 80; // espacamento vertical uniforme com base na opcao
    
    // highlight da questao selecionada
    if (selectedAnswer == i) {
      fill(135, 193, 255, 100);
      stroke(0, 100, 255);
      strokeWeight(2);
    } else {
      fill(245);
      stroke(150);
      strokeWeight(1);
    }
    
    // option box
    rect(width/2 - 350, y, 700, 60, 10);
    
    // option text
    fill(0);
    textAlign(LEFT, CENTER);
    text(q[i + 1], width/2 - 330, y + 30);
    textAlign(CENTER, CENTER);
  }

  if (selectedAnswer != -1) {
    drawButton(nextBtnX, nextBtnY, nextBtnW, nextBtnH, nextBtnR, "Próxima");
  }
}

void handleQuestionInteraction() {
  for (int i = 0; i < 3; i++) {
    int y = 260 + i * 80;
    if (mouseX > width/2 - 350 && mouseX < width/2 + 350 && 
        mouseY > y && mouseY < y + 60) {
      selectedAnswer = i;
      
      answers[currentQuestion] = i;
      
      String[] q = questions[currentQuestion];
      points[currentQuestion] = Integer.parseInt(q[i + 4]);
      
      answered[currentQuestion] = true;
      return;
    }
  }

  if (selectedAnswer != -1 && 
      mouseX > nextBtnX && mouseX < nextBtnX + nextBtnW && 
      mouseY > nextBtnY && mouseY < nextBtnY + nextBtnH) {
    
    if (currentQuestion < questions.length - 1) {
      currentQuestion++;
      selectedAnswer = -1; // reseta selecao para a proxima questao
      
      // caso a questao ja tenha sido respondida (se implementarmos botao de voltar)
      if (answered[currentQuestion]) {
        selectedAnswer = answers[currentQuestion];
      }
    } else {
      saveResults();
      state = "waitingResults";
    }
  }
}

void saveResults() {
  int totalScore = 0;
  for (int i = 0; i < points.length; i++) {
    totalScore += points[i];
  }
  
  // pega row do user atual (ultima)
  TableRow row = table.getRow(table.getRowCount() - 1);
  
  // add total score se n existir
  table.checkColumnIndex("total_score");
  
  row.setInt("total_score", totalScore);
  
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

void updateAnalysisResults() {
  analysis_results.clear();
  
  Map<String, Integer> categoryScores = new HashMap<>();
  
  categoryScores.put("Alimentação", points[0] + points[1]);
  categoryScores.put("Transporte", points[2] + points[3]);
  categoryScores.put("Água", points[4] + points[5]);
  categoryScores.put("Energia", points[6] + points[7]);
  categoryScores.put("Resíduos", points[8] + points[9]);
  
  for (Map.Entry<String, Integer> entry : categoryScores.entrySet()) {
    Map<String, Object> result = new HashMap<>();
    result.put("pergunta", entry.getKey());
    result.put("pontos", entry.getValue());
    analysis_results.add(result);
  }
  
  gotResults = true;
}

// funcao para gerar as dicas personalizadas ao estudante
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
  promptBuilder.append("Dê no máximo 5 sugestões práticas e objetivas.");
  
  tips = askAI(promptBuilder.toString());
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
    if (!gotResults) {
      getResults(analysis_results);
      gotResults = true;
    }
    state = "showingResults";
  }

  if (mouseOver(dicasBtnX, dicasBtnY, dicasBtnW, dicasBtnH) && state == "showingResults") {
    state = "loadingTips";
  }

  if (mouseOver(rankBtnX, rankBtnY, rankBtnW, rankBtnH) && state == "showingResults") {
    state = "showingLeaderboard";
  }

  if (state == "showingTips" && mouseOver(width/2 - 150, height - 80, 300, 40)) {
    state = "showingResults";
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
  if (mouseOver(dicasBtnX, dicasBtnY, dicasBtnW, dicasBtnH) && state == "showingResults") {
    mouseOverStroke(dicasBtnX, dicasBtnY, dicasBtnW, dicasBtnH, dicasBtnR);
  }
  if (mouseOver(rankBtnX, rankBtnY, rankBtnW, rankBtnH) && state == "showingResults") {
    mouseOverStroke(rankBtnX, rankBtnY, rankBtnW, rankBtnH, rankBtnR);
  }
  if (state == "answeringQuestions" && selectedAnswer != -1) {
    if (mouseOver(nextBtnX, nextBtnY, nextBtnW, nextBtnH)) {
      mouseOverStroke(nextBtnX, nextBtnY, nextBtnW, nextBtnH, nextBtnR);
    }
  }
  if (state == "showingTips" && mouseOver(width/2 - 150, height - 80, 300, 40)) {
    mouseOverStroke(width/2 - 150, height - 80, 300, 40, 28);
  }
}

boolean mouseOver(int x, int y, int w, int h) {
  return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
}

void mouseOverStroke(int x, int y, int w, int h, int r) {
  noFill();
  stroke(135, 193, 255);
  strokeWeight(3);
  rect(x,y,w,h,r);
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
    text("Seu resultado foi:", width / 2, 90);
    for (Map<String, Object> result : results) {
      String msg = "+ " + result.get("pontos") + " pts devido a seu " + result.get("pergunta");
      showedResults.append(msg);
    }
    int y = 120;
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
  generatePersonalizedTips();
  state = "showingTips";
}

void showTips(String tips) {
  if (tips != null) {
    float boxW = width * 0.8;
    float boxX = (width - boxW) / 2;
    float boxY = 100;
    
    fill(245);
    stroke(150);
    strokeWeight(1);
    rect(boxX - 20, boxY - 20, boxW + 40, height - 200, 10);
    
    fill(0);
    textAlign(CENTER, TOP);
    textSize(24);
    text("Dicas Personalizadas de Sustentabilidade", width/2, boxY);
    
    textAlign(LEFT, TOP);
    textSize(20);
    text(tips, boxX, boxY + 50, boxW, height - 280);
    
    textAlign(CENTER, CENTER);
    drawButton(width/2 - 150, height - 80, 300, 40, 28, "Voltar aos Resultados");
  }
}
