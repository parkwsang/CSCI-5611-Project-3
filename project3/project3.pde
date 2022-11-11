void setup() {
  size(1200, 700);
  surface.setTitle("CSCI 5611 - Project 3");
}

//Root
Vec2 root = new Vec2(600, 200);
// Right Shoulder 
float rightShoulderLength = 40;
float rightShoulderAngle = 0;

//Right Upper Arm
float rightUpperArmLength = 100;
float rightUpperArmAngle = 0.3; //Shoulder joint

//Right Lower Arm
float rightForearmLength = 100;
float rightForearmAngle = 0.7; //Elbow joint

//Right Hand
float rightHandLength = 25;
float rightHandAngle = HALF_PI; //Wrist joint

// Left Shoulder 
float leftShoulderLength = 40;
float leftShoulderAngle = PI;

//Left Upper Arm
float leftUpperArmLength = 100;
float leftUpperArmAngle = -0.3; //Shoulder joint

//Left Lower Arm
float leftForearmLength = 100;
float leftForearmAngle = -0.7; //Elbow joint

//Left Hand
float leftHandLength = 25;
float leftHandAngle = -HALF_PI; //Wrist joint

float accelerationSlow = 5;
Vec2 rightUpperArmStart, rightForearmStart, rightHandStart, endPointRight;
Vec2 leftUpperArmStart, leftForearmStart, leftHandStart, endPointLeft;
Vec2 goalRightArm = new Vec2(750, 300);
Vec2 goalLeftArm = new Vec2(450, 300);

