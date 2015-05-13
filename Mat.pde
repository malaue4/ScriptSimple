public class Sheet {
  Rectangle rect;
  Rectangle shadow;
  Rectangle parent;
  int resting_z;
  float z;
  color col;
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
  void drawShadow(Rectangle area, int z){
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
        vertex(x-r*0.9, y-r*0.4, 0, 0);
        vertex(x-r*0.7, y-r*0.7, 0, 0);
        vertex(x-r*0.4, y-r*0.9, 0, 0);
        vertex(x, y-r, 0, 0);
        endShape();
      }
      if(area.intersects(new Rectangle(this.rect.x+this.rect.width, this.rect.y-r, r, r))){
        translate(x+w, y);
        rotate(PI*0.5);
        beginShape();
        texture(shade);
        vertex(0, 0, 0, intensity);
        vertex(0-r, 0, 0, 0);
        vertex(0-r*0.9, 0-r*0.4, 0, 0);
        vertex(0-r*0.7, 0-r*0.7, 0, 0);
        vertex(0-r*0.4, 0-r*0.9, 0, 0);
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
        vertex(0-r*0.9, 0-r*0.4, 0, 0);
        vertex(0-r*0.7, 0-r*0.7, 0, 0);
        vertex(0-r*0.4, 0-r*0.9, 0, 0);
        vertex(0, 0-r, 0, 0);
        endShape();
        resetMatrix();
      }
      if(area.intersects(new Rectangle(this.rect.x-r, this.rect.y+this.rect.height, r, r))){
        beginShape();
        texture(shade);
        vertex(x,         y+h,       0, intensity);
        vertex(x-r,       y+h,       0,  0);
        vertex(x-r*0.9,   y+h+r*0.4, 0,  0);
        vertex(x-r*0.7,   y+h+r*0.7, 0,  0);
        vertex(x-r*0.4,   y+h+r*0.9, 0,  0);
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
