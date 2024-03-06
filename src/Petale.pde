/**
* Réalise une interpolation linéaire entre deux couleurs
*/
color interpolCouleur(float percent, color first, color second){
   int teinte = floor(percent * (hue(second) - hue(first)) + hue(first));
   int saturation = floor(percent * (saturation(second) - saturation(first)) + saturation(first));
   int luminosite = floor(percent * (brightness(second)-brightness(first)) + brightness(first));
     
   return color(teinte, saturation, luminosite);
}

//--------------------------------------------------------------------
/**
* Crée une courbe d'ordonnées de points à l'allure paramétrable
*/
ArrayList<Float> courbure(int nbPoint, int abscisseMax, float ampliMax, int allure){
  ArrayList<Float> courbe = new ArrayList<Float>();
  
  if(allure == 0){ //courbe d'allure sinusoïdale ---------------------------------------------------------
  
    float nbPeriode = 2*PI*int(random(1,19));
        
    for(int i = 0; i < abscisseMax; i++){
      float theta            = ToolBox.cast(float(i), 1.0, nbPoint, 0.0, nbPeriode);
      float percentAmplitude = ToolBox.cast(float(i), 1.0, nbPoint, 0.0, 1.0); 
      float ordonnee         = (sin(theta)*0.5 + 1)*ampliMax*percentAmplitude;
          
      courbe.add(ordonnee);
    }
        
    for(int i = abscisseMax; i < nbPoint; i++){ 
      float theta            = ToolBox.cast(float(nbPoint-i), 1.0, nbPoint, 0.0, nbPeriode);
      float percentAmplitude = ToolBox.cast(float(nbPoint-i), 1.0, nbPoint, 0.0, 1.0); 
      float ordonnee         = (sin(theta)*0.5 + 1)*ampliMax*percentAmplitude;
          
      courbe.add(ordonnee);
    }
  
  }else{ //courbe complètement aléatoire :-) ----------------------------------------------------------
    float ampliMin = random(0.1*ampliMax, 0.8*ampliMax);
    
    for(int i = 0; i < abscisseMax; i++) courbe.add(random(ampliMin, ampliMax));
    courbe.add(ampliMax);
    for(int i = abscisseMax+1; i < nbPoint; i++) courbe.add(random(ampliMin, ampliMax));
  }
  return courbe;
}

/********************************************************************************************
Classe PETALE *******************************************************************************
*********************************************************************************************/
/* Un pétale est un motif qui à un axe de symétrie et 
* une bordure en courbe, d'allure parametrable.
*/
public class Petale implements Motif{
  //courbe externe du pétal, représentée par un certain nombre de point
  // et symétrique par rapport à l'axe
  public ArrayList<PVector> courbe, symetrie; 
  //axe de symétrie représenté par deux points
  public ArrayList<PVector> axe; 
  
  //largeur maximale et hauteur du petale
  public float hauteur;
  
  //----------------------------------------------------------------------------
  /**
  * Constructeur de base de petale, non paramétré
  */
  public Petale(){
    this.axe      = new ArrayList<PVector>(); 
    this.courbe   = new ArrayList<PVector>();
    this.symetrie = new ArrayList<PVector>();
    this.hauteur  = 0;
  }
  
  //----------------------------------------------------------------------------
  /**
  * On construit un pétal à partir de son axe de symétrie et de l'allure de
  * sa courbe externe
  */
  public Petale(PVector p1, PVector p2, int allure){
    /*création de l'axe de symétrie : on prendra comme convention
    que le point le plus proche du centre de la rosace soit toujours
    celui d'indice 0 dans la liste 'axe' */
    this.axe = new ArrayList<PVector>();
    this.axe.add(p1); this.axe.add(p2);
    
    this.hauteur = ToolBox.distance(p1, p2);
    
    /* création de la courbe externe du pétale dans une fonction à part */
    this.courbe = new ArrayList<PVector>();
    this.symetrie = new ArrayList<PVector>();
    this.generateCourbe(int(2*hauteur), allure);
  }
  
