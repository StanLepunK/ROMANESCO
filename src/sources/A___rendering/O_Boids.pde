/**
BOIDS
2015-2019
V 1.1.1
*/

class Boids extends Romanesco {
  public Boids() {
    item_name = "Boids" ;
    item_author  = "Stan le Punk";
    item_version = "Version 1.1.1";
    item_pack = "Base 2015-2019" ;
    item_costume = "";
    item_mode = "Tetra monochrome/Tetra camaieu" ; // separate the differentes mode by "/"

    hue_fill_is = true;
    sat_fill_is = true;
    bright_fill_is = true;
    alpha_fill_is = true;
    hue_stroke_is = true;
    sat_stroke_is = true;
    bright_stroke_is = true;
    alpha_stroke_is = true;
    thickness_is = true;
    size_x_is = true;
    size_y_is = false;
    size_z_is = false;
    diameter_is = false;
    canvas_x_is = true;
    canvas_y_is = true;
    canvas_z_is = true;

    // frequence_is = true;
    speed_x_is = true;
    speed_y_is = false;
    speed_z_is = false;
    spurt_x_is = false;
    spurt_y_is = false;
    spurt_z_is = false;
    dir_x_is = false;
    dir_y_is = false;
    dir_z_is = false;
    jit_x_is = false;
    jit_y_is = false;
    jit_z_is  = false;
    swing_x_is = false;
    swing_y_is = false;
    swing_z_is = false;

    quantity_is = true;
    variety_is = false;
    life_is = false;
    flow_is = false;
    quality_is = false;
    area_is = false;
    angle_is = false;
    scope_is = false;
    scan_is = false;
    align_is = true;
    repulsion_is = true;
    attraction_is = true;
    density_is = false;
    influence_is = true;
    calm_is = false;
    spectrum_is = false;
  }
  
  Flock flock;
  Canvas myCanvas ;
  PVector birthPlace ;
  int maxColorRef = 360 ; // here we are in HSB 360
  int rangeAroundYourColor = 70 ;
  int numOfBoid ;
  // Main method
  // setup
  void setup() {
   set_item_pos(width/2,height/2,-width);

   // build the canvas where the boid can move
   PVector pos = new PVector (0, 0, 0) ;
   PVector size = new PVector(width,width,width) ;
   // PVector size = new PVector(get_canvas_x(),get_canvas_y(),get_canvas_z()) ;
   myCanvas = new Canvas(pos, size) ;
   // color colorBoid = color(80,100,100) ;
   birthPlace = pos.copy() ;
   flock = new Flock() ;

   // tetrahedronAdd() : weird why this method is here ?
   // tetrahedron_add();

  }
  
  // draw
  void draw() {
    // MAIN method
    float thickness = map(get_thickness().value(),0,width,0,width/30 ) ;
    int size = (int)map(get_size_x().value(),0,width, 2,width/10) ;
    float alignment = map(get_alignment().value(),0,1,0,10) ;
    float cohesion = map(get_attraction().value(),0,1,0,10) ;
    float separation = map(get_repulsion().value(),0,1,0,10) ;
    PVector unity = new PVector(cohesion, separation) ;
    if(flock.listBoid.size() > 0 )flock.run(alignment, unity);
    
    // ANNEXE methods
    
    // GOAL of the boids
    if(shift_long_is()) {
      float depthGoal =sin(frameCount *.002) *width ;
      float pos_x = map(mouse[ID_item].x,0,width, -get_canvas_x().value(), get_canvas_x().value()) ;
      float pos_y = map(mouse[ID_item].y,0,height, -get_canvas_y().value(), get_canvas_y().value()) ;
      flock.goal(pos_x,pos_y, depthGoal);
    }

    int beat_sensibility = 5 ;
    if(all_transient(ID_item) > beat_sensibility) {      
      float depthGoal =sin(frameCount *.003) *width ;
      float pos_x = sin(frameCount *.003) *get_canvas_x().value();
      float pos_y = cos(frameCount *.003) *get_canvas_y().value();
      flock.goal(pos_x,pos_y, depthGoal);
    }


    
    // INFLUENCE of the boid around him
    float ratioInfluence = get_influence().value() *400 +1 ;
    float influenceArea =  abs(sin(frameCount *.001) *ratioInfluence) ;
    flock.influence(influenceArea);
    
    // SPEED
    float speed = map(get_speed_x().value(),0,1,.1,7) ;
    speed *= speed ;
    if(sound_is() )speed *= (map(mix[ID_item],0,1,.00000001,7)) ;
    if(!motion_is() || (sound_is() && get_time_track() < .2)) speed = .00000001 ;
    flock.speed(speed) ;
    
    // cage size
    myCanvas.size.x = get_canvas_x().value() *10 ;
    myCanvas.size.y = get_canvas_y().value() *10 ;
    myCanvas.size.z = get_canvas_z().value() *10 ;
    myCanvas.update() ;
  
    flock.canvasSetting(myCanvas.left, myCanvas.right, myCanvas.top, myCanvas.bottom, myCanvas.front, myCanvas.back) ;
    
    // quantity of boids
    numOfBoid = int(get_quantity().value() *700 +30); //amount of boids to start the program with
    if(!FULL_RENDERING) numOfBoid /= 15 ;
    
    // change the setting of the boid
    for(Boid b : flock.listBoid) {
      b.fillBoid = color(hue(b.fillBoid), saturation(get_fill()), brightness(get_fill()), alpha(get_fill())) ;
      b.strokeBoid = color(hue(b.strokeBoid), saturation(get_stroke()), brightness(get_stroke()), alpha(get_stroke())) ;
      b.size = size ;
      b.thickness = thickness;
    }
    
    
    if(flock.listBoid.size() < 1 ) {
      flock.add(birthPlace, numOfBoid, get_fill(), get_stroke(), maxColorRef, rangeAroundYourColor) ;
    }
    
    // clear the boids list
    // flock.clear() ;
    if(key_n && action_is()) {
      flock.add(birthPlace, numOfBoid, get_fill(), get_stroke(), maxColorRef, rangeAroundYourColor) ;
    }
    
    // INFO
    item_info[ID_item] = ("There is " + numOfBoid + " boids") ;
    if(displayInfo) {
      strokeWeight(1) ;
      stroke(255) ;
      myCanvas.canvasLine() ;
    }
  }
}