boolean clickedRightHand, clickedLeftHand;
void solve() {  
  if(clickedRightHand) goalRightArm = new Vec2(mouseX, mouseY);
  if(clickedLeftHand) goalLeftArm = new Vec2(mouseX, mouseY);
  Vec2 startToGoal, startToEndEffector;
  float dotProd, angleDiff;

  //Update right wrist joint
  startToGoal = goalRightArm.minus(rightHandStart);
  startToEndEffector = endPointRight.minus(rightHandStart);
  dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
  dotProd = clamp(dotProd, -1, 1);
  angleDiff = acos(dotProd);
  if (cross(startToGoal, startToEndEffector) < 0)
    rightHandAngle += angleDiff / (rightHandLength / accelerationSlow);
  else
    rightHandAngle -= angleDiff / (rightHandLength / accelerationSlow);
  /*TODO: Wrist joint limits here*/
  if (rightHandAngle > HALF_PI) {
    rightHandAngle = HALF_PI;
  } else if (rightHandAngle < -HALF_PI) {
    rightHandAngle = -HALF_PI;
  }
  fk(); //Update link positions with fk (e.g. end effector changed)

  //Update left wrist joint
  startToGoal = goalLeftArm.minus(leftHandStart);
  startToEndEffector = endPointLeft.minus(leftHandStart);
  dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
  dotProd = clamp(dotProd, -1, 1);
  angleDiff = acos(dotProd);
  if (cross(startToGoal, startToEndEffector) < 0)
    leftHandAngle += angleDiff / (leftHandLength / accelerationSlow);
  else
    leftHandAngle -= angleDiff / (leftHandLength / accelerationSlow);
  /*TODO: Wrist joint limits here*/
  if (leftHandAngle > HALF_PI) {
    leftHandAngle = HALF_PI;
  } else if (leftHandAngle < -HALF_PI) {
    leftHandAngle = -HALF_PI;
  }
  fk(); //Update link positions with fk (e.g. end effector changed)

  //Update right elbow joint
  startToGoal = goalRightArm.minus(rightForearmStart);
  startToEndEffector = endPointRight.minus(rightForearmStart);
  dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
  dotProd = clamp(dotProd, -1, 1);
  angleDiff = acos(dotProd);
  if (cross(startToGoal, startToEndEffector) < 0)
    rightForearmAngle += angleDiff / (rightForearmLength / accelerationSlow);
  else
    rightForearmAngle -= angleDiff / (rightForearmLength / accelerationSlow);
  if (rightForearmAngle > HALF_PI) {
    rightForearmAngle = HALF_PI;
  } else if (rightForearmAngle < -HALF_PI) {
    rightForearmAngle = -HALF_PI;
  }
  fk(); //Update link positions with fk (e.g. end effector changed)

  //Update left elbow joint
  startToGoal = goalLeftArm.minus(leftForearmStart);
  startToEndEffector = endPointLeft.minus(leftForearmStart);
  dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
  dotProd = clamp(dotProd, -1, 1);
  angleDiff = acos(dotProd);
  if (cross(startToGoal, startToEndEffector) < 0)
    leftForearmAngle += angleDiff / (leftForearmLength / accelerationSlow);
  else
    leftForearmAngle -= angleDiff / (leftForearmLength / accelerationSlow);
  if (leftForearmAngle > HALF_PI) {
    leftForearmAngle = HALF_PI;
  } else if (leftForearmAngle < -HALF_PI) {
    leftForearmAngle = -HALF_PI;
  }
  fk(); //Update link positions with fk (e.g. end effector changed)

  //Update right upper arm joint
  startToGoal = goalRightArm.minus(rightUpperArmStart);
  startToEndEffector = endPointRight.minus(rightUpperArmStart);
  dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
  dotProd = clamp(dotProd, -1, 1);
  angleDiff = acos(dotProd);
  if (cross(startToGoal, startToEndEffector) < 0)
    rightUpperArmAngle += angleDiff / (rightUpperArmLength / accelerationSlow);
  else
    rightUpperArmAngle -= angleDiff / (rightUpperArmLength / accelerationSlow);
  /*TODO: Shoulder joint limits here*/
  if (rightUpperArmAngle > HALF_PI) {
    rightUpperArmAngle = HALF_PI;
  } else if (rightUpperArmAngle < 0) {
    rightUpperArmAngle = 0;
  }
  fk(); //Update link positions with fk (e.g. end effector changed)

  //Update left upper arm joint
  startToGoal = goalLeftArm.minus(leftUpperArmStart);
  startToEndEffector = endPointLeft.minus(leftUpperArmStart);
  dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
  dotProd = clamp(dotProd, -1, 1);
  angleDiff = acos(dotProd);
  if (cross(startToGoal, startToEndEffector) < 0)
    leftUpperArmAngle += angleDiff / (leftUpperArmLength / accelerationSlow);
  else
    leftUpperArmAngle -= angleDiff / (leftUpperArmLength / accelerationSlow);
  /*TODO: Shoulder joint limits here*/
  if (leftUpperArmAngle > 0) {
    leftUpperArmAngle = 0;
  } else if (leftUpperArmAngle < -HALF_PI) {
    leftUpperArmAngle = -HALF_PI;
  }
  fk(); //Update link positions with fk (e.g. end effector changed)
  
  //Update right shoulder joint
  startToGoal = goalRightArm.minus(root);
  if (startToGoal.length() < .0001) return;
  startToEndEffector = endPointRight.minus(root);
  dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
  dotProd = clamp(dotProd, -1, 1);
  angleDiff = acos(dotProd);
  if (cross(startToGoal, startToEndEffector) < 0)
    rightShoulderAngle += angleDiff / (rightShoulderLength / accelerationSlow);
  else
    rightShoulderAngle -= angleDiff / (rightShoulderLength / accelerationSlow);
  /*TODO: Shoulder joint limits here*/
  if (rightShoulderAngle > HALF_PI / 3) {
    rightShoulderAngle = HALF_PI / 3;
  } else if (rightShoulderAngle < -HALF_PI / 3) {
    rightShoulderAngle = -HALF_PI / 3;
  }
  fk(); //Update link positions with fk (e.g. end effector changed)

  //Update left shoulder joint
  startToGoal = goalLeftArm.minus(root);
  if (startToGoal.length() < .0001) return;
  startToEndEffector = endPointLeft.minus(root);
  dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
  dotProd = clamp(dotProd, -1, 1);
  angleDiff = acos(dotProd);
  if (cross(startToGoal, startToEndEffector) < 0)
    leftShoulderAngle += angleDiff / (leftShoulderLength / accelerationSlow);
  else
    leftShoulderAngle -= angleDiff / (leftShoulderLength / accelerationSlow);
  /*TODO: Shoulder joint limits here*/
  if (leftShoulderAngle > PI + HALF_PI / 3) {
    leftShoulderAngle = PI + HALF_PI / 3;
  } else if (leftShoulderAngle < PI - HALF_PI / 3) {
    leftShoulderAngle = PI - HALF_PI / 3;
  }
  fk(); //Update link positions with fk (e.g. end effector changed)
  
  println("Right Shoulder Angle:", rightShoulderAngle, "Right Upper Arm Angle:", rightUpperArmAngle); 
}

