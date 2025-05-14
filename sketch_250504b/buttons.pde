void checkButtonHover() {
  if (mouseOver(exportPdfBtnX, exportPdfBtnY, exportPdfBtnW, exportPdfBtnH)) {
    mouseOverStroke(exportPdfBtnX, exportPdfBtnY, exportPdfBtnW, exportPdfBtnH, exportPdfBtnR);
  }
  if (mouseOver(exportSheetBtnX, exportSheetBtnY, exportSheetBtnW, exportSheetBtnH)) {
    mouseOverStroke(exportSheetBtnX, exportSheetBtnY, exportSheetBtnW, exportSheetBtnH, exportSheetBtnR);
  }
  if (mouseOver(tipsBtnX, tipsBtnY, tipsBtnW, tipsBtnH)) {
    mouseOverStroke(tipsBtnX, tipsBtnY, tipsBtnW, tipsBtnH, tipsBtnR);
  }
  if (mouseOver(rankBtnX, rankBtnY, rankBtnW, rankBtnH)) {
    mouseOverStroke(rankBtnX, rankBtnY, rankBtnW, rankBtnH, rankBtnR);
  }
}

void drawTTSButton(int x, int y, int w, int h, int r) {
  fill(245);
  stroke(150);
  strokeWeight(1);
  rect(x, y, w, h, r);
  
  // speaker (tem highlight mas ainda sem loading)
  imageMode(CENTER);
  if (isSpeaking) {
    tint(47, 57, 17);
  } else {
    tint(100, 100);
  }
  image(speakerIcon, x + w/2, y + h/2);
  noTint();

  if (isSpeaking) {
    noFill();
    stroke(47, 57, 17);
  }
}
