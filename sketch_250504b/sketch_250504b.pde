import java.awt.event.KeyEvent; 
String userInput = "";
StringList questionsList;
boolean typing = false;
int inputX, inputY, inputW, inputH; // dimensoes da text box de input
int questionCounter = 0;
String currentQuestion = "";
Table table;

void setup() {

  table = new Table();

  table.addColumn("id");
  table.addColumn("email");
  table.addColumn("curso");
  table.addColumn("nome");

  size(400, 300);
  inputX = 100;
  inputY = 120;
  inputW = 200;
  inputH = 30;
  
  questionsList = new StringList("email", "curso", "nome");
  
  textAlign(LEFT, CENTER);
  textSize(14);
}

void draw() {
  background(240);
  
  if (questionCounter < questionsList.size()) {
    if (typing) {
      fill(255);
      stroke(0, 0, 255); // borda azul se a box estiver ativa
    } else {
      fill(245);
      stroke(150);
    }
    rect(inputX, inputY, inputW, inputH);
    
    // exibe o texto input atual
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
  } else {
    text("Você inseriu todas as informações\nnecessárias para a avaliação.\nPor favor, aguarde um instante.", 105, 105);
  }
}

void mousePressed() {
  if (mouseX > inputX && mouseX < inputX + inputW && 
      mouseY > inputY && mouseY < inputY + inputH) {
    typing = true;
  } else {
    typing = false;
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
      typing = false;

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

  //TableRow newRow = table.addRow();
  //newRow.setInt("id", table.getRowCount() - 1);
  userInput = "";
}
