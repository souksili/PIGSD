class Hud {
 private PMatrix3D hud;
 Hud() {
 // Should be constructed just after P3D size() or fullScreen()
 this.hud = g.getMatrix((PMatrix3D) null);
 }
 private void begin() {
         g.noLights();
         g.pushMatrix();
         g.hint(PConstants.DISABLE_DEPTH_TEST);
         g.resetMatrix();
         g.applyMatrix(this.hud);
 }
 private void end() {
         g.hint(PConstants.ENABLE_DEPTH_TEST);
         g.popMatrix();
 }
 private void displayFPS() {
        // Bottom left area
        noStroke();
        fill(96);
        rectMode(CORNER);
        rect(10, height-30, 60, 20, 5, 5, 5, 5);
        // Value
        fill(0xF0);
        textMode(SHAPE);
        textSize(14);
        textAlign(CENTER, CENTER);
        text(String.valueOf((int)frameRate) + " fps", 40, height-20);
 }

 private void  displayCamera(Camera camera) {
         // Bottom left area
        noStroke();
        fill(96);
        rectMode(CORNER);
        rect(10, 10, 150, 100, 5, 5, 5, 5);
         // Value
        fill(0xF0);
        textMode(SHAPE);
        textSize(14);
        textAlign(CENTER, CENTER);
        text("Camera", 75, 20);
        text("Longitude  " + (int)(Math.toDegrees(camera.longitude)) + "°",70, 40);
        text("Latitude   " + (int)(Math.toDegrees(camera.colatitude)) + "°", 58 , 60);
        text("Radius " + camera.radius, 62 , 80);
 }

public void update(){
       this.begin();
       this.displayFPS(); 
       this.end();
}
public void update1(){
       this.begin();
       this.displayCamera(camera);
       this.end();
}
}
