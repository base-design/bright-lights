int start; 
float timer;

float thresholdL;
float thresholdR;
float[] thresholds = {
  1000, 2000, 1500, 2500
};
int[] imageIndex = {
  0, 1, 2, 3
};
int[] prevMillis= {
  0, 0, 0, 0
};
int prevMillisR=0;
float x = 0.0;

int maxImages = 4; // Total # of images
int imageIndexLeft = 0; // Initial image to be displayed is the first

int maxImagesRight = 8; // Total # of images
int imageIndexRight = 0;

PImage[] imagesA = new PImage[maxImages]; 
PImage[] imagesB = new PImage[maxImages]; 
PImage baseImgL;
PImage baseImgR;

int posXLeft;
int posYLeft;

int posXRight;
int posYRight;
float scaleX;
float scaleY;

boolean scaleMask = false;

void setup() {
  background(0);

  // adjust image position and scale
  posXLeft= 0;
  posYLeft= 0;

  posXRight= 720;
  posYRight = 0;

  scaleX = 720;
  scaleY = 900;

  size(1440, 900);
  start = millis();
  // speed
  thresholdL = random(1000, 3000);
  thresholdR = random (4000, 7000);

  for (int i = 0; i < imagesA.length; i ++ ) {
    imagesA[i] = loadImage( "A" + i + ".png" );
  }
  for (int i = 0; i < imagesB.length; i ++ ) {
    imagesB[i] = loadImage( "B" + i + ".png" );
  }
}

void draw() {  
  background(0);
  displayPics();
}

void displayPics() {
  // left x
  image(imagesA[imageIndex[0]], posXLeft, posYLeft, scaleX, scaleY); 
  image(imagesB[imageIndex[1]], posXLeft, posYLeft, scaleX, scaleY);

  // right x
  image(imagesA[imageIndex[2]], posXRight, posYRight, scaleX, scaleY); 
  image(imagesB[imageIndex[3]], posXRight, posYRight, scaleX, scaleY); 


  for (int i = 0; i < thresholds.length; i++) {
    if (millis() - prevMillis[i] >= thresholds[i])
    {
      imageIndex[i] = int(random(maxImages));
      prevMillis[i] += thresholds[i];
    }
  }
}

