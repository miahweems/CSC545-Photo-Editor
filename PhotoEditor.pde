/*
CSC 545 Photo Editor
Miah Weems, Evelyn Routon, Faith Cordsiemon, Elena Brown
*/

// Import library
import controlP5.*;

// Image variables
PImage img, gray_img, sep_img, currentImg, rose_img, neg_img, baw_img;
PImage originalImg;
String filename = "", errorText = "";
ControlP5 cp5;
Boolean mainMenu = true, textReadError = false;
PFont f;

// Cropping variables
boolean cropMode = false;
boolean isDragging = false;
int cropX1, cropY1, cropX2, cropY2;

void setup() {
  size(1000, 750);
  f = createFont("Bookman Old Style", 48, true);
  textFont(f);
  windowResizable(true);

  cp5 = new ControlP5(this);

  // File input
  cp5.addTextfield("filename")
     .setPosition(40, 400)
     .setSize(280, 40)
     .setFont(createFont("Bookman Old Style", 20))
     .setAutoClear(false)
     .setColor(color(144,238,144))
     .setColorBackground(color(50))
     .setColorForeground(color(100));
}

void draw() {
  if (mainMenu) {
    background(6, 64, 43);
    textSize(110);
    fill(144, 238, 144);
    text("545 Photo Editor", 45, 100);

    textSize(50);
    text("Please enter your file name with its extension to open your picture!", 45, 200, 900, 900);

    if (textReadError) {
      fill(255, 0, 0);
      textSize(40);
      text("Could not load image: " + filename, 45, 550);
      textSize(30);
      text("Ensure spelling and file location are correct (should be in the data folder).", 45, 600, 900, 900);
    }

  } else {
    cp5.get(Textfield.class, "filename").hide();
    background(255);

    if (cropMode) {
      image(currentImg, 0, 0);
      stroke(255, 0, 0);
      noFill();
      rect(cropX1, cropY1, cropX2 - cropX1, cropY2 - cropY1);

      fill(0, 0, 0, 150);
      noStroke();
      rect(10, 10, 400, 80);
      fill(255);
      textSize(20);
      text("Crop Mode: Drag to select. Press 'k' to keep inside, 'o' to keep outside, 'c' to cancel.", 20, 40, 380, 80);
    } else {
      image(currentImg, 0, 0);
      windowResize(currentImg.width, currentImg.height);

      gray_img = imageGrayScale(currentImg);
      sep_img = imageSepia(currentImg);
      rose_img = imageRoseTint(currentImg);
      neg_img = imageNegative(currentImg);
      baw_img = imageBlackWhite(currentImg);
    }
  }
}

// Handle key inputs
void keyReleased() {
  if (mainMenu) return;

  println("Key Released: " + key);

  //FILTERS & RESET
  if (key == '1') currentImg = img.copy();
  else if (key == '2') currentImg = gray_img.copy();
  else if (key == '3') currentImg = baw_img.copy();
  else if (key == '4') currentImg = sep_img.copy();
  else if (key == '5') currentImg = rose_img.copy();
  else if (key == '6') currentImg = neg_img.copy();

  //IMAGE TRANSFORMS
  else if (key == 'r') rotateImage();
  else if (key == 'h') flipHorizontal();
  else if (key == 'v') flipVertical();

  //BRIGHTNESS / CONTRAST / SHADOWS
  else if (key == 'b') adjustBrightness(10);
  else if (key == 'n') adjustBrightness(-10);
  else if (key == 'c' && !cropMode) adjustContrast(1.1);
  else if (key == 'x') adjustContrast(0.9);
  else if (key == 's') adjustShadows(20);
  else if (key == 'a') adjustShadows(-20);
}

void keyPressed() {
  if (mainMenu) return;

  println("Key Pressed: " + key);

  if (key == 'm') {
    println("Crop mode activated");
    cropMode = true;
  }
  else if (key == 'k' && cropMode) {
    applyCrop(true);
  }
  else if (key == 'o' && cropMode) {
    applyCrop(false);
  }
  else if (key == 'c' && cropMode) {
    println("Crop canceled");
    cropMode = false;
    currentImg = img.copy();
  }
}

// Image loading callback
void filename(String txt) {
  filename = txt;
  currentImg = loadImage(filename);

  if (currentImg == null) {
    textReadError = true;
  } else {
    textReadError = false;
    println("Image loaded: " + filename);
    mainMenu = false;
    img = currentImg.copy();
    originalImg = currentImg.copy();
    
    cp5.get(Textfield.class, "filename").setFocus(false);

  }
}

// Mouse drag for crop
void mousePressed() {
  if (cropMode) {
    cropX1 = mouseX;
    cropY1 = mouseY;
    isDragging = true;
  }
}

void mouseReleased() {
  if (cropMode) {
    cropX2 = mouseX;
    cropY2 = mouseY;
    isDragging = false;
  }
}

// Apply crop
void applyCrop(boolean keepInside) {
  cropMode = false;
  int x1 = min(cropX1, cropX2);
  int y1 = min(cropY1, cropY2);
  int w = abs(cropX2 - cropX1);
  int h = abs(cropY2 - cropY1);

  if (w <= 0 || h <= 0) return;

  if (keepInside) {
    currentImg = currentImg.get(x1, y1, w, h);
  } else {
    PGraphics pg = createGraphics(currentImg.width, currentImg.height);
    pg.beginDraw();
    pg.image(currentImg, 0, 0);
    pg.noStroke();
    pg.fill(255);
    pg.rect(x1, y1, w, h);
    pg.endDraw();
    currentImg = pg.get();
  }
}

// --- Filters ---
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

// --- Edits ---
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
