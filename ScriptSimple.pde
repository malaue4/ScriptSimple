import java.awt.Rectangle;
import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.StringSelection;
PFont codeFont;
Rectangle rect0, rect1, rect2, rectCol0, rectCol1, rectCol2;
int EMaks = 35, ENu = 0;
int w=1000, h=600;
PImage shade;
PShape shBucket;
PShape shPaint;
int trykX, trykY = 0;
int cursorIndex = 0;
String code;
int punkt = -1;
boolean codeShow = false;
String kant = "";
boolean tryk, traek, valgt = false, paint = false;
float xMul, yMul;
Shape[] El = new Shape[EMaks];
Shape Elo, None, Copy; // The None variable is never set. As it shouldn't be.
int colorPicker = 0;
color[] colors = {
 color(0), color(0,255,0), color(0,255,64), color(0,255,128), color(0,255,196), color(0,255,255), color(0,196,255), color(0,128,255), color(0,64,255), color(0,0,255)
,color(64), color(64,196,0), color(64,196,64), color(64,196,128), color(64,196,196), color(64,196,255), color(48,147,196), color(32,98,196), color(16,49,196), color(0,0,196)
,color(128), color(128,128,0), color(128,128,64), color(128,128,128), color(128,128,196), color(128,128,255), color(96,96,128), color(64,64,128), color(32,32,128), color(0,0,128)
,color(196), color(196,64,0), color(196,64,64), color(196,64,128), color(196,64,196), color(196,64,255), color(147,48,64), color(98,32,64), color(49,16,64), color(0,0,64)
,color(255), color(255,0,0), color(255,0,64), color(255,0,128), color(255,0,196), color(255,0,255), color(196,0,0), color(128,0,0), color(64,0,0), color(0,0,0)};

color fillCol;
color strokeCol;
float wobble = 0.5;
float wobbleSpeed = 0;
int timer = hour()*3600+minute()*60+second();

Sheet root;
Sheet ohSheet;
Sheet ohCode;
Sheet ohSidePanel;
Sheet ohColor;
Sheet ohPicker;
int amount_of_sheets = 6; //remember to change this if sheets are added or removed
Sheet[] sheets = new Sheet[amount_of_sheets];

public void setup() {
  // The window size is set
  size(w, h, P2D);
  
  // images are loaded/rendered into memory
  shade = renderShade();
  shBucket = loadShape("bucket.svg");
  // the paint part of the bucket ctor graphic is kept separatly,
  shPaint = shBucket.getChild("paintthing");
  // and this line makes the fill() and stroke() colors be used instead of the picture's own colors. 
  shPaint.disableStyle();

  // Sheet objects are instantiated
  root = new Sheet(0,0,w,h,0);
  ohSheet = new Sheet(180, 10, 775+max(0, w-180-775-480), h-20, 2);
  ohSheet.col = color(196,255);
  ohSheet.img = loadImage("bgGrid.png");
  ohCode = new Sheet(w, 0, w/2, h, 4);
  ohColor = new Sheet(0, h-177, 170, 177, 2);
  ohColor.img = loadImage("bgColorPicker.png");
  ohSidePanel = new Sheet(0, 0, 170, h-ohColor.rect.height, 2);
  ohSidePanel.img = loadImage("bg_knapper2.png");
  ohPicker = new Sheet(0, h-80, 160, 80, 4);
  ohPicker.col = color(255,255);
  
  // They are then added to an array for access in for loop
  sheets[0] = root; sheets[2] = ohSheet; sheets[3] = ohCode;
  sheets[1] = ohSidePanel; sheets[4] = ohColor; sheets[5] = ohPicker;
  
  // The rectangles are instatiated
  rect0 = new Rectangle(0, 0, 170, ohSidePanel.rect.height/3);
  rect1 = new Rectangle(0, 1*ohSidePanel.rect.height/3, 170, ohSidePanel.rect.height/3);
  rect2 = new Rectangle(0, 2*ohSidePanel.rect.height/3, 170, ohSidePanel.rect.height/3);
  rectCol0 = new Rectangle(ohColor.rect.x+20, ohColor.rect.y+12, 130, 80);
  rectCol1 = new Rectangle(ohColor.rect.x+21, ohColor.rect.y+105, 58, 35);
  rectCol2 = new Rectangle(ohColor.rect.x+91, ohColor.rect.y+105, 58, 35);
  
  // The default fill and stroke colors for the Shape objects is set
  fillCol = color(255, 255, 255, 255);
  strokeCol = color(0, 0, 0, 255);
  
  // The font is loaded and applied
  codeFont = createFont("Arial", 21, true);
  textFont(codeFont);
}

