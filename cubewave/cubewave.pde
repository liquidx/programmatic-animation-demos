// by davey aka @beesandbombs

int[][] result;
float t, c;

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5)
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

float mn = .5*sqrt(3);

//void setup() {
//  setup_();
//}

void draw() {

  if (!recording) {
    t = mouseX*1.0/width;
    c = mouseY*1.0/height;
    if (mousePressed)
      println(c);
    draw_();
  } else {
    for (int i=0; i<width*height; i++)
      for (int a=0; a<3; a++)
        result[i][a] = 0;

    c = 0;
    for (int sa=0; sa<samplesPerFrame; sa++) {
      t = map(frameCount-1 + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
      draw_();
      loadPixels();
      for (int i=0; i<pixels.length; i++) {
        result[i][0] += pixels[i] >> 16 & 0xff;
        result[i][1] += pixels[i] >> 8 & 0xff;
        result[i][2] += pixels[i] & 0xff;
      }
    }

    loadPixels();
    for (int i=0; i<pixels.length; i++)
      pixels[i] = 0xff << 24 |
        int(result[i][0]*1.0/samplesPerFrame) << 16 |
        int(result[i][1]*1.0/samplesPerFrame) << 8 |
        int(result[i][2]*1.0/samplesPerFrame);
    updatePixels();

    saveFrame("f###.gif");
    if (frameCount==numFrames)
      exit();
  }
}

//////////////////////////////////////////////////////////////////////////////

int samplesPerFrame = 8;
int numFrames = 100;
float shutterAngle = .5;

boolean recording = false;

void setup() {
  size(640, 600, P3D);
  smooth(8);
  ortho();
  rectMode(CENTER);
  fill(32);
  noStroke();

  result = new int[width*height][3];
}

float x, y, tt;
int N = 7;
float l = 22;

color c3 = #82bbb5, c2 = #3f5484, c1 = #e7e5b0;

void column(float h) {
  fill(c1);
  pushMatrix();
  translate(0, 0, l/2);
  rect(0, 0, l, h);
  popMatrix();
  pushMatrix();
  translate(0, 0, -l/2);
  rect(0, 0, l, h);
  popMatrix();

  fill(c2);
  pushMatrix();
  rotateY(HALF_PI);
  translate(0, 0, l/2);
  rect(0, 0, l, h);
  popMatrix();
  pushMatrix();
  rotateY(-HALF_PI);
  translate(0, 0, l/2);
  rect(0, 0, l, h);
  popMatrix();

  fill(c3);
  pushMatrix();
  translate(0, h/2, 0);
  rotateX(HALF_PI);
  rect(0, 0, l, l);
  popMatrix();
  pushMatrix();
  translate(0, -h/2, 0);
  rotateX(HALF_PI);
  rect(0, 0, l, l);
  popMatrix();
}


void draw_() {
  background(250);
  pushMatrix();
  translate(width/2, height/2);
  rotateX(-atan(sqrt(.5)));
  rotateY(QUARTER_PI);
  for (int i=-N; i<=N; i++) {
    for (int j=-N; j<=N; j++) {
      pushMatrix();
      translate(i*l*.99, 0, j*l*.99);
      column(map(cos(TWO_PI*t - .064*sq(dist(i,j,0,0))),1,-1,80,280));
      popMatrix();
    }
  }
  popMatrix();
}
