import java.awt.event.KeyEvent;
import java.io.*;
import java.net.*;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;
import http.requests.*;
import processing.video.*;
import processing.pdf.*;
import java.awt.Desktop;

PImage bg, startBg, tipsBg, speakerIcon;
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
int nextBtnX, nextBtnY, nextBtnW, nextBtnH, nextBtnR;
int pdfBtnX, pdfBtnY, pdfBtnW, pdfBtnH, pdfBtnR;
int openPdfBtnX, openPdfBtnY, openPdfBtnW, openPdfBtnH, openPdfBtnR;
int ttsBtnX, ttsBtnY, ttsBtnW, ttsBtnH, ttsBtnR;
int exportPdfBtnX, exportPdfBtnY, exportPdfBtnW, exportPdfBtnH, exportPdfBtnR;
int exportSheetBtnX, exportSheetBtnY, exportSheetBtnW, exportSheetBtnH, exportSheetBtnR;
int tipsBtnX, tipsBtnY, tipsBtnW, tipsBtnH, tipsBtnR;

boolean isSpeaking = false;
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
boolean exportingPDF = false;
String pdfFilename = "";
Movie loading;
boolean tipsGenerated = false;
boolean loadingMovieReady = false;
int lastClickTime = 0;
int doubleClickSpeed = 300;
int lastClickedOption = -1;
boolean sheetExported = false;
String sheetFilename = "";

HashMap<String, Float> emissoes = new HashMap<String, Float>();

// p armazenar a pegada de carbono calculada
float pegadaTotalDia = 0;
float percentualComparado = 0;
float[] pegadaPorCategoria = new float[7]; // float array pra salvar a pegada por categoria (para grafico) 

String[][] questions = {
  // pergunta, opção 1, opção 2, opção 3, pontuação 1, 2, 3
  { "Qual meio de transporte você usa predominantemente para chegar à faculdade?",
    "Carona ou App", "Transporte público", "Bicicleta/A pé", "1", "3", "5" },
  
  { "Com que frequência você usa transporte público?",
    "Quase nunca", "Algumas vezes por semana", "Quase sempre", "1", "3", "5" },
  
  { "Aproximadamente, quanto de deslocamento você percorre até seu ambiente escolar?",
    "Mais de 10 km", "5-10 km", "Menos de 5 km", "1", "3", "5" },
  
  { "Com que frequência você participa de aulas ou reuniões de forma remota para evitar deslocamento?",
    "Raramente", "Algumas vezes por semana", "Diariamente", "1", "3", "5" },
  
  { "Você separa resíduos recicláveis em casa e/ou em seu ambiente educacional?",
    "Não", "Às vezes", "Sim, sempre", "1", "3", "5" },
  
  { "Você opta por livros digitais ou impressos?",
    "Livros impressos", "Ambos", "Livros digitais", "1", "3", "5" },
  
  { "Você costuma comprar materiais acadêmicos (como livros ou calculadoras) de segunda mão ou emprestado?",
    "Não, prefiro comprar novos", "Às vezes", "Sempre que posso", "1", "3", "5" },
  
  { "Com que frequência você consome carne vermelha?",
    "Todos os dias", "Algumas vezes por semana", "Raramente ou nunca", "1", "3", "5" },
  
  { "Você já participou de campanhas de reciclagem ou doações dentro da faculdade?",
    "Nunca", "Uma vez ou outra", "Sim, com frequência", "1", "3", "5" },
  
  { "Você possui hábitos para economizar energia elétrica em casa?",
    "Não", "Às vezes", "Sim, sempre", "1", "3", "5" },
  
  { "Você utiliza lâmpadas LED ou outro tipo de iluminação eficiente?",
    "Não sei/Não uso", "Algumas", "Sempre", "1", "3", "5" },
  
  { "Você fecha o chuveiro ao se ensaboar?",
    "Nunca", "Às vezes", "Sempre", "1", "3", "5" },
  
  { "Quanto tempo dura seu banho?",
    "Mais de 15 minutos", "10-15 minutos", "Menos de 10 minutos", "1", "3", "5" },
  
  { "Com que frequência você compra roupas novas?",
    "Mais de uma vez por mês", "A cada dois meses", "Raramente", "1", "3", "5" }
};

boolean[] answered = new boolean[questions.length];
int currentQuestion = 0;
int[] answers = new int[questions.length];
int[] points = new int[questions.length];
boolean done = false;
int selectedAnswer = -1;
