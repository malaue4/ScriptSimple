class HUD{
  StringList messages;
  String message;
  int delay = 0; int wait = 60*2;
  float y = 550; float x; int w=0; int h=0;
  PFont font; int fontSize;
  color boxColor = color(164, 128); color textColor;
  public HUD(PFont font, int fontSize){
    messages = new StringList();
    message = "";
    this.fontSize = fontSize;
    this.font = font;
    textFont(font);
  }
  
  public HUD(){
    this(createFont("Source Code Pro", 21), 21);
  }
  
  public void addMessage(String message){
    messages.append(message);
  }
  
  public void draw(){
    if(delay > 0){
      rectMode(CENTER);
      ellipseMode(CENTER);
      fill(boxColor);
      noStroke();
      arc(x+w, y+h/2, 20, 20, PI*0.0, PI*0.5);
      arc(x-w, y+h/2, 20, 20, PI*0.5, PI*1.0);
      arc(x-w, y-h/2, 20, 20, PI*1.0, PI*1.5);
      arc(x+w, y-h/2, 20, 20, PI*1.5, PI*2.0);
      rect(x, y, w*2, h+20);
      rect(x-w-5, y, -10, h);
      rect(x+w+5, y, 10, h);
      textAlign(CENTER, CENTER);
      if(font != null){ textFont(font); }
      fill(textColor);
      text(message, x, y);
    }
    if(frameCount < delay){
      y = (height-h/2-35)*0.1+y*0.9;
    } else {
      if(x > width+w+40){
        if(messages.size() > 0){
          message = messages.get(0);
          messages.remove(0);
          delay = frameCount + wait;
          textFont(font);
          w = int(textWidth(message)/2);
          h = fontSize;
          for(int i=0; i< message.length(); i++){
            if(message.charAt(i) == '\n') h += fontSize;
          }
          x = width/2;
          y = height+h+20;
        } else {
          delay = 0;
        }
      } else {
        x = (width+w+50)*0.1+x*0.9;
      }
    }
  }
}
