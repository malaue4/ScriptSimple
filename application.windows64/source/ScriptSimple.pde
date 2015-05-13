import java.awt.Rectangle;
import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.StringSelection;
PFont f;
Rectangle rect0, rect1, rect2, rectDel, rectCol0, rectCol1, rectCol2;
int EMaks = 35, ENu = 0;
int w=1000, h=600;
PImage shade;
PImage gridImg;
PImage bgKnapper;
int trykX, trykY = 0;
int cursorIndex = 0;
int codeX = width-10;
int codeY = 0;
String code;
int punkt = -1;
int problem = 0;
float problem_y = h;
String kant = "";
boolean tryk, traek, valgt = false, paint = false;
Shape[] El = new Shape[EMaks];
Shape Elo, None, Copy;
int colorPicker = 0;
color[] colors = {
 color(0), color(0,255,0), color(0,255,64), color(0,255,128), color(0,255,196), color(0,255,255), color(0,196,255), color(0,128,255), color(0,64,255), color(0,0,255)
,color(64), color(64,196,0), color(64,196,64), color(64,196,128), color(64,196,196), color(64,196,255), color(48,147,196), color(32,98,196), color(16,49,196), color(0,0,196)
,color(128), color(128,128,0), color(128,128,64), color(128,128,128), color(128,128,196), color(128,128,255), color(96,96,128), color(64,64,128), color(32,32,128), color(0,0,128)
,color(196), color(196,64,0), color(196,64,64), color(196,64,128), color(196,64,196), color(196,64,255), color(147,48,64), color(98,32,64), color(49,16,64), color(0,0,64)
,color(255), color(255,0,0), color(255,0,64), color(255,0,128), color(255,0,196), color(255,0,255), color(196,0,0), color(128,0,0), color(64,0,0), color(0,0,0)};

color fillCol;
color strokeCol;
int timer = hour()*3600+minute()*60+second();

Sheet root;
Sheet ohSheet;
Sheet ohSheet2;
Sheet ohKnapper;
Sheet ohPicker;
int sheetsNum = 5;
Sheet[] sheets = new Sheet[sheetsNum];

public void setup() {
  size(w, h, P2D);
  shade = createImage(32, 32, ARGB);
  shade.loadPixels();
  float step = 255.0/32.0;
  for (int i = 0; i < shade.pixels.length; i++) {
    shade.pixels[i] = color(0, int((i / shade.width)*step)); 
  }
  shade.updatePixels();
  gridImg = loadImage("grid.png");
  root = new Sheet(0,0,0,w,h);
  ohSheet = new Sheet(180, 10, 2, 775, 580);
  ohSheet.col = color(196,255);
  ohSheet2 = new Sheet(200, 100, 4, 100, 180);
  ohKnapper = new Sheet(0, 0, 2, int(w*0.17), h);
  ohKnapper.col = color(128,255);
  ohPicker = new Sheet(0, 520, 4, int(w*0.16), 80);
  ohPicker.col = color(255,255);
  sheets[0] = root; sheets[2] = ohSheet; sheets[3] = ohSheet2;
  sheets[1] = ohKnapper; sheets[4] = ohPicker;
  bgKnapper = loadImage("bg_knapper2.png");
  fillCol = color(255, 255, 255, 255);
  strokeCol = color(0, 0, 0, 255);
  f = createFont("Arial", 21, true);
  textFont(f, 21);
  rect0 = new Rectangle(0, 0, int(w*0.17), int(h*0.235));
  rect1 = new Rectangle(0, int(h*0.235), int(w*0.17), int(h*0.235));
  rect2 = new Rectangle(0, int(h*0.470), int(w*0.17), int(h*0.235));
  rectDel = new Rectangle(0,0, int(w*0.170), h);
  rectCol0 = new Rectangle(int(w*0.019), int(h*0.723), int(w*0.138), int(h*0.139));
  rectCol1 = new Rectangle(int(w*0.022), int(h*0.88), int(w*0.055), int(h*0.063));
  rectCol2 = new Rectangle(int(w*0.101), int(h*0.88), int(w*0.055), int(h*0.063));
}

public void mousePressed() {
  if (colorPicker > 0){
    if (!ohPicker.rect.contains(mouseX, mouseY)){
      colorPicker = 0;
    } else {
      int mx,my;
      mx = (mouseX-ohPicker.rect.x)/16;
      my = (mouseY-ohPicker.rect.y)/16;
      println(mx, my, mx+10*my);
      if (colorPicker == 1){
        fillCol = colors[mx+10*my];
      } else {
        strokeCol = colors[mx+10*my];
      }
    }
  } else {
    if (rectCol1.contains(mouseX, mouseY)){
      colorPicker = 1;
    }
    if (rectCol2.contains(mouseX, mouseY)){
      colorPicker = 2;
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
  } else if (rectCol0.contains(mouseX, mouseY)) {
    paint = true;
  } else {
    Shape tempElo = None;
    for (int i = 0; i < ENu; i++) {
      if ( El[i].isInside(mouseX, mouseY) ) {
        tempElo = El[i];
        trykX = El[i].posX - mouseX;
        trykY = El[i].posY - mouseY;
        traek = true;
        kant = tempElo.atEdge(mouseX, mouseY, false);
        punkt = tempElo.atVertex(mouseX, mouseY, false);
      }
    }
    Elo = tempElo;
  }
  valgt = traek;
}

public void mouseReleased() {
  if (rectDel.contains(mouseX, mouseY)) {
    if (traek) {
      //reorder list, if the shape removed was in the middle
      removeShape(Elo);
      Elo = None;
      valgt = false;
    }
  }
  if(paint){
    for(int i=0; i<ENu; i++){
      if(El[i].isInside(mouseX, mouseY)){
        El[i].fillColor = fillCol;
        El[i].strokeColor = strokeCol;
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
      println("pasta");
      Elo = pasteShape();
      valgt = true;
    }
  } else {
    if(key == ENTER){
      Toolkit toolkit = Toolkit.getDefaultToolkit();
      Clipboard clipboard = toolkit.getSystemClipboard();
      StringSelection strSel = new StringSelection(generateCode());
      clipboard.setContents(strSel, null);
      println("Koden er i udklipsholderen");
    }
    if(key == TAB){
      problem = 1 - problem;
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
  if (mouseX > codeX-25) {
    int codeHeight = 1;
    for(char c : code.toCharArray()) {
      if(c=='\n') { codeHeight++; }
    }
    codeY = constrain(codeY+event.getCount()*5, 0, max(0, codeHeight*32-height));
  }
}
