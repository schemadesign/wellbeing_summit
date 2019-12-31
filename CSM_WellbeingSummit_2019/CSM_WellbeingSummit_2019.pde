/*

 .-""-.
 (___/\ \
 ,                 (|^ ^ ) )
 /(                _)_\=_/  (
 ,..__/ `\          ____(_/_ ` \   )
 `\    _/        _/---._/(_)_  `\ (
 '--\ `-.__..-'    /.    (_), |  )
 `._        ___\_____.'_| |__/
 `~----"`   `-.........'
 
 
 */



import de.looksgood.ani.*;

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

PApplet root;

// A reference to our box2d world
Box2DProcessing box2d;

PFont sharpSansBold, sharpSansMedium;

DimensionManager dimensionMan;

DimensionsIntro dimensionsIntro;
TopLogo topLogo;
Definition definition;

Action action;
//Finding finding;

PhysicsManager physicsMan;

SceneManager sceneMan;

PImage ref;

color headerText = #272089;
color neutralLight = #A6A6A6;
color neutralMid = #959595;
color neutralDark = #535353;
color neutralDarker = #454545;

Boolean RECORD = true; // set to true if we're recording this
int FPS = 60;

Boolean DEV = false; // development mode

void settings() {
  if (RECORD) {
    if (DEV)size(1920, 1080, P3D);
    else size(3840, 2160, P3D);
  } else {
    if (DEV)size(1920, 1080, P3D);
    else fullScreen(P3D); // ready for display
  }
}

void setup() {

  /* 
   ** setup environment
   */

  noCursor();
  root = this;


  box2d = new Box2DProcessing(root);
  box2d.createWorld();
  box2d.setGravity(0, 0); // No global gravity force

  //ref = loadImage("ref/FindingView.png");  // used for aligning graphics to comps

  sharpSansBold = createFont("SharpSansNo1-Bold", 128, true);
  sharpSansMedium = createFont("SharpSansNo1-Medium", 128, true);

  Ani.init(this);
  if (RECORD) Ani.setDefaultTimeMode(Ani.FRAMES);

  /* 
   ** create elements
   */

  action = new Action();
  dimensionMan = new DimensionManager();

  dimensionsIntro = new DimensionsIntro();

  topLogo = new TopLogo();
  definition = new Definition();

  physicsMan = new PhysicsManager();

  sceneMan = new SceneManager();
}

void draw() {
  background(255);

  //image(ref, 0, 0, width, height); // used for aligning graphics to comps

  if (frameCount == 10) sceneMan.init();
  sceneMan.update();

  if (RECORD) { 
    if( dimensionMan.loopedAround() ) exit();
    else saveFrame("/Users/admin/Desktop/output/CSM_WellbeingSummit_2019-######.png");
  }
}

float MillisTime()
{
  return frameCount*1000.0/float(FPS);
} 
