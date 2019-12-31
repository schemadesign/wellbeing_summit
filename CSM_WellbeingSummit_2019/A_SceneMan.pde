class SceneManager {

  Dimension currentDimension;


  SceneManager() {
    
  }

  void init() {
    //nextFinding();
    showDimensionsIntro();
    //showFinding();
    //topLogo.fadeUp();
    //physicsMan.centerOrbs();
    //action.fadeUp();
  }

  void update() {
    
    currentDimension = dimensionMan.currentDimension();

    if (dimensionsIntro.active) dimensionsIntro.render();
    if (definition.active) definition.render();    
    if (topLogo.active) topLogo.render();

    if (physicsMan.active) physicsMan.update();
    if (currentDimension.currentFinding.active) currentDimension.currentFinding.render();
    if (action.active) action.render();
  }

  void showDimensionsIntro() {
    if (action.active) action.fadeOut();
    if (topLogo.active) topLogo.fadeOut();
    dimensionsIntro.transitionIn();
  }

  void showTopLogo() {
    topLogo.fadeUp();
  }

  void showDefinition() {
    definition.fadeUp();
  }

  void showFinding() {
    physicsMan.activate();

    int totalOrbs = 100;
    if (currentDimension.currentFinding.percentagesTotal < 100) totalOrbs = currentDimension.currentFinding.percentagesTotal;
    physicsMan.centerOrbs(totalOrbs);

    currentDimension.currentFinding.fadeUpQuestion();
  }

  void nextFinding() {
    //currentDimension = dimensionMan.currentDimension();
    
    currentDimension.currentFinding.deactivate();
    currentDimension.nextFinding();
    currentDimension.currentFinding.jumpCut();
    physicsMan.distributeOrbs( currentDimension.currentFinding );
  }


  void showFindingBins() {
    try {
      physicsMan.distributeOrbs( currentDimension.currentFinding );

      currentDimension.currentFinding.fadeUpText();
      currentDimension.currentFinding.fadeUpBins();
    } 
    catch (Error e) {
      println(e);
      return;
    }
  }

  void showAction() {

    physicsMan.disperseOrbs();
    currentDimension.currentFinding.fadeOutAll();
    currentDimension.nextFinding();

    action.fadeUp();
  }
  
}
