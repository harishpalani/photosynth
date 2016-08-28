// Instance variables //<>//
int light = 5, co2 = 5;
int runCount = 1;
int yValue = 120, yAdj = 20;
ArrayList<String[]> list = new ArrayList<String[]>();
ArrayList<Integer> yValues = new ArrayList<Integer>();
final String LIGHT = "Light";
final String CO2 = "CO2";
// General
int bGoX, bGoY; // position
int bGoWidth = 180, bGoHeight = 30; // dimension
int containerSize = 420;
int cornerMargin = 10;
color rectColor, baseColor;
color rectHighlight;
color currentColor;
boolean rectOver = false;
boolean isRunning = false;
PFont f;
// Slider class
Slider lightSlider, co2Slider;
// Bubbles class
Bubble[] bubbles = new Bubble[0];
int numDots;
int currentDot= -1;

void setup() {
  size(840, 415); // size(1280, 720);
  smooth();

  rectColor = color(253, 181, 21);
  rectHighlight = color(0, 50, 98);
  baseColor = color(0, 50, 98);
  currentColor = baseColor;
  bGoX = width-(bGoWidth+(cornerMargin));
  bGoY = height-(bGoHeight+(cornerMargin));

  lightSlider = new Slider(LIGHT, (containerSize + 1), 10, (width - (containerSize + 1)), 16, 16);
  co2Slider = new Slider(CO2, (containerSize + 1), 50, (width - (containerSize + 1)), 16, 16);

  f = createFont("Arial", 14, true);
}

void draw() {
  update(); // update(mouseX, mouseY);
  background(currentColor);

  // Draw "Go" Button
  stroke(253, 181, 21);
  fill(253, 181, 21);
  rect(bGoX, bGoY, bGoWidth, bGoHeight);

  stroke(255);
  noFill();
  // fill(255);
  rect(0, height-containerSize, containerSize, containerSize, 3, 6, 12, 18);

  lightSlider.update();
  lightSlider.display();
  co2Slider.update();
  co2Slider.display();

  if (isRunning) {
    // for (int i = 0; i < currentDot; i++) {   }  
    int n = int(random(-1, 4));    
    if (bubbles.length < numDots) {
      for (int a = 0; a < n; a++) {
        new Bubble();
      }
    }    

    for (int a = 0; a < bubbles.length; a++) {
      bubbles[a].drawBubbles();
    }
     
    String[] info = new String[] { str(runCount), str(co2), str(light), "white", str(numDots) }; 
    list.add(info);    
    yValues.add(yValue - yAdj);
    
    for(int i = 0; i < list.size(); i++) {
      String[] arr = list.get(i);
      text((Integer.parseInt(arr[0]) - 1), 435,   yValues.get(i)); // enter 'Run #' data
      text(arr[1], 487, yValues.get(i)); // enter 'CO2' data
      text(arr[2], 572.75, yValues.get(i)); // enter 'light' data
      text(arr[3], 658.5, yValues.get(i)); // enter 'filter' data
      text(arr[4], 744.25, yValues.get(i)); // enter 'count' data
    }
    
    //for(String[] arr : list) {
    //  text((Integer.parseInt(arr[0]) - 1), 435, (yValue - yAdj)); // enter 'Run #' data
    //  text(arr[1], 487, (yValue - yAdj)); // enter 'CO2' data
    //  text(arr[2], 572.75, (yValue - yAdj)); // enter 'light' data
    //  text(arr[3], 658.5, (yValue - yAdj)); // enter 'filter' data
    //  text(arr[4], 744.25, (yValue - yAdj)); // enter 'count' data   
    //}
    
    //text((runCount - 1), 435, (yValue - yAdj)); // enter 'Run #' data
    //text(co2, 487, (yValue - yAdj)); // enter 'CO2' data
    //text(light, 572.75, (yValue - yAdj)); // enter 'light' data
    //text("white", 658.5, (yValue - yAdj)); // enter 'filter' data
    //text(numDots, 744.25, (yValue - yAdj)); // enter 'count' data     
  }

  stroke(255);
  noFill();
  rect(430, 80, 400, 280);
  
  textFont(f, 14);
  fill(255);
  text("Run #", 435, 98);
  line(482, 80, 482, 360);
  text("CO2", 487, 98);
  line(567.75, 80, 567.75, 360);
  text("light", 572.75, 98);
  line(653.5, 80, 653.5, 360);
  text("filter", 658.5, 98);
  line(739.25, 80, 739.25, 360);
  text("count", 744.25, 98);
  
  line(430, 102, 830, 102);
}

void mousePressed() {
  if (rectOver) {
    isRunning = true;
    
    runCount++;
    yValue += yAdj;
  }
}

// simulate the bubbles 
class Bubble {
  int x, y;

  Bubble() {
    x = floor(random(containerSize)); // x = floor(random(width));
    y = floor(random(height - containerSize)) + containerSize; // y = floor(random(height));
    bubbles = (Bubble[]) append(bubbles, this);
  }

  void drawBubbles() {
    y += random(-1, 0.005);
    fill(255);
    ellipse(x, y, 2, 2);
  }
}

// selection slider
class Slider {
  String identity;
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  Slider (String identity, float xp, float yp, int sw, int sh, int l) {
    this.identity = identity;
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) { 
      locked = true;
    }
    if (!mousePressed) { 
      locked = false;
    }
    if (locked) { 
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) { 
      spos = spos + (newspos-spos)/loose;
    }

    if (identity.equalsIgnoreCase(LIGHT)) {
      light = position1to10();
      System.out.println("light: " + light);
    } else if (identity.equalsIgnoreCase(CO2)) {
      co2 = position1to10();
      System.out.println("co2: " + co2);
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
      mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(0, 50, 98); 
    rect(xpos, ypos, swidth, sheight);    
    fill(253, 181, 21);
    //if (over || locked) {
    //  fill(0, 0, 0);
    //} else {
    //  fill(102, 102, 102);
    //}
    rect(spos, ypos, sheight, sheight);

    if (between(light, 1, 3)) {
      if (between(co2, 1, 3)) {
        numDots = 100;
      } else if (between(co2, 4, 7)) {
        numDots = 300;
      } else {
        numDots = 200;
      }
    } else if (between(light, 4, 7)) {
      if (between(co2, 1, 3)) {
        numDots = 400;
      } else if (between(co2, 4, 7)) {
        numDots = 600;
      } else {
        numDots = 500;
      }
    } else {
      if (between(co2, 1, 3)) {
        numDots = 700;
      } else if (between(co2, 4, 7)) {
        numDots = 900;
      } else {
        numDots = 800;
      }
    }
    //System.out.println("numDots: " + numDots);
    // bubbles = new Bubble[numDots];
  }

  void disable() {
  }

  int position1to10() {
    return (Math.round(getPos() / ((width / 2) / 10)) - 10);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}

// Helper methods
void update() {
  if (overRect(bGoX, bGoY, bGoWidth, bGoHeight)) {
    rectOver = true;
  } else {
    rectOver = false;
  }
}

boolean overRect(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width &&
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2) {
    return true;
  } else {
    return false;
  }
}

boolean between(int x, int min, int max) {
  return ((x >= min) && (x <= max));
}