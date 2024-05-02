import hypermedia.net.*; //<>//
UDP udp;

void setup() {
  udp = new UDP(this, 8080);
  udp.listen(true);

  size(800, 800);
}

int len1 = 200, len2 = 200;
float dir1 = 0, dir2 = 0;

Section s = new Section(0, 0, len1), c = new Section(s.endX, s.endY, len2);

void draw() {
  background(255);
  stroke(200);
  line(0, 400, 800, 400);
  line(400, 0, 400, 800);

  calculateAngles(s, c, mouseX-400, mouseY-400);
  c.turnTo(mouseX-400, mouseY-400);
  translate(width/2, height/2);
  strokeWeight(5);
  stroke(0);
  s.show();
  strokeWeight(3);
  stroke(255, 0, 0);
  c.show();
  circle(mouseX-400, mouseY-400, 10);
}

void calculateAngles(Section first, Section second, int x, int y) {
  float straightPath = dist(first.startX, first.startY, x, y);
  first.setDirection(
    cosineRule(straightPath, x-first.startX, y-first.startY) + cosineRule(straightPath, first.len, second.len)
    );
  if (Double.isNaN(first.direction)) {
    first.turnTo(x, y);
  } else if (y <= first.startX) {
    first.setDirection(-first.direction);
  }
  second.update(first);
}

/**
 returns the angle between a and b in radians
 */
float cosineRule(float a, float b, float c) {
  float bottom = -2*a*b;
  if (bottom==0) {
    bottom = 0.1;
  }
  return (float)(acos((c*c-a*a-b*b)/(bottom)));
}

void receive(byte[] data, String ip, int port) {

  data = subset(data, 0, data.length-2);
  String message = new String( data );
  
  println(message);
}
