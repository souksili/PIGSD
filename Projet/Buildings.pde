public class Buildings {
  PShape buildings;
  Map3D map;
  int colors = 0xFFaaaaaa;
  PShape group = createShape(GROUP);
  JSONArray features ;
  ArrayList<String> fc = new ArrayList<String>();
  ArrayList<Integer> cl = new ArrayList<Integer>();
  
  
public Buildings(Map3D map){
    this.map = map;
    this.buildings = createShape(GROUP);
    int w = 0;
    add("buildings_city.geojson", 0xFFaaaaaa);
    add("buildings_IPP.geojson", 0xFFCB9837);
    add("buildings_EDF_Danone.geojson", 0xFF3030FF);
    add("buildings_CEA_algorithmes.geojson", 0xFF30FF30);
    add("buildings_Thales.geojson", 0xFFFF3030);
    add("buildings_Paris_Saclay.geojson", 0xFFee00dd);
    for(int i = 0 ; i < fc.size() ; i++){
    w++;
    JSONObject geojson = loadJSONObject(fc.get(i));
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
        case "Polygon":
        JSONArray coordinates = geometry.getJSONArray("coordinates");
    
   if(coordinates != null){
       for(int p = 0 ; p < coordinates.size();p++){
        JSONArray bat = coordinates.getJSONArray(p);
        // on crÃ©e les murs 
        PShape walls = createShape();
        walls.beginShape(QUAD_STRIP);
        for(int d = w ;d < cl.size() ; d+=5){
        walls.fill(cl.get(d));
        }
        walls.emissive(0x30);
        walls.noStroke();
        PShape roofs = createShape();
        roofs.beginShape(POLYGON);
        for(int d = w ;d < cl.size() ; d+=5){
        roofs.fill(cl.get(d));
        }
        roofs.emissive(0x60);
        roofs.noStroke();
        
        // on rentre dans le deuxieme niveau 
        for(int q = 0 ; q < bat.size() - 1 ; q++){
          JSONObject properties = feature.getJSONObject("properties");
          JSONArray point = bat.getJSONArray(q);
          JSONArray point_suivant = bat.getJSONArray(q+1);
          int levels = properties.getInt("building:levels",1);
          float top = Map3D.heightScale * 4.0f *((float)levels);
          
          /////////murs////////
          Map3D.GeoPoint temp_geo_walls = map.new GeoPoint(point.getDouble(0),point.getDouble(1));
          Map3D.ObjectPoint temp_walls = map.new ObjectPoint(temp_geo_walls);
          //Map3D.GeoPoint temp_geo_walls2 = map.new GeoPoint(point_suivant.getDouble(0),point_suivant.getDouble(1));
          //Map3D.ObjectPoint temp_walls2 = map.new ObjectPoint(temp_geo_walls2);
          if(temp_walls.inside()){
            walls.vertex(temp_walls.x,temp_walls.y,temp_walls.z);
            //walls.vertex(temp_walls2.x,temp_walls2.y,temp_walls2.z);
            //walls.vertex(temp_walls2.x,temp_walls2.y,temp_walls2.z+top);
            walls.vertex(temp_walls.x,temp_walls.y,temp_walls.z+top);
          }
          Map3D.GeoPoint temp_geo_roofs = map.new GeoPoint(point.getDouble(0),point.getDouble(1));
          Map3D.ObjectPoint temp_roofs = map.new ObjectPoint(temp_geo_roofs);
          //Map3D.GeoPoint temp_geo_walls2 = map.new GeoPoint(point_suivant.getDouble(0),point_suivant.getDouble(1));
          //Map3D.ObjectPoint temp_walls2 = map.new ObjectPoint(temp_geo_walls2);
          if(temp_roofs.inside()){
            roofs.vertex(temp_roofs.x,temp_roofs.y,temp_roofs.z+top);
          }
        }
        walls.endShape();
        roofs.endShape(CLOSE);
        this.group.addChild(walls);
        this.group.addChild(roofs);
      }
     }
     break;
     }
}
    }
    this.group.setVisible(false);
}
  
  public void add(String fileName , int cls)
  {
    File ressource = dataFile(fileName);
    if (!ressource.exists() || ressource.isDirectory()) {
      println("ERROR: GeoJSON file " + fileName + " not found.");
      return; 
    }
    this.fc.add(fileName);
    this.cl.add(cls);
  }
  
  public void update()
  {
    shape(this.group);
  }
  
  public void toggle()
  {
     group.setVisible(!this.group.isVisible());
  }
 }
