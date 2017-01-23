// Andrew Glassner - www.glassner.com & www.imaginary-institute.com
import AULib.*;

class Bbox {
  float cx, cy, s;
  color clr;

  Bbox(float acx, float acy, float as, color aclr) {
    cx = acx;
    cy = acy;
    s = as;
    clr = aclr;
  }

  void render(float alfa, float angle) {
    alfa = alfa%1;
    noFill();
    float ulx = cx-(s/2.);
    float uly = cy-(s/2.);
    float r = s*.6;
    float theta2 = (3*HALF_PI) + (alfa*HALF_PI);
    float theta3 = (PI) - (alfa*HALF_PI);
    float x2 = 0 + (r*cos(theta2));
    float y2 = s + (r*sin(theta2));
    float x3 = s + (r*cos(theta3));
    float y3 = 0 + (r*sin(theta3));
    pushMatrix();
      translate(cx, cy);
      rotate(angle);
      translate(-s/2., -s/2.0);
      noFill();
      //rect(0, 0, s, s);
      fill(clr);
      noStroke();
      beginShape();
        vertex(s, 0);
        vertex(0, 0);
        vertex(0, s);
        bezierVertex(x2, y2, x3, y3, s, 0);
      endShape();
    popMatrix();
  }
}

AUCamera Camera;
Bbox BboxList[];
int Res = 20;
color BGcolor = color(40, 50, 50);
color FGcolor = color(220, 200, 195);

void setup() {
  size(500, 500);
  Camera = new AUCamera(this, 180, 10, true);
  float unit = width*1.0/Res;
  float gap = unit * 0;
  float sq = unit-gap;
  BboxList = new Bbox[Res*Res];
  for (int y=0; y<Res; y++) {
    for (int x=0; x<Res; x++) {
      int index = (y*Res)+x;
      BboxList[index] = new Bbox((gap/2)+(sq/2)+(x*unit), (gap/2)+(sq/2)+(y*unit), sq, FGcolor);
    }
  }
}

void draw() {
  float time = Camera.getTime();
  background(BGcolor);
  for (int y=0; y<Res; y++) {
    for (int x=0; x<Res; x++) {
      int index = (y*Res)+x;
      float d = 1-(dist(BboxList[index].cx, BboxList[index].cy, width/2., height/2.)/(.5*mag(width, height)));
      float alfa = map(cos(TWO_PI*(d+time)), 1, -1, 0.1, .99);
      int qturns = 0;
      float angle = 0;
      qturns = x%2;
      if (y%2 == 1) qturns = 3-qturns;
      angle = qturns * HALF_PI;
      BboxList[index].render(alfa, angle);
    }
  }
  Camera.expose();
}