void fk() {
  rightUpperArmStart = new Vec2(cos(rightShoulderAngle)*rightShoulderLength, sin(rightShoulderAngle)*rightShoulderLength).plus(root);
  rightForearmStart = new Vec2(cos(rightShoulderAngle+rightUpperArmAngle)*rightUpperArmLength, sin(rightShoulderAngle+rightUpperArmAngle)*rightUpperArmLength).plus(rightUpperArmStart);
  rightHandStart = new Vec2(cos(rightShoulderAngle+rightUpperArmAngle+rightForearmAngle)*rightForearmLength, sin(rightShoulderAngle+rightUpperArmAngle+rightForearmAngle)*rightForearmLength).plus(rightForearmStart);
  endPointRight = new Vec2(cos(rightShoulderAngle+rightUpperArmAngle+rightForearmAngle+rightHandAngle)*rightHandLength, sin(rightShoulderAngle+rightUpperArmAngle+rightForearmAngle+rightHandAngle)*rightHandLength).plus(rightHandStart);

  leftUpperArmStart = new Vec2(cos(leftShoulderAngle)*leftShoulderLength, sin(leftShoulderAngle)*leftShoulderLength).plus(root);
  leftForearmStart = new Vec2(cos(leftShoulderAngle+leftUpperArmAngle)*leftUpperArmLength, sin(leftShoulderAngle+leftUpperArmAngle)*leftUpperArmLength).plus(leftUpperArmStart);
  leftHandStart = new Vec2(cos(leftShoulderAngle+leftUpperArmAngle+leftForearmAngle)*leftForearmLength, sin(leftShoulderAngle+leftUpperArmAngle+leftForearmAngle)*leftForearmLength).plus(leftForearmStart);
  endPointLeft = new Vec2(cos(leftShoulderAngle+leftUpperArmAngle+leftForearmAngle+leftHandAngle)*leftHandLength, sin(leftShoulderAngle+leftUpperArmAngle+leftForearmAngle+leftHandAngle)*leftHandLength).plus(leftHandStart);
}

float armW = 20;
void draw() {
  update(1.0/frameRate);
  fk();
  solve();
  //clickedRightHand = pointInCircle(new Vec2(mouseX, mouseY),20, new Vec2(endPointRight.x, endPointRight.y));
  //clickedLeftHand = pointInCircle(new Vec2(mouseX, mouseY),20, new Vec2(endPointLeft.x, endPointLeft.y));
  background(250, 250, 250);

  // Draw Right Arm
  fill(210, 180, 140);
  pushMatrix();
  translate(root.x,root.y);
  rotate(rightShoulderAngle);
  rect(0, -armW/2, rightShoulderLength, armW);
  popMatrix();
  
  pushMatrix();
  translate(rightUpperArmStart.x,rightUpperArmStart.y);
  rotate(rightShoulderAngle+rightUpperArmAngle);
  rect(0, -armW/2, rightUpperArmLength, armW);
  popMatrix();

  pushMatrix();
  translate(rightForearmStart.x, rightForearmStart.y);
  rotate(rightShoulderAngle+rightUpperArmAngle+rightForearmAngle);
  rect(0, -armW/2, rightForearmLength, armW);
  popMatrix();

  pushMatrix();
  translate(rightHandStart.x, rightHandStart.y);
  rotate(rightShoulderAngle+rightUpperArmAngle+rightForearmAngle+rightHandAngle);
  rect(0, -armW/2, rightHandLength, armW);
  popMatrix();
  
  // Draw end effector for right hand
  fill(0, 0, 0); //Goal/mouse
  if (clickedRightHand){
    fill(255,200,200);
  }
  pushMatrix();
  translate(endPointRight.x, endPointRight.y);
  circle(0, 0, 20);
  popMatrix();
  
  // Draw Left Arm    
  fill(210, 180, 140);
  pushMatrix();
  translate(root.x,root.y);
  rotate(leftShoulderAngle);
  rect(0, -armW/2, leftShoulderLength, armW);
  popMatrix();
  
  pushMatrix();
  translate(leftUpperArmStart.x,leftUpperArmStart.y);
  rotate(leftShoulderAngle+leftUpperArmAngle);
  rect(0, -armW/2, leftUpperArmLength, armW);
  popMatrix();

  pushMatrix();
  translate(leftForearmStart.x, leftForearmStart.y);
  rotate(leftShoulderAngle+leftUpperArmAngle+leftForearmAngle);
  rect(0, -armW/2, leftForearmLength, armW);
  popMatrix();

  pushMatrix();
  translate(leftHandStart.x, leftHandStart.y);
  rotate(leftShoulderAngle+leftUpperArmAngle+leftForearmAngle+leftHandAngle);
  rect(0, -armW/2, leftHandLength, armW);
  popMatrix();
  
  // Draw end effector for left hand
  fill(0, 0, 0); //Goal/mouse
  if (clickedLeftHand){
    fill(255,200,200);
  }
  pushMatrix();
  translate(endPointLeft.x, endPointLeft.y);
  circle(0, 0, 20);
  popMatrix();
}


