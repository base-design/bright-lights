
//PREFERENCES
boolean debug = false;
// how scaled down.
int global_scale = 2;
// number of particles.
int ps_num[] = { 30,29,30,29};
// diameters per group
int ps_size[] = {30,50,40,70};

//Libraries
import toxi.geom.*; 

// Variables.=
ParticleSystem ps[] = new ParticleSystem[4];
PImage white;
int canvas_width = 5760;
int canvas_height = 1080;
boolean initialized = false;


void setup() {
  size(canvas_width / global_scale, canvas_height /global_scale, P2D);
  white = loadImage("white.png"); // Load our spotlight
  frameRate(30);
  // intialize the 4 systems
  for (int i = 0; i < ps.length; i++) {
    ps[i] = new ParticleSystem(ps_num[i], white, ps_size[i] / global_scale, i);
  }

  parseInstructions();


  //  for (int i = 0; i < 150; i++) {
  //    int type = i % 4;
  //    ps[type].addParticle(new Vec2D(random(width), height), lights[type], type);
  //  }
}

//preset  magnitude 1
Vec2D horizontal = new Vec2D(1, 0);
Vec2D vertical = new Vec2D(0,1);
Vec2D upright = new Vec2D(1,1).normalize();
Vec2D upleft = new Vec2D(-1,1).normalize();

void keyPressed() {
  
  //stop
  if (key == '1') {
    ps[0].stop();
  }
  if (key == 'q') {
    ps[1].stop();
  }
  if (key == 'a') {
    ps[2].stop();
  }
  if (key == 'z') {
    ps[3].stop();
  }



  //rotate : scale , velocity
  // clockwise > 0 > counterclockwise
  if (key == '2') {
    ps[0].rotate(1, 1);
  }
  if (key == 'w') {
    ps[1].rotate(1, 1);
  }
  if (key == 's') {
    ps[2].rotate(1,-1);
  }
  if (key == 'x') {
    ps[3].rotate(1,-1);
  }
}

void draw() {
  // Additive blending!
  blendMode(ADD);
  background(0); 
  runInstructions();
  for (int i = 0; i < ps.length; i++) {
    ps[i].run();
  }
  
  
  if (!initialized) {
    initialized = true; 
    for (int i = 0; i < ps.length; i++) {
      ps[i].start(i);
    }
  
}
}