  //----------------------------------------------------------------------------
  /**
  * On construit un pétal à partir d'un centre de rotation, de la distance à ce centre
  * et de la hauteur du pétale
  */
  public Petale(PVector centre, float distance, float hauteur, int allure){
    this.hauteur = hauteur;
    
    this.axe = new ArrayList<PVector>();
    this.axe.add(ToolBox.pol2Cart(centre, distance, 0.0));
    this.axe.add(ToolBox.pol2Cart(centre, distance+hauteur, 0.0));
    
    this.courbe = new ArrayList<PVector>();
    this.symetrie = new ArrayList<PVector>();
    this.generateCourbe(int(2*hauteur), allure);
  }
  
  //----------------------------------------------------------------------------
  /**
  * On construit un pétal comme copie d'un autre pétale
  */
  public Petale(Petale petale){
    this.axe = new ArrayList(petale.axe);
    this.symetrie = new ArrayList(petale.symetrie);
    this.courbe = new ArrayList(petale.courbe);
    
    this.hauteur = petale.hauteur;
  }
  
  
  //------------------------------------------------------------------------
  /**
  * Génère la courbe externe du pétale en fonction d'un certain nombre de point
  * et d'une fonction qui va permettre de déterminer l'allure de cette courbe
  */
  private void generateCourbe(int n, int allure){
    PVector p1 = this.axe.get(0),
            p2 = this.axe.get(1);
    
    float subdiv = this.hauteur / float(n+1);
    float orientation = ToolBox.orientation(p1,p2);
    
    int abscisseAmpliMax = int(0.33*n); //int(random(1, n-1));
    
    ArrayList<Float> ecartAxe = courbure(n, abscisseAmpliMax, this.hauteur/2.0, allure);
    
    for(int i = 1; i < n; i++){
      PVector u   = new PVector(i*subdiv*cos(orientation), i*subdiv*sin(orientation)),
              v   = new PVector(-ecartAxe.get(i)*sin(orientation), ecartAxe.get(i)*cos(orientation)),
              v_s = new PVector(-v.x, -v.y); //construction du symétrique du point
      
      this.courbe.add(new PVector(p1.x+u.x+v.x, p1.y+u.y+v.y));
      this.symetrie.add(new PVector(p1.x+u.x+v_s.x, p1.y+u.y+v_s.y));
    }
  }
  
  //------------------------------------------------------------------------
  //un motif est dessinable
  public void dessiner(color c){
    noStroke();
    int nbPt = this.courbe.size();
    
    //TODO : debug
    //on dessine le pétale
    
    for(int i = 0; i < nbPt-1; i++){
      float percent = ToolBox.cast(float(i), 0, nbPt-1, 0, 1);
      color couleur = interpolCouleur(percent, color(hue(c),0,0), c); 
      
      beginShape();
      
      fill(couleur);
      vertex(this.courbe.get(i).x, this.courbe.get(i).y);
      vertex(this.symetrie.get(i).x, this.symetrie.get(i).y);
      vertex(this.symetrie.get(i+1).x, this.symetrie.get(i+1).y);
      vertex(this.courbe.get(i+1).x, this.courbe.get(i+1).y);
      
      endShape(CLOSE);
    }
    
    
  }
  
  //-------------------------------------------------------------------------
  /**
  * Effectue la translation circulaire d'un pétale autour d'un centre le long d'un arc
  * donné par un certain angle
  */
  public void rotation(PVector centre, float angle){
    
    for(int i = 0; i < this.axe.size(); i++){
     PVector pt = new PVector(this.axe.get(i).x, this.axe.get(i).y);
     this.axe.set(i, ToolBox.rotation(centre, angle, pt));
    }
    
    for(int i = 0; i < this.courbe.size(); i++){
     PVector pt = new PVector(this.courbe.get(i).x, this.courbe.get(i).y);
     this.courbe.set(i, ToolBox.rotation(centre, angle, pt));
    }
    
    for(int i = 0; i < this.symetrie.size(); i++){
     PVector pt = new PVector(this.symetrie.get(i).x, this.symetrie.get(i).y);
     this.symetrie.set(i, ToolBox.rotation(centre, angle, pt));
    }
  }
  
  /********************************************************************************************** 
  ********************************************************************************************** 
  ********************************************************************************************* 
  * REPOSITIONNEMENT ET TRANSLATION PETALE 
  *
  *  - initialement devaient permettre de réorienter un pétale générée quelque part
  *    sur la fenêtre vers un centre, 
  *  - puis de le translater vers ce centre l'approcher à une distance voulue
  *  
  * NON IMPLEMENTEES COMPLETEMENT par manque de temps
  
  //-------------------------------------------------------------------------
  /*
  * Effectue la translation d'un pétale le long de son axe sur une certaine distance,
  * la distance peut-être négative en fonction du sens de translation du pétale
  * /
  public void translation(float distance){
    PVector directionAxe = new PVector( 
            this.axe.get(1).x - this.axe.get(0).x,
            this.axe.get(1).y - this.axe.get(0).y
    );
    
    for(int i = 0; i < this.axe.size(); i++){
     PVector pt = new PVector(this.axe.get(i).x, this.axe.get(i).y);
     this.axe.set(i, ToolBox.translation(directionAxe, distance, pt));
    }
    
    for(int i = 0; i < this.courbe.size(); i++){
     PVector pt = new PVector(this.courbe.get(i).x, this.courbe.get(i).y);
     this.courbe.set(i, ToolBox.translation(directionAxe, distance, pt));
    }
    
    for(int i = 0; i < this.symetrie.size(); i++){
     PVector pt = new PVector(this.symetrie.get(i).x, this.symetrie.get(i).y);
     this.symetrie.set(i, ToolBox.translation(directionAxe, distance, pt));
    }
  }
  
  //--------------------------------------------------------------------------
  /* * 
  * Repositionne un pétale de sorte à ce que son axe soit aligné avec un point donnés,
  * et qu'il se situe à une certaine distance de ce point
  * /
  public void repositionnement(PVector centre, float distance){
    //on détermine de quel angle on doit faire tourner le pétale pour que son axe soit aligné avec 
    //le point qui est donné en paramètre
      float angleCentreAbscisse = ToolBox.orientation(new PVector(0,0), centre);
      float angleAxeAbscisse    = ToolBox.orientation(this.axe.get(0), this.axe.get(1));
      float angleRotation = angleCentreAbscisse - angleAxeAbscisse;
    //on détermine le point 'central' du pétale autour duquel va s'effectuer la rotation afin d'aligner
    //l'axe du pétale avec le point
      PVector centrePetale = new PVector(
              (this.axe.get(1).x + this.axe.get(0).x)/2.0,
              (this.axe.get(1).x + this.axe.get(0).y)/2.0
      );
      
      this.rotation(centrePetale, angleRotation);
      //on fait translater le pétale afin de l'approcher du centre
      if(this.axe.get(0).x < centre.x){
        this.translation(distance);
      }else{
        this.translation(-distance);
      }
  }
  
  *********************************************************************************************
  ********************************************************************************************* 
  *********************************************************************************************/
  
  //-------------------------------------------------------------------------
  /**
  * Un motif est répétable en cercle un certain nombre de fois
  * et autour d'un centre de rotation
  * 
  * PRECONDITION PETALE :
  *   - le pétale a été initialisé orienté par rapport au centre
  */
  public void repeter(int nb, PVector centre, float phase){
    float stepAngle = (2*PI)/float(nb);
    
    color c = color(200,200,200);
    this.rotation(centre, phase);
    
    for(int i = 0; i < nb; i++){
      this.rotation(centre, stepAngle);
      this.dessiner(c);
    }
  }
}
