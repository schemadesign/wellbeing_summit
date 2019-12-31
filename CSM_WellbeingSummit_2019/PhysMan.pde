class PhysicsManager {

  float timeStep = 1.0/FPS; //0.016666666666667;
  int velocityIterations = 6;
  int positionIterations = 2;

  // The Orb is an OK electronica group
  Orb[] orbs = new Orb[100];


  float minRadius, maxRadius;
  float orbPaddingMin, orbPaddingMax, orbRadius;

  float midLine, baseLine;

  boolean active = false;

  PhysicsManager() {

    orbRadius = height*0.0125;
    orbPaddingMin = orbRadius*1.15;
    orbPaddingMax = orbRadius*1.5;

    minRadius = dist(0, 0, width*.6, height*.6);
    maxRadius = minRadius*4;


    for (int i = 0; i < orbs.length; i++) {

      float radius = random(minRadius, maxRadius);
      float angle = random(TWO_PI);
      float x = cos(angle)*radius + width*.5;
      float y = sin(angle)*radius + height*.5;

      float orbPadding = random(orbPaddingMin, orbPaddingMax);

      orbs[i] = new Orb(orbRadius, orbPadding, x, y);
    }

    midLine = width*0.5;
    baseLine = height*0.45;

    //distributeOrbs();
    //orbs[i].setDestinationOrigin();
  }

  void update() {
    // We must always step through time!
    box2d.step(timeStep, velocityIterations, positionIterations);
    for (int i = 0; i < orbs.length; i++) orbs[i].update();
  }

  void centerOrbs(int totalOrbs) {
    for (int i = 0; i < totalOrbs; i++) {
      orbs[i].setColor(dimensionMan.currentDimension().circleColor);
      orbs[i].setDestination(midLine, baseLine);
    }
  }

  void disperseOrbs() {
    for (int i = 0; i < orbs.length; i++) orbs[i].setDestinationOrigin();
  }

  void distributeOrbs(Finding finding) {
    int[] percentages = finding.percentagesRounded;
    float[] binsX = finding.binsX;
    color[] binsColors = finding.binsColors;

    int tally = 0;

    for (int i=0; i<percentages.length; i++) {
      float x = binsX[i];
      for (int j=0; j<percentages[i]; j++) {
        orbs[tally].setColor(binsColors[i]);
        orbs[tally].setDestination(x, baseLine);
        tally++;
      }

      if (tally < 100) for (int k=tally; k<100; k++) orbs[k].setDestinationOrigin();
    }
  }

  void activate() {
    active = true;
  }

  void deactivate() {
    active = false;
  }
}