// FLOCK
class Flock {
  ArrayList<Boid> listBoid = new ArrayList<Boid>(); //will hold the boids in this BoidList
  // float h; //for color
 //  color colorBoid ;
  // Univers
  float left, right, top, bottom, front, back ;
  // 
  PVector birthPlace ;
  
  // Constructor just to init
  Flock() {}
  
  
  // CONSTRUCTOR
  Flock(int n, color fillBoid, color strokeBoid) {
   birthPlace = new PVector(width/2,height/2,0) ;
    for(int i = 0; i < n ; i++) {
      listBoid.add(new Boid(birthPlace, fillBoid, strokeBoid));
    }
  }
  
  
  // 
  Flock(PVector birthPlace, int n, color fillBoid, color strokeBoid) {
    this.birthPlace = birthPlace.copy() ;
    for(int i = 0; i < n ; i++) {
      listBoid.add(new Boid(birthPlace, fillBoid, strokeBoid));
    }
  }
  
  
  // Flock Camaieu constructor
  Flock(PVector birthPlace, int n, color fillBoid, color strokeBoid, int max, int range) {
     this.birthPlace = birthPlace.copy() ;
     
     float refFill = hue(fillBoid) ;
     float refStroke = hue(strokeBoid) ;
     for(int i = 0; i < n ; i++) {
      float newHueFill = camaieu(max, refFill, range) ;
      float newHueStroke = camaieu(max, refStroke, range) ;
      fillBoid = color (newHueFill, saturation(fillBoid), brightness(fillBoid)) ;
      strokeBoid = color (newHueStroke, saturation(strokeBoid), brightness(strokeBoid)) ;
      listBoid.add(new Boid(birthPlace, fillBoid, strokeBoid));
    }
  }
  
  

  
  
  // SETUP
  void canvasSetting() {
    right = width ;
    left = 0 ;
    bottom = height ;
    top = 0 ;
    back = -300 ; 
    front = 300 ;
  }
  
  void canvasSetting(float left, float right, float top, float bottom, float front, float back) {
    this.left = left ;
    this.right = right ;
    this.top = top ;
    this.bottom = bottom ;
    this.front = front ;
    this.back = back ;
  }
  
  
  // DRAW
  void run(float ratioAlignment, PVector unity) {
    //iterate through the list of boids 
    for(Boid b : listBoid) {
     // Boid tempBoid = (Boid)listBoid.get(i); //create a temporary boid to process and make it the current boid in the list
    //  b.colorBoid = colorBoid;
      b.settingBounds (left, right, top, bottom, front, back);
      b.run (listBoid, ratioAlignment, unity); //tell the temporary boid to execute its run method
    }
  }
  
  // ANNEXE and EXTERNAL
  
   void goal(float x, float y, float z) {
     for(Boid b : listBoid) b.goal(x,y,z);
   }
   
