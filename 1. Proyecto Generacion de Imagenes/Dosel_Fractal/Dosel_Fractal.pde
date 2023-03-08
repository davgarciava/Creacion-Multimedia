float largoRamaInicial;  // Largo  de la primera rama, la madre de todas
float gruesoRamaInicial;  // Grueso de la primera rama, la madre de todas
float anguloEntreRamas;  // Ángulo entre dos ramas EN RADIANES.
float factorDeLongitud;  // Factor de disminución de longitud entre la rama madre y sus ramas hijas.
int nivelMaximo; // Nivel de profundidad máximo a dibujar.

ArrayList<ArrayList<Rama>> fractales;
ArrayList<Rama> ramas;
ArrayList<Rama> anterioresRamas;

void setup() {
  colorMode(HSB, 360, 100, 100);
  frameRate(1);
  size(1000, 1000);
  background(0);
  nuevoFractal();
}

int nivel = 0;
float hue = random(6);

// DIBUJAR TODAS LAS RAMAS DE UN MISMO NIVEL (MOVIMIENTO DE ABAJO A ARRIBA).
void draw() {
  delay(1000);
  background(0);
  
  if (nivel > nivelMaximo) {
    delay(5000);
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
      ArrayList<Rama> fractal = fractales.get(f);
      
      for(int r = 0; r < sumaRamas; r++) {
        Rama rama = fractal.get(r);
        color colorRama = color(60*hue, 100-(15*rama.nivel), 100);
        rama.dibujar(rama.grueso, colorRama);
      }
    }
  }
  
  nivel += 1;
}

void generarRamas() {
  ArrayList siguientesRamas = new ArrayList<Rama>();
  for (Rama rama : anterioresRamas) {
    
    // Punto inicial de las tres nuevas ramas hijas.
    PVector i = rama.fin;
    // Nivel de la rama padre. 
    int nivel = rama.nivel;
    
    // El objeto Fractal tiene tres funciones, cada una de las cuales devuelve un PVector de acuerdo con las reglas para formar cada rama del fractal.
    PVector a = rama.puntoA(anguloEntreRamas, factorDeLongitud);
    PVector b = rama.puntoB(anguloEntreRamas, factorDeLongitud);
    PVector c = rama.puntoC(anguloEntreRamas, factorDeLongitud);
    
    siguientesRamas.add(new Rama(i, a, rama.grueso*factorDeLongitud, nivel+1));
    siguientesRamas.add(new Rama(i, b, rama.grueso*factorDeLongitud, nivel+1));
    siguientesRamas.add(new Rama(i, c, rama.grueso*factorDeLongitud, nivel+1));
  }
 
  anterioresRamas = siguientesRamas;
  ramas.addAll(siguientesRamas);
}

void nuevoFractal() {
  fractales = new ArrayList<ArrayList<Rama>>();
  
  largoRamaInicial = random(width/6, width/4);
  gruesoRamaInicial = random(5, 10);
  anguloEntreRamas = random(30, 120);
  factorDeLongitud = random(0.65, 0.75);
  nivelMaximo = int(random(4, 5));
  int despRamaInicial = int(random(width/2));
  int anguloRamaInicial = int(random(30, 90));
  
  for(int f = 0; f < 4; f++) {
    ramas = new ArrayList<Rama>();
    anterioresRamas = new ArrayList<Rama>();

    PVector inicio;
    PVector fin;
    
    if(f == 0) {
      inicio = new PVector(despRamaInicial, 0);
      fin   = new PVector(despRamaInicial + largoRamaInicial, 0);
    } else if(f == 1) {
      inicio = new PVector(width, despRamaInicial);
      fin   = new PVector(width, despRamaInicial + largoRamaInicial);
    } else if(f == 2) {
      inicio = new PVector(width - despRamaInicial, height);
      fin   = new PVector(width - largoRamaInicial - despRamaInicial, height);
    } else {
      inicio = new PVector(0, height - despRamaInicial);
      fin   = new PVector(0, height - largoRamaInicial - despRamaInicial);
    }
    
    PVector x = PVector.sub(fin, inicio);
    x.rotate(radians(anguloRamaInicial));
    x.add(inicio);
    fin = x;
    
    Rama ramaInicial = new Rama(inicio, fin, gruesoRamaInicial, 0);
    
    ramas.add(ramaInicial);
    anterioresRamas.add(ramaInicial);
     
    // Aplicar las reglas del fractal un nivel máximo de veces.
    for (int i = 1; i <= nivelMaximo; i++) {
      generarRamas();
    }
    
    fractales.add(ramas);
  }
}
