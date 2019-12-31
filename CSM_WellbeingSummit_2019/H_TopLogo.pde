class TopLogo {

  float midLine;

  float diameter;

  PImage pinwheel;
  float pinwheelX, pinwheelSize, pinwheelRotation;

  String introText = "Wellbeing is";
  color introTextColor = #2A2A2A;

  float duration = 2;

  float alpha = 0;

  Dimension dimension;
  
  Boolean active = false;

  TopLogo() {
    
    if(RECORD) duration *= FPS;
    
    pinwheel = loadImage("img/pinwheel_small.png");

    midLine = 0.07*height;

    diameter = 0.029*height;

    pinwheelX = 0.044*width;
    pinwheelSize = 0.048*height;
  }

  void render() {

    dimension = dimensionMan.currentDimension();

    pushMatrix();
    pushStyle();

    translate(0, midLine);

    renderPinwheel();

    textFont(sharpSansBold);
    textAlign(LEFT, CENTER);
    textSize(diameter);
    textLeading(diameter);


    fill(red(introTextColor), green(introTextColor), blue(introTextColor), alpha);
    text(introText, 0.0667*width, 0 );

    fill(red(dimension.circleColor), green(dimension.circleColor), blue(dimension.circleColor), alpha);
    noStroke();
    ellipseMode(CENTER);
    ellipse(0.176*width, 0, diameter, diameter);

    fill(dimension.textColor);
    fill(red(dimension.textColor), green(dimension.textColor), blue(dimension.textColor), alpha);
    text(dimension.name, 0.195*width, 0);

    popStyle();
    popMatrix();
  }

  void renderPinwheel() {
    pushStyle();

    imageMode(CENTER);
    tint(255, alpha);
    image(pinwheel, pinwheelX, 0, pinwheelSize, pinwheelSize);

    popStyle();
  }

  void fadeUp() {
    
    active = true;
    
    alpha = 0;
    float newAlpha = 255;
    Ani.to(this, duration, "alpha", newAlpha, Ani.QUINT_OUT);
  }

  void fadeOut() {
    alpha = 255;
    float newAlpha = 0;
    Ani.to(this, duration, "alpha", newAlpha, Ani.QUINT_OUT, "onEnd:deactivate");
  }
  
  void deactivate() {
    active = false;
  }
  
}
