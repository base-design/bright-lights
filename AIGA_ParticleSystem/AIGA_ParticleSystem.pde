
//PREFERENCES
boolean debug = false;
boolean playback = true;
boolean intro = false;

String instructions_file = "instructions_5.txt";

// how scaled down.
int global_scale = 3;

// number of particles.
int ps_num[] = { 26,25,26,25};
// diameters per group
int ps_size[] = {50,50,50,50};

//Libraries
import toxi.geom.*; 
import penner.easing.*;


// Variables.=
ParticleSystem ps[] = new ParticleSystem[4];
PImage white;
int canvas_width = 5760;
int canvas_height = 1080;
boolean initialized = false;
PFont mono;

void setup() {
  size(canvas_width / global_scale, canvas_height /global_scale, P2D);
  white = loadImage("white.png"); // Load our spotlight
  smooth();
  mono = createFont("Courier", 11);
  textFont(mono);


  // intialize the 4 systems
  for (int i = 0; i < ps.length; i++) {
    ps[i] = new ParticleSystem(ps_num[i], white, ps_size[i], i);
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
    ps[1].stop();
    ps[2].stop();
    ps[3].stop();
  }
  if (key == '2') {
    ps[0].rotate(1, 1);
    ps[1].rotate(1, -1);
    ps[2].rotate(1, 1);
    ps[3].rotate(1, -1);
  }
  if (key == '3') {
    ps[0].backAndForth("u", 1, 1);
    ps[1].backAndForth("d", 1, 1);
    ps[2].backAndForth("l", 1,1);
    ps[3].backAndForth("r", 1,1);
  }
  if (key == '4') {
    ps[0].grow(100);
    ps[1].grow(100);
    ps[2].grow(100);
    ps[3].grow(100);
  }
  if (key == '5') {
    ps[0].grow(150);
    ps[1].grow(150);
    ps[2].grow(150);
    ps[3].grow(150);
  }
  if (key == '6') {
    ps[0].grow(100);
    ps[1].grow(25);
    ps[2].grow(100);
    ps[3].grow(25);
  }


  if (key == '7') {
    for (int i = 0; i < ps.length; i++) {
      ps[i].changePattern(0);
    }
  }
  if (key == '8') {
    for (int i = 0; i < ps.length; i++) {
      ps[i].changePattern(1);
    }
  }
  if (key == '9') {
    for (int i = 0; i < ps.length; i++) {
      ps[i].changePattern(2);
    }
  }
  if (key == '0') {
    for (int i = 0; i < ps.length; i++) {
      ps[i].changePattern(3);
    }
  }
  if (key == '-') {
    for (int i = 0; i < ps.length; i++) {
      ps[i].changePattern(4);
    }
  }

}

void draw() {
  // Additive blending!
  blendMode(ADD);
  background(0); 
  if (playback) runInstructions();
  for (int i = 0; i < ps.length; i++) {
    ps[i].run();
  }
  fill(255);
  text("framerate: " + parseInt(frameRate) + "\t\t\t elapsed: " + millis()/1000, 10, height-10);
  
  
  if (!initialized) {
    initialized = true; 
    for (int i = 0; i < ps.length; i++) {
      if (intro) ps[i].start(i);
    }
  
}
}

