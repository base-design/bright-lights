// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {

  ArrayList<Particle> particles;    // An arraylist for all the particles
  ArrayList <Integer> order;
  int id, size;
  String currentMode = "";

  ParticleSystem(int num, PImage img, int s, int _id) {
    particles = new ArrayList();              // Initialize the arraylist
    size = s;
    id = _id;
    float ratio = 1.0 * width / height;
    int type = (num%2 == 0) ? 2 : 1;
    int cols = num + num%2;
    int rows = floor(num/ratio);
    float offset = width / (cols +1);
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        Vec2D[] v = new Vec2D[10];
        
        v[0] = new Vec2D( (offset + ( offset/4 * ( id%2 * 2 - 1 ) ) ) + i * offset, (offset + ( offset/4 * (id/2*2 - 1) ) ) + j * offset);
        v[1] = new Vec2D( offset + i * offset, offset + j * offset);
        v[2] = new Vec2D( 2*offset/type + i/2 * 2*offset, 2*offset/type + j/2 * 2* offset);
        v[3] = new Vec2D( -offset/1.5 + offset*4/type + i/4 * 4.5*offset, -offset/2 + offset*4/type + j/4 * 4* offset);
        v[4] = new Vec2D( offset*4.5 + i/9 * 9*offset, offset*2.5 + j/9 * 9*offset);

        particles.add( new Particle(v, img, size, offset, id, i));
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

  void changePattern(int pt) {
    currentMode= currentMode.replaceAll(" *changePattern:[0-9]*", "") + " changePattern:"+pt;
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.changePattern(pt);
    }
  }

  void backAndForth(String d, float w, float s) {
    currentMode = "backAndForth:" + d+","+w+","+s;
    Vec2D vector = new Vec2D();
    if (d.equals("u")) vector.set(0, -1);
    else if (d.equals("d")) vector.set(0, 1);
    else if (d.equals("l")) vector.set(-1, 0);
    else if (d.equals("r")) vector.set(1, 0);
    else if (parseInt(d) != 0) vector.set(1, 0).rotate(radians(parseInt(d) ) );
//    println(vector);
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.setBackAndForth(vector, w, s);
    }
  }

  void rotate(float scale, float vel) {
    currentMode = "rotate:"+scale+","+vel;
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.setRotate(scale, vel);
    }
  }


  void grow(int s) {
    currentMode += " grow";
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.grow(s);
    }
  }

  String currentMode(){
    return currentMode;
  }





//  void addParticle( Vec2D[] v, PImage i, Vec2D d, int id ) {
//    particles.add(new Particle(v, i, size, d, id));
//  }
//
//  void addParticle(Particle p) {
//    particles.add(p);
//  }
}

