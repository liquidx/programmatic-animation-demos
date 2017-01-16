// Andrew Glassner - www.glassner.com & www.imaginary-institute.com
import AULib.*;


float S;
float Cx, Cy;
AUCamera Camera;
AUStepper Stepper;

void setup() {
  size(500, 500);

  boolean saveFrames = true;
  int numFrames = 120;   // output frames
  int numExposures = saveFrames ? 8 : 1;  // snapshots per frame
  float[] stepLengths = { 60, 60}; // relative lengths
  int numSnapshots = numFrames * numExposures;
  Stepper = new AUStepper(numSnapshots, stepLengths);
  Camera = new AUCamera(this, numFrames, numExposures, saveFrames);
  S = width/4.;
  Cx = width/2.;
  Cy = height/2.;
}

void draw() {
  background(255);
  fill(0);
  noStroke();
  Stepper.step();  // same result as Camera.getTime();
  pushMatrix();
    switch (Stepper.getStepNum()) {
       case 0: phase0(Stepper.getAlfa()); break;
       case 1: phase1(Stepper.getAlfa()); break;
    }
  popMatrix();
  Camera.expose();
}

void phase0(float alfa) {
  float w2 = width/2.;
  float h2 = height/2.;
  float angle = TWO_PI*lerp(5/8., 6/8., alfa);
  float sr = S*sqrt(2.);
  PVector P = new PVector(sr*cos(angle), sr*sin(angle));
  PVector K = new PVector(-w2, -h2);
  PVector Q = new PVector(-w2, lerp((-h2)+S, -h2, alfa));
  PVector R = new PVector(lerp((-w2)+S, w2, alfa), -h2);
  pushMatrix();
    translate(Cx, Cy);
    rotate(alfa*QUARTER_PI);
    rect(-S, -S, 2*S, 2*S);
    endShape();
  popMatrix();
  for (int i=0; i<4; i++) {
    pushMatrix();
      translate(Cx, Cy);
      rotate(i*HALF_PI);
      quad(P.x, P.y, Q.x, Q.y, K.x, K.y, R.x, R.y);
    popMatrix();
  }
}


void phase1(float alfa) {
  float w2 = width/2.;
  float h2 = height/2.;
  float sr = S*sqrt(2.);
  float c = lerp(0, S, alfa);
  float angle = TWO_PI*lerp(6/8., 7/8., alfa);
  PVector P = new PVector(sr*cos(angle), sr*sin(angle));
  PVector K = new PVector(-w2, -h2);
  PVector Q = new PVector((-w2)+c, (-h2)+c);
  PVector R = new PVector(w2-c, (-h2)+c);
  pushMatrix();
    translate(Cx, Cy);
    rotate((alfa+1)*QUARTER_PI);
    rect(-S, -S, 2*S, 2*S);
    endShape();
  popMatrix();
  for (int i=0; i<4; i++) {
    pushMatrix();
      translate(Cx, Cy);
      rotate(i*HALF_PI);
      rect(K.x, K.y, Q.x-K.x, Q.y-K.y);
      triangle(P.x, P.y, Q.x, Q.y, R.x, R.y);
    popMatrix();
  }
}

void phase2(float alfa) {
  phase0(0);
}

float ease(float t) {
  return(map(cos(t*PI), 1, -1, 0, 1));
}

float bias(float t, float bias) {
  return t/((((1.0/bias)-2)*(1.0-t))+1);
}
