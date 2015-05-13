import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.awt.Rectangle; 
import java.awt.Toolkit; 
import java.awt.datatransfer.Clipboard; 
import java.awt.datatransfer.StringSelection; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ScriptSimple extends PApplet {





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
int[] colors = {
 color(0), color(0,255,0), color(0,255,64), color(0,255,128), color(0,255,196), color(0,255,255), color(0,196,255), color(0,128,255), color(0,64,255), color(0,0,255)
,color(64), color(64,196,0), color(64,196,64), color(64,196,128), color(64,196,196), color(64,196,255), color(48,147,196), color(32,98,196), color(16,49,196), color(0,0,196)
,color(128), color(128,128,0), color(128,128,64), color(128,128,128), color(128,128,196), color(128,128,255), color(96,96,128), color(64,64,128), color(32,32,128), color(0,0,128)
,color(196), color(196,64,0), color(196,64,64), color(196,64,128), color(196,64,196), color(196,64,255), color(147,48,64), color(98,32,64), color(49,16,64), color(0,0,64)
,color(255), color(255,0,0), color(255,0,64), color(255,0,128), color(255,0,196), color(255,0,255), color(196,0,0), color(128,0,0), color(64,0,0), color(0,0,0)};

int fillCol;
int strokeCol;
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
  float step = 255.0f/32.0f;
  for (int i = 0; i < shade.pixels.length; i++) {
    shade.pixels[i] = color(0, PApplet.parseInt((i / shade.width)*step)); 
  }
  shade.updatePixels();
  gridImg = loadImage("grid.png");
  root = new Sheet(0,0,0,w,h);
  ohSheet = new Sheet(180, 10, 2, 775, 580);
  ohSheet.col = color(196,255);
  ohSheet2 = new Sheet(200, 100, 4, 100, 180);
  ohKnapper = new Sheet(0, 0, 2, PApplet.parseInt(w*0.17f), h);
  ohKnapper.col = color(128,255);
  ohPicker = new Sheet(0, 520, 4, PApplet.parseInt(w*0.16f), 80);
  ohPicker.col = color(255,255);
  sheets[0] = root; sheets[2] = ohSheet; sheets[3] = ohSheet2;
  sheets[1] = ohKnapper; sheets[4] = ohPicker;
  bgKnapper = loadImage("bg_knapper2.png");
  fillCol = color(255, 255, 255, 255);
  strokeCol = color(0, 0, 0, 255);
  f = createFont("Arial", 21, true);
  textFont(f, 21);
  rect0 = new Rectangle(0, 0, PApplet.parseInt(w*0.17f), PApplet.parseInt(h*0.235f));
  rect1 = new Rectangle(0, PApplet.parseInt(h*0.235f), PApplet.parseInt(w*0.17f), PApplet.parseInt(h*0.235f));
  rect2 = new Rectangle(0, PApplet.parseInt(h*0.470f), PApplet.parseInt(w*0.17f), PApplet.parseInt(h*0.235f));
  rectDel = new Rectangle(0,0, PApplet.parseInt(w*0.170f), h);
  rectCol0 = new Rectangle(PApplet.parseInt(w*0.019f), PApplet.parseInt(h*0.723f), PApplet.parseInt(w*0.138f), PApplet.parseInt(h*0.139f));
  rectCol1 = new Rectangle(PApplet.parseInt(w*0.022f), PApplet.parseInt(h*0.88f), PApplet.parseInt(w*0.055f), PApplet.parseInt(h*0.063f));
  rectCol2 = new Rectangle(PApplet.parseInt(w*0.101f), PApplet.parseInt(h*0.88f), PApplet.parseInt(w*0.055f), PApplet.parseInt(h*0.063f));
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
    // hvis musen er over en af knapperne, s\u00e5 lav en ny figur
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
    if(PApplet.parseChar(keyCode) == 'C' && valgt){
      println("copy");
      copyShape(Elo);
    }
    if(PApplet.parseChar(keyCode) == 'V' && Copy != None){
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
      if(PApplet.parseChar(keyCode) == 'O'){
        for(int i = 0; i < ENu; i++){
          if(El[i] == Elo){
            if(i>0){
              El[i] = El[i-1];
              El[i-1] = Elo;
            }
            break;
          }
        }
      }else if(PApplet.parseChar(keyCode) == 'L'){
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
public class Sheet {
  Rectangle rect;
  Rectangle shadow;
  Rectangle parent;
  int resting_z;
  float z;
  int col;
  public Sheet(int x, int y, int z, int width, int height) {
    this.shadow = new Rectangle();
    this.parent = new Rectangle(0,0,1000,600);
    this.rect = new Rectangle(x, y, width, height);
    this.z = z;
    this.resting_z = z;
    this.col = color(64,64,185,127);
  }
  public void draw(){
    //this.z = (this.z*8+this.resting_z*2)/10;
    rectMode(CORNER);
    fill(this.col); noStroke();
    rect(this.rect.x, this.rect.y, this.rect.width, this.rect.height);
  }
  public void drawShadow(Rectangle area, int z){
    int x, y, w, h;
    //area is where the shadow can be drawn.
    //dz is the difference in z between this object
    //and the on the shadow lands on.
    this.shadow.setBounds(this.rect);
    this.shadow = this.shadow.intersection(area);
    if(this.shadow.isEmpty() == false){
      x = this.shadow.x;
      y = this.shadow.y;
      w = this.shadow.width;
      h = this.shadow.height;
      float intensity = 32*32/(32+z*4);
      int r = 2+z*2;
      noStroke();
      
      if(area.intersects(new Rectangle(this.rect.x-r, this.rect.y-r, r, r))){
        beginShape();
        texture(shade);
        vertex(x, y, 0, intensity);
        vertex(x-r, y, 0, 0);
        vertex(x-r*0.9f, y-r*0.4f, 0, 0);
        vertex(x-r*0.7f, y-r*0.7f, 0, 0);
        vertex(x-r*0.4f, y-r*0.9f, 0, 0);
        vertex(x, y-r, 0, 0);
        endShape();
      }
      if(area.intersects(new Rectangle(this.rect.x+this.rect.width, this.rect.y-r, r, r))){
        translate(x+w, y);
        rotate(PI*0.5f);
        beginShape();
        texture(shade);
        vertex(0, 0, 0, intensity);
        vertex(0-r, 0, 0, 0);
        vertex(0-r*0.9f, 0-r*0.4f, 0, 0);
        vertex(0-r*0.7f, 0-r*0.7f, 0, 0);
        vertex(0-r*0.4f, 0-r*0.9f, 0, 0);
        vertex(0, 0-r, 0, 0);
        endShape();
        resetMatrix();
      }
      if(area.intersects(new Rectangle(this.rect.x+this.rect.width, this.rect.y+this.rect.height, r, r))){
        translate(x+w, y+h);
        rotate(PI);
        beginShape();
        texture(shade);
        vertex(0, 0, 0, intensity);
        vertex(0-r, 0, 0, 0);
        vertex(0-r*0.9f, 0-r*0.4f, 0, 0);
        vertex(0-r*0.7f, 0-r*0.7f, 0, 0);
        vertex(0-r*0.4f, 0-r*0.9f, 0, 0);
        vertex(0, 0-r, 0, 0);
        endShape();
        resetMatrix();
      }
      if(area.intersects(new Rectangle(this.rect.x-r, this.rect.y+this.rect.height, r, r))){
        beginShape();
        texture(shade);
        vertex(x,         y+h,       0, intensity);
        vertex(x-r,       y+h,       0,  0);
        vertex(x-r*0.9f,   y+h+r*0.4f, 0,  0);
        vertex(x-r*0.7f,   y+h+r*0.7f, 0,  0);
        vertex(x-r*0.4f,   y+h+r*0.9f, 0,  0);
        vertex(x,         y+h+r,     0,  0);
        endShape();
      }
      if(area.intersects(new Rectangle(this.rect.x, this.rect.y-r, this.rect.width, r))){
        beginShape();
        texture(shade);
        vertex(x, y-r, 0, 0);
        vertex(x+w, y-r, 100, 0);
        vertex(x+w, y, 100, intensity);
        vertex(x, y, 0, intensity);
        endShape();
      }
      if(area.intersects(new Rectangle(this.rect.x+this.rect.width, this.rect.y-r, r, this.rect.height))){
        beginShape();
        texture(shade);
        vertex(x+w, y, 0, intensity);
        vertex(x+w+r, y, 100, 0);
        vertex(x+w+r, y+h, 100, 0);
        vertex(x+w, y+h, 0, intensity);
        endShape();
      }
      if(area.intersects(new Rectangle(this.rect.x, this.rect.y, this.rect.width, r))){
        beginShape();
        texture(shade);
        vertex(x, y+h, 0, intensity);
        vertex(x+w, y+h, 100, intensity);
        vertex(x+w, y+h+r, 100, 0);
        vertex(x, y+h+r, 0, 0);
        endShape();
      }
      if(area.intersects(new Rectangle(this.rect.x-r, this.rect.y, r, this.rect.height))){
        beginShape();
        texture(shade);
        vertex(x, y, 0, intensity);
        vertex(x-r, y, 0, 0);
        vertex(x-r, y+h, 0, 0);
        vertex(x, y+h, 0, intensity);
        endShape();
      }
    }
  }
}
public class Shape {
  int strokeColor, fillColor;
  int[] x;
  int[] y;
  int type, posX, posY;
  int vertexCount;
  //boolean done = false;
  public Shape(int type) {
    this.posX = 0; 
    this.posY = 0;
    if (type == 2) {
      this.vertexCount = 3;
      this.x = new int[3];
      this.y = new int[3];
      this.x[0] = 0; 
      this.y[0] =-50;
      this.x[1] = 50; 
      this.y[1] = 50;
      this.x[2] =-50; 
      this.y[2] = 50;
    } else {
      this.vertexCount = 2;
      this.x = new int[2];
      this.y = new int[2];
      this.x[0] = -50; 
      this.y[0] = -50;
      this.x[1] = 50; 
      this.y[1] = 50;
    }
    this.fillColor = fillCol;
    this.strokeColor = strokeCol;
    this.type = type;
  }

  public void draw(String label) {
    stroke(this.strokeColor);
    fill(this.fillColor);
    switch(this.type) {
    case 0:
      ellipseMode(CORNERS);
      ellipse(this.x[0], this.y[0], 
      this.x[1], this.y[1]);
      break;
    case 1:
      rectMode(CORNERS);
      rect(this.x[0], this.y[0], 
      this.x[1], this.y[1]);
      break;
    case 2:
      triangle(this.x[0], this.y[0], 
      this.x[1], this.y[1], 
      this.x[2], this.y[2]);
      break;
    }
    fill(0);
    textAlign(CENTER, CENTER);
    
    text(label, mean(this.x), mean(this.y));
  }
  
  public void drawVertex() {
    for (int i=0; i<this.vertexCount; i++) {
          ellipseMode(CENTER);
          noFill();
          stroke(128);
          ellipse(this.x[i], this.y[i], 6, 6);
    }
  }
  
  public int atVertex(int x, int y, boolean draw) {
    for (int i=0; i<this.vertexCount; i++) {
      if (dist(this.x[i], this.y[i], x, y) <= 4) {
        if (draw) { 
          ellipseMode(CENTER);
          noFill();
          stroke(0);
          ellipse(this.x[i], this.y[i], 8, 8);
          cursorIndex = 1;
        }
        return i;
      }
    }
    return -1;
  }

  public String atEdge(int x, int y, boolean draw) {
    // Finder ud af om koordinatet (x, y) er inden for 3 pixels af figurens kant
    int x1 = min(this.x);
    int y1 = min(this.y);
    int x2 = max(this.x);
    int y2 = max(this.y);
    String w = "";
    String h = "";
    noFill();
    stroke(0);
    rectMode(CORNERS);
    if (y1-3 < y && y < y2+3) {
      //rect(120, y1-3, 1000, y2+3);
      if (x < x1+3 && x1-3 < x) { 
        w = "l"; 
        if (draw) {
          rect(x1-3, y1-3, x1+3, y2+3);
        }
      }
      if (x < x2+3 && x2-3 < x) { 
        w = "r"; 
        if (draw) {
          rect(x2-3, y1-3, x2+3, y2+3);
        }
      }
    }
    if (x1-3 < x && x < x2+3) {
      //rect(x1-3, 0, x2+3, 1000);
      if (y < y1+3 && y1-3 < y) { 
        h = "t"; 
        if (draw) {
          rect(x1-3, y1-3, x2+3, y1+3);
        }
      }
      if (y < y2+3 && y2-3 < y) { 
        h = "b"; 
        if (draw) {
          rect(x1-3, y2-3, x2+3, y2+3);
        }
      }
    }
    String kant = w+h;
    if(draw){
      if     ("lb".equals(kant)) { 
        cursorIndex = 4;
      } else if ("rb".equals(kant)) { 
        cursorIndex = 5;
      } else if ("lt".equals(kant)) { 
        cursorIndex = 6;
      } else if ("rt".equals(kant)) { 
        cursorIndex = 7;
      } else if ("t".equals(kant)) { 
        cursorIndex = 8;
      } else if ("b".equals(kant)) { 
        cursorIndex = 9;
      } else if ("l".equals(kant)) { 
        cursorIndex = 10;
      } else if ("r".equals(kant)) { 
        cursorIndex = 11;
      }
    }
    return kant;
  }

  public boolean isInside(float x, float y) {
    float x0 = min(this.x);
    float x1 = max(this.x);
    float y0 = min(this.y);
    float y1 = max(this.y);
    if (valgt && Elo == this) {
      if(x >= x0-3  && x <=x1+3 && y >= y0-3 && y <= y1+3){
        return true;
      } else { return false; }
    } else {
      switch(this.type) {
      case 0:
        //kun inde i ellipsen
          x0 = (x0 + x1) / 2; y0 = (y0 + y1) / 2;
          x1 = abs(x1 - x0); y1 = abs(y1 - y0);
          x = x - x0; y = y - y0;
          ellipseMode(CENTER);
          ellipse(x0+x, y0+y, 5, 5);
          if(1.0f >= (x*x)/(x1*x1) + (y*y)/(y1*y1)){
            return true;
          } else { return false; }
      case 1:
          //inde i firkanten
          if(x >= x0-3  && x <=x1+3 && y >= y0-3 && y <= y1+3){
            return true;
          } else { return false; }
      case 2:
        //kun hvis inde i trekanten
          float A = 0.5f * (-this.y[1] * this.x[2] + this.y[0] * (-this.x[1] + this.x[2]) + this.x[0] * (this.y[1] - this.y[2]) + this.x[1] * this.y[2]);
          int sign = A < 0 ? -1 : 1;
          float s = (this.y[0] * this.x[2] - this.x[0] * this.y[2] + (this.y[2] - this.y[0]) * x + (this.x[0] - this.x[2]) * y) * sign;
          float t = (this.x[0] * this.y[1] - this.y[0] * this.x[1] + (this.y[0] - this.y[1]) * x + (this.x[1] - this.x[0]) * y) * sign;
         
          if(s > 0 && t > 0 && (s + t) < 2 * A * sign){
            return true;
          } else { return false; }
      default:
        return false;
      }
    }
  }

  public void setFillColor(int colR, int colB, int colG) {
    this.fillColor = color(colR, colG, colB);
  }

  public void setFillColor(int col) {
    this.setFillColor(col, col, col);
  }

  public void setStrokeColor(int colR, int colB, int colG) {
    this.strokeColor = color(colR, colG, colB);
  }

  public void setStrokeColor(int col) {
    this.setStrokeColor(col, col, col);
  }

  public void setPos(int x, int y){
    this.setPosX(x);
    this.setPosY(y);
  }

  public void setPosX(int x) {
    int deltaX = x - this.posX;
    this.posX = x;
    for (int i=0; i<this.vertexCount; i++) {
      this.x[i] = this.x[i] + deltaX;
    }
  }

  public void setPosY(int y) {
    int deltaY = y - this.posY;
    this.posY = y;
    for (int i=0; i<this.vertexCount; i++) {
      this.y[i] = this.y[i] + deltaY;
    }
  }

  public void setVertex(int vertex, int x, int y){
    this.x[vertex] = x;
    this.y[vertex] = y;
    this.posX = (max(this.x) + min(this.x))/2;
    this.posY = (max(this.y) + min(this.y))/2;
    
  }

  public void setWidth(int x, String edge) {
    if (this.type == 2) {
      if (edge.equals("l") || edge.equals("lt")  || edge.equals("lb") ) {
        for(int i=0; i<this.vertexCount;i++){
          if(this.x[i] == min(this.x)){
            this.x[i] = x;
          }
        }
      }
      if (edge.equals("r") || edge.equals("rt")  || edge.equals("rb") ) {
        for(int i=0; i<this.vertexCount;i++){
          if(this.x[i] == max(this.x)){
            this.x[i] = x;
          }
        }
      }
    } else {
      if (edge.equals("l") || edge.equals("lt")  || edge.equals("lb") ) {
        this.x[0] = min(x, this.x[1]-10);
      }
      if (edge.equals("r") || edge.equals("rt")  || edge.equals("rb") ) {
        this.x[1] = max(x, this.x[0]+10);
      }
    }
    this.posX = (max(this.x) + min(this.x))/2;
  }

  public void setHeight(int y, String edge) {
    if (this.type == 2) {
      if (edge.equals("t") || edge.equals("lt")  || edge.equals("rt") ) {
        for(int i=0; i<this.vertexCount;i++){
          if(this.y[i] == min(this.y)){
            this.y[i] = y;
          }
        }
      }
      if (edge.equals("b") || edge.equals("lb")  || edge.equals("rb") ) {
        for(int i=0; i<this.vertexCount;i++){
          if(this.y[i] == max(this.y)){
            this.y[i] = y;
          }
        }
      }
    } else {
      if (edge.equals("t") || edge.equals("lt")  || edge.equals("rt") ) {
        this.y[0] = min(y, this.y[1]-10);
      }
      if (edge.equals("b") || edge.equals("lb")  || edge.equals("rb") ) {
        this.y[1] = max(y, this.y[0]+10);
      }
    }
    this.posY = (max(this.y) + min(this.y))/2;
  }

  public int getWidth() {
    return max(this.x)-min(this.x);
  }

  public int getHeight() {
    return max(this.y)-min(this.y);
  }
}

public void draw() {
  background(128);
  //Det er her at figurenes form bliver \u00e6ndret.
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
      sheets[j].drawShadow(sheets[i-1].rect, PApplet.parseInt(sheets[j].z-sheets[i-1].z));
    }
    sheets[i].draw();
    if(sheets[i] == ohPicker){
      rectMode(CORNER);
      int j = 0;
      stroke(0);
      for (int c : colors){
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
      //tegn kant om knap n\u00e5r musen er over den
      noFill();
      if (traek) { 
        if (rectDel.contains(mouseX, mouseY)) {
          stroke(0xffFF0000);
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
        //hvis denne figur er valgt, s\u00e5 tegn en gr\u00e5 firkant omkring den
            noFill();
            stroke(96);
            rectMode(CORNERS);
            strokeWeight(1);
            rect(min(Elo.x), min(Elo.y), max(Elo.x), max(Elo.y));
            Elo.atEdge(mouseX, mouseY, true);
        //hvis det er en trekant, s\u00e5 tegn ogs\u00e5 sm\u00e5 cirkler om hvert hj\u00f8rne
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
    codeX = (codeX+PApplet.parseInt(w*0.5f))/2;
  } else {
    codeX = (codeX+w-25)/2;
  }
}

public String generateCode(){
  int stroke, fill;
  stroke = color(0, 0, 0);
  fill = color(255, 255, 255);
  String output = "void setup(){\n  size(775, 580);\n}\n\nvoid draw(){\n";
  int x, y;
  x = ohSheet.rect.x; 
  y = ohSheet.rect.y;
  for (int i = 0; i < ENu; i++) {
    if(El[i].strokeColor != stroke){
      stroke = El[i].strokeColor;
      output = output + "  stroke(" + (stroke >> 16 & 0xFF) + ", "+
                                      (stroke >> 8 & 0xFF )+ ", " +
                                      (stroke & 0xFF)+ ");\n";
    }
    if(El[i].fillColor != fill){
      fill = El[i].fillColor;
      output = output + "  fill(" + (fill >> 16 & 0xFF) + ", "+
                                      (fill >> 8 & 0xFF )+ ", " +
                                      (fill & 0xFF)+ ");\n";
    }
    if(ENu == 0) { break; }
    if (El[i].type == 0) {
      output = output + "  ellipse(" + 
      (El[i].posX-x)+ ", "+ (El[i].posY-y)+ ", " +
      El[i].getWidth()+ ", "+ El[i].getHeight()+ ");\n";
    }
    if (El[i].type == 1) {
      output = output + "  rect(" + 
      (El[i].x[0]-x)+ ", "+ (El[i].y[0]-y)+ ", " +
      El[i].getWidth()+ ", "+ El[i].getHeight()+ ");\n";
    }
    if (El[i].type == 2) {
      output = output + "  triangle(" + 
      (El[i].x[0]-x)+ ", "+ (El[i].y[0]-y)+ ", " +
      (El[i].x[1]-x)+ ", "+ (El[i].y[1]-y)+ ", " +
      (El[i].x[2]-x)+ ", "+ (El[i].y[2]-y)+ ");\n";
    }
  }
  output = output + "}";
  return output;
}

//kunne m\u00e5ske godt v\u00e6re i Shape, men p\u00e5 den anden side...
public void removeShape(Shape shape){
  boolean found = false;
  ENu -= 1;
  for(int i=0; i<ENu; i++) {
    if(found || El[i] == shape){
      found = true;
      El[i] = El[i+1];
    }
  }
}
public void copyShape(Shape shape){
  Copy = new Shape(shape.type);
  for(int i=0; i<shape.vertexCount; i++){
    Copy.setVertex(i, shape.x[i], shape.y[i]);
  }
  Copy.strokeColor = color(shape.strokeColor);
  Copy.fillColor = color(shape.fillColor);
}
public Shape pasteShape(){
  Shape shape;
  shape = Copy;
  copyShape(Copy);
  shape.setPos(mouseX, mouseY);
  El[ENu] = shape;
  ENu++;
  return shape;
}

public int mean(int[] numbers) {
  int sum = 0;
  for(int i: numbers){
    sum += i;
  }
  return sum/numbers.length;
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ScriptSimple" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
