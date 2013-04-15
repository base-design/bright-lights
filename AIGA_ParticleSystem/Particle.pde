// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Simple Particle System
class Particle {
  // Settings
  float maxspeed = 5 + random(1);
  float maxforce = 0.5 + random(.1);
  String mode = "none";

  Vec2D loc, target, origin, start, vel, acc;
  PImage img;
  float size, targetSize;
  int id, order;



  // variables related to modes. 
  Timer timer;
  Vec2D delta, rdelta;
  float rvel, rangle;

  Particle(Vec2D l, PImage i, int s, Vec2D d, int _id) {
    img = i;
    id = _id;
    size = s;
    targetSize = s;
    timer = new Timer(1000);

    acc = new Vec2D(0, 0);
    vel = new Vec2D(0, 0);
    origin = l.copy();

    start = new Vec2D(random(width), height + s );
    loc = start.copy();
    target = start.copy();
    delta = d.copy();
  }


  void render() {
    imageMode(CENTER);
    tint(255, 200);
    size = lerp(size,targetSize, 0.05);
    image(img, loc.x, loc.y, size, size);
    if (debug) {
      fill(255);
      noStroke();
      ellipse(target.x, target.y, 4, 4);
      stroke(255);
      line(loc.x, loc.y, loc.x+vel.scale(10).x, loc.y+vel.scale(10).y);
    }
  }


  // helper to run the modes
  void runModes() {
    if (mode.equals("backAndForth")) runBackAndForth();
    if (mode.equals("rotate")) runRotate();
    if (mode.equals("enterStage"))  runEnterStage();
  }


  // MODES

  void stop() {
    mode = "none";
  }

  void setEnterStage(int o) {
    mode = "enterStage";
    order = o;
  }

  void runEnterStage() {
    target = origin.copy();
  }


  // BACK AND FORTH
  void setBackAndForth(Vec2D d, int w) {
    mode = "backAndForth";
    timer.wait(w * 1000);
    float mag;
    float angle = degrees(d.angleBetween(new Vec2D(1, 0)));
    if (angle % 180 > 90+60 || angle % 180 < 30 ) mag = delta.x;
    else if (angle % 90 > 30 || angle % 90 < 60 ) mag = delta.magnitude();
    else mag = delta.y;
    delta = d.normalize().scale(mag);
  }

  void runBackAndForth() {
    if (!timer.isRunning()) {
      target.addSelf(delta);
      timer.start();
    }
    if (timer.isFinished()) {
      delta = delta.rotate(PI);
    }
  }





  void setRotate(float sc, float v) {
    mode = "rotate";
    rdelta = new Vec2D(delta.x, 0);
    rvel = radians(v);
  }

  void runRotate() {
    target = origin.add(rdelta.rotate(rvel) );
  }





  void grow(int s) {
    mode = "grow";
    targetSize = s;
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

