int numjointsLeft = 5;
int numjointsRight = 5;
float tolerance = 0.02;
Vec2 endPointLeft = new Vec2(0, 0);
Vec2 endPointRight = new Vec2(1200, 0);
Vec2 jointsLeft[] = new Vec2[numjointsLeft];
Vec2 jointsRight[] = new Vec2[numjointsRight];
float leftLengths[] = new float[numjointsLeft - 1];
float rightLengths[] = new float[numjointsRight - 1];
Vec2 root = new Vec2(0, 0);
float totalLengthLeft = 0;
float totalLengthRight = 0;
boolean clickedLeftHand, clickedRightHand;

void setup(){
  size(1200, 700);
  surface.setTitle("CSCI 5611 - Project 3 Part 2");
  
  // Setting starting point to center of canvas
  jointsLeft[0] = new Vec2(width / 2, height / 2);
  
  jointsLeft[1] = new Vec2(width / 2 - 40, height / 2);
  jointsLeft[2] = new Vec2(width / 2 - 100, height / 2);
  jointsLeft[3] = new Vec2(width / 2 - 100, height / 2);
  jointsLeft[4] = new Vec2(width / 2 - 25, height / 2);
  
  jointsRight[0] = new Vec2(width / 2, height / 2);
  
  jointsRight[1] = new Vec2(width / 2 + 40, height / 2);
  jointsRight[2] = new Vec2(width / 2 + 100, height / 2);
  jointsRight[3] = new Vec2(width / 2 + 100, height / 2);
  jointsRight[4] = new Vec2(width / 2 + 25, height / 2);

  for (int i = 0; i < numjointsLeft-1; i++) {
    leftLengths[i] = (jointsLeft[0].minus(jointsLeft[i+1])).length();
  }
  
  for (int i = 0; i < numjointsLeft-1; i++) {
    rightLengths[i] = (jointsRight[0].minus(jointsRight[i+1])).length();
  }
  
  root = new Vec2(width/2, height/2);
  for (int i = 0; i < numjointsLeft-1; i++) {
    totalLengthLeft += leftLengths[i];  
  }
  
  for (int i = 0; i < numjointsLeft-1; i++) {
    totalLengthRight += rightLengths[i];  
  }
}

void backward() {
  jointsLeft[numjointsLeft - 1] = endPointLeft;
  for (int i = numjointsLeft - 2; i >= 0; i--) {
    Vec2 r = jointsLeft[i+1].minus(jointsLeft[i]);
    float l = leftLengths[i] / r.length();
    Vec2 pos = jointsLeft[i+1].times(1 - l).plus(jointsLeft[i].times(l));
    jointsLeft[i] = pos;
  }
  
  jointsRight[numjointsRight - 1] = endPointRight;
  for (int i = numjointsRight - 2; i >= 0; i--) {
    Vec2 r = jointsRight[i+1].minus(jointsRight[i]);
    float l = rightLengths[i] / r.length();
    Vec2 pos = jointsRight[i+1].times(1 - l).plus(jointsRight[i].times(l));
    jointsRight[i] = pos;
  }
}

void forward() {
  jointsLeft[0] = root;
  for (int i = 0; i < numjointsLeft-1; i++) {
    Vec2 r = jointsLeft[i+1].minus(jointsLeft[i]);
    float l = leftLengths[i] / r.length();
    Vec2 pos = jointsLeft[i].times(1 - l).plus(jointsLeft[i+1].times(l));
    jointsLeft[i+1] = pos;
  }
  
  jointsRight[0] = root;
  for (int i = 0; i < numjointsRight-1; i++) {
    Vec2 r = jointsRight[i+1].minus(jointsRight[i]);
    float l = rightLengths[i] / r.length();
    Vec2 pos = jointsRight[i].times(1 - l).plus(jointsRight[i+1].times(l));
    jointsRight[i+1] = pos;
  }
}

