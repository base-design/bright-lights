import toxi.geom.*; 

ParticleSystem ps[] = new ParticleSystem[4];
PImage lights[] = new PImage[4];
int sizes[] = {50, 60, 70,40 };

boolean debug = false;

void setup() {
  size(1470, 870, P2D);

  // Create an alpha masked image to be applied as the particle's texture

  for (int i = 0; i < ps.length; i++) {
    lights[i] = loadImage( (i+1) + ".png");
    ps[i] = new ParticleSystem(50, lights[i], sizes[i]);
  } 


  //  for (int i = 0; i < 150; i++) {
  //    int type = i % 4;
  //    ps[type].addParticle(new Vec2D(random(width), height), lights[type], type);
  //  }
}

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
    ps[0].backAndForth(new Vec2D(100, 0).rotate(radians(30)), 3000);
  }
  if (key == 'e') {
    ps[1].backAndForth(new Vec2D(150, 0).rotate(radians(60)), 3000);
  }
  if (key == 'd') {
    ps[2].backAndForth(new Vec2D(70, 0).rotate(radians(90+30)), 4500);
  }
  if (key == 'c') {
    ps[3].backAndForth(new Vec2D(70, 0).rotate(radians(90+60)), 1500);
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

