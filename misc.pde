public String generateCode(){
  color stroke, fill;
  stroke = color(0, 0, 0);
  fill = color(255, 255, 255);
  String output = "void setup(){\n  size("+ohSheet.rect.width+", "+ohSheet.rect.height+");\n}\n\nvoid draw(){\n";
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

// This function is used to remove Shapes from the drawing area.
public void removeShape(Shape shape){
  boolean found = false;
  ENu -= 1;
  for(int i=0; i<ENu; i++) {
    if(found || El[i] == shape){
      found = true;
      El[i] = El[i+1];
    }
  }
  El[ENu] = null;
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

public PImage renderShade() {
  PImage img = createImage(32, 32, ARGB);
  img.loadPixels();
  float step = 255.0/32.0;
  for (int i = 0; i < img.pixels.length; i++) {
    img.pixels[i] = color(0, int((i / img.width)*step)); 
  }
  img.updatePixels();
  return img;
}

public int calculateCodeHeight(String code) {
  int codeHeight = 1;
  for(char c : code.toCharArray()) {
    if(c=='\n') { codeHeight++; }
  }
  return codeHeight*32;
}