float largoRamaInicial;  // Largo  de la primera rama, la madre de todas
float gruesoRamaInicial;  // Grueso de la primera rama, la madre de todas
float anguloEntreRamas;  // Ángulo entre dos ramas EN RADIANES.
float factorDeLongitud;  // Factor de disminución de longitud entre la rama madre y sus ramas hijas.
int nivelMaximo; // Nivel de profundidad máximo a dibujar.

ArrayList<ArrayList> fractales;
ArrayList<Fractal> ramas;
ArrayList<Fractal> anterioresRamas;

void setup() {
  colorMode(HSB, 360, 100, 100);
  frameRate(1);
  size(800, 800);
  background(0);
  nuevoFractal();
}

int nivel = 0;
float hue = random(6);

// DIBUJAR TODAS LAS RAMAS DE UN MISMO NIVEL (MOVIMIENTO DE ABAJO A ARRIBA).
void draw() {
  background(0);
  
  if (nivel > nivelMaximo) {
    delay(3000);
    nivel = 0;
    hue = random(6);
    nuevoFractal();
  }
  
  for(int i = 0; i <= nivel; i++) {
    
    int sumaRamas = 0;
   
    for(int exp = 0; exp <= nivel; exp++) {
      sumaRamas += pow(3, exp);
    }
    
    for(int f = 0; f < 4; f++) {
      ArrayList<Fractal> fractal = fractales.get(f);
      
      for(int r = 0; r < sumaRamas; r++) {
        Fractal rama = fractal.get(r);
        
        color colorRama = color(60*hue, random(25,100), 100);
        rama.dibujar(rama.grueso, colorRama);
      }
    }
  }
  
  nivel += 1;
}

void generarRamas() {
  ArrayList siguientesRamas = new ArrayList<Fractal>();
  for (Fractal rama : anterioresRamas) {
    
    // Punto inicial de las tres nuevas ramas hijas.
    PVector i = rama.fin;
    
    // El objeto Fractal tiene tres funciones, cada una de las cuales devuelve un PVector de acuerdo con las reglas para formar cada rama del fractal.
    PVector a = rama.puntoA(anguloEntreRamas, factorDeLongitud);
    PVector b = rama.puntoB(anguloEntreRamas, factorDeLongitud);
    PVector c = rama.puntoC(anguloEntreRamas, factorDeLongitud);
    
    siguientesRamas.add(new Fractal(i, a, rama.grueso * factorDeLongitud));
    siguientesRamas.add(new Fractal(i, b, rama.grueso * factorDeLongitud));
    siguientesRamas.add(new Fractal(i, c, rama.grueso * factorDeLongitud));
  }
 
  anterioresRamas = siguientesRamas;
  ramas.addAll(siguientesRamas);
}

void nuevoFractal() {
  fractales = new ArrayList<ArrayList>();
  
  largoRamaInicial = random(150, 250);
  gruesoRamaInicial = random(5, 10);
  anguloEntreRamas = random(30, 120);
  factorDeLongitud = random(0.5, 0.8);
  nivelMaximo = int(random(4, 6));
  
  for(int f = 0; f < 4; f++) {
    ramas = new ArrayList<Fractal>();
    anterioresRamas = new ArrayList<Fractal>();
    
    PVector inicio;
    PVector fin;
    
    if(f == 0) {
      inicio = new PVector(0, 0);
      fin   = new PVector(largoRamaInicial, 0);
    } else if(f == 1) {
      inicio = new PVector(width, 0);
      fin   = new PVector(width, largoRamaInicial);
    } else if(f == 2) {
      inicio = new PVector(width, height);
      fin   = new PVector(width - largoRamaInicial, height);
    } else {
      inicio = new PVector(0, height);
      fin   = new PVector(0, height - largoRamaInicial);
    }
    
    PVector x = PVector.sub(fin, inicio);
    x.rotate(radians(45));
    x.add(inicio);
    fin = x;
    
    Fractal ramaInicial = new Fractal(inicio, fin, gruesoRamaInicial);
    
    ramas.add(ramaInicial);
    anterioresRamas.add(ramaInicial);
     
    // Aplicar las reglas del fractal un nivel máximo de veces.
    for (int i = 1; i <= nivelMaximo; i++) {
      generarRamas();
    }
    
    fractales.add(ramas);
  }
}

/* DIBUJAR RAMA POR RAMA (MOVIMIENTO DE IZQUIERDA A DERECHA).
void draw() {
  background(0);
  
  if (indice >= ramas.size()){
    delay(5000);
    indice = 0;
  }
  
  for(int i = 0; i <= indice; i++){
    Fractal rama = ramas.get(i);
    color colorRama = color(random(100,255), random(100,255), random(100,255));
    rama.dibujar(colorRama);
  }
  
  indice += 1;
}
*/