public void mousePressed() {
  if (colorPicker > 0){ // If the color palette window is open.
    if (!ohPicker.rect.contains(mouseX, mouseY)){ // If the user clicked outside the color palette window...
      colorPicker = 0; // close the color palette window.
    } else {
      int colorIndex;
      colorIndex = (mouseX-ohPicker.rect.x)/16 + 
      (mouseY-ohPicker.rect.y)/16*10; // Find the cell
      println(mx, my, mx+10*my);
      if (colorPicker == 1){
        fillCol = colors[mx+10*my];
      } else {
        strokeCol = colors[mx+10*my];
      }
    }
  } else {
    if (rectCol0.contains(mouseX, mouseY)) {
      paint = true; // The color bucket was pressed.
    } else if (rectCol1.contains(mouseX, mouseY)){
      colorPicker = 1; // The fill color picker was pressed.
    } else if (rectCol2.contains(mouseX, mouseY)){
      colorPicker = 2; // The stroke color picker was pressed.
    }
  }
  boolean new_Elo = false;
  if (ENu < EMaks) {
    // hvis musen er over en af knapperne, så lav en ny figur
    if (rect0.contains(mouseX, mouseY)) {
      Elo = new Shape(0);
      new_Elo = true;
    } else if (rect1.contains(mouseX, mouseY)) {
      Elo = new Shape(1);
      new_Elo = true;
    } else if (rect2.contains(mouseX, mouseY)) {
      Elo = new Shape(2);
      new_Elo = true;
    }
  }
  if (new_Elo) {
    El[ENu] = Elo;
    ENu++;
    trykX = 0; 
    trykY = 0;
    traek = true;
  } else {
    for (int i = ENu-1; i >= 0; i--) {
      if ( El[i].isInside(mouseX, mouseY) ) {
        Elo = El[i];
        trykX = El[i].posX - mouseX;
        trykY = El[i].posY - mouseY;
        traek = true;
        kant = Elo.atEdge(mouseX, mouseY, false);
        punkt = Elo.atVertex(mouseX, mouseY, false);
        if(Elo.type == 2 && !kant.equals("")){
          if(Elo.getWidth() == 0){ xMul = 0.5; } else {
            xMul = (getMid(Elo.x)-min(Elo.x))/float(Elo.getWidth());
          }
          if(Elo.getHeight() == 0){ yMul = 0.5; } else {
            yMul = (getMid(Elo.y)-min(Elo.y))/float(Elo.getHeight());
          }
        }
        break;
      }
    }
  }
  valgt = traek;
}

public void mouseReleased() {
  if (!ohSheet.rect.contains(mouseX, mouseY)) {
    if (traek) {
      //reorder list, if the shape removed was in the middle
      removeShape(Elo);
      Elo = None;
      valgt = false;
    }
  }
  // If we are holding a glob of paint...
  if(paint){
    // Then find the top most shape and paint it!
    for(int i=ENu-1; i>=0; i--){
      if(El[i].isInside(mouseX, mouseY)){
        El[i].fillColor = fillCol;
        El[i].strokeColor = strokeCol;
        break;
      }
    }
    paint = false;
  }
  traek = false;
  kant = "";
  punkt = -1;
}

public void keyPressed(KeyEvent ke){
  if(ke.isControlDown()){
    if(char(keyCode) == 'C' && valgt){
      println("copy");
      copyShape(Elo);
    }
    if(char(keyCode) == 'V' && Copy != None){
      if(ENu < EMaks){
      println("pasta");
      Elo = pasteShape();
      valgt = true;
      } else { println("PASTA OVERWHELMING D:"); }
    }
  } else {
    if(key == ENTER){
      Toolkit toolkit = Toolkit.getDefaultToolkit();
      Clipboard clipboard = toolkit.getSystemClipboard();
      StringSelection strSel = new StringSelection(generateCode());
      clipboard.setContents(strSel, null);
      println("Koden er i udklipsholderen, men den bliver måske slettet hvis du lukker programmet.");
    }
    if(key == TAB){
      codeShow = !codeShow;
    }
    if(valgt){
      if(key == DELETE){
        removeShape(Elo);
        valgt = false;
        Elo = None;
      }
      if(char(keyCode) == 'O'){
        for(int i = 0; i < ENu; i++){
          if(El[i] == Elo){
            if(i>0){
              El[i] = El[i-1];
              El[i-1] = Elo;
            }
            break;
          }
        }
      }else if(char(keyCode) == 'L'){
        for(int i = 0; i < ENu; i++){
          if(El[i] == Elo){
            if(i<ENu-1){
              El[i] = El[i+1];
              El[i+1] = Elo;
            }
            break;
          }
        }
      }
    }
  }
}

public void mouseWheel(MouseEvent event){
  if (mouseX > ohCode.rect.x) {
    ohCode.rect.y = constrain(ohCode.rect.y-event.getCount()*5, min(0, height-ohCode.rect.height), 0);
  }
}
