// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Simple Particle System

class Particle {
  Vec2D loc, target, vel, acc;


  // variables related to modes. 
  Vec2D delta;
  float deltaRotate;
  Timer timer;
  
  
  float lifespan;
  PImage img;
  int size;
  float maxspeed, maxforce;
  String mode = "none";
  
  // Another constructor (the one we are using here)
  Particle(Vec2D l, PImage i, int s) {
    // Boring example with constant acceleration
    acc = new Vec2D(0, 0);
    vel = new Vec2D(random(1) - 0.5, random(1) - 0.5).scale(3);
    loc = l.copy();
    target = l.copy();
    maxspeed = 5;
    maxforce = 0.5;
    img = i;
    size = s;
    lifespan = 255;
    timer = new Timer(1000);


  }


  // Method to display
  void render() {
    imageMode(CENTER);
    tint(155,200);
    image(img, loc.x, loc.y, size, size);
    if (debug) {
      fill(255);
      noStroke();
      ellipse(target.x, target.y, 4, 4);
      stroke(255);
      line(loc.x, loc.y, loc.x+vel.scale(10).x, loc.y+vel.scale(10).y);
    }
  }


  void runModes() {
    if (mode.equals("backAndForth")) runBackAndForth();
    if (mode.equals("rotate")) runRotate();
  }


  String currentMode() {
    return mode;
  }



  void stop(){
  mode = "none";
  }


  void setBackAndForth(Vec2D d, int w) {
    mode = "backAndForth";
    timer.wait(w);
    delta = d.copy().scale(random(.2)+1);
  }

  void runBackAndForth() {
    if (!timer.isRunning()) {
      target.addSelf(delta);
      timer.start();
    }
    if (timer.isFinished() ) {
      delta = delta.rotate(PI);
    }
  }





  void setRotate(Vec2D d, float r) {
    mode = "rotate";
    delta = d.copy().scale(random(.2)+1);
    deltaRotate = r;
  }

  void runRotate() {
    target.addSelf(delta);
    delta = delta.rotate(deltaRotate);
  }


























  void run() {
    runModes();
    update();
    render();
  }

  // Method to update location
  void update() {
    vel.addSelf(steer(target, true));
    vel.addSelf(acc);
    loc.addSelf(vel);
    //    lifespan -= 2.0;
  }



  // Is the particle still useful?
  boolean isDead() {
    if (lifespan <= 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }

  Vec2D steer(Vec2D target, boolean slowdown) {
    Vec2D steer;  // The steering vector
    Vec2D desired = target.sub(loc);  // A vector pointing from the location to the target
    float d = desired.magnitude(); // Distance from the target is the magnitude of the vector
    // If the distance is greater than 0, calc steering (otherwise return zero vector)
    if (d > 0) {
      // Normalize desired
      desired.normalize();
      // Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
      if (slowdown && d < 100.0f) desired.scaleSelf(maxspeed*d/50.0f); // This damping is somewhat arbitrary
      else desired.scaleSelf(maxspeed);
      // Steering = Desired minus Velocity
      steer = desired.sub(vel).limit(maxforce);  // Limit to maximum steering force
    } 
    else {
      steer = new Vec2D();
    }
    return steer;
  }
}