float rootSpeed = 50;
void update(float dt){
  Vec2 rootVel = new Vec2(0,0);
  if (shiftPressed) {
    rootSpeed = 150;
  } else {
    rootSpeed = 50;
  }
  if (leftPressed) rootVel.x = -1;
  if (rightPressed) rootVel.x = 1;
  if (upPressed) rootVel.y = -1;
  if (downPressed) rootVel.y = 1;
  if (rootVel.length() > 0) rootVel.normalize();
  root.add(rootVel.times(rootSpeed * dt));
}

void mouseClicked() {
   if(pointInCircle(new Vec2(mouseX, mouseY),20, new Vec2(endPointRight.x, endPointRight.y))){
     clickedRightHand = true;
   } else if (pointInCircle(new Vec2(mouseX, mouseY),20, new Vec2(endPointLeft.x, endPointLeft.y))) {
     clickedLeftHand = true;
   } else {
     clickedRightHand = false;
     clickedLeftHand = false;
   }
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

//Vector Library
//CSCI 5611 Vector 2 Library [Example]
// Stephen J. Guy <sjguy@umn.edu>

public class Vec2 {
  public float x, y;

  public Vec2(float x, float y) {
    this.x = x;
    this.y = y;
  }

  public String toString() {
    return "(" + x+ "," + y +")";
  }

  public float length() {
    return sqrt(x*x+y*y);
  }

  public Vec2 plus(Vec2 rhs) {
    return new Vec2(x+rhs.x, y+rhs.y);
  }

  public void add(Vec2 rhs) {
    x += rhs.x;
    y += rhs.y;
  }

  public Vec2 minus(Vec2 rhs) {
    return new Vec2(x-rhs.x, y-rhs.y);
  }

  public void subtract(Vec2 rhs) {
    x -= rhs.x;
    y -= rhs.y;
  }

  public Vec2 times(float rhs) {
    return new Vec2(x*rhs, y*rhs);
  }

  public void mul(float rhs) {
    x *= rhs;
    y *= rhs;
  }

  public void clampToLength(float maxL) {
    float magnitude = sqrt(x*x + y*y);
    if (magnitude > maxL) {
      x *= maxL/magnitude;
      y *= maxL/magnitude;
    }
  }

  public void setToLength(float newL) {
    float magnitude = sqrt(x*x + y*y);
    x *= newL/magnitude;
    y *= newL/magnitude;
  }

  public void normalize() {
    float magnitude = sqrt(x*x + y*y);
    x /= magnitude;
    y /= magnitude;
  }

  public Vec2 normalized() {
    float magnitude = sqrt(x*x + y*y);
    return new Vec2(x/magnitude, y/magnitude);
  }

  public float distanceTo(Vec2 rhs) {
    float dx = rhs.x - x;
    float dy = rhs.y - y;
    return sqrt(dx*dx + dy*dy);
  }
}

Vec2 interpolate(Vec2 a, Vec2 b, float t) {
  return a.plus((b.minus(a)).times(t));
}

float interpolate(float a, float b, float t) {
  return a + ((b-a)*t);
}

float dot(Vec2 a, Vec2 b) {
  return a.x*b.x + a.y*b.y;
}

float cross(Vec2 a, Vec2 b) {
  return a.x*b.y - a.y*b.x;
}


Vec2 projAB(Vec2 a, Vec2 b) {
  return b.times(a.x*b.x + a.y*b.y);
}

float clamp(float f, float min, float max) {
  if (f < min) return min;
  if (f > max) return max;
  return f;
}