   void influence(float neighborhoodRadius) {
     for(Boid b : listBoid) b.influence(neighborhoodRadius);
   }
   
   
 void speed(float maxSpeed) {
    for(Boid b : listBoid) b.speed(maxSpeed);
  }
  
  // ADD and REMOVE boids
  
  // different rebirth
  void add(int n) {
    listBoid.clear() ;
    for(int i = 0; i < n ; i++) listBoid.add(new Boid(birthPlace));
  }
  
  void add(int n, color fillBoid, color strokeBoid) {
    listBoid.clear() ;
    for(int i = 0; i < n ; i++) listBoid.add(new Boid(birthPlace, fillBoid, strokeBoid));
  }
  
 void add(PVector birthPlace, int n, color fillBoid, color strokeBoid, int max, int range) {
   listBoid.clear() ;
    float refFill = hue(fillBoid) ;
    float refStroke = hue(strokeBoid) ;
    for(int i = 0; i < n ; i++) {
      float newHueFill = camaieu(max, refFill, range) ;
      float newHueStroke = camaieu(max, refStroke, range) ;
      fillBoid = color (newHueFill, saturation(fillBoid), brightness(fillBoid)) ;
      strokeBoid = color (newHueStroke, saturation(strokeBoid), brightness(strokeBoid)) ;
      listBoid.add(new Boid(birthPlace,fillBoid,strokeBoid));
    }
  }
  
  
  
  
  void clear(){
    listBoid.clear() ;
  }
  
  void add() {
    listBoid.add(new Boid(new PVector(birthPlace.x,birthPlace.y,birthPlace.z)));
  }
  
  void addBoid(Boid b) {
    listBoid.add(b);
  }
  
  // remove specific boid
  void remove(int n) {
    if(n < listBoid.size())
      listBoid.remove(n);
  }
  
  // remove the last boid
  void remove() {
    if(listBoid.size() > 0)
      listBoid.remove(listBoid.size()-1);
  }
}
// END FLOCK
///////////









// BOID
////////
class Boid {
  //fields
  PVector pos = new PVector() ;
  PVector acc = new PVector() ;
  PVector velNorm = new PVector() ;
  PVector ali = new PVector() ;
  PVector coh = new PVector() ;
  PVector sep = new PVector() ; 
  
  float neighborhoodRadius = 100 ; //radius in which it looks for fellow boids, we give 100 for default value
  float maxSpeed = 4; //maximum magnitude for the velocity vector
  float maxSteerForce = .1; //maximum magnitude of the steering vector
  color fillBoid = color(255) ;
  color strokeBoid = color(255) ;
  float thickness = 1 ;
  int size = 1 ;
  
  
  
  // Canvas where the boids can move
  float left, right, top, bottom, front, back ;
  
  //constructors
    Boid(PVector pos) {
    this.pos = pos.copy() ;
    velNorm = new PVector(random(-1,1),random(-1,1),random(1,-1));
  }
  
  Boid(PVector pos, color fillBoid, color strokeBoid) {
    this.fillBoid = fillBoid ;
    this.strokeBoid = strokeBoid ;
    this.pos = pos.copy() ;
    velNorm = new PVector(random(-1,1),random(-1,1),random(1,-1));
  }
  
  Boid(PVector pos,PVector velNorm, float neighborhoodRadius) {
    this.pos = pos.copy() ;
    this.velNorm = velNorm.copy() ;
    this.neighborhoodRadius =neighborhoodRadius;
  }
  
  
  // DRAW
  void run(ArrayList boidList, float ratioAlignment, PVector unity) {

    
    //acc.add(new PVector(0,.05,0));

    flock(boidList, ratioAlignment, unity);
    move();
    checkBounds();
    
    //display
    display();
  }
  
  
  // ANNEXE EXTERNAL METHOD
  void goal(float x, float y, float z) {
    acc.add(steer(new PVector(x,y,z),true));
  }
  
  
  void influence(float neighborhoodRadius) {
    this.neighborhoodRadius = neighborhoodRadius;
  }
  
  void speed(float maxSpeed) {
    this.maxSpeed = maxSpeed ;
  }
  
  
  
  
  
  
  
  
  // ANNEXE INTERNAL METHOD
  // BEHAVIOR
  void flock(ArrayList listBoids, float ratioAlignment, PVector unity) {
    ali = alignment(listBoids);
    coh = cohesion(listBoids);
    sep = seperation(listBoids);
   //  float ratioAlignment = 1 ; // original 1
    float ratioCohesion = unity.x ; // original 3
    float ratioSeparation = unity.y ; // original 1
    acc.add(PVector.mult(ali,ratioAlignment));
    acc.add(PVector.mult(coh,ratioCohesion));
    acc.add(PVector.mult(sep,ratioSeparation));
  }
  
