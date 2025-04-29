/*
Image Cropper
Select an area using mouse then press c to crop.
*/
PImage img, croppedImg;
String fname = "hot_air2.jpg";
int startX, startY, endX, endY;
boolean selecting = false;
boolean cropped = false;

void setup(){
  size(400, 300);
  windowResizable(true);
  img = loadImage(fname);
  imageMode(CENTER);
  windowResize(img.width, img.height);
}


void draw(){
  background(255);
  
  if(!cropped){
    image(img, width/2, height/2);
    if(selecting){
      noFill();
      stroke(255, 0, 0);
      rect(startX, startY, mouseX-startX, mouseY-startY);
    }
  } else{
    image(croppedImg, width/2, height/2);
  }
}


void mousePressed(){
  startX = mouseX;
  startY = mouseY;
  selecting = true;
}


void mouseReleased(){
  endX = mouseX;
  endY = mouseY;
  selecting = false;
}


void keyPressed(){
  if(key == 'c' || key == 'C'){
    int cropX = min(startX, endX);
    int cropY = min(startY, endY);
    int cropW = abs(endX - startX);
    int cropH = abs(endY - startY);
    
    cropW = constrain(cropW, 1, img.width - cropX);
    cropH = constrain(cropH, 1, img.height - cropY);

    croppedImg = img.get(cropX, cropY, cropW, cropH);
    cropped = true;
  }
}
