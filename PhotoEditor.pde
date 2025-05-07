PGraphics drawingLayer;
color currentPenColor = color(0);
int brushSize = 10;
boolean drawingMode = true; // Always on for demo

void setup() {
  size(800, 600);
  drawingLayer = createGraphics(width, height - 50);
  drawingLayer.beginDraw();
  drawingLayer.clear();
  drawingLayer.endDraw();
}

void draw() {
  background(255);

  // Simulate image area with top UI bar
  fill(200);
  rect(0, 0, width, 50); // top bar
  fill(0);
  text("Drawing below this line", 10, 30);

  // Draw the canvas
  image(drawingLayer, 0, 50); // drawing layer starts at y=50
}

void mouseDragged() {
  if (mouseY > 50 && drawingMode) {
    drawingLayer.beginDraw();
    drawingLayer.noStroke();
    drawingLayer.fill(currentPenColor);
    drawingLayer.ellipse(mouseX, mouseY - 50, brushSize, brushSize); // offset y
    drawingLayer.endDraw();
  }
}

    currentImg.pixels[i] = color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
  }
  currentImg.updatePixels();
}
