void drawCode(StringList code, int x, int y, int ch){
  int xi, yi, i; String text; char c;
  int cw = int(ch*0.65);
  yi = 0;
  for( String line : code){
    text = "";
    xi = 0;
    for(i = 0; i<line.length(); i++){
      c = line.charAt(i);
      if(c != '['){
        text += c;
      } else {
        text(text, x+xi*cw, y+yi*ch);
        xi += text.length();
        text = "";
        i++;
        c = line.charAt(i);
        if(c == '#') {
          i++;
          fill(unhex("ff"+line.substring(i, i+6)));
          i+=6;
        } else if(c == 'b') {
          textFont(codeFontBold);
          i++;
        } else if(c == 'p') {
          textFont(codeFontPlain);
          i++;
        }
      }
    }
    text(text, x+xi*cw, y+yi*ch);
    yi++;
  }
}



public StringList generateCodeTagged(){
  StringList output = new StringList();
  String xC = "[#"+hex(xColor).substring(2)+"]"; String yC = "[#"+hex(yColor).substring(2)+"]";
  color stroke, fill;
  stroke = color(0,0,0);
  fill = color(255,255,255);
  output.append("[#339977][p]void [#006699][b]setup[#000000][p](){");
  output.append("  [#006699][p]size[#000000][p]("+xC+ohSheet.rect.width+"[#000000], "+yC+ohSheet.rect.height+"[#000000]);");
  output.append("}");
  output.append("");
  output.append("[#339977][p]void [#006699][b]draw[#000000][p](){");
  int x, y;
  x = ohSheet.rect.x; 
  y = ohSheet.rect.y;
  for (int i = 0; i < ENu; i++) {
    if(El[i].strokeColor != stroke || i == 0){
      stroke = El[i].strokeColor;
      output.append("  [#006699][p]stroke[#000000][p]([#ff0000]" + (stroke >> 16 & 0xFF) + "[#000000], [#00ff00]"+
                                      (stroke >> 8 & 0xFF )+ "[#000000], [#0000ff]" +
                                      (stroke & 0xFF)+ "[#000000]);");
    }
    if(El[i].fillColor != fill || i == 0){
      fill = El[i].fillColor;
      output.append("  [#006699][p]fill[#000000][p]([#ff0000]" + (fill >> 16 & 0xFF) + "[#000000], [#00ff00]"+
                                      (fill >> 8 & 0xFF )+ "[#000000], [#0000ff]" +
                                      (fill & 0xFF)+ "[#000000]);");
    }
    if(ENu == 0) { break; }
    if (El[i].type == 0) {
      output.append("  [#006699][p]ellipse[#000000][p](" + xC + 
      (El[i].posX-x)+ "[#000000], " + yC + (El[i].posY-y)+ "[#000000], " + xC +
      El[i].getWidth()+ "[#000000], " + yC + El[i].getHeight()+ "[#000000]);");
    }
    if (El[i].type == 1) {
      output.append("  [#006699][p]rect[#000000][p](" + xC + 
      (El[i].x[0]-x)+ "[#000000], " + yC + (El[i].y[0]-y)+ "[#000000], " + xC +
      El[i].getWidth()+ "[#000000], " + yC + El[i].getHeight()+ "[#000000]);");
    }
    if (El[i].type == 2) {
      output.append("  [#006699][p]triangle[#000000][p](" + xC + 
      (El[i].x[0]-x)+ "[#000000], " + yC + (El[i].y[0]-y)+ "[#000000], " + xC +
      (El[i].x[1]-x)+ "[#000000], " + yC + (El[i].y[1]-y)+ "[#000000], " + xC +
      (El[i].x[2]-x)+ "[#000000], " + yC + (El[i].y[2]-y)+ "[#000000]);");
    }
  }
  output.append("}");
  return output;
}