void solve() {
  if(clickedLeftHand) endPointLeft = new Vec2(mouseX, mouseY);
  if(clickedRightHand) endPointRight = new Vec2(mouseX, mouseY);
  
  float distance = jointsLeft[0].minus(endPointLeft).length();
  if (distance > totalLengthLeft) {
    for (int i = 0; i < numjointsLeft-1; i++) {
      Vec2 r = endPointLeft.minus(jointsLeft[i]);
      float l = leftLengths[i] / r.length();
      jointsLeft[i+1] = jointsLeft[i].times(1 - l).plus(endPointLeft.times(l));
    }
  }
  else {
    int count = 0;
    float dif = jointsLeft[numjointsLeft-1].minus(endPointLeft).length();
    while (dif > tolerance) {
      backward();
      forward();
      dif = jointsLeft[numjointsLeft-1].minus(endPointLeft).length();
      count++;
      if (count > 10) {
        break;
      }
    }
  }
  
  distance = jointsRight[0].minus(endPointRight).length();
  if (distance > totalLengthRight) {
    for (int i = 0; i < numjointsRight-1; i++) {
      Vec2 r = endPointRight.minus(jointsRight[i]);
      float l = rightLengths[i] / r.length();
      jointsRight[i+1] = jointsRight[i].times(1 - l).plus(endPointRight.times(l));
    }
  }
  else {
    int count = 0;
    float dif = jointsRight[numjointsRight-1].minus(endPointRight).length();
    while (dif > tolerance) {
      backward();
      forward();
      dif = jointsRight[numjointsRight-1].minus(endPointRight).length();
      count++;
      if (count > 10) {
        break;
      }
    }
  }
}

void draw() {
  update(1.0/frameRate);
  solve();  
  background(255, 255, 255);
  
  //draw left joints
  fill(0, 0, 0);
  for (int i = 0; i < numjointsLeft - 1; i++) {
    pushMatrix();
    circle(jointsLeft[i].x, jointsLeft[i].y, 12);
    popMatrix();
  }
  
  // draw lines between left joints
  for (int i = 0; i < numjointsLeft - 1; i++) {
    pushMatrix();
    line(jointsLeft[i].x, jointsLeft[i].y, jointsLeft[i+1].x, jointsLeft[i+1].y);
    popMatrix();
  }
  
  // Draw end point for left
  fill(0, 0, 0); //Goal/mouse
  if (clickedLeftHand){
    fill(255,200,200);
  }
  pushMatrix();
  translate(jointsLeft[numjointsLeft - 1].x, jointsLeft[numjointsLeft - 1].y);
  circle(0, 0, 12);
  popMatrix();
  
  
  //draw right joints
  fill(0, 0, 0);
  for (int i = 0; i < numjointsLeft - 1; i++) {
    pushMatrix();
    circle(jointsRight[i].x, jointsRight[i].y, 12);
    popMatrix();
  }
  
  // draw lines between right joints
  for (int i = 0; i < numjointsLeft - 1; i++) {
    pushMatrix();
    line(jointsRight[i].x, jointsRight[i].y, jointsRight[i+1].x, jointsRight[i+1].y);
    popMatrix();
  }
  
  // Draw end point for right
  fill(0, 0, 0); //Goal/mouse
  if (clickedRightHand){
    fill(255,200,200);
  }
  pushMatrix();
  translate(jointsRight[numjointsRight - 1].x, jointsRight[numjointsRight - 1].y);
  circle(0, 0, 12);
  popMatrix();
}

void mouseClicked() {
   if(pointInCircle(new Vec2(mouseX, mouseY), 12, new Vec2(jointsRight[numjointsRight - 1].x, jointsRight[numjointsRight - 1].y))){
     clickedRightHand = true;
   } else if (pointInCircle(new Vec2(mouseX, mouseY), 12, new Vec2(jointsLeft[numjointsLeft - 1].x, jointsLeft[numjointsLeft - 1].y))) {
     clickedLeftHand = true;
   } else {
     clickedRightHand = false;
     clickedLeftHand = false;
   }
}

