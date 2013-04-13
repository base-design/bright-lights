// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {

  ArrayList<Particle> particles;    // An arraylist for all the particles
  int size;

  ParticleSystem(int num, PImage img, int s) {
    particles = new ArrayList();              // Initialize the arraylist
    size = s;
    int res = ceil(sqrt(num));
    int rows = width / res;
    int cols = height / res;
    
    println(rows + " "+ res );
    for (int i = 0; i < res; i++) {
      for (int j = 0; j < cols; j++) {
        Vec2D v = new Vec2D((rows/2) + i * rows, (cols/2) + j * cols);
        particles.add( new Particle(v, img, size));
      }
    }
    
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }


  String currentMode(){
    Particle pp = particles.get(0);
   return pp.currentMode();
  }


  void stop(){
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.stop();
    }  
  }

  void backAndForth(Vec2D d, int w){
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.setBackAndForth(d,w);
    }
  }
  
  void rotate(Vec2D d, float r){
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.setRotate(d,r);
    }
  }









  void addParticle( Vec2D v, PImage i ) {
    particles.add(new Particle(v, i, size));
  }

  void addParticle(Particle p) {
    particles.add(p);
  }

  // A method to test if the particle system still has particles
  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } 
    else {
      return false;
    }
  }
}


