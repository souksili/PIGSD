public class Railways {
  PShape group = createShape(GROUP);
  String fileName = "railways.geojson";
  JSONObject geojson = loadJSONObject(fileName);
  JSONArray features = geojson.getJSONArray("features");
  public Railways(Map3D map , String fichier){
            File ressource = dataFile(fichier);
    
    if (!ressource.exists() || ressource.isDirectory()) {
      println("ERROR: GeoJSON file " + fichier + " not found.");
      return; 
    }
    JSONObject geojson = loadJSONObject(fichier);
    
    if (!geojson.hasKey("type")) {
      println("WARNING: Invalid GeoJSON file.");
      return;
    } else if (!"FeatureCollection".equals(geojson.getString("type", "undefined"))) {
        println("WARNING: GeoJSON file doesn't contain features collection.");
        return;
    }
    JSONArray features = geojson.getJSONArray("features");
    
    if (features == null) {
      println("WARNING: GeoJSON file doesn't contain any feature.");
      return;
    }
      
    for (int f=0; f <features.size(); f++) {
      JSONObject feature = features.getJSONObject(f);
      if (!feature.hasKey("geometry"))
        break;
      JSONObject geometry = feature.getJSONObject("geometry");
      color laneColor = #FFFFFF;
      double laneOffset = 1.50d;
      float laneWidth = 6.5f;
       // Display threshold (increase if more performance needed...)
      if (laneWidth < 1.0f)
        break;      
      switch (geometry.getString("type", "undefined")) {
        case "LineString":
          JSONArray coordinates = geometry.getJSONArray("coordinates");

          if (coordinates != null){
              
              PShape track = createShape(); 
              track.beginShape(QUAD_STRIP);
              track.strokeWeight(0);
              track.emissive(0x7F);
              track.fill(laneColor);
              
              JSONArray point = coordinates.getJSONArray(0);
              Map3D.GeoPoint geopointA  = map.new GeoPoint(point.getDouble(0), point.getDouble(1));
              geopointA.elevation += laneOffset;
              Map3D.ObjectPoint objpointA = map.new ObjectPoint(geopointA);
              PVector Va = new PVector(objpointA.x,objpointA.y,objpointA.z).normalize().mult(laneWidth/2.0f);
              
              JSONArray C = coordinates.getJSONArray(coordinates.size() - 1);
              Map3D.GeoPoint geopointC = map.new GeoPoint(C.getDouble(0), C.getDouble(1));
              geopointC.elevation += laneOffset;
              Map3D.ObjectPoint objectpointC = map.new ObjectPoint(geopointC);
              PVector vC = new PVector(objectpointC.x, objectpointC.y, objectpointC.z).normalize().mult(laneWidth/2.0f);
              
              // vertex du debut 
              if ( geopointA.inside() ) {
                 track.normal(0,0,1);
                 track.vertex(objpointA.x - Va.x, objpointA.y - Va.y, objpointA.z);
                 track.normal(0,0,1);
                 track.vertex(objpointA.x + Va.x, objpointA.y + Va.y, objpointA.z);
                }
              // vertex du "milieu"
              PVector vB = new PVector((objpointA.y - objectpointC.y), (objpointA.x - objectpointC.x)).normalize().mult(laneWidth/2.0f);
              for (int p=1; p < coordinates.size() - 2; p++) {
                JSONArray B = coordinates.getJSONArray(p);
                Map3D.GeoPoint geopointB = map.new GeoPoint(B.getDouble(0), B.getDouble(1));
                geopointB.elevation += laneOffset;
                if(geopointB.inside()){
                  Map3D.ObjectPoint opB = map.new ObjectPoint(geopointB);
                  track.normal(0,0,1);
                  track.vertex(opB.x - vB.x, opB.y - vB.y, opB.z );
                  track.normal(0,0,1);
                  track.vertex(opB.x + vB.x, opB.y + vB.y, opB.z);
                }
              }
              // dernier vertex
              if(geopointC.inside()){
                track.normal(0,0,1);
                track.vertex(objectpointC.x - vC.x, objectpointC.y - vC.y, objectpointC.z );
                track.normal(0,0,1);
                track.vertex(objectpointC.x + vC.x, objectpointC.y + vC.y, objectpointC.z);
              }
              track.endShape();
              this.group.addChild(track);
          }
         break; 
      }
    }
  this.group.setVisible(false);    
  }

   void toggle(){
    group.setVisible(!this.group.isVisible());
  }
  
  void update(){
     shape(this.group);
  }
}
