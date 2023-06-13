class Figura {
  //Parámetros de creación
  float x, y, rand;
  float diametro;
  int id;
  
  //Cambios en coordenadas
  float vx = 0;
  float vy = 0;
 
  Figura(float xin, float yin, float din) {
    x = xin;
    y = yin;
    diametro = din;
    id = ultimoId;
    ultimoId++;
    rand=random(0,1);
  } 
  
  void colisionar() {
    for (int i = id + 1; i < figuras.size(); i++) {
      float dx = figuras.get(i).x - x;
      float dy = figuras.get(i).y - y;
      float distancia = sqrt(dx*dx + dy*dy);
      float minDist = figuras.get(i).diametro/2 + diametro/2;
      if (distancia < minDist) { 
        float angulo = atan2(dy, dx);
        float objetivoX = x + cos(angulo) * minDist;
        float objetivoY = y + sin(angulo) * minDist;
        float ax = (objetivoX - figuras.get(i).x) * fuerza;
        float ay = (objetivoY - figuras.get(i).y) * fuerza;
        vx -= ax;
        vy -= ay;
        figuras.get(i).vx += ax;
        figuras.get(i).vy += ay;
      }
    }   
  }
  
  void mover() {
    vy += gravedad;
    x += vx;
    y += vy;
    if (x + diametro/2 > width) {
      x = width - diametro/2;
      vx *= friccion; 
    }
    else if (x - diametro/2 < 0) {
      x = diametro/2;
      vx *= friccion;
    }
    if (y + diametro/2 > height) {
      y = height - diametro/2;
      vy *= friccion; 
    } 
    else if (y - diametro/2 < 0) {
      y = diametro/2;
      vy *= friccion;
    }
  }

  
  void dibujar() {
    // Obtener el color de un píxel en la posición de indicada (Mouse o Controlador OSC)
    color colorPixel = foto.get(int(x), int(y));
    fill(colorPixel);
    //noStroke();
    if (rand>0.7){
      rect(x, y, diametro, diametro/2);
    } else {
      ellipse(x, y, diametro, diametro);
    }
  }
}
