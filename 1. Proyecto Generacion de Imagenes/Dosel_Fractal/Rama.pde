class Rama {
 
  //Una línea entre dos puntos: inicio y fin
  PVector inicio;
  PVector fin;
  float grueso;
  int nivel;
 
  Rama (PVector a, PVector b, float c, int d) {
    inicio = a.copy();
    fin = b.copy();
    grueso = c;
    nivel = d;
  }

  void dibujar(float gruesoRama, color colorRama) {
    strokeWeight(gruesoRama);
    stroke(colorRama);
    // Dibuje la línea de inicio a fin del PVector.
    line(inicio.x, inicio.y, fin.x, fin.y); 
  }
  
  PVector puntoA(float anguloEntreRamas, float factorDeLongitud) {

    PVector a = PVector.sub(fin, inicio);
    // Reducir el vector en una fracción del padre según el factor de longitud.
    a.mult(factorDeLongitud);
    
    // Girar "sobre" la línea padre unos 60 grados hacia en sentido anti-horario.
    a.rotate(-anguloEntreRamas);
    
    // Mover ese vector hasta el punto de fin de la rama padre.
    a.add(fin);
    
    return a;
  }
  
  PVector puntoB(float anguloEntreRamas, float factorDeLongitud) {
    
    PVector b = PVector.sub(fin, inicio);
    // Reducir el vector en una fracción del padre según el factor de longitud.
    b.mult(factorDeLongitud);
    
    // Mover ese vector hasta el punto de fin de la rama padre.
    b.add(fin);
    
    return b;
  }
  
  PVector puntoC(float anguloEntreRamas, float factorDeLongitud) {

    PVector c = PVector.sub(fin, inicio);
    // Reducir el vector en una fracción del padre según el factor de longitud.
    c.mult(factorDeLongitud);
    
    
    // Girar "sobre" la línea padre unos 60 grados hacia en sentido horario.
    c.rotate(anguloEntreRamas);
    
    // Mover a ese vector hasta el punto de fin de la rama padre.
    c.add(fin);
    
    return c;
  }
 
}
