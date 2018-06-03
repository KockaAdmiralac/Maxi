import processing.serial.*;

Serial pic;
String read;
String[] list;
final PVector pos = new PVector(0, 0);
final int velicinaX = 5;
final int velicinaY = 5;
final int FONT_SIZE = 32;
int v1, v2, v3, v4;
final PVector[] sensor = new PVector[] {
  new PVector(0, 100),
  new PVector(0, 0),
  new PVector(100, 0)
};
boolean debug = true;
final float UNIT = 1;

// Parses an integer that starts with zeroes
int customParseInt(String str) {
  str = trim(str);
  while (str.startsWith("0")) {
    str = str.substring(1);
  }
  return int(str);
}

float distance(int var, int sensor) {
  float x = 1 / sqrt(var);
  switch (sensor) {
    case 3: return 2358.7 * x - 66.535; //<>//
    case 2: return 1603.3 * x - 43.249;
    case 1: return 1956.9 * x - 57.712;
    // case 4:
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
  float tempX = 0, tempY = 0, tempZ = 0, tempU = 0;
  float min = 999999999;
  float d0x, d0y, d1x, d1y, d2x, d2y;
  float cv1 = distance(v1, 1);
  float cv2 = distance(v2, 2);
  float cv3 = distance(v3, 3);
  // float cv4 = distance(v4, 4);
  println(cv1 + " " + cv2 + " " + cv3);
  for (int x = 0; x < 100; ++x) {
    for (int y = 0; y < 100; ++y) {
      d0x = (sensor[0].x - x) * UNIT;
      d0y = (sensor[0].y - y) * UNIT;
      d1x = (sensor[1].x - x) * UNIT;
      d1y = (sensor[1].y - y) * UNIT;
      d2x = (sensor[2].x - x) * UNIT;
      d2y = (sensor[2].y - y) * UNIT;
      tempX = sqrt(d0x * d0x + d0y * d0y);
      tempY = sqrt(d1x * d1x + d1y * d1y);
      tempZ = sqrt(d2x * d2x + d2y * d2y);
      tempU = abs(tempX - cv1) + abs(tempY - cv2) + abs(tempZ - cv3);
      
        if (tempU < min) {
         println("debuhhhhhhhhh");
          pos.x = x; //<>//
        pos.y = y;
        min = tempU;
      }
    }
  }
println("posX="+pos.x);
println("posY="+pos.y);


}

// Draws everything useful
void drawPosition() {
  background(0, 0, 0);
    stroke(255, 0, 0);
  noFill();
  rect(250, 0, 500, 500);
  ellipse(250,0,distance(v2,2)*10,distance(v2,2)*10);
  ellipse(250,500,distance(v1,1)*10,distance(v1,1)*10);
  ellipse(750,0,distance(v3,3)*10,distance(v3,3)*10);
  fill(0, 0, 0);
  noStroke();
  rect(0, 0, 249, 500);
  rect(751, 0, 1000, 500);
  fill(255, 255, 255);
  ellipse(pos.x*5 + 250, pos.y*5, velicinaX, velicinaY);
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
