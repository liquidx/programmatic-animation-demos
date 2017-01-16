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

void setup() {
  size(600, 500, P3D);
  smooth(8);
  strokeWeight(1.75);
  rectMode(CENTER);
  stroke(32);
  noFill();
  result = new int[width*height][3];
}

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
int numFrames = 160;
float shutterAngle = .7;

boolean recording = false;

void setup_() {
}

float x, y, tt;
int N = 24;
float qq;
float l = 19, th;
int n;

void circ(float q) {
  halfCirc(q);
  pushMatrix();
  scale(1, -1);
  halfCirc(q);
  popMatrix();
}

void halfCirc(float q) {
  beginShape();
  for (int i=0; i<=N; i++) {
    th = PI*i/N;
    qq = map(cos(TWO_PI*q-th/3), 1, -1, 0, 1);
    qq = ease(qq, 4.5);
    x = -l*cos(th);
    y = sqrt(l*l - x*x)*qq;
    vertex(x, y);
  }
  endShape();
}


void draw_() {
  background(250);
  pushMatrix();
  translate(width/2, height/2);
  scale(1.1);
  for (int a=0; a<10; a++) {
    n = 6*a;
    for (int b=0; b<n; b++) {
      pushMatrix();
      rotate(TWO_PI*(b+t)/n);
      translate(2.25*l*a - .04*l, 0);
      rotate(PI/6);
      circ((t + 100 - .04*a)%1);
      popMatrix();
    }
  }
  popMatrix();
}
