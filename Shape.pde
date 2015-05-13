public class Shape {
  color strokeColor, fillColor;
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
          if(1.0 >= (x*x)/(x1*x1) + (y*y)/(y1*y1)){
            return true;
          } else { return false; }
      case 1:
          //inde i firkanten
          if(x >= x0-3  && x <=x1+3 && y >= y0-3 && y <= y1+3){
            return true;
          } else { return false; }
      case 2:
        //kun hvis inde i trekanten
          float A = 0.5 * (-this.y[1] * this.x[2] + this.y[0] * (-this.x[1] + this.x[2]) + this.x[0] * (this.y[1] - this.y[2]) + this.x[1] * this.y[2]);
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

