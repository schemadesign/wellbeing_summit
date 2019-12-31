class Definition {

  Dimension dimension;

  float midline;

  float iconY, iconSize;

  float nameSize, nameY;

  float defSize, defY, defWidth, defHeight;
  color defColor = #4E4E4E;

  Confetti[] confetti;
  int totalConfetti = 40;

  float alpha = 0;
  float duration = 3;

  Boolean active  = false;

  float nothing = 0; // used as a hack to use Ani as a setTimeout ish 

  Definition() {
    if(RECORD) duration *= FPS;
    
    midline = width*.5;

    iconY = height*0.235;
    iconSize = height*0.157;

    nameSize = height*0.05;
    nameY = height*0.373;

    defSize = height*0.035;
    defHeight = height*0.311;
    defWidth = width*0.4;

    defY = height*0.433 + defHeight*.5;

    confetti = new Confetti[totalConfetti];

    for (int i=0; i<totalConfetti; i++) {
      confetti[i] = new Confetti();
    }
  }

  void render() {

    dimension = dimensionMan.currentDimension();

    for (int i=0; i<totalConfetti; i++) confetti[i].render();

    pushMatrix();
    pushStyle();

    translate(midline, 0);

    rectMode(CENTER);

    ellipseMode(CENTER);
    fill(red(dimension.circleColor), green(dimension.circleColor), blue(dimension.circleColor), alpha);
    noStroke();
    ellipse(0, iconY, iconSize, iconSize);

    //fill(255);
    //noStroke();
    //rect(0, defY-iconSize*.5, defWidth+iconSize, defHeight+nameSize);

    //imageMode(CENTER);
    //image(dimension.icon, 0, iconY, iconSize, iconSize);

    textFont(sharpSansBold);
    textAlign(CENTER, CENTER);
    textSize(nameSize);
    fill(red(neutralDark), green(neutralDark), blue(neutralDark), alpha);
    text(dimension.name, 0, nameY);

    textFont(sharpSansMedium);
    textAlign(CENTER, TOP);

    textSize(defSize);
    fill(red(defColor), green(defColor), blue(defColor), alpha);
    text(dimension.definition, 0, defY, defWidth, defHeight);

    popStyle();
    popMatrix();
  }

  void fadeUp() {
    active  = true;

    for (int i=0; i<totalConfetti; i++) confetti[i].fadeUp();

    alpha = 0;
    float newAlpha = 255;
    Ani.to(this, duration, "alpha", newAlpha, Ani.QUINT_OUT);
    Ani.to(this, duration*10, "nothing", nothing, Ani.LINEAR, "onEnd:fadeOut");  // total hack to emulate setTimeout()
  }

  void fadeOut() {
    for (int i=0; i<totalConfetti; i++) confetti[i].fadeOut();

    alpha = 255;
    float newAlpha = 0;
    Ani.to(this, duration, "alpha", newAlpha, Ani.QUINT_OUT, "onEnd:deactivate");
  }

  void deactivate() {
    sceneMan.showFinding();
    active = false;
  }
  
}



/*
**  Confetti me up bro!
*/

class Confetti {

  float diameter;
  PVector pos;

  color dotColor;
  float alpha = 255; //196;
  float r, g, b;

  float speed;

  float duration = 2;

  Confetti() {
    
    if(RECORD) duration *= FPS;
    
    float min = height*0.05;
    float max = height*0.2;
    diameter = random(min, max);

    float x = random(-width*2, -diameter*.5); //(-random(width)-diameter)*2;
    float y = random(height*.75, height*.95);
    pos = new PVector(x, y);

    int index = round(random(dimensionMan.dimensions.length-1));
    dotColor = dimensionMan.dimensions[index].circleColor;

    r = red(dotColor);
    g = green(dotColor);
    b = blue(dotColor);

    speed = height*.0014;
    speed += random(speed);
  }

  void render() {
    pos.x += speed;
    if (pos.x > width+diameter*0.5) return; // pos.x = -diameter - random(diameter);  

    
    float yOffset = sin( MillisTime()*.0001*speed ) * diameter * .5;

    pushMatrix();
    pushStyle();

    ellipseMode(CENTER);
    translate(pos.x, pos.y + yOffset );

    blendMode(MULTIPLY);
    fill(r, g, b);
    noStroke();
    ellipse(0, 0, diameter, diameter);

    blendMode(BLEND);
    fill(255, 255-alpha);
    //stroke(255, 255-alpha);
    ellipse(0, 0, diameter, diameter);


    popStyle();
    popMatrix();
  }

  void fadeUp() {
    alpha = 0;
    float newAlpha = 255;
    Ani.to(this, duration, "alpha", newAlpha, Ani.QUINT_OUT);
  }

  void fadeOut() {
    alpha = 255;
    float newAlpha = 0;
    Ani.to(this, duration, "alpha", newAlpha, Ani.QUINT_OUT, "onEnd:reset");
  }

  void reset() {
    pos.x = random(-width*2, -diameter*.5);
  }
}
