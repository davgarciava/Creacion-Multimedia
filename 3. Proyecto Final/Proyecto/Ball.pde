class Ball {
  //Parámetros de creación
  float x, y;
  float diameter;
  int id;
  
  //Cambios en coordenadas
  float vx = 0;
  float vy = 0;
 
  Ball(float xin, float yin, float din) {
    x = xin;
    y = yin;
    diameter = din;
    id = lastId;
    lastId++;
  } 
  
  void collide() {
    for (int i = id + 1; i < bolas.size(); i++) {
      float dx = bolas.get(i).x - x;
      float dy = bolas.get(i).y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = bolas.get(i).diameter/2 + diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - bolas.get(i).x) * spring;
        float ay = (targetY - bolas.get(i).y) * spring;
        vx -= ax;
        vy -= ay;
        bolas.get(i).vx += ax;
        bolas.get(i).vy += ay;
      }
    }   
  }
  
  void move() {
    vy += gravity;
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction; 
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction; 
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
  }

  
  void display() {
    int nx=int(x);
    int ny=int(y);
    color pixelColor = snapshot.get(nx, ny);
    fill(pixelColor);
    noStroke();
    ellipse(x, y, diameter, diameter);
  }
}
