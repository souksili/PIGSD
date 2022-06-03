Workspace workspace;
Camera camera;
Hud hud;
Map3D map;
Land land;
Gpx gpx;
Railways railways;
Road road;
Buildings buildings;

void settings() {
  pixelDensity(displayDensity());
  size(1000, 900,P3D);
  smooth(8);
}

void setup() {
  this.workspace = new Workspace(6000) ;
  this.camera = new Camera(PI/6,-PI/2,6000); 
  this.hud = new Hud();
  // Load Height Map
  this.map = new Map3D("paris_saclay.data");
  this.land = new Land(this.map,"paris_saclay.jpg");
  this.gpx = new Gpx(this.map, "trail.geojson");
  this.railways = new Railways(this.map, "railways.geojson");
  this.road = new Road(this.map, "roads.geojson");
    // Prepare buildings
   this.buildings = new Buildings(this.map);
  // Make camera move easier
  hint(ENABLE_KEY_REPEAT);
}

void draw() {
  background(60);
  perspective();
  //camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  // 3D camera (X+ right / Z+ top / Y+ Front)
  //camera(-500, 2000, 1000, 0, 0, 0, 0, 0, -1);
  camera(this.camera.x, -this.camera.y, this.camera.z, 0, 0, 0, 0, 0, -1);
  this.workspace.update();
  this.land.update();
  this.land.update1();
  this.land.update2();
  this.hud.update();
  this.hud.update1();
  this.gpx.update();
  this.railways.update();
  this.road.update();
  this.buildings.update();
}

void keyPressed() {
  switch (key) {
  case 'w': 
  case 'W':
    // Hide/Show grid & Gizmo
    this.workspace.toggle(); 
    // Hide/Show Land
    this.land.toggle();
    break;
  }

  if (key == CODED) {
    float delta = 0;
    float delta1 = 0;
    switch (keyCode) {
    case UP:
      // INSÉREZ VOTRE CODE ICI
      delta -= 0.01;
      this.camera.adjustLongitude(delta);
      this.camera(this.camera.x,this.camera.y,this.camera.z, 0, 0, 0, 0, 0, -1);
      break;
    case DOWN:
      // INSÉREZ VOTRE CODE ICI
      delta += 0.01;
      this.camera.adjustLongitude(delta);
      this.camera(this.camera.x,this.camera.y,this.camera.z, 0, 0, 0, 0, 0, -1);
      break;
    case LEFT:
      // INSÉREZ VOTRE CODE ICI
      delta1 -= 0.01;
      this.camera.adjustColatitude(delta1);
      this.camera(this.camera.x,this.camera.y,this.camera.z, 0, 0, 0, 0, 0, -1);
      break;
    case RIGHT:
      // INSÉREZ VOTRE CODE ICI
      delta1 += 0.01;
      this.camera.adjustColatitude(delta1);
      this.camera(this.camera.x,this.camera.y,this.camera.z, 0, 0, 0, 0, 0, -1);
      break;
    }
  } else {
    float offset = 0;
    switch (key) {
    case '+': 
      // INSÉREZ VOTRE CODE ICI
      offset -= 10;
      this.camera.adjustRadius(offset);
      this.camera(this.camera.x,this.camera.y,this.camera.z, 0, 0, 0, 0, 0, -1);
      break;
    case '-': 
      // INSÉREZ VOTRE CODE ICI
      offset += 10;
      this.camera.adjustRadius(offset);
      this.camera(this.camera.x,this.camera.y,this.camera.z, 0, 0, 0, 0, 0, -1);
      break;
    }
  }
  switch (key) {
  case 'x': 
  case 'X':
    // Hide/Show Gpx
    this.gpx.toggle();
    break;
  }
  
  switch (key) {
  case 'r': 
  case 'R':
    // Hide/Show Railways
    this.railways.toggle();
    this.road.toggle();
    break;
  }
  switch (key) {
  case 'b': 
  case 'B':
    // Hide/Show Buildings
    this.buildings.toggle();
    break;
  }
}
void mousePressed() {
 if (mouseButton == LEFT){
 this.gpx.clic(mouseX, mouseY);
 }
}
