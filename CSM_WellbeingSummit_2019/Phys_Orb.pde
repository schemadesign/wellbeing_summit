// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// Box2DProcessing example

// Showing how to use applyForce() with box2d

class Orb {

  // We need to keep track of a Body and a radius
  Body body;
  float padding;
  float radius, diameter;

  Vec2 pos;
  PVector origin, destination;

  float G = 100; // Strength of force
  
  float diagonal;

  color c;

  Orb(float _radius, float _padding, float x, float y) {
    radius = _radius;// size of circle rendered to screen
    padding = _padding; // size of physics body
    
    diameter = radius*2;
    
    origin = new PVector(x, y);
    destination = new PVector(x, y);  // the destination is the origin – so deep
    
    // Define a body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;

    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(padding);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;

    // Parameters that affect physics
    fd.density = 10;
    fd.friction = 0.0;
    fd.restitution = 0.0;

    body.createFixture(fd);
    
    diagonal = dist(0, 0, width, height);

  }

  void setDestination(float x, float y) {
    destination = new PVector(x, y);
  }
  
  void setDestinationOrigin() {
    destination = origin;
  }

  void attract() {

    Vec2 dest = box2d.coordPixelsToWorld(destination); 
    Vec2 bodyVec = body.getWorldCenter();

    // force is stronger the closer to target
    PVector local = box2d.coordWorldToPixelsPVector(bodyVec);
    float force = (PVector.dist(local, destination)) *0.20; //1000;//(diagonal-PVector.dist(local, destination)) *0.25 + 500;
    //println(force);
    if(force < 45) force *= 0.4;
    else if(force < 22.5) force *= 0.2;
    else if(force < 10.75) force *= 0.1;

    // First find the vector going from this body to the specified point
    dest.subLocal(bodyVec);

    // Then, scale the vector to the specified force
    dest.normalize();
    dest.mulLocal(force);

    // Now apply it to the body's center of mass.
    body.setLinearVelocity(dest);
    
    //Vec2 velo = body.getLinearVelocity();
    //if( velo.length() < 10) body.setLinearVelocity( dest.mulLocal(0) );

    
  }

  void setColor(color _c) {
    c = _c;
  }

  void display() {
    //c = dimensionMan.currentDimension().circleColor;

    pushMatrix();
    pushStyle(); 

    // We look at each body and get its screen position
    pos = box2d.getBodyPixelCoord(body);
    translate(pos.x, pos.y);

    fill(c);
    noStroke();
    ellipse(0, 0, diameter, diameter);

    popStyle();
    popMatrix();
  }

  void update() {
    attract();
    display();
  }
}
