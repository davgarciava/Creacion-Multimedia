import processing.sound.*;
import processing.video.*;

//Parámetros de los circulos
float spring = 0.05;
float gravity = 0.1;
float friction = 0.05;
int lastId=0;
ArrayList<Ball> bolas = new ArrayList<Ball>();

//Efecto de foto
PGraphics photo;
int timeSnapshot = 0;
int alpha = 0;
boolean flash = false;

//Sonido
SoundFile flashSound;
SoundFile dropSound;

//Video
Capture video;
PImage snapshot;
boolean takeSnapshot = false;

//Para guardar imagen
boolean save = false;

void setup() {
  size(720, 405);
  video = new Capture(this, width, height);
  video.start();
  photo = createGraphics(720,405);
  flashSound = new SoundFile(this, "cameraflash.aiff");
  dropSound = new SoundFile(this, "drop.aiff");
}

void draw() {
  if (save) {
    save("image.png");
    save = false;
  } else if (video.available()) {
    video.read();
    if (!takeSnapshot) {
      // Mostrar el video en tiempo real
      image(video, 0, 0);
    } else {
      if (!flash) {
        flashSound.play();
        flash = true;
      }
      timeSnapshot++;
      // Mostrar la imagen capturada
      if (timeSnapshot <= 20) {
        photo.beginDraw();
        photo.background(255, 255, 255, alpha);
        photo.endDraw();
        image(photo, 0, 0);
        alpha += 5;
      } else if (timeSnapshot > 20 && timeSnapshot <= 100) {
        image(snapshot, 0, 0);
        timeSnapshot++;
        alpha = 0;
      } else if(timeSnapshot > 100 && timeSnapshot <= 120) {
        photo.beginDraw();
        photo.background(0, 0, 0, alpha);
        photo.endDraw();
        image(photo, 0, 0);
        alpha += 5;
      } else {
        background(0);
      }
      if (mouseX >= 0 && mouseX < width && mouseY >= 0 && mouseY < height && mousePressed) {
        dropSound.play();
        for (int i=0;i<10;i++){
          generateCircles();
        }
      }
    }
  } 

  for (Ball ball : bolas) {    
    ball.collide();
    ball.move();
    ball.display();
  }
}

void mouseClicked() {
  if (!takeSnapshot) {
    // Capturar la imagen actual
    snapshot = video.get();
    takeSnapshot = true;
  }
}

void keyPressed() {
  if (key == BACKSPACE){
    bolas = new ArrayList<Ball>();
    lastId=0;
    takeSnapshot = false;
    timeSnapshot = 0;
    alpha = 0;
    flash = false;
  } else if (key == ENTER) {
    save = true;
  }
}

void generateCircles() {
  // Obtener el color de un píxel en la posición del mouse
  float x = mouseX;
  float y = mouseY;
  
  // Crear una nueva figura en la posición del mouse
  bolas.add(new Ball(x,y,random(10,20)));
}
