public void draw() {
  background(128);
  //Det er her at figurenes form bliver ændret.
  //kant og punkt bliver indstillet i mousePressed() og mouseReleased() i ScriptSimple.pde
  if (mousePressed && traek == true) {
    if (punkt >= 0) {
      Elo.setVertex(punkt, mouseX, mouseY);
    } else if (kant.equals("")) {
      Elo.setPosX(mouseX + trykX);
      Elo.setPosY(mouseY + trykY);
    } else {
      Elo.setWidth(mouseX, kant);
      Elo.setHeight(mouseY, kant);
    }
  }

  ohSheet2.rect.setBounds(codeX-10, 0, width, height);
  for(int i=1; i<sheetsNum; i++) {
    for(int j=i; j<sheetsNum; j++) {
      sheets[j].drawShadow(sheets[i-1].rect, int(sheets[j].z-sheets[i-1].z));
    }
    sheets[i].draw();
    if(sheets[i] == ohPicker){
      rectMode(CORNER);
      int j = 0;
      stroke(0);
      for (color c : colors){
        fill(c);
        rect(ohPicker.rect.x+16*(j%10), ohPicker.rect.y+16*(j/10), 16, 16);
        j++;
      }
    }
    if(sheets[i] == ohKnapper){
      //knapper
      image(bgKnapper, 0, 0);
      ellipseMode(CORNER);
      fill(fillCol);
      stroke(strokeCol);
      ellipse(34, 441, 110, 64);
      noStroke();
      fill(fillCol);
      rect(22, 528, 55, 38);
      fill(strokeCol);
      rect(101, 528, 55, 38);
      //tegn kant om knap når musen er over den
      noFill();
      if (traek) { 
        if (rectDel.contains(mouseX, mouseY)) {
          stroke(#FF0000);
          rect(rectDel.x, rectDel.y, rectDel.width, rectDel.height);
        }
      } else {
        stroke(1);
        if (rect0.contains(mouseX, mouseY)) {
          rect(rect0.x, rect0.y, rect0.width, rect0.height);
        } else if (rect1.contains(mouseX, mouseY)) {
          rect(rect1.x, rect1.y, rect1.width, rect1.height);
        } else if (rect2.contains(mouseX, mouseY)) {
          rect(rect2.x, rect2.y, rect2.width, rect2.height);
        } else if (rectCol0.contains(mouseX, mouseY)) {
          rect(rectCol0.x, rectCol0.y, rectCol0.width, rectCol0.height);
        } else if (rectCol1.contains(mouseX, mouseY)) {
          rect(rectCol1.x, rectCol1.y, rectCol1.width, rectCol1.height);
        } else if (rectCol2.contains(mouseX, mouseY)) {
          rect(rectCol2.x, rectCol2.y, rectCol2.width, rectCol2.height);
        }
      }
    }
    if(sheets[i] == ohSheet){
      //axer
      int x0, y0, x1, y1;
      x0 = sheets[i].rect.x; y0 = sheets[i].rect.y;
      x1 = x0 + sheets[i].rect.width-5; y1 = y0 + sheets[i].rect.height-5;
      image(gridImg, x0, y0);
      stroke(0, 0, 196);
      fill(0, 0, 196);
      strokeWeight(2);
      line(x0, y0, x1, y0);
      triangle(x1, y0, x1+4, y0, x1, y0+4);
      text('x', x1-10, y0);
      
      stroke(196,0,0);
      fill(196,0,0);
      line(x0, y0, x0, y1);
      triangle(x0, y1, x0+4, y1, x0, y1+4);
      text('y', x0+3, y1-26);
      strokeWeight(1);
      
      cursorIndex = 0;
      for(int k = 0; k < ENu; k++) {
        //tegn figuren
        El[k].draw(""+(k+1));
        if (valgt) {
          if (El[k] == Elo) {
        //hvis denne figur er valgt, så tegn en grå firkant omkring den
            noFill();
            stroke(96);
            rectMode(CORNERS);
            strokeWeight(1);
            rect(min(Elo.x), min(Elo.y), max(Elo.x), max(Elo.y));
            Elo.atEdge(mouseX, mouseY, true);
        //hvis det er en trekant, så tegn også små cirkler om hvert hjørne
            if (Elo.type == 2) {
              Elo.drawVertex();
              Elo.atVertex(mouseX, mouseY, true);
            }
          }
        }
      }
    }
  }
  
  if (colorPicker > 0) {
    ohPicker.rect.x = (ohPicker.rect.x)/2;
  } else {
    ohPicker.rect.x = (ohPicker.rect.x-165)/2;
  }
  //rect(codeX-10, 0, width, height);
  cursor(cursorIndex);
  code = generateCode();
  textAlign(LEFT, TOP);
  if (ENu == 0) {
    fill(128);
    code = "";
  } else {
    fill(0);
  }
  text(code, codeX, -codeY);
  if (problem == 1 || mouseX > codeX-25) {
    codeX = (codeX+int(w*0.5))/2;
  } else {
    codeX = (codeX+w-25)/2;
  }
}

