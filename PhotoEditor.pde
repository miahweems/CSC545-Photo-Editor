PImage originalImage;
PImage currentImage;

void setup() {
  size(800, 800);
  originalImage = loadImage("queenstown.jpg");
  currentImage = originalImage.copy();
}

void draw() {
  background(255);
  image(currentImage, 0, 0);
  windowResizable(true);
  windowResize(originalImage.width, originalImage.height);
}

void keyPressed() {
  if (key == 'r') rotateImage();
  else if (key == 'h') flipHorizontal();
  else if (key == 'v') flipVertical();
  else if (key == 'b') adjustBrightness(10);
  else if (key == 'n') adjustBrightness(-10);
  else if (key == 'c') adjustContrast(1.1);
  else if (key == 'x') adjustContrast(0.9);
  else if (key == 's') adjustShadows(20);
  else if (key == 'a') adjustShadows(-20);
}

void rotateImage() {
  PGraphics temp = createGraphics(currentImage.height, currentImage.width);
  temp.beginDraw();
  temp.translate(temp.width / 2, temp.height / 2);
  temp.rotate(HALF_PI);
  temp.imageMode(CENTER);
  temp.image(currentImage, 0, 0);
  temp.endDraw();
  currentImage = temp.get();
}

void flipHorizontal() {
  currentImage.loadPixels();
  for (int y = 0; y < currentImage.height; y++) {
    for (int x = 0; x < currentImage.width / 2; x++) {
      int i = x + y * currentImage.width;
      int j = (currentImage.width - 1 - x) + y * currentImage.width;
      color temp = currentImage.pixels[i];
      currentImage.pixels[i] = currentImage.pixels[j];
      currentImage.pixels[j] = temp;
    }
  }
  currentImage.updatePixels();
}

void flipVertical() {
  currentImage.loadPixels();
  for (int y = 0; y < currentImage.height / 2; y++) {
    for (int x = 0; x < currentImage.width; x++) {
      int i = x + y * currentImage.width;
      int j = x + (currentImage.height - 1 - y) * currentImage.width;
      color temp = currentImage.pixels[i];
      currentImage.pixels[i] = currentImage.pixels[j];
      currentImage.pixels[j] = temp;
    }
  }
  currentImage.updatePixels();
}

void adjustBrightness(float amount) {
  currentImage.loadPixels();
  for (int i = 0; i < currentImage.pixels.length; i++) {
    float r = red(currentImage.pixels[i]) + amount;
    float g = green(currentImage.pixels[i]) + amount;
    float b = blue(currentImage.pixels[i]) + amount;
    currentImage.pixels[i] = color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
  }
  currentImage.updatePixels();
}

void adjustContrast(float factor) {
  currentImage.loadPixels();
  for (int i = 0; i < currentImage.pixels.length; i++) {
    float r = (red(currentImage.pixels[i]) - 128) * factor + 128;
    float g = (green(currentImage.pixels[i]) - 128) * factor + 128;
    float b = (blue(currentImage.pixels[i]) - 128) * factor + 128;
    currentImage.pixels[i] = color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
  }
  currentImage.updatePixels();
}

void adjustShadows(float delta) {
  currentImage.loadPixels();
  for (int i = 0; i < currentImage.pixels.length; i++) {
    float r = red(currentImage.pixels[i]);
    float g = green(currentImage.pixels[i]);
    float b = blue(currentImage.pixels[i]);
    float avg = (r + g + b) / 3;
    if (avg < 100) {
      r += delta;
      g += delta;
      b += delta;
    }
    currentImage.pixels[i] = color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
  }
  currentImage.updatePixels();
}
