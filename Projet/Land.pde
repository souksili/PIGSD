public class Land {
  PShape shadow;
  PShape wireFrame;
  PShape satellite;
  Map3D map;
   /**
 * Returns a Land object.
 * Prepares land shadow, wireframe and textured shape
 * @param map Land associated elevation Map3D object 
 * @return Land object
 */
 Land(Map3D map , String fileName) {
 final float tileSize = 10.0f;
 this.map = map;
 float w = (float)Map3D.width;
 float h = (float)Map3D.height;
 // Shadow shape
 this.shadow = createShape();
 this.shadow.beginShape(QUADS);
 this.shadow.fill(0x992F2F2F);
 this.shadow.noStroke();
 this.shadow.translate((-width/2)-2000,(-height/2)-1000,30);
 this.shadow.vertex(0,0);
 this.shadow.vertex(0,h);
 this.shadow.vertex(w,h);
 this.shadow.vertex(w,0);
 this.shadow.endShape();
 // satellite shape
File ressource = dataFile(fileName);
if (!ressource.exists() || ressource.isDirectory()) {
 println("ERROR: Land texture file " + fileName + " not found.");
 exitActual();
}
PImage uvmap = loadImage(fileName);
 this.satellite = createShape();
 this.satellite.beginShape(QUADS);
 this.satellite.noFill();
 this.satellite.stroke(#888888);
 this.satellite.strokeWeight(0.00001f);
 this.satellite.texture(uvmap);
 // INSÉREZ VOTRE CODE ICI
float ru = uvmap.width / w;
float rv = uvmap.height / h;
for(int i = (int)(-w/(2*tileSize)),u = 0 ; i < w/(2*tileSize); i++,u += tileSize )
         {
       
           
           for(int j = (int)(-h/(2*tileSize)), v = 0; j < h/(2*tileSize); j++,v += tileSize)
           {
              Map3D.ObjectPoint un  = this.map.new ObjectPoint( i*tileSize, j*tileSize  );
              this.satellite.vertex(un.x, un.y, un.z, (u + tileSize) * ru, v * rv);
              Map3D.ObjectPoint deux  = this.map.new ObjectPoint( (i+1)*tileSize, j*tileSize  );
              this.satellite.vertex(deux.x, deux.y, deux.z,(u + tileSize) * ru, v * rv);
              Map3D.ObjectPoint trois  = this.map.new ObjectPoint( (i+1)*tileSize, (j+1)*tileSize  );
              this.satellite.vertex(trois.x, trois.y, trois.z,(u + tileSize) * ru, v * rv);
              Map3D.ObjectPoint quatre  = this.map.new ObjectPoint( i*tileSize, (j+1)*tileSize  );
              this.satellite.vertex(quatre.x, quatre.y, quatre.z,(u + tileSize) * ru, v * rv);              
              
           }
           
         }
 
 this.satellite.endShape();
 
 // Wireframe shape
 this.wireFrame = createShape();
 this.wireFrame.beginShape(QUADS);
 this.wireFrame.noFill();
 this.wireFrame.stroke(#888888);
 this.wireFrame.strokeWeight(0.5f);
 // INSÉREZ VOTRE CODE ICI
 
for(int i = (int)(-w/(2*tileSize)); i < w/(2*tileSize); i++ )
         {
       
           
           for(int j = (int)(-h/(2*tileSize)); j < h/(2*tileSize); j++)
           {
              Map3D.ObjectPoint un  = this.map.new ObjectPoint( i*tileSize, j*tileSize  );
              Map3D.ObjectPoint deux  = this.map.new ObjectPoint( (i+1)*tileSize, j*tileSize  );
              Map3D.ObjectPoint trois  = this.map.new ObjectPoint( (i+1)*tileSize, (j+1)*tileSize  );
              Map3D.ObjectPoint quatre  = this.map.new ObjectPoint( i*tileSize, (j+1)*tileSize  );
              
              
              this.wireFrame.vertex(un.x, un.y, un.z);
              this.wireFrame.vertex(deux.x, deux.y, deux.z);
              this.wireFrame.vertex(trois.x, trois.y, trois.z);
              this.wireFrame.vertex(quatre.x, quatre.y, quatre.z);
              
              
              
              
           }
           
         }
 
 this.wireFrame.endShape();

 // Shapes initial visibility
 this.shadow.setVisible(true);
 this.wireFrame.setVisible(false);
 this.satellite.setVisible(true);
 }
 public void update(){
    shape(this.shadow);
 }
 public void update1(){
    shape(this.wireFrame);
 }
 public void update2(){
    shape(this.satellite);
 }
 public void toggle() {
   this.shadow.setVisible(!this.shadow.isVisible());
   this.wireFrame.setVisible(!this.wireFrame.isVisible());
   this.satellite.setVisible(!this.satellite.isVisible());
  }
}
