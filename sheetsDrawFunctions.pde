void ohSheetDraw(){
  // The arrows that indicate the axis
  // the x-axis
  int x0, y0, x1, y1;
  x0 = ohSheet.rect.x; y0 = ohSheet.rect.y;
  x1 = x0 + ohSheet.rect.width-5; y1 = y0 + ohSheet.rect.height-5;
  stroke(0, 0, 196);
  fill(0, 0, 196);
  strokeWeight(2);
  line(x0, y0, x1, y0);
  triangle(x1, y0, x1+4, y0, x1, y0+4);
  text('x', x1-10, y0);
  // the y-axis
  stroke(196,0,0);
  fill(196,0,0);
  line(x0, y0, x0, y1);
  triangle(x0, y1, x0+4, y1, x0, y1+4);
  text('y', x0+3, y1-26);
  strokeWeight(1);
  
  // We iterate over the shapes
  cursorIndex = 0;
  for(int k = 0; k < ENu; k++) {
    // We draw the current shape
    El[k].draw(""+(k+1));
    if (valgt) {
      if (El[k] == Elo) {
        // If this shape is selected, then draw a border around it.
        noFill();
        stroke(96);
        rectMode(CORNERS);
        strokeWeight(1);
        rect(min(Elo.x), min(Elo.y), max(Elo.x), max(Elo.y));
        Elo.atEdge(mouseX, mouseY, true);
        // If it is a triangle then also draw small circles around the borders
        if (Elo.type == 2) {
          Elo.drawVertex();
          Elo.atVertex(mouseX, mouseY, true);
        }
      }
    }
  }
}
void ohCodeDraw(){
  // Generate the code string
  code = generateCode();
  // Adjust the size of ohCode, so it fits the code.
  ohCode.rect.height = calculateCodeHeight(code)+20;
  // Draw the code string
  textAlign(LEFT, TOP);
  fill(0);
  text(code, ohCode.rect.x+10, ohCode.rect.y+10);
  // Slide the code sheet out, TAB has been pressed or the mouse is over it.
  if (codeShow || mouseX > ohCode.rect.x) {
    ohCode.rect.x = (ohCode.rect.x+min(ohSheet.rect.x+ohSheet.rect.width+10, w-470))/2;
  } else {
    ohCode.rect.x = (ohCode.rect.x+ohSheet.rect.x+ohSheet.rect.width+10)/2;
  }
}
void ohSidePanelDraw(){
  // Draws a border around the clickable areas, if the mouse hovers over them.
  noFill();
  strokeWeight(1);
  stroke(#000000);
  if (rect0.contains(mouseX, mouseY)) {
    rect(rect0.x, rect0.y, rect0.width, rect0.height);
  } else if (rect1.contains(mouseX, mouseY)) {
    rect(rect1.x, rect1.y, rect1.width, rect1.height);
  } else if (rect2.contains(mouseX, mouseY)) {
    rect(rect2.x, rect2.y, rect2.width, rect2.height);
  }
}
void ohColorDraw(){
  // the example color thing
  shape(shBucket, rectCol0.x, rectCol0.y);
  fill(fillCol);
  stroke(strokeCol);
  strokeWeight(4);
  shape(shPaint, rectCol0.x, rectCol0.y);
  
  // The color selection fields
  noStroke();
  fill(fillCol);
  rect(rectCol1.x, rectCol1.y, rectCol1.width, rectCol1.height);
  fill(strokeCol);
  rect(rectCol2.x, rectCol2.y, rectCol2.width, rectCol2.height);
  
  // Draws a border around the clickable areas, if the mouse hovers over them.
  noFill();
  strokeWeight(1);
  stroke(#000000);
  if (rectCol0.contains(mouseX, mouseY)) {
    rect(rectCol0.x, rectCol0.y, rectCol0.width, rectCol0.height);
  } else if (rectCol1.contains(mouseX, mouseY)) {
    rect(rectCol1.x-1, rectCol1.y-1, rectCol1.width+1, rectCol1.height+1);
  } else if (rectCol2.contains(mouseX, mouseY)) {
    rect(rectCol2.x-1, rectCol2.y-1, rectCol2.width+1, rectCol2.height+1);
  }
}
void ohPickerDraw(){
  // If the color picker has been opened, then slide it into view
  if (colorPicker > 0) {
    ohPicker.rect.x = (ohPicker.rect.x)/2;
  } else {
    ohPicker.rect.x = (ohPicker.rect.x-165)/2;
  }
  
  rectMode(CORNER);
  int j = 0;
  stroke(0);
  strokeWeight(1);
  // Draws all the pretty colors!
  for (color c : colors){
    fill(c);
    rect(ohPicker.rect.x+16*(j%10), ohPicker.rect.y+16*(j/10), 16, 16);
    j++;
  }
}
