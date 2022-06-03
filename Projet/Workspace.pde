public class Workspace{

  PShape gizmo;
  PShape grid;
  PShape gizmo2;

  public Workspace(int size){
      //Gizmo-------------------------
      this.gizmo = createShape();
      this.gizmo.beginShape(LINES);
      this.gizmo.noFill();
      this.gizmo.strokeWeight(3.0f);
      
      // Red X
      this.gizmo.stroke(0xAAFF3F7F);
      gizmo.vertex(200,0,0);
      gizmo.vertex(0,0,0);
      
      // Green Y
      this.gizmo.stroke(0xAA3FFF7F);
      gizmo.vertex(0,200,0);
      gizmo.vertex(0,0,0);
      
      // Blue Z
      this.gizmo.stroke(0xAA3F7FFF);
      gizmo.vertex(0,0,200);
      gizmo.vertex(0,0,0);
      
      this.gizmo.endShape();
      
      // Grid------------------------
      this.grid = createShape();
      this.grid.beginShape(QUADS);
      this.grid.noFill();
      this.grid.stroke(0x77836C3D);
      this.grid.strokeWeight(0.5f);
      for(int i = -size/2 ; i < size/2 ; i+=100){
        for(int j = -size/2 ; j < size/2 ; j+=100){
          this.grid.vertex(i, j);
          this.grid.vertex(i+100, j);
          this.grid.vertex(i+100, j+100);
          this.grid.vertex(i, j+100);
        }
      }
      this.grid.endShape(); 
   
      this.gizmo2 = createShape();
      this.gizmo2.beginShape(LINES);
      this.gizmo2.noFill();
      this.gizmo2.strokeWeight(1.0f);
      
      // Red X
      this.gizmo2.stroke(0xAAFF3F7F);
      gizmo2.vertex(size/2,0,0);
      gizmo2.vertex(0,0,0);
      
      // Green Y
      this.gizmo2.stroke(0xAA3FFF7F);
      gizmo2.vertex(0,size/2,0);
      gizmo2.vertex(0,0,0);
      
       // Red -X
      this.gizmo2.stroke(0xAAFF3F7F);
      gizmo2.vertex(-size/2,0,0);
      gizmo2.vertex(0,0,0);
      
      // Green -Y
      this.gizmo2.stroke(0xAA3FFF7F);
      gizmo2.vertex(0,-size/2,0);
      gizmo2.vertex(0,0,0);
      
      this.gizmo2.endShape();

             
}
  public void update(){
    shape(this.gizmo);
    shape(this.grid);
    shape(this.gizmo2);
  }
    
  /**
  * Toggle Grid & Gizmo visibility.
  */
  void toggle() {
   this.gizmo.setVisible(!this.gizmo.isVisible());
  }
  
}
