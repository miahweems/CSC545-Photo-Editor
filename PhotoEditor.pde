/*
CSC 545 Photo Editor
Miah Weems, Evelyn Routon, Faith Cordsiemon, Elena Brown
*/

//import statements
import controlP5.*;

//variables
PImage img, gray_img, sep_img, currentImg, rose_img, neg_img, baw_img;
String filename = "", errorText = "";
ControlP5 cp5;
Boolean mainMenu = true, textReadError = false;
PFont f;

void setup() {
  size(1000, 750);  
  f = createFont("Bookman Old Style", 48, true);
  textFont(f);
  windowResizable(true);
  
  cp5 = new ControlP5(this);

  //input box for file selection
  cp5.addTextfield("filename")
     .setPosition(40, 400)     //Position
     .setSize(280, 40)      //Size
     .setFont(createFont("Bookman Old Style", 20))  //Font  
     .setAutoClear(false)
     .setColor(color(144,238,144)) //Color
     .setColorBackground(color(50)) //Background Color
     .setColorForeground(color(100)); //On Focus Color
}

void draw() {
  
  if(mainMenu) {
    //background color - dark green
    background(6, 64, 43);
    textSize(110);
    //text color- light green
    fill(144,238,144);

    //title
    text("545 Photo Editor", 45, 100);
    
    //subtitle
    textSize(50);
    text("Please enter your file name with it's extension to open your picture in the editor!", 45, 200,  900, 900);

    if(textReadError){
     fill(255,0,0);
     textSize(40);
     text("Could not load image: " +filename, 45, 550);
     textSize(30);
     text("Please make sure you spelled the file name/extension correct and that the file is in the data folder, then try again.", 45, 600, 900, 900);
    }

  } else {
    //hide text box
    cp5.get(Textfield.class, "filename").hide();
    background(255);
    //selectedImg = loadImage(filename);
    image(currentImg, 0, 0);
    windowResizable(true);
    windowResize(currentImg.width, currentImg.height);
    //currentImg = img;
    gray_img = imageGrayScale(currentImg);
    sep_img = imageSepia(currentImg);
    rose_img = imageRoseTint(currentImg);
    neg_img = imageNegative(currentImg);
    baw_img = imageBlackWhite(currentImg);
    windowResize(currentImg.width, currentImg.height);
    
  }
}

// --- KEY HANDLERS ---
void keyReleased() {
  if (key == '1' && !mainMenu) currentImg = img;
  else if (key == '2' && !mainMenu) currentImg = gray_img;
  else if (key == '3' && !mainMenu) currentImg = baw_img;
  else if (key == '4' && !mainMenu) currentImg = sep_img;
  else if (key == '5' && !mainMenu) currentImg = rose_img;
  else if (key == '6' && !mainMenu) currentImg = neg_img;
  else if (key == 'r' && !mainMenu) rotateImage();
  else if (key == 'h' && !mainMenu) flipHorizontal();
  else if (key == 'v' && !mainMenu) flipVertical();
  else if (key == 'b' && !mainMenu) adjustBrightness(10);
  else if (key == 'n' && !mainMenu) adjustBrightness(-10);
  else if (key == 'c' && !mainMenu) adjustContrast(1.1);
  else if (key == 'x' && !mainMenu) adjustContrast(0.9);
  else if (key == 's' && !mainMenu) adjustShadows(20);
  else if (key == 'a' && !mainMenu) adjustShadows(-20);
}

// --- FILE NAME READER ---
//Automatically called when the user inputs text in the text box and hits Enter
void filename(String txt) {
  filename = txt;
  currentImg = loadImage(filename);

   if (currentImg == null) {
    textReadError = true;

  } else {
    textReadError = false;
    println("Image loaded: " + filename);
    img = currentImg.copy();
    mainMenu = false;
  }
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
