int moveX, moveY;

ArrayList<Wall> walls = new ArrayList<Wall>();

void setup() {
  size(800, 800);
  
  //inner walls
  walls.add(new Wall(100, 100, 300, 300));
  walls.add(new Wall(100, 700, 400, 500));
  walls.add(new Wall(500, 200, 600, 500));
  
  //outer walls
  walls.add(new Wall(-1, -1, 800, 0));
  walls.add(new Wall(-1, -1, -1, 800));
  walls.add(new Wall(800, -1, 800, 800));
  walls.add(new Wall(-1, 800, 800, 800));
}

void draw() {
  background(0);
  fill(255);
  stroke(255);
  
  //render light source at mouse position
  ellipse(moveX, moveY, 25, 25);
  
  //draw all walls
  for(Wall w : walls){
    w.draw();
  }
  
  //Calculate intersections for all rays from light source
  for(int i = 0; i < 360; i += 1){
    //generate vector for ray at specified angle
    PVector r = PVector.fromAngle(radians(i));
    r.mult(800 * sqrt(2));
    PVector p = new PVector(moveX, moveY);
    ArrayList<PVector> intersections = new ArrayList<PVector>();
    //find all intersections of r
    for(Wall w : walls){
      float t = cross(PVector.sub(w.start, p), w.s) / cross(r, w.s);
      float u = cross(PVector.sub(w.start, p), r) / cross(r, w.s);
      //add candidate intersection if there are values t and u that satisfy p+t*u = q+u*s
      if(cross(r, w.s) != 0 && u <= 1 && u >= 0 && t <= 1 && t >= 0){
       PVector pt = new PVector(p.x + (t * r.x), p.y + (t * r.y));
       intersections.add(pt);
      }
    }
    if(intersections.size() > 0){
      PVector closest = findClosestIntersection(intersections, p);
      stroke(255, 100);
      //draw ray
      line( moveX, moveY, closest.x, closest.y );
    }
  }
}

PVector findClosestIntersection(ArrayList<PVector> intersections, PVector src){
  if(intersections.size() == 1){ return intersections.get(0); }
  float min_dist = 10000.0;
  PVector pt = new PVector();
  //find closest intersection to light source
  for(PVector intersection : intersections){
    float dist = PVector.dist(src, intersection);
    if(dist < min_dist){
      pt = intersection;
      min_dist = dist;
    }
  }
  return pt;
}

float cross(PVector v, PVector w){
  return v.x * w.y - v.y * w.x;
}

void mouseMoved() {
  //update mouse position
  moveX = mouseX;
  moveY = mouseY;
}
