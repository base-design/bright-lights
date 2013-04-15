// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Simple Particle System
class Particle {
  // Settings
  float maxspeed = (10 + random(1)) / global_scale ;
  float maxforce = (1 + random(.1)) / global_scale;
  String mode = "none";
  Vec2D[] patterns;
  Vec2D loc, target, offset, origin, start, vel, acc;
  PImage img;
  float size, targetSize;
  int groupId, order, currentPattern;
  color c;


  // variables related to modes. 
  Timer timer;
  Vec2D delta, rdelta;
  float rvel, rangle;

  Particle(Vec2D[] l, PImage i, int s, Vec2D d, int _id) {
    img = i;
    groupId = _id;
    size = s;
    targetSize = s;
    timer = new Timer(1000);
    c = color(255, 200);
    acc = new Vec2D(0, 0);
    vel = new Vec2D(0, 0);
    patterns = l;
    currentPattern = 0;
    origin = patterns[currentPattern]; 
    if (playback) start = new Vec2D(random(width), height + s );
    else start = origin.copy();
    loc = start.copy();
    target = start.copy();
    delta = d.copy();
    offset = d.copy();
    if (!playback){
    switch(groupId) {
    case 0:
      c = color(255, 0, 0, 200);
      break;
    case 1:
      c = color(0, 255, 0, 200);
      break;
    case 2:
      c = color(0, 255, 255, 200);
      break;
    case 3:
      c = color(255, 255, 0, 200);
    }
//    println(groupId + " " + red(c) + " " + green(c) + " " + blue(c));
    }
  }


  void render() {
    imageMode(CENTER);
    tint(c);
    size = lerp(size, targetSize, 0.1 / global_scale);
    image(img, loc.x, loc.y, size * 1.0 / global_scale, size * 1.0 / global_scale );
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
    if (angle % 180 > 90+60 || angle % 180 < 30 ) mag = offset.x;
    else if (angle % 90 > 30 || angle % 90 < 60 ) mag = offset.magnitude();
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

