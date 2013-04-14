import toxi.geom.*; 

ParticleSystem ps[] = new ParticleSystem[4];
PImage lights[] = new PImage[4];
PImage white;
int sizes[] = {50, 60, 70,40 };

boolean debug = false;

void setup() {
  size(1470, 870, P2D);

  // Create an alpha masked image to be applied as the particle's texture


  white = loadImage("white.png");

  for (int i = 0; i < ps.length; i++) {
    lights[i] = loadImage( (i+1) + ".png");
  } 
    ps[0] = new ParticleSystem(10, white, 40);
    ps[1] = new ParticleSystem(10, white, 70);
    ps[2] = new ParticleSystem(9, white, 30);
    ps[3] = new ParticleSystem(9, white, 50);


  //  for (int i = 0; i < 150; i++) {
  //    int type = i % 4;
  //    ps[type].addParticle(new Vec2D(random(width), height), lights[type], type);
  //  }
}

//preset vectors.

Vec2D v50 = new Vec2D(50, 0);
Vec2D v100 = new Vec2D(100, 0);
Vec2D v150 = new Vec2D(150, 0);




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

  //back and forth
  if (key == '3') {
    ps[0].backAndForth( v100.rotate(radians(90)), 1500);
  }
  if (key == 'e') {
    ps[1].backAndForth( v100.rotate(radians(90)), 1500);
  }
  if (key == 'd') {
    ps[2].backAndForth( v100.rotate(radians(90)), 1500);
  }
  if (key == 'c') {
    ps[3].backAndForth( v100.rotate(radians(90)), 1500);
  }


  //rotate
  if (key == '2') {
    ps[0].rotate(new Vec2D(4, 0).rotate(PI/4), 0.05);
  }
  if (key == 'w') {
    ps[1].rotate(new Vec2D(4, 0).rotate(PI/4), 0.05);
  }
  if (key == 's') {
    ps[2].rotate(new Vec2D(4, 0).rotate(PI/4), 0.05);
  }
  if (key == 'x') {
    ps[3].rotate(new Vec2D(4, 0).rotate(PI/4), 0.05);
  }


}




void draw() {

  // Additive blending!
  blendMode(ADD);
  background(0);
  for (int i = 0; i < ps.length; i++) {
    ps[i].run();
  }
  //  println(ps[1].currentMode());
}

