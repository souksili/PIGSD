 public class Road {
  PShape group = createShape(GROUP);
  String fileName = "roads.geojson";
  JSONObject geojson = loadJSONObject(fileName);
  JSONArray features = geojson.getJSONArray("features");

  
  public Road(Map3D map, String fichier){
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
      if (!feature.hasKey("properties"))
        break;
      JSONObject properties = feature.getJSONObject("properties");
      String laneKind = "unclassified";
      color laneColor = 0xFFFF0000;
      double laneOffset = 1.50d;
      float laneWidth = 0.5f;
      // See https://wiki.openstreetmap.org/wiki/Key:highway
      laneKind = properties.getString("highway", "unclassified");
      switch (laneKind) {
        case "motorway":
          laneColor = 0xFFe990a0;
          laneOffset = 3.75d;
          laneWidth = 8.0f;
          break;
        case "trunk":
          laneColor = 0xFFfbb29a;
          laneOffset = 3.60d;
          laneWidth = 7.0f;
          break;
        case "trunk_link":
        case "primary":
          laneColor = 0xFFfdd7a1;
          laneOffset = 3.45d;
          laneWidth = 6.0f;
          break;
        case "secondary":
        case "primary_link":
          laneColor = 0xFFf6fabb;
          laneOffset = 3.30d;
          laneWidth = 5.0f;
          break;
        case "tertiary":
        case "secondary_link":
          laneColor = 0xFFE2E5A9;
          laneOffset = 3.15d;
          laneWidth = 4.0f;
          break;
        case "tertiary_link":
        case "residential":
        case "construction":
        case "living_street":
          laneColor = 0xFFB2B485;
          laneOffset = 3.00d;
          laneWidth = 3.5f;
          break;
        case "corridor":
        case "cycleway":
        case "footway":
        case "path":
        case "pedestrian":
        case "service":
        case "steps":
        case "track":
        case "unclassified":
          laneColor = 0xFFcee8B9;
          laneOffset = 2.85d;
          laneWidth = 1.0f;
          break;
        default:
          laneColor = 0xFFFF0000;
          laneOffset = 1.50d;
          laneWidth = 0.5f;
          println("WARNING: Roads kind not handled : ", laneKind);
          break;
        }
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
              group.addChild(track);
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
