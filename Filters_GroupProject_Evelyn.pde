/*
Press 1 for original image
2 for grayscale image
3 for black and white image
4 for sepia image 
5 for rose tinted image
6 for negative image 
*/

PImage img, gray_img, sep_img, currentImg, rose_img, neg_img, baw_img;
String fname = "hot_air2.jpg";

void setup() {
  size(400, 300);
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
  image(currentImg, 0, 0);
}


PImage imageGrayScale(PImage input_img){
  PImage target = createImage(input_img.width, input_img.height, ARGB);
  for(int x = 0; x < input_img.width; x++){
    for(int y = 0; y < input_img.height; y++){
      color c = input_img.get(x, y);
      float r = red(c), g = green(c), b = blue(c);
      float val = (r + g + b)/3.0;
      c = color(val, val, val);
      target.set(x, y, c);
    }
  }
  return target;
}


PImage imageSepia(PImage input_img){
  PImage target = createImage(input_img.width, input_img.height, ARGB);
  for(int x = 0; x < input_img.width; x++){
    for(int y = 0; y < input_img.height; y++){
      color c = input_img.get(x, y);
      float r = red(c), g = green(c), b = blue(c);
      float tr = 0.393*r + 0.769*g + 0.189*b;
      float tg = 0.349*r + 0.686*g + 0.168*b;
      float tb = 0.272*r + 0.534*g + 0.131*b;

      // Cap values at 255 to avoid overflow
      tr = constrain(tr, 0, 255);
      tg = constrain(tg, 0, 255);
      tb = constrain(tb, 0, 255);
      c = color(tr, tg, tb);
      target.set(x, y, c);
    }
  }
  return target;
}


PImage imageHighContrast(PImage input_img){
  PImage target = createImage(input_img.width, input_img.height, ARGB);
  for(int x = 0; x < input_img.width; x++){
    for(int y = 0; y < input_img.height; y++){
      color c = input_img.get(x, y);
      float r = red(c), g = green(c), b = blue(c);
      
      //insert code for high contrast pixel conversion
      
      target.set(x, y, c);
    }
  }
  return target;
}


PImage imageNegative(PImage input_img){
  PImage target = createImage(input_img.width, input_img.height, ARGB);
  for(int x = 0; x < input_img.width; x++){
    for(int y = 0; y < input_img.height; y++){
      color c = input_img.get(x,y);
      float r = red(c), g = green(c), b = blue(c);
      r = r*-1 +255.0;
      g = g*-1 +255.0;
      b = b*-1 +255.0;
      c = color(r,g,b);
      target.set(x, y, c);
    }
  }
  return target;
}


PImage imageBlackWhite(PImage input_img){
  PImage target = input_img.copy();
  target.filter(THRESHOLD, 0.5);
  return target;
}


PImage imageRoseTint(PImage input_img){
  PImage target = createImage(input_img.width, input_img.height, ARGB);
  for(int x = 0; x < input_img.width; x++){
    for(int y = 0; y < input_img.height; y++){
      color c = input_img.get(x, y);
      float r = red(c), g = green(c), b = blue(c);
      r = constrain(r*1.5, 0, 255);
      g = constrain(g*0.9 + 30, 0, 255);
      b = constrain(b*1.1 + 20, 0, 255);
      c = color(r, g, b);     
      target.set(x, y, c);
    }
  }
  return target;
}

void keyReleased(){
  if(key == '1') currentImg = img;
  else if(key == '2') currentImg = gray_img;
  else if (key == '3') currentImg = baw_img;
  else if (key == '4') currentImg = sep_img;
  else if (key == '5') currentImg = rose_img;
  else if (key == '6') currentImg = neg_img;
}
