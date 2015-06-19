public void draw() {
  background(128);
  //Det er her at figurenes form bliver ændret.
  //kant og punkt bliver indstillet i mousePressed() og mouseReleased() i ScriptSimple.pde
  if (mousePressed && traek == true) {
    if (punkt >= 0) { // hvis fat i et punkt, flyt punkt
      Elo.setVertex(punkt, mouseX, mouseY);
    } else if (kant.equals("")) { // hvis ikke fat i et kant, flyt Shape
      Elo.setPosX(mouseX + trykX);
      Elo.setPosY(mouseY + trykY);
    } else { // hvis fat i et kant, flyt kant
      Elo.setWidth(mouseX, kant);
      Elo.setHeight(mouseY, kant);
    }
  }

  // Iterate over all the sheets
  for(int i=1; i<amount_of_sheets; i++) {
    // Iterate over all the sheets "beneath" this one and draw a shadow on them, if there is a overlap.
    for(int j=i; j<amount_of_sheets; j++) {
      sheets[j].drawShadow(sheets[i-1].rect, int(sheets[j].z-sheets[i-1].z));
    }
    // Draw the sheet itself
    sheets[i].draw();
    if(sheets[i] == ohCode){
      // Does the code stuff
      ohCodeDraw();
    }else if(sheets[i] == ohPicker){
      // Deals with the color picker
      ohPickerDraw();
    }else if(sheets[i] == ohColor){
      // Handles the color preview
      ohColorDraw();
    }else if(sheets[i] == ohSidePanel){
      // This is where the shape buttons are
      ohSidePanelDraw();
    }else if(sheets[i] == ohSheet){
      // This is the main drawing area
      ohSheetDraw();
    }
  }
  
  // If a color is being dragged, why not show it?
  if(paint){
    wobbleSpeed += (1-wobble)*0.1;
    wobbleSpeed = constrain(wobbleSpeed, -1, 1);
    wobbleSpeed *= 0.94;
    wobble = constrain(wobble+wobbleSpeed+(-abs(pmouseX - mouseX) + abs(pmouseY - mouseY))/500.0, 0.25, 4);
    ellipseMode(CENTER);
    fill(fillCol);
    stroke(strokeCol);
    ellipse(mouseX, mouseY, 30*wobble, 30/wobble);
  }
  
  Hud.draw();
  // Actually change the mouse cursor
  cursor(cursorIndex);
}
