public class Gpx {
  Map3D map;
  PShape track;
  PShape posts;
  PShape thumbtacks;
  int position;
  Gpx (Map3D map , String fileName){
    this.map = map;
    this.position = -1;
    // Check ressources
    this.track = createShape();
    this.track.beginShape(LINE_STRIP);
    this.track.noFill();
    this.track.strokeWeight(2);
    this.track.stroke(#9207EA);
    this.posts = createShape();
    this.posts.beginShape(LINES);
    this.posts.noFill();
    this.posts.strokeWeight(3);
    this.posts.stroke(#9207EA);
    this.thumbtacks = createShape();
    this.thumbtacks.beginShape(POINTS);
    this.thumbtacks.noFill();
    this.thumbtacks.strokeWeight(15);
    this.thumbtacks.stroke(0xFFFF3F3F);
File ressource = dataFile(fileName);
if (!ressource.exists() || ressource.isDirectory()) {
 println("ERROR: GeoJSON file " + fileName + " not found.");
 return;
}
// Load geojson and check features collection
JSONObject geojson = loadJSONObject(fileName);
if (!geojson.hasKey("type")) {
 println("WARNING: Invalid GeoJSON file.");
 return;
} else if (!"FeatureCollection".equals(geojson.getString("type", "undefined"))) {
 println("WARNING: GeoJSON file doesn't contain features collection.");
 return;
}
// Parse features
JSONArray features = geojson.getJSONArray("features");
if (features == null) {
 println("WARNING: GeoJSON file doesn't contain any feature.");
 return;
}
for (int f=0; f<features.size(); f++) {
 JSONObject feature = features.getJSONObject(f);
 if (!feature.hasKey("geometry"))
 break;
 JSONObject geometry = feature.getJSONObject("geometry");
 switch (geometry.getString("type", "undefined")) {
case "LineString":
 // GPX Track
 JSONArray coordinates = geometry.getJSONArray("coordinates");
 if (coordinates != null)
 for (int p=0; p < coordinates.size(); p++) {
 JSONArray point = coordinates.getJSONArray(p);
 Map3D.GeoPoint geopoint = this.map.new GeoPoint(point.getFloat(0),point.getFloat(1));
 Map3D.ObjectPoint objPoint = this.map.new ObjectPoint(geopoint);
 this.track.vertex(objPoint.x,objPoint.y,objPoint.z);
 //println("Track ", p, point.getDouble(0), point.getDouble(1));
 }
 break;
 case "Point":
 // GPX WayPoint
 if (geometry.hasKey("coordinates")) {
 JSONArray point = geometry.getJSONArray("coordinates");
 String description = "Pas d'information.";
 if (feature.hasKey("properties")) {
 description = feature.getJSONObject("properties").getString("desc", 
description);
 }
 Map3D.GeoPoint geopoint = this.map.new GeoPoint(point.getFloat(0),point.getFloat(1));
 Map3D.ObjectPoint objPoints = this.map.new ObjectPoint(geopoint);
 this.posts.vertex(objPoints.x,objPoints.y,objPoints.z);
 this.posts.vertex(objPoints.x,objPoints.y,objPoints.z+250);
 this.thumbtacks.vertex(objPoints.x,objPoints.y,objPoints.z+255);
 //println("WayPoint", point.getDouble(0), point.getDouble(1), description);
 }
 break;
default:
 println("WARNING: GeoJSON '" + geometry.getString("type", "undefined") + "' geometry type not handled.");
 break;
 }
}
 this.thumbtacks.endShape();
 this.posts.endShape();
 this.track.endShape();
 this.thumbtacks.setVisible(false);
 this.posts.setVisible(false);
 this.track.setVisible(false);
  }
  void update()
     {
     shape(this.track);
     shape(this.posts);
     shape(this.thumbtacks);
     if(this.position != -1){
       displaytext(camera, this.position);
     }
     }
 void toggle()
     {
        this.track.setVisible(!this.track.isVisible());
        this.posts.setVisible(!this.posts.isVisible());
        this.thumbtacks.setVisible(!this.thumbtacks.isVisible());
     }
  void clic(float mouseX, float mouseY){
       int s = 0;
       PVector hit = this.thumbtacks.getVertex(0);
       float d0 = dist(mouseX, mouseY, screenX(hit.x, hit.y, hit.z), screenY(hit.x, hit.y, hit.z));
       PVector hit1 = this.thumbtacks.getVertex(1);
       float d1 = dist(mouseX, mouseY, screenX(hit1.x, hit1.y, hit1.z), screenY(hit1.x, hit1.y, hit1.z));
       PVector hit2 = this.thumbtacks.getVertex(2);
       float d2 = dist(mouseX, mouseY, screenX(hit2.x, hit2.y, hit2.z), screenY(hit2.x, hit2.y, hit2.z));
       PVector hit3 = this.thumbtacks.getVertex(3);
       float d3 = dist(mouseX, mouseY, screenX(hit3.x, hit3.y, hit3.z), screenY(hit3.x, hit3.y, hit3.z));
       PVector hit4 = this.thumbtacks.getVertex(4);
       float d4 = dist(mouseX, mouseY, screenX(hit4.x, hit4.y, hit4.z), screenY(hit4.x, hit4.y, hit4.z));
       PVector hit5 = this.thumbtacks.getVertex(5);
       float d5 = dist(mouseX, mouseY, screenX(hit5.x, hit5.y, hit5.z), screenY(hit5.x, hit5.y, hit5.z));
       PVector hit6 = this.thumbtacks.getVertex(6);
       float d6 = dist(mouseX, mouseY, screenX(hit6.x, hit6.y, hit6.z), screenY(hit6.x, hit6.y, hit6.z));
       float [] tab = {d0,d1,d2,d3,d4,d5,d6};
       float min = min(tab);
       for(int i = 0 ; i < tab.length; i++){
           if(tab[i] == min){
             s = i;
             this.position = s;
             this.thumbtacks.setStroke(s, 0xFF3FFF7F);
             this.displaytext(camera,s);
             for(int v = 0 ; v <this.thumbtacks.getVertexCount() ; v++){
                 if(v != s){
                    this.thumbtacks.setStroke(v, 0xFFFF3F3F);
                 }
             }
           }
       }
  } 
  private void  displaytext(Camera camera, int val) {
    pushMatrix();
    lights();
    fill(0xFFFFFFFF);
    String [] tab ={"P.U.I.O","Arrêt de bus ","Descendre vers la forêt","Intersection dangereuse", "A droite avant Le Château","Feu tricolore","Parking Bat. 333"};
    PVector hit = this.thumbtacks.getVertex(val);
    translate(hit.x+40.0f, hit.y, hit.z + 10.0f);
    rotateZ(camera.longitude-HALF_PI);
    rotateX(camera.colatitude);
    g.hint(PConstants.DISABLE_DEPTH_TEST);
    textMode(SHAPE);
    textSize(70);
    textAlign(LEFT, CENTER);
    text(tab[val], 0, 0);
    g.hint(PConstants.ENABLE_DEPTH_TEST);
    popMatrix();
  }
}
