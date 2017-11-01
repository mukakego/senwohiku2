class sen { 
  float a, b, c;
  ten suiten = null;

  //ax + by = c

  sen(float _a, float _b, float _c) {
    a = _a;
    b = _b;
    c = _c;
  }

  sen(ten _a, ten _b) {
    a = _a.x-_b.x;
    b = _a.y-_b.y;
    c = (
      +_a.x*_a.x+_a.y*_a.y
      -_b.x*_b.x-_b.y*_b.y
      )/2;
    suiten = new ten(
      (_a.x+_b.x)/2, (_a.y+_b.y)/2
      );
  }

  void display() {
    if (a != 0) {
      float x1 = (c - b * 0)/a;
      float x2 = (c - b * height)/a;
      line(x1, 0, x2, height);
    } else if (b != 0) {
      float y1 = c/b;
      float y2 = y1;
      line(0, y1, width, y2);
    }
  }
}

class ten {
  float x, y;
  sen[] parent = {null, null};

  ten(float _x, float _y) {
    x = _x;
    y = _y;
  }

  ten(float _x, float _y, sen _a, sen _b) {
    x = _x;
    y = _y;
    parent[0] = _a;
    parent[1] = _b;
  }

  void display() {
    ellipse(x, y, 5, 5);
  }
}

ten[] others = new ten[10];
ten center = new ten(0, 0);
sen[] waku;

void setup() {
  size(400, 400);

  for (int i = 0; i < others.length; i++) {
    others[i] = new ten(random(0, width), random(0, height));
  }

  fill(0);

  sen[] _waku = {
    new sen(1, 0, 0), 
    new sen(0, 1, 0), 
    new sen(1, 0, width), 
    new sen(0, 1, height)
  };
  waku = _waku;
}

void draw() {
  background(255); 

  center.x = mouseX;
  center.y = mouseY;

  int nagasa = others.length;

  sen[] takusan = new sen[nagasa];
  float nearestdist = width*width + height*height;
  int nearestnumb = -1;
  for (int i = 0; i < nagasa; i++) {
    takusan[i] = new sen(center, others[i]);
    float sans = distsq(center, others[i]);
    if (sans < nearestdist) {
      nearestdist = sans;
      nearestnumb = i;
    }
  }

  ten[] all = new ten[(nagasa+4)*(nagasa+3)/2];
  all[0] = new ten(    0, 0, waku[0], waku[1]);
  all[1] = new ten(width, 0, waku[1], waku[2]);
  all[2] = new ten(width, height, waku[2], waku[3]);
  all[3] = new ten(    0, height, waku[3], waku[0]);
  int count = 4;

  for (int i = 0; i < nagasa; i++) {
    for (int j = i + 1; j < nagasa; j++) {
      all[count] = cross(takusan[i], takusan[j]);
      count++;
    }
    for (sen mayj : waku) {
      all[count] = cross(takusan[i], mayj);
      count++;
    }
  }

  fill(0);
  stroke(0);
  center.display();
  for (ten matsutaka : others) {
    matsutaka.display();
  }
  for (int i = 0; i < nagasa; i++) {
    if (i == nearestnumb) {
      stroke(255, 0, 0);
    }
    takusan[i].display();
    stroke(0);
  }
  for (sen mayj : waku) {
    mayj.display();
  }
  fill(255, 0, 0);
  noStroke();
  for (ten matsutaka : all) {
    if (matsutaka!=null)matsutaka.display();
  }
}

ten cross(sen _a, sen _b) {
  float 
    a = _a.a, b = _a.b, c = _a.c, 
    d = _b.a, e = _b.b, f = _b.c, 
    determination = a * e - b * d;
  if (determination == 0) {
    return null;
  } else {
    float x = ( e * c - b * f) / determination;
    float y = (-d * c + a * f) / determination;
    return new ten(x, y, _a, _b);
  }
}

float distsq(ten _a, ten _b) {
  float x=_a.x-_b.x, y=_a.y-_b.y;
  return x*x+y*y;
}