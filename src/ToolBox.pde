/**
* Cette classe sera utilisée pour donner l'accès à
* des fonctions utilitaires qui pourraient servir dans
* plusieurs classes différentes
*/
public static class ToolBox{
  
  //-------------------------------------------------
  /**
  * Calcule la distance entre deux points / la norme du vecteur 
  * reliant les deux points
  */
  public static float distance(PVector p1, PVector p2){
     return ( 
       sqrt((p1.x - p2.x)*(p1.x - p2.x)
       + (p1.y - p2.y)*(p1.y - p2.y))
     );
  }
  
  //-------------------------------------------------
  /**
  * Calcule l'angle d'un vecteur avec l'axe d'origine des abscisses
  *
  * Pour la répétition suivant un cercle on va avoir besoin 
  * de connaître l'orientation d'un axe par rapport à la base canonique
  */
  public static float orientation(PVector p1, PVector p2){
     float arctan = atan((p2.y-p1.y)/(p2.x-p1.x));
    
     if(p2.x > p1.x) 
       return arctan;
     else if(p2.x < p1.x)  
       return arctan + PI;
     else if(p2.y > p1.y)
       return PI/2.0;
     else 
       return -PI/2.0; 
  }
  
  //------------------------------------------------------------------------
  /**
  * Convertit un point des coordonnées polaires vers les cartésiennes
  */
  public static PVector pol2Cart(PVector centre, float rayon, float angle){
    return new PVector(
           centre.x + cos(angle) * rayon,
           centre.y + sin(angle) * rayon
    );
  }
  
  //------------------------------------------------------------------------
  /**
  * Casting d'un nombre d'un intervalle sur un autre intervalle
  */
  public static float cast(float number, float inf1, float sup1, float inf2, float sup2){
     return number * ((sup2-inf2)/(sup1-inf1));
  }
  
  //------------------------------------------------------------------------
  /**
  * Effectue la translation circulaire d'un point autour d'un centre,
  * sur un certain arc donné par un angle
  */
  public static PVector rotation(PVector centre, float angle, PVector pt){
    float rayon = distance(centre, pt);
    float theta = orientation(centre, pt) - angle;
    return pol2Cart(centre, rayon, theta);
  }
  
  //------------------------------------------------------------------------
  /**
  * Effectue la translation rectiligne d'un point suivant un certain axe sur une distance donnée
  */
  public static PVector translation(PVector directionAxe, float distance, PVector pt){
    float theta = orientation(new PVector(0,0), directionAxe);
    return pol2Cart(pt, distance, theta);
  }
}