float rootSpeed = 50;
void update(float dt){
  Vec2 rootVel = new Vec2(0,0);
  if (shiftPressed) {
    rootSpeed = 150;
  } else {
    rootSpeed = 50; println("here");
  }
  if (leftPressed) rootVel.x = -1;
  if (rightPressed) rootVel.x = 1;
  if (upPressed) rootVel.y = -1;
  if (downPressed) rootVel.y = 1;
  if (rootVel.length() > 0) rootVel.normalize();
  root.add(rootVel.times(rootSpeed * dt));
}

boolean leftPressed, rightPressed, upPressed, downPressed, shiftPressed;

void keyPressed(){
  if (keyCode == LEFT) leftPressed = true;
  if (keyCode == RIGHT) rightPressed = true;
  if (keyCode == UP) upPressed = true; 
  if (keyCode == DOWN) downPressed = true;
  if (keyCode == SHIFT) shiftPressed = true;
}

void keyReleased(){
  if (keyCode == LEFT) leftPressed = false;
  if (keyCode == RIGHT) rightPressed = false;
  if (keyCode == UP) upPressed = false; 
  if (keyCode == DOWN) downPressed = false;
  if (keyCode == SHIFT) shiftPressed = false;
}

//Returns true if the point is inside a circle
boolean pointInCircle(Vec2 center, float r, Vec2 pointPos){
  float dist = pointPos.distanceTo(center);
  if (dist < r+0.5){ //small safety factor
    return true;
  }
  return false;
}

//-----------------
// Vector Library
//-----------------

public class Vec2 {
  public float x, y;
  
  public Vec2(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  public String toString(){
    return "(" + x+ "," + y +")";
  }
  
  public float length(){
    return sqrt(x*x+y*y);
  }
  
  public Vec2 plus(Vec2 rhs){
    return new Vec2(x+rhs.x, y+rhs.y);
  }
  
  public void add(Vec2 rhs){
    x += rhs.x;
    y += rhs.y;
  }
  
  public Vec2 minus(Vec2 rhs){
    return new Vec2(x-rhs.x, y-rhs.y);
  }
  
  public void subtract(Vec2 rhs){
    x -= rhs.x;
    y -= rhs.y;
  }
  
  public Vec2 times(float rhs){
    return new Vec2(x*rhs, y*rhs);
  }
  
  public void mul(float rhs){
    x *= rhs;
    y *= rhs;
  }
  
  public void clampToLength(float maxL){
    float magnitude = sqrt(x*x + y*y);
    if (magnitude > maxL){
      x *= maxL/magnitude;
      y *= maxL/magnitude;
    }
  }
  
  public void setToLength(float newL){
    float magnitude = sqrt(x*x + y*y);
    x *= newL/magnitude;
    y *= newL/magnitude;
  }
  
  public void normalize(){
    float magnitude = sqrt(x*x + y*y);
    x /= magnitude;
    y /= magnitude;
  }
  
  public Vec2 normalized(){
    float magnitude = sqrt(x*x + y*y);
    return new Vec2(x/magnitude, y/magnitude);
  }
  
  public float distanceTo(Vec2 rhs){
    float dx = rhs.x - x;
    float dy = rhs.y - y;
    return sqrt(dx*dx + dy*dy);
  }
}

Vec2 interpolate(Vec2 a, Vec2 b, float t){
  return a.plus((b.minus(a)).times(t));
}

float interpolate(float a, float b, float t){
  return a + ((b-a)*t);
}

float dot(Vec2 a, Vec2 b){
  return a.x*b.x + a.y*b.y;
}

float cross(Vec2 a, Vec2 b){
  return a.x*b.y - a.y*b.x;
}


Vec2 projAB(Vec2 a, Vec2 b){
  return b.times(a.x*b.x + a.y*b.y);
}

float clamp(float f, float min, float max){
  if (f < min) return min;
  if (f > max) return max;
  return f;
}
