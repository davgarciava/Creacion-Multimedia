import processing.sound.*;
import processing.video.*;
import oscP5.*;

//Parámetros de los circulos
float fuerza = 0.05;
float gravedad = 0.1;
float friccion = 0.05;
int ultimoId=0;
ArrayList<Figura> figuras = new ArrayList<Figura>();

//Para el efecto de tomar la foto
PGraphics efectoFlash;
int tiempoDeCaptura = 0;
int opacidad = 0;
boolean flash = false;

//Para sonido
SoundFile sonidoFlash;
SoundFile sonidoGota;

//Para video
Capture video;
PImage foto;
boolean tomarFoto = false;

//Para guardar imagen
boolean guardar = false;

//Para manejar correctamente con el controlador OSC
float OSCx;
float OSCy;
ArrayList<Figura> figurasOSC = new ArrayList<Figura>();
boolean regresar = false;

void setup() {
  size(720, 405);
  video = new Capture(this, width, height);
  video.start();
  efectoFlash = createGraphics(720,405);
  sonidoFlash = new SoundFile(this, "cameraflash.aiff");
  sonidoGota = new SoundFile(this, "drop.aiff");
  OscP5 oscP5 = new OscP5(this, 11111);
}



//Mensajes OSC
void oscEvent(OscMessage oscMessage) {
  println(" addrpattern: "+oscMessage.addrPattern());
  //oscMessage.print();
  
  if (tomarFoto && (oscMessage.checkAddrPattern("/oscControl/x") || oscMessage.checkAddrPattern("/oscControl/y"))){
    if (oscMessage.checkAddrPattern("/oscControl/x")) {
      OSCx = oscMessage.get(0).floatValue();
    } else {
      OSCy = oscMessage.get(0).floatValue();
    }
    generarFiguras(OSCx, OSCy, true);
  } else if (oscMessage.checkAddrPattern("/oscControl/foto")) {
    capturarImagen();
  } else if (oscMessage.checkAddrPattern("/oscControl/regresar")) {
    regresar = true;
  } else if (oscMessage.checkAddrPattern("/oscControl/guardar")) {
    guardarImagen();
  } else if (oscMessage.checkAddrPattern("/oscControl/salir")) {
    exit();
  }
}

void draw() {
  if (guardar) {
    save("image.png");
    guardar = false;
  } else if (video.available()) {
    video.read();
    if (!tomarFoto) {
      // Mostrar el video en tiempo real
      image(video, 0, 0);
    } else {
      if (!flash) {
        sonidoFlash.play();
        flash = true;
      }
      tiempoDeCaptura++;
      // Mostrar la imagen capturada
      if (tiempoDeCaptura <= 20) {
        efectoFlash.beginDraw();
        efectoFlash.background(255, 255, 255, opacidad);
        efectoFlash.endDraw();
        image(efectoFlash, 0, 0);
        opacidad += 5;
      } else if (tiempoDeCaptura > 20 && tiempoDeCaptura <= 100) {
        image(foto, 0, 0);
        tiempoDeCaptura++;
        opacidad = 0;
      } else if(tiempoDeCaptura > 100 && tiempoDeCaptura <= 120) {
        efectoFlash.beginDraw();
        efectoFlash.background(0, 0, 0, opacidad);
        efectoFlash.endDraw();
        image(efectoFlash, 0, 0);
        opacidad += 5;
      } else {
        background(0);
      }
      if (mouseX >= 0 && mouseX < width && mouseY >= 0 && mouseY < height && mousePressed) {
        generarFiguras(mouseX, mouseY, false);
      }
      
      for (Figura figura : figuras) {
        figura.colisionar();
        figura.mover();
        figura.dibujar();
      }
      
      figuras.addAll(figurasOSC);
      figurasOSC.clear();
      
      if (regresar) {
        regresar = false;
        regresarVideo();
      }
    }
  } 
}

void mouseClicked() {
  capturarImagen();
}

void keyPressed() {
  if (key == BACKSPACE){
    regresarVideo();
  } else if (key == ENTER) {
    guardarImagen();
  }
}

void capturarImagen() {
  if (!tomarFoto) {
    // Capturar la imagen actual
    foto = video.get();
    tomarFoto = true;
  }
}

void regresarVideo() {
  figuras.clear();
  ultimoId=0;
  tomarFoto = false;
  tiempoDeCaptura = 0;
  opacidad = 0;
  flash = false;
}

void guardarImagen() {
  guardar = true;
}

void generarFiguras(float x, float y, boolean osc) {
  sonidoGota.play();
  // Crear una nuevo conjunto de figuras en la posición del mouse o según el controlador OSC
  if (osc) {
    for (int i=0;i<10;i++){
      figurasOSC.add(new Figura(x,y,random(10,30)));
    }
  } else {
    for (int i=0;i<10;i++){
      figuras.add(new Figura(x,y,random(10,30)));
    }
  }
}