  void move() {
    velNorm.add(acc); // add acceleration to velocity
    velNorm.limit(maxSpeed); // make sure the velocity vector magnitude does not exceed maxSpeed
    pos.add(velNorm); // add velocity to position
    acc.mult(0); // reset acceleration
  }
  
  
  
  // UNIVERS
  // seeting in the Flock Class
  void settingBounds(float left, float right, float top, float bottom, float front, float back) {
    this.left = left ;
    this.right = right ;
    this.top = top ;
    this.bottom = bottom ;
    this.front = front ;
    this.back = back ;
  }

  // check bound
  void checkBounds() {
    // width
    if(pos.x > right) pos.x = left ;
    if(pos.x < left) pos.x = right ;
    //height
    if(pos.y > bottom) pos.y = top ;
    if(pos.y < top) pos.y = bottom ;
    // depth
    if(pos.z > front) pos.z = back ;
    if(pos.z < back) pos.z = front ;
  }
  
  
  
  
  
  
  // ENGINE
  
  /* STEERING, If arrival==true, the boid slows to meet the target. Credit to Craig Reynolds */
  PVector steer(PVector target,boolean arrival) {
    PVector steer = new PVector(); //creates vector for steering
    if(!arrival) {
      steer.set(PVector.sub(target,pos)); //steering vector points towards target (switch target and pos for avoiding)
      steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    } else {
      PVector targetOffset = PVector.sub(target, pos);
      float distance=targetOffset.mag();
      float rampedSpeed = maxSpeed *(distance *.01);
      float clippedSpeed = min(rampedSpeed,maxSpeed);
      PVector desiredVelocity = PVector.mult(targetOffset, (clippedSpeed /distance));
      steer.set(PVector.sub(desiredVelocity, velNorm));
    }
    return steer;
  }
  
  // DODGE. If weight == true avoidance vector is larger the closer the boid is to the target
  PVector dodge(PVector target,boolean weight) {
    PVector steer = new PVector(); //creates vector for steering
    steer.set(PVector.sub(pos, target)); //steering vector points away from target
    if(weight)
      steer.mult(1/sq(PVector.dist(pos, target)));
    //steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    return steer;
  }
  
  
  // SEPARATION
  PVector seperation(ArrayList <Boid> list) {
    PVector posSum = new PVector();
    PVector repulse;
    for(Boid b : list) {
      float d = PVector.dist(pos,b.pos);
      if(d > 0 && d <= neighborhoodRadius) {
        repulse = PVector.sub(pos,b.pos);
        repulse.normalize();
        repulse.div(d);
        posSum.add(repulse);
      }
    }
    return posSum;
  }
  
  
  // ALIGNMENT
  PVector alignment(ArrayList <Boid> list) {
    PVector velSum = new PVector();
    int count = 0;
    for(Boid b : list) {
      float d = PVector.dist(pos,b.pos);
      if(d > 0 && d<= neighborhoodRadius) {
        velSum.add(b.velNorm);
        count++;
      }
    }
    if(count>0) {
      velSum.div((float)count);
      velSum.limit(maxSteerForce);
    }
    return velSum;
  }
  
  
  // COHESION
  PVector cohesion(ArrayList <Boid> list) {
    PVector posSum = new PVector();
    PVector steer = new PVector();
    int count = 0;
    for(Boid b : list) {
      float d = dist(pos.x,pos.y,b.pos.x,b.pos.y);
      if(d > 0 && d <= neighborhoodRadius) {
        posSum.add(b.pos);
        count++;
      }
    }
    if(count>0) posSum.div((float)count);

    steer = PVector.sub(posSum,pos);
    steer.limit(maxSteerForce); 
    return steer;
  }
  // END ENGINE
  
  
  
  
  
  
  
  
  // DISPLAY
  void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateY(atan2(-velNorm.z, velNorm.x));
    rotateZ(asin(velNorm.y /velNorm.mag()));
    strokeWeight(thickness) ;
    if(thickness <= 0 || alpha(strokeBoid) == 0 ) noStroke() ; else stroke(strokeBoid);
    if(alpha(fillBoid) == 0 ) noFill() ; else  fill(fillBoid);
    // costume(vec3(),vec3(size),TRIANGLE_ROPE);
    // polyhedron(String type, String style, int size)
    // tetrahedron(size) ;
    polyhedron("TETRAHEDRON","VERTEX",(int)size);

    
    endShape();
    //box(10);
    popMatrix();
  }
}