// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {

  ArrayList<Particle> particles;    // An arraylist for all the particles
  ArrayList <Integer> order;
  int id, size;

  ParticleSystem(int num, PImage img, int s, int _id) {
    particles = new ArrayList();              // Initialize the arraylist
    size = s;
    id = _id;
    float ratio = 1.0 * width / height;
    int type = (num%2 == 0) ? 2 : 1;
    int cols = num + num%2;
    int rows = floor(num/ratio);
    Vec2D delta = new Vec2D(width / (cols +1), height / (rows +1));
    
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        Vec2D[] v = new Vec2D[10];
        v[0] = new Vec2D( (delta.x) + i * delta.x, (delta.y) + j * delta.y);
        v[1] = new Vec2D( (delta.x/type) + i * delta.x, (delta.y/type) + j * delta.y);
        particles.add( new Particle(v, img, size, delta, id));
      }
    }
  }
  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
    }
  }


  void stop() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.stop();
    }
  }



  void start( int cue) {
    order = new ArrayList();
    for (int i = 0; i < particles.size(); i++) {
      order.add(i);
    }

    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      int rand = (int) random(order.size());
      p.setEnterStage(order.get(rand));
      order.remove(rand);
    }
  }


  void backAndForth(String d, int w) {
    Vec2D vector = new Vec2D();
    if (d.equals("ud")) vector.set(0, 1);
    else if (d.equals("u")) vector.set(0, -1);
    else if (d.equals("d")) vector.set(0, 1);
    else if (d.equals("lr")) vector.set(1, 0);
    else if (d.equals("l")) vector.set(-1, 0);
    else if (d.equals("r")) vector.set(1, 0);
    else if (parseInt(d) != 0) vector.set(1, 0).rotate(radians(parseInt(d) ) );
//    println(vector);
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.setBackAndForth(vector, w);
    }
  }

  void rotate(float scale, float vel) {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.setRotate(scale, vel);
    }
  }


  void grow(int s) {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.grow(s);
    }
  }







  void addParticle( Vec2D[] v, PImage i, Vec2D d, int id ) {
    particles.add(new Particle(v, i, size, d, id));
  }

  void addParticle(Particle p) {
    particles.add(p);
  }
}

