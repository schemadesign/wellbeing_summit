class Finding {

  float midLine;

  String question; // = "Will children be able to live in\nSanta Monica as adults?";
  float questionY, questionYOffset, questionSize, questionWidth, questionHeight;
  float questionAlpha = 0;

  String[] labels; // = {"Unlikely", "Neutral", "Likely"};
  float labelsSize, labelsY;

  int[] percentagesRounded; // = {68, 15, 17};
  String[] percentages; 
  float percentagesSize, percentagesY;
  int percentagesTotal = 0;


  int totalBins;
  float binsMargin, binsRange;
  float[] binsX; 
  color[] binsColors;
  float binsAlpha = 0;

  color binAColor, binBColor, textColor;


  String group; // = "All";
  String groupText = "Santa Monicans surveyed";
  float groupTextSize, groupTextY;

  String note; // = "Two thirds believe their children won't be able to remain in Santa Monica.";
  float noteY, noteTextSize, noteWidth, noteHeight;

  boolean lastInGroup;
  String actionCopy;

  float copyAlpha = 0;

  Dimension dimension;

  float duration = 2;

  Boolean active = false;

  float nothing = 0; // used to emulate timeOut


  Finding(String findingRaw, color _binAColor, color _binBColor, color _textColor) {
    
    if(RECORD) duration *= FPS;

    // load the data itself

    String[] dataRaw = split(findingRaw, ',');

    question = dataRaw[4];
    question = question.replace("|", ",");

    group = dataRaw[5];
    note = dataRaw[7];
    note = note.replace("|", ",");

    actionCopy = dataRaw[11];
    actionCopy = actionCopy.replace("|", ",");

    labels = split(dataRaw[9], '|');

    String[] percentagesRaw = split(dataRaw[8], '|'); 

    if (labels.length == percentagesRaw.length) {

      percentages = new String[percentagesRaw.length];
      percentagesRounded = new int[percentagesRaw.length];

      for (int i=0; i<percentages.length; i++) {
        percentages[i] = percentagesRaw[i];        
        percentagesTotal += round( float(percentages[i]) );
      }

      //println("percentagesTotal "+percentagesTotal);

      for (int j=0; j<percentages.length; j++) {
        if (percentagesTotal > 100) {
          percentagesRounded[j] = round((float(percentages[j])/percentagesTotal)*100);
          //print(percentagesRounded[j]);
        } else percentagesRounded[j] = round( float(percentages[j]) );
      }
      //println("");
    } else {
      println("!!! Percentages and labels not of same length: "+question);
    }

    lastInGroup = boolean(dataRaw[10]);


    // the colors of this finding

    binAColor = _binAColor;
    binBColor = _binBColor;
    textColor = _textColor;

    // setup all the placement stuff

    midLine = width*.5;

    questionY = height*.19;
    questionSize = height*0.052;
    questionWidth = width*.7;
    questionHeight = height*0.15;

    labelsSize = height*0.03;
    labelsY = height*0.606;

    percentagesSize = height*0.043;
    percentagesY = height*0.653;

    totalBins = labels.length;
    binsMargin = width*0.1;
    binsRange = width-(binsMargin*2.0);

    setBinColors();

    float binsSpacing = binsRange/totalBins;
    binsX = new float[totalBins];
    float baseX = binsMargin+(binsSpacing*.5);
    for (int i=0; i<totalBins; i++) {
      binsX[i] = baseX + binsSpacing*i;
    }

    groupTextSize = height * 0.043;
    groupTextY = height * 0.8;

    noteY = height*0.95;
    noteTextSize = height * 0.03;
    noteWidth = width*.8;
    noteHeight = groupTextSize*3;
  }

  void setBinColors() {
    binsColors = new color[totalBins];

    if (totalBins == 2) { 
      binsColors[0] = binAColor;
      binsColors[1] = binBColor;
    } else if (totalBins == 3) { 
      binsColors[0] = binAColor;
      binsColors[1] = neutralMid;
      binsColors[2] = binBColor;
    } else if (totalBins > 3) {
      for (int j=0; j<totalBins; j++) {
        float amt = map(j, 0, totalBins, 0, 1); // ceil(float(j)/totalBins);
        binsColors[j] = lerpColor(binAColor, binBColor, amt);
      }
    }
  }

  void render() {

    dimension = dimensionMan.currentDimension();

    pushMatrix();
    pushStyle();

    rectMode(CENTER);

    translate(midLine, 0);

    textFont(sharpSansBold);
    textAlign(CENTER, CENTER);
    textSize(questionSize);
    textLeading(questionSize*1.1);

    fill(red(textColor), green(textColor), blue(textColor), questionAlpha);
    text(question, 0, questionY+questionYOffset, questionWidth, questionHeight);


    textAlign(CENTER, TOP);
    textSize(groupTextSize);
    fill(red(textColor), green(textColor), blue(textColor), copyAlpha);
    text(group, 0, groupTextY-groupTextSize*1.125);

    fill(red(neutralDarker), green(neutralDarker), blue(neutralDarker), copyAlpha);

    text(groupText, 0, groupTextY);

    fill(red(neutralMid), green(neutralMid), blue(neutralMid), copyAlpha);
    textFont(sharpSansMedium);
    textSize(noteTextSize);
    //textAlign(CENTER, CENTER);
    text(note, 0, noteY, noteWidth, noteHeight);

    popStyle();
    popMatrix();

    renderBins();
  }

  void renderBins() {
    pushMatrix();
    pushStyle();

    for (int i=0; i<totalBins; i++) {

      fill(red(binsColors[i]), green(binsColors[i]), blue(binsColors[i]), binsAlpha );

      textFont(sharpSansBold);
      textAlign(CENTER, TOP);
      textSize(labelsSize);

      //float xOffset = binsSpacing*i;
      text(labels[i], binsX[i], labelsY);

      textFont(sharpSansMedium);
      textSize(percentagesSize);
      text(percentages[i]+"%", binsX[i], percentagesY);
    }

    popStyle();
    popMatrix();
  }

  void fadeUpQuestion() {
    active = true;

    binsAlpha = 0;

    questionAlpha = 0;
    float newAlpha = 255;
    Ani.to(this, duration*2, "questionAlpha", newAlpha, Ani.QUINT_OUT);

    questionYOffset = -questionHeight*0.5;
    float newYOffset = 0;
    Ani.to(this, duration, "questionYOffset", newYOffset, Ani.QUINT_OUT);

    Ani.to(this, duration*3, "nothing", 0, Ani.QUINT_OUT, "onEnd:showBins");
  }

  void showBins() {
    sceneMan.showFindingBins();
  }

  void fadeUpText() {
    copyAlpha = 0;
    float newAlpha = 255;
    Ani.to(this, duration, "copyAlpha", newAlpha, Ani.QUINT_OUT);
  }

  void fadeOutText() {
    float newAlpha = 0;

    questionAlpha = 255;
    Ani.to(this, duration, "questionAlpha", newAlpha, Ani.QUINT_OUT);

    copyAlpha = 255;
    Ani.to(this, duration, "copyAlpha", newAlpha, Ani.QUINT_OUT, "onEnd:deactivate");
  }

  void fadeUpBins() {

    binsAlpha = 0;
    float newAlpha = 255;
    Ani.to(this, duration, "binsAlpha", newAlpha, Ani.QUINT_OUT);

    if (lastInGroup) Ani.to(this, duration*10, "nothing", 0, Ani.QUINT_OUT, "onEnd:transitonOut");
    else Ani.to(this, duration*30, "nothing", 0, Ani.QUINT_OUT, "onEnd:nextFinding");
  }

  void nextFinding() {
    sceneMan.nextFinding();
  }

  void jumpCut() {
    active = true;

    questionAlpha = 255;
    copyAlpha = 255;
    binsAlpha = 255;

    if (lastInGroup) Ani.to(this, duration*6, "nothing", 0, Ani.QUINT_OUT, "onEnd:transitonOut");
    else Ani.to(this, duration*6, "nothing", 0, Ani.QUINT_OUT, "onEnd:nextFinding");
  }

  void transitonOut() {

    action.copy = actionCopy;
    sceneMan.showAction();
  }

  void fadeOutBins() {
    binsAlpha = 255;
    float newAlpha = 0;
    Ani.to(this, duration, "binsAlpha", newAlpha, Ani.QUINT_OUT);
  }

  void fadeOutAll() {
    fadeOutText();
    fadeOutBins();
  }

  void deactivate() {

    questionAlpha = 0;
    copyAlpha = 0;
    binsAlpha = 0;

    active = false;
  }
}
