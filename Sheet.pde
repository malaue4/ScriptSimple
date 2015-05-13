public class Sheet {
  Rectangle rect;
  Rectangle parent;
  PImage img;
  int resting_z;
  float z;
  color col;
  public Sheet(float x, float y, float width, float height, float z) {
    //this.shadow = new Rectangle();
    this.rect = new Rectangle(int(x), int(y), int(width), int(height));
    this.z = z;
    this.resting_z = int(z);
    this.col = color(64,64,185,127);
  }
  public void draw(){
    if(abs(z-resting_z) < 0.5) { 
      this.z = resting_z;
    } else {
      this.z = (this.z*8+this.resting_z*2)/10;
    }
    // The background color
    rectMode(CORNER);
    fill(this.col); noStroke();
    rect(this.rect.x, this.rect.y, this.rect.width, this.rect.height);
    // If the img variable is set, then draw the image on the sheet
    if(this.img != null) {
      image(this.img, this.rect.x, this.rect.y, this.rect.width, this.rect.height);
    }
  }
  void drawShadow(Rectangle area, int z){
    if(z <= 0) {
      return;
    }
    int x, y, w, h;
    //area is where the shadow can be drawn.
    //z is the difference in z between this object
    //and the z of the object the shadow lands on.
    Rectangle shadow = new Rectangle(this.rect);
    //this.shadow.setBounds(this.rect);
    shadow = shadow.intersection(area);
    if(shadow.isEmpty() == false){
      x = shadow.x;
      y = shadow.y;
      w = shadow.width;
      h = shadow.height;
      float intensity = 32*32/(32+z*4);
      int r = 2+z*2;
      noStroke();
      
      shadow = new Rectangle(this.rect.x-r, this.rect.y-r, r, r);
      if(area.intersects(shadow)){
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
      shadow = new Rectangle(this.rect.x+this.rect.width, this.rect.y-r, r, r);
      if(area.intersects(shadow)){
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
      shadow = new Rectangle(this.rect.x+this.rect.width, this.rect.y+this.rect.height, r, r);
      if(area.intersects(shadow)){
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
      shadow = new Rectangle(this.rect.x-r, this.rect.y+this.rect.height, r, r);
      if(area.intersects(shadow)){
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
      shadow = new Rectangle(this.rect.x, this.rect.y-r, this.rect.width, r);
      if(area.intersects(shadow)){
        beginShape();
        texture(shade);
        vertex(x, y-r, 0, 0);
        vertex(x+w, y-r, 100, 0);
        vertex(x+w, y, 100, intensity);
        vertex(x, y, 0, intensity);
        endShape();
      }
      shadow = new Rectangle(this.rect.x+this.rect.width, this.rect.y-r, r, this.rect.height);
      if(area.intersects(shadow)){
        beginShape();
        texture(shade);
        vertex(x+w, y, 0, intensity);
        vertex(x+w+r, y, 100, 0);
        vertex(x+w+r, y+h, 100, 0);
        vertex(x+w, y+h, 0, intensity);
        endShape();
      }
      shadow = new Rectangle(this.rect.x, this.rect.y+this.rect.height, this.rect.width, r);
      if(area.intersects(shadow)){
        beginShape();
        texture(shade);
        vertex(x, y+h, 0, intensity);
        vertex(x+w, y+h, 100, intensity);
        vertex(x+w, y+h+r, 100, 0);
        vertex(x, y+h+r, 0, 0);
        endShape();
      }
      shadow = new Rectangle(this.rect.x-r, this.rect.y, r, this.rect.height);
      if(area.intersects(shadow)){
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
