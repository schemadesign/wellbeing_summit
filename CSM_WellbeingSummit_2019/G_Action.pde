class Action {

  float circleX, circleY, diameter, diameterStart, diameterEnd;
  float circleAlpha;

  String copy = "";
  float fontSize, textWidth, textHeight;
  float textColor = 255;
  float textAlpha = 0;

  float midline, baseLine;
  
  float duration = 2;
  
  float nothing = 0;

  boolean active = false;

  Action() {
    
    if(RECORD) duration *= FPS;

    circleX = 0.044*width;
    circleY = 0.07*height;

    diameterStart = height*0.029;
    diameterEnd = width*2;
    diameter = diameterStart;

    fontSize = height*0.07;
    textWidth = width*0.7;
    textHeight = height*.7;

    midline = width*.5;
    baseLine = height*.5;
    
    copy = "";
  }

  void render() {

    renderCircle();

    pushMatrix();
    pushStyle();

    translate(midline, baseLine);
    rectMode(CENTER);
    textFont(sharpSansBold);
    textSize(fontSize);
    textAlign(CENTER, CENTER);
    fill(textColor, textAlpha);
    text(copy, 0, 0, textWidth, textHeight);


    popStyle();
    popMatrix();
  }

  void renderCircle() {
    color c = dimensionMan.currentDimension().circleColor;

    pushMatrix();
    pushStyle();
    
    ellipseMode(CENTER);

    translate(circleX, circleY);
    noStroke();
    fill(red(c), green(c), blue(c), circleAlpha);
    ellipse(0,0, diameter, diameter);

    popStyle();
    popMatrix();
  }
  
  void fadeUp() {
    active = true;
    
    circleAlpha = 255;
    
    textAlpha = 0;
    float newAlpha = 255;
    Ani.to(this, duration, "textAlpha", newAlpha, Ani.QUINT_OUT);
    
    diameter = diameterStart;
    float newDiameter = diameterEnd;
    Ani.to(this, duration, "diameter", newDiameter, Ani.QUINT_OUT);
    
    Ani.to(this, duration*10, "nothing", 0, Ani.QUINT_OUT, "onEnd:transitonOut");
  }
  
  void transitonOut() {
    sceneMan.showDimensionsIntro();
  }
  
  void fadeOut() {
    textAlpha = 255;
    float newAlpha = 0;
    Ani.to(this, duration*.25, "textAlpha", newAlpha, Ani.QUINT_OUT);
    
    circleAlpha = 255;
    Ani.to(this, duration*.5, "circleAlpha", newAlpha, Ani.QUINT_OUT);
    
    diameter = diameterEnd;
    float newDiameter = diameterEnd*2;
    Ani.to(this, duration, "diameter", newDiameter, Ani.QUINT_OUT, "onEnd:deactivate");
  }
  
  void deactivate() {
    active = false;
  }
  
  
}
