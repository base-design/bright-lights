// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Simple Particle System
class Particle {
  // Settings
  float maxspeed = (25 + random(1)) / global_scale ;
  float maxforce = (1 + random(.1)) / global_scale;
  String mode = "none";
  Vec2D[] patterns;
  Vec2D loc, target, offset, origin, start, vel, acc;
  PImage img;
  float size, targetSize;
  int groupId, id, order, currentPattern;
  color c;


  // variables related to modes. 
  Timer timer;
  Vec2D delta, rdelta;
  float rvel, rangle;

  Particle(Vec2D[] _locs, PImage _img, int _size, float _offset, int _gid, int _id) {
    img = _img;
    groupId = _gid;
    id = _id;
    size = _size;
    targetSize = _size;
    timer = new Timer(1000);
    c = color(255, 200);
    acc = new Vec2D(0, 0);
    vel = new Vec2D(0, 0);
    patterns = _locs;
    currentPattern = 0;
    origin = patterns[currentPattern]; 
    if (playback) start = new Vec2D(random(width), height + _size );
    else start = origin.copy();
    loc = (intro) ? start.copy() : origin.copy();
    target = (intro) ? start.copy() : origin.copy();
    offset = new Vec2D(_offset,_offset);
    delta = offset.copy().scale(0.25);

    if (!playback || colorful){
      switch(groupId) {
      case 0:
        c = color(255, 210, 219, 200);
        break;
      case 1:
        c = color(240, 210, 255, 200);
        break;
      case 2:
        c = color(216, 209, 255, 200);
        break;
      case 3:
        c = color(255, 214, 252, 200);
      }
      // println(groupId + " " + red(c) + " " + green(c) + " " + blue(c));
    }
  }


  void render() {
    imageMode(CENTER);
    tint(c);
    size = lerp(size, targetSize, 0.1 / global_scale);
    image(img, loc.x, loc.y, size * 1.0 / global_scale, size * 1.0 / global_scale );
    if (debug && false) { // deactivating debug on particles
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
    runEnterStage();
  }


  // MODES

  void stop() {
    mode = "none";
    target = origin.copy();
  }

  void setEnterStage(int o) {
    mode = "enterStage";
    order = o;
  }

  boolean entered = false;
  void runEnterStage() {
    if (!entered && initialized){
      
      if(order*frame_rate*10/(order+1) < frames) {
        target = origin.copy();
        entered = true;
      } else {
        target = start;
      }
    }
  }

  //CHANGE PATTERN
  
  void changePattern(int p){
    currentPattern = p;
    origin = patterns[currentPattern]; 
    target = origin.copy();
    checkCurrentPattern();
  }
  void checkCurrentPattern(){
    switch(currentPattern){
      case 2:
        targetSize = (id%2 == 0) ? targetSize : 0;
        break;
      case 3:
        targetSize = (id%4 == 0) ? targetSize : 0;
        break; 
      case 4:
        targetSize = (id%8 == 0) ? targetSize : 0;
      default:
        break;
    }
    if (size <= 25) c= color(red(c),green(c), blue(c), constrain(map(size,25,2,200,0), 0 ,200));
    
  }


  // BACK AND FORTH
  void setBackAndForth(Vec2D d, float w, float s) {
    mode = "backAndForth";
    timer.wait(parseInt(w * 1000));
    float mag;
    float angle = degrees(d.angleBetween(new Vec2D(1, 0)));
    if (angle % 180 > 90+60 || angle % 180 < 30 ) mag = offset.x;
    else if (angle % 90 > 30 || angle % 90 < 60 ) mag = offset.magnitude();
    else mag = delta.y;
    delta = d.normalize().scale(s * mag/3);
  }

  void runBackAndForth() {
    if (!timer.isRunning()) {
      target = origin.add(delta);
      timer.start();
    }
    if (timer.isFinished()) {
      delta = delta.rotate(PI);
    }
  }





  void setRotate(float sc, float v) {
    mode = "rotate";
    rdelta = new Vec2D(offset.x / 4 * sc, 0);
    rvel = radians(v*2);
  }

  void runRotate() {
    target = origin.add(rdelta.rotate(rvel) );
  }





  void grow(int s) {
//    mode = "grow";
    targetSize = s;
    checkCurrentPattern();
  }






















  void run() {
    
    runModes();
    update();
    render();
  }

  // Method to update location
  void update() {
    if (gravity) acc.set(0,1);
    if (!gravity) vel.addSelf(steer(target, true));
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
//      if (slowdown && d < 400.0f / global_scale) desired.scaleSelf(maxspeed*d/70.0f); // This damping is somewhat arbitrary
      if (slowdown && d < 400.0f / global_scale) desired.scaleSelf(map(d, 400 / global_scale,0,maxspeed,0)); // This damping is somewhat arbitrary
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
