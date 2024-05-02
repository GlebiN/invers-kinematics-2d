class Section {
  int startX, startY, len, endX, endY;
  float direction = 0; //radians

  Section(int startX, int startY, int len) {
    this.startX = startX;
    this.startY = startY;
    this.len = len;
    setDirection(direction);
  }

  void turnTo(int x, int y) {
    direction = acos((x-startX)/dist(startX, startY, x, y));
    if (y<=startY) {
      direction = -direction;
    }
    
    setDirection(direction);
  }

  void update(Section master) {
    this.startX = master.endX;
    this.startY = master.endY;
  }

  void setDirection(float newDirection){
    this.direction = newDirection;
    endX = (int)(this.startX + len*cos(newDirection));
    endY = (int)(this.startY + len*sin(newDirection));
  }

  void show() {
    line(
      startX,
      startY,
      endX,
      endY
      );
  }
}
