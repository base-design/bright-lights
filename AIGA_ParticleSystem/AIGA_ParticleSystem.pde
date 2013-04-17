
//PREFERENCES
boolean debug = true;
boolean playback = true;
boolean intro = false;

boolean recording = false;
boolean colorful = true;
String instructions_file = "instructions_test.txt";
// scale down.
int global_scale = 3;
int frame_rate = 30;


// number of particles.
int ps_num[] = { 
  26, 25, 26, 25
};
// diameters per group
int ps_size[] = {
  50, 50, 50, 50
};

//Libraries
import toxi.geom.*; 


// Variables.=
ParticleSystem ps[] = new ParticleSystem[4];
PImage white;
int canvas_width = 5760;
int canvas_height = 1080;
int frames = 0;
boolean initialized = false;
boolean gravity = false;
PFont mono;
String currentTime = nf(hour(), 2)+"-"+nf(minute(), 2)+"-"+nf(second(), 2);
Vec2D g = new Vec2D(0,1);


void setup() {
  size(canvas_width / global_scale, canvas_height /global_scale, P2D);
  white = loadImage("white.png"); // Load our spotlight
  smooth();
  mono = createFont("Courier", 11);
  textFont(mono);
  frameRate(frame_rate);

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
Vec2D vertical = new Vec2D(0, 1);
Vec2D upright = new Vec2D(1, 1).normalize();
Vec2D upleft = new Vec2D(-1, 1).normalize();

void keyPressed() {
  if (key == 'f') {
     gravity = true;
  }
  
  
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
    ps[2].backAndForth("l", 1, 1);
    ps[3].backAndForth("r", 1, 1);
  }
  if (key == '4') {
    ps[0].grow(100,0.1);
    ps[1].grow(100,0.1);
    ps[2].grow(100,0.1);
    ps[3].grow(100,0.1);
  }
  if (key == '5') {
    ps[0].grow(150,0.1);
    ps[1].grow(150,0.1);
    ps[2].grow(150,0.1);
    ps[3].grow(150,0.1);
  }
  if (key == '6') {
    ps[0].grow(100,0.1);
    ps[1].grow(25,0.1);
    ps[2].grow(100,0.1);
    ps[3].grow(25,0.1);
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
    if (debug) text(i + " " + ps[i].currentMode(), 10, i*13 +15 );
  }
  fill(255);
  if (debug) text("framerate: " + parseInt(frameRate) + "\t\t\t elapsed: " + millis()/1000, 10, height-10);



  if (!initialized) {
    initialized = true; 
    for (int i = 0; i < ps.length; i++) {
      if (intro) ps[i].start(i);
    }
  }
  if (recording) saveFrame("exports/movie-"+ currentTime +"/" + "frame-#####.png"); 
  frames++;
}

