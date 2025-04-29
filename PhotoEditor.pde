/*
CSC 545 Photo Editor
Miah Weems, Evelyn Routon, Faith Cordsiemon, Elena Brown
*/

PImage img, gray_img, sep_img, currentImg, rose_img, neg_img, baw_img;
String fname = "queenstown.jpg";

void setup() {
  size(800, 800);
  windowResizable(true);
  img = loadImage(fname);
  currentImg = img;
  gray_img = imageGrayScale(img);
  sep_img = imageSepia(img);
  rose_img = imageRoseTint(img);
  neg_img = imageNegative(img);
  baw_img = imageBlackWhite(img);
  windowResize(img.width, img.height);
}

void draw() {
  background(255);
  image(currentImg, 0, 0);
}

void keyReleased() {
  if (key == '1') currentImg = img;
  else if (key == '2') currentImg = gray_img;
  else if (key == '3') currentImg = baw_img;
  else if (key == '4') currentImg = sep_img;
  else if (key == '5') currentImg = rose_img;
  else if (key == '6') currentImg = neg_img;
  else if (key == 'r') rotateImage();
  else if (key == 'h') flipHorizontal();
  else if (key == 'v') flipVertical();
  else if (key == 'b') adjustBrightness(10);
  else if (key == 'n') adjustBrightness(-10);
  else if (key == 'c') adjustContrast(1.1);
  else if (key == 'x') adjustContrast(0.9);
  else if (key == 's') adjustShadows(20);
  else if (key == 'a') adjustShadows(-20);
}

// --- FILTERS ---
PImage imageGrayScale(PImage input_img) {
  PImage target = createImage(input_img.width, input_img.height, ARGB);
  for (int x = 0; x < input_img.width; x++) {
    for (int y = 0; y < input_img.height; y++) {
      color c = input_img.get(x, y);
      float val = (red(c) + green(c) + blue(c)) / 3.0;
      target.set(x, y, color(val, val, val));
    }
  }
  return target;
}

PImage imageSepia(PImage input_img) {
  PImage target = createImage(input_img.width, input_img.height, ARGB);
  for (int x = 0; x < input_img.width; x++) {
    for (int y = 0; y < input_img.height; y++) {
      color c = input_img.get(x, y);
      float r = red(c), g = green(c), b = blue(c);
      float tr = constrain(0.393*r + 0.769*g + 0.189*b, 0, 255);
      float tg = constrain(0.349*r + 0.686*g + 0.168*b, 0, 255);
      float tb = constrain(0.272*r + 0.534*g + 0.131*b, 0, 255);
      target.set(x, y, color(tr, tg, tb));
    }
  }
  return target;
}

PImage imageNegative(PImage input_img) {
  PImage target = createImage(input_img.width, input_img.height, ARGB);
  for (int x = 0; x < input_img.width; x++) {
    for (int y = 0; y < input_img.height; y++) {
      color c = input_img.get(x, y);
      target.set(x, y, color(255 - red(c), 255 - green(c), 255 - blue(c)));
    }
  }
  return target;
}

PImage imageBlackWhite(PImage input_img) {
  PImage target = input_img.copy();
  target.filter(THRESHOLD, 0.5);
  return target;
}

PImage imageRoseTint(PImage input_img) {
  PImage target = createImage(input_img.width, input_img.height, ARGB);
  for (int x = 0; x < input_img.width; x++) {
    for (int y = 0; y < input_img.height; y++) {
      color c = input_img.get(x, y);
      float r = constrain(red(c) * 1.5, 0, 255);
      float g = constrain(green(c) * 0.9 + 30, 0, 255);
      float b = constrain(blue(c) * 1.1 + 20, 0, 255);
      target.set(x, y, color(r, g, b));
    }
  }
  return target;
}

// --- EDIT TOOLS ---
void rotateImage() {
  PGraphics temp = createGraphics(currentImg.height, currentImg.width);
  temp.beginDraw();
  temp.translate(temp.width / 2, temp.height / 2);
  temp.rotate(HALF_PI);
  temp.imageMode(CENTER);
  temp.image(currentImg, 0, 0);
  temp.endDraw();
  currentImg = temp.get();
}

void flipHorizontal() {
  currentImg.loadPixels();
  for (int y = 0; y < currentImg.height; y++) {
    for (int x = 0; x < currentImg.width / 2; x++) {
      int i = x + y * currentImg.width;
      int j = (currentImg.width - 1 - x) + y * currentImg.width;
      color temp = currentImg.pixels[i];
      currentImg.pixels[i] = currentImg.pixels[j];
      currentImg.pixels[j] = temp;
    }
  }
  currentImg.updatePixels();
}

void flipVertical() {
  currentImg.loadPixels();
  for (int y = 0; y < currentImg.height / 2; y++) {
    for (int x = 0; x < currentImg.width; x++) {
      int i = x + y * currentImg.width;
      int j = x + (currentImg.height - 1 - y) * currentImg.width;
      color temp = currentImg.pixels[i];
      currentImg.pixels[i] = currentImg.pixels[j];
      currentImg.pixels[j] = temp;
    }
  }
  currentImg.updatePixels();
}

void adjustBrightness(float amount) {
  currentImg.loadPixels();
  for (int i = 0; i < currentImg.pixels.length; i++) {
    float r = red(currentImg.pixels[i]) + amount;
    float g = green(currentImg.pixels[i]) + amount;
    float b = blue(currentImg.pixels[i]) + amount;
    currentImg.pixels[i] = color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
  }
  currentImg.updatePixels();
}

void adjustContrast(float factor) {
  currentImg.loadPixels();
  for (int i = 0; i < currentImg.pixels.length; i++) {
    float r = (red(currentImg.pixels[i]) - 128) * factor + 128;
    float g = (green(currentImg.pixels[i]) - 128) * factor + 128;
    float b = (blue(currentImg.pixels[i]) - 128) * factor + 128;
    currentImg.pixels[i] = color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
  }
  currentImg.updatePixels();
}

void adjustShadows(float delta) {
  currentImg.loadPixels();
  for (int i = 0; i < currentImg.pixels.length; i++) {
    float r = red(currentImg.pixels[i]);
    float g = green(currentImg.pixels[i]);
    float b = blue(currentImg.pixels[i]);
    float avg = (r + g + b) / 3;
    if (avg < 100) {
      r += delta;
      g += delta;
      b += delta;
    }
    currentImg.pixels[i] = color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
  }
  currentImg.updatePixels();
}
