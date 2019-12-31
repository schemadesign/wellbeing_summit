class DimensionsIntro {

  Boolean active = false;

  Dimension prevDimension, currDimension;



  PImage pinwheel;
  float pinwheelSize;

  float pinwheelAngle = 0;
  float pinwheelAngleIncrement;
  float pinwheelX = 0;

  float prevDimensionY, currDimensionY;

  String introText = "Wellbeing is";
  color introTextColor = #2A2A2A;
  float introTextY = 0;

  float diameter;

  float duration = 2;

  int moves = 0;
  int totalMoves = 5;

  Boolean transitioningNext = false;
  Boolean transitioningInOut = false;

  float transitionAlpha = 0;

  DimensionsIntro () {
    
    if(RECORD) duration *= FPS;

    pinwheel = loadImage("img/pinwheel.png");
    println("");
    pinwheelSize = height*1.2;

    diameter = height*.063;

    pinwheelAngleIncrement = TWO_PI/6.0;

    prevDimensionY = 0;
    currDimensionY = diameter*2;

    currDimension = dimensionMan.currentDimension();
  }

  void render() {
    
    currDimension.currentFinding.deactivate();

    renderPinwheel();

    pushMatrix();
    pushStyle();

    translate(0, height*.5);

    textFont(sharpSansBold);
    textSize(diameter);
    textAlign(LEFT, CENTER);


    noStroke();

    fill(red(introTextColor), green(introTextColor), blue(introTextColor), transitionAlpha);
    text(introText, width*.3, introTextY);

    ellipseMode(CENTER);

    // current dimension
    //fill(currDimension.circleColor);
    fill(red(currDimension.circleColor), green(currDimension.circleColor), blue(currDimension.circleColor), transitionAlpha);
    ellipse(width*0.53, currDimensionY, diameter, diameter);

    //fill(currDimension.textColor);
    fill(red(currDimension.textColor), green(currDimension.textColor), blue(currDimension.textColor), transitionAlpha);
    text(currDimension.name, width*.57, currDimensionY);

    if (transitioningNext) {
      // previous dimension
      fill(prevDimension.circleColor);
      ellipse(width*0.53, prevDimensionY, diameter, diameter);

      fill(prevDimension.textColor);
      text(prevDimension.name, width*.57, prevDimensionY);

      // white rectangels mask
      fill(255);
      rectMode(CORNER);
      rect(width*.5, -diameter*3, width*.5, diameter*2 );
      rect(width*.5, diameter, width*.5, diameter*2 );
    }

    popStyle();
    popMatrix();
  }

  void renderPinwheel() {
    pushMatrix();
    pushStyle();

    translate(pinwheelX, height*.5);
    rotate(pinwheelAngle);
    imageMode(CENTER);

    image(pinwheel, 0, 0, pinwheelSize, pinwheelSize);

    popStyle();
    popMatrix();
  }


  void nextDimension () {

    // have we gone through enough dimensions?
    if (moves == totalMoves) {
      transitioningNext = false;
      transitionOut();
      return;
    }

    transitioningInOut = false;
    transitioningNext = true;
    moves++;

    prevDimension = currDimension;
    currDimension = dimensionMan.nextDimension();

    if (pinwheelAngle>=TWO_PI) pinwheelAngle -= TWO_PI;
    float newAngle = pinwheelAngle+pinwheelAngleIncrement;
    Ani.to(this, duration, "pinwheelAngle", newAngle, Ani.EXPO_IN_OUT, "onEnd:nextDimension");

    prevDimensionY = 0;
    float newPrevDimensionY = prevDimensionY - diameter*2;
    Ani.to(this, duration, "prevDimensionY", newPrevDimensionY, Ani.EXPO_IN_OUT);

    currDimensionY = diameter*2;
    float newCurrDimensionY = currDimensionY - diameter*2;
    Ani.to(this, duration, "currDimensionY", newCurrDimensionY, Ani.EXPO_IN_OUT);
  }

  void transitionIn() {

    active = true;
    transitioningInOut = true;
  
    moves = 0;

    pinwheelX = -pinwheelSize*.5;
    float newPinwheelX = 0;
    Ani.to(this, duration*2, "pinwheelX", newPinwheelX, Ani.QUINT_OUT);

    introTextY = -diameter*3;
    float newIntroTextY = 0;
    Ani.to(this, duration*2, "introTextY", newIntroTextY, Ani.QUINT_OUT);

    currDimensionY = -diameter*3;
    float newCurrDimensionY = 0;
    Ani.to(this, duration*2, "currDimensionY", newCurrDimensionY, Ani.QUINT_OUT);

    transitionAlpha = 0;
    float newTransitionAlpha = 255;
    Ani.to(this, duration*2, "transitionAlpha", newTransitionAlpha, Ani.QUINT_OUT, "onEnd:nextDimension");
  }

  void transitionOut() {
    
    sceneMan.showTopLogo();

    transitioningInOut = true;

    pinwheelX = 0;
    float newPinwheelX = -pinwheelSize*.5;
    Ani.to(this, duration, "pinwheelX", newPinwheelX, Ani.QUINT_OUT);

    introTextY = 0;
    float newIntroTextY = -diameter*3;
    Ani.to(this, duration, "introTextY", newIntroTextY, Ani.QUINT_OUT);

    currDimensionY = 0;
    float newCurrDimensionY = -diameter*3;
    Ani.to(this, duration, "currDimensionY", newCurrDimensionY, Ani.QUINT_OUT);

    transitionAlpha = 255;
    float newTransitionAlpha = 0;
    Ani.to(this, duration, "transitionAlpha", newTransitionAlpha, Ani.QUINT_OUT, "onEnd:deactivate");
  }

  void deactivate() {

    sceneMan.showDefinition();
    
    active = false;
  }
  
}
