import processing.serial.*;

Serial pic;
String read;
String[] list;
final PVector pos = new PVector(0, 0);
final int velicinaX = 5;
final int velicinaY = 5;
final int FONT_SIZE = 32;
int v1, v2, v3, v4;
PImage petnica, pfe;
final PVector[] sensor = new PVector[] {
  new PVector(0, 100),
  new PVector(0, 0),
  new PVector(100, 0),
  new PVector(100, 100)
};
// If fourth sensor is enabled
boolean fourth;
// Debug mode variables
boolean debug;
int row = 0;
PrintWriter output;

// Parses an integer that starts with zeroes
int customParseInt(String str) {
  str = trim(str);
  while (str.startsWith("0")) {
    str = str.substring(1);
  }
  return int(str);
}

// Calculates distance from a certain sensor
float distance(int var, int sensor) {
  float x = 1 / sqrt(var);
  switch (sensor) {
    case 4: return 2358.7 * x - 66.535; // TODO
    case 3: return 2358.7 * x - 66.535; //<>//
    case 2: return 1603.3 * x - 43.249;
    case 1: return 1956.9 * x - 57.712;
    default: return 5.5f;
  }
}

// Sets up the simulation
void setup() {
  size(1000, 500);
  stroke(256, 256, 256);
  textSize(FONT_SIZE);
  textAlign(CENTER, CENTER);
  fill(0, 0, 0);
  // We don't want to attempt serial connection every 1/60th of a second
  frameRate(1);
  // Draw waiting text
  background(255, 255, 255);
  text("Waiting for serial connection...", 0, 0, width, height);
  output = createWriter("Maxi.txt");
  petnica = loadImage("Petnica.png");
  pfe = loadImage("PFE.png");
}

// Executed every frame
void draw() {
  if (pic == null) {
    connectSerial();
  } else {
    drawPosition();
  }
}

// Connects to first available serial port
void connectSerial() {
  list = Serial.list();
  // There are no COM ports available to connect
  if (list.length == 0) {
    return;
  }
  // Connect to serial port
  pic = new Serial(this, list[0], 9600);
  // Don't allow corrupt data after connection
  pic.clear();
  pic.bufferUntil('|');
  pic.readStringUntil('|');
  // Restore frame rate and text options
  frameRate(60);
  textSize(24);
  textAlign(LEFT, CENTER);
}

// Calculates position based on three measured voltages
void calculatePosition() {
  float dist1, dist2, dist3, dist4, dist;
  float min = 999999999;
  float dx1, dy1, dx2, dy2, dx3, dy3, dx4, dy4;
  float cv1 = distance(v1, 1);
  float cv2 = distance(v2, 2);
  float cv3 = distance(v3, 3);
  float cv4 = distance(v4, 4);
  for (int x = 0; x < 100; ++x) {
    for (int y = 0; y < 100; ++y) {
      dx1 = sensor[0].x - x;
      dy1 = sensor[0].y - y;
      dx2 = sensor[1].x - x;
      dy2 = sensor[1].y - y;
      dx3 = sensor[2].x - x;
      dy3 = sensor[2].y - y;
      dx4 = sensor[3].x - x;
      dy4 = sensor[3].y - y;
      dist1 = sqrt(dx1 * dx1 + dy1 * dy1);
      dist2 = sqrt(dx2 * dx2 + dy2 * dy2);
      dist3 = sqrt(dx3 * dx3 + dy3 * dy3);
      dist4 = sqrt(dx4 * dx4 + dy4 * dy4);
      dist = abs(dist1 - cv1) + abs(dist2 - cv2) + abs(dist3 - cv3);
      if (fourth) {
        dist += abs(dist4 - cv4);
      }
      if (dist < min) {
        pos.x = x; //<>//
        pos.y = y;
        min = dist;
      }
    }
  }
}

// Draws everything useful
void drawPosition() {
  background(0, 0, 0);
  stroke(255, 0, 0);
  noFill();
  rect(250, 0, 500, 500);
  float d1 = distance(v1, 1) * 10;
  float d2 = distance(v2, 2) * 10;
  float d3 = distance(v3, 3) * 10;
  float d4 = distance(v4, 4) * 10;
  ellipse(250, 500, d1, d1);
  ellipse(250, 0, d2, d2);
  ellipse(750, 0, d3, d3);
  if (fourth) {   
    ellipse(750, 500, d4, d4);
  }
  fill(0, 0, 0);
  noStroke();
  rect(0, 0, 249, 500);
  rect(751, 0, 1000, 500);
  fill(255, 255, 255);
  image(petnica, 750, 0);
  image(pfe, 750, 250);
  ellipse(pos.x * 5 + 250, pos.y * 5, velicinaX, velicinaY);
  if (debug) {
    text(
      "V1: " + v1 + "\nV2: " + v2 + "\nV3: " + v3 +
      "\nV4: " + v4 + "\nX: " + pos.x + "\nY: " + pos.y +
      "\nZ: " + pos.z,
      10,
      10,
      250,
      500
    );
  }
}

// Fires when a pipe sign is encountered
void serialEvent(Serial s) {
  read = s.readString();
  if (read != null) {
    String[] split = read.split("\n");
    if (split.length != 5) {
      println("[Error] split.length is not 5!");
      return;
    }
    v1 = customParseInt(split[0]);
    v2 = customParseInt(split[1]);
    v3 = customParseInt(split[2]);
    v4 = customParseInt(split[3]);
    calculatePosition();
  }
}

// Key press handler
void keyPressed() {
  if (keyCode == 32 && debug) {
    // Records data when spacebar is clicked while in debug mode
    output.print("[" + pos.x + ", " + pos.y + "] ");
    if (++row == 41  ) {
      output.println();
      row = 0;
      println("Going into new row...");
    }
    output.flush();
    println("Recorded! (" + row + ")");
  } else if (keyCode == 68) {
    // Toggle debug mode
    debug = !debug;
  } else if (keyCode == 70) {
    // Toggle fourth sensor
    fourth = !fourth;
  }
}
