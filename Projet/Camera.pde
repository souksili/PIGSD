public class Camera {

  public float x ;
  public float y ;
  public float z ;
  public float longitude;
  public float colatitude;
  public float radius;
  
  public Camera(float longitude,float colatitude , float radius){
         this.longitude = longitude;
         this.colatitude = colatitude;
         this.radius = radius;
         this.x = (float)(radius * Math.sin(longitude) * Math.cos(colatitude));
         this.y = (float)(radius * Math.sin(longitude) * Math.sin(colatitude));
         this.z = (float)(radius * Math.cos(longitude)) ;
  }

  //pour ajuster le zoom (en mètres)
  public void adjustRadius(float offset) {
         this.radius = this.radius + offset;
         this.x = (float)(radius * Math.sin(longitude) * Math.cos(colatitude));
         this.y = (float)(radius * Math.sin(longitude) * Math.sin(colatitude));
         this.z = (float)(radius * Math.cos(longitude)) ;
         
  }
  //pour se déplacer vers ladroite ou la gauche
  public void adjustLongitude(float delta) {
         this.longitude = this.longitude + delta; 
         this.x = (float)(radius * Math.sin(longitude) * Math.cos(colatitude));
         this.y = (float)(radius * Math.sin(longitude) * Math.sin(colatitude));
         this.z = (float)(radius * Math.cos(longitude)) ;
  }
  //pour définir l’angle de vue plongeante (en radians).
  public void adjustColatitude(float delta) {
         this.colatitude = this.colatitude + delta;
         this.x = (float)(radius * Math.sin(longitude) * Math.cos(colatitude));
         this.y = (float)(radius * Math.sin(longitude) * Math.sin(colatitude));
         this.z = (float)(radius * Math.cos(longitude)) ;
  }
  
}
