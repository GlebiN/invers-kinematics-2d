import websockets.*; //<>//
WebsocketServer ws;

void setup() {
  ws = new WebsocketServer(this, 8080, "");

  size(1000, 1000);
  //fullScreen();

  len1 = (height>width ? width : height)/4;
  len2 = len1;
  s = new Section(0, 0, len1);
  c = new Section(s.endX, s.endY, len2);
}

int len1, len2;
float dir1 = 0, dir2 = 0;

int destX = 0, destY = 0, destZ = 0;

Section s, c;

void draw() {
  background(255);
  stroke(200);
  line(0, height/2, width, height/2);
  line(width/2, 0, width/2, height);
  translate(width/2, height/2);

  //destX = mouseX - width/2;
  //destY = mouseY - height/2;

  calculateAngles(s, c, destX, destY);


  strokeWeight(5);
  stroke(0);
  s.show();
  strokeWeight(3);
  stroke(255, 0, 0);
  c.show();
  circle(destX, destY, 10);
}

void calculateAngles(Section first, Section second, int x, int y) {
  float straightPath = dist(first.startX, first.startY, x, y);
  first.setDirection(
    cosineRule(straightPath, x-first.startX, y-first.startY)
    +
    cosineRule(straightPath, first.len, second.len));
  if (Double.isNaN(first.direction)) {
    first.turnTo(x, y);
  } else if (y <= first.startX) {
    first.setDirection(-first.direction);
  }
  second.update(first);
  second.turnTo(destX, destY);
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

void webSocketServerEvent(String msg) {
  println(msg);
  String[] cords = msg.split(",");
  destX = (int)(Double.parseDouble(cords[0])*width/2);
  destY = (int)(Double.parseDouble(cords[1])*height/2);
  destZ = (int)(Double.parseDouble(cords[2]));
  println("x: " + destX + " y: " + destY + " z: " + destZ);
}
