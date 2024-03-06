PVector centreRosace = new PVector(),
        pt = new PVector();
        
ArrayList<Petale> petales = new ArrayList<Petale>(); //DECLARATION DES PETALES A DESSINER
float distanceOrigine = 50, hauteur = 50;
int nbPetales = 7;

void setup(){
  colorMode(HSB);
  size(800,800,P3D);
  
  centreRosace.x = width/2;
  centreRosace.y = height/2;
  
  background(255);
  
  //////////////////////////////////////////////////////////////////////////////////////////
  //EVALUATION DES PETALES A DESSINER
  for(int i = 0; i < nbPetales; i++){
    petales.add(new Petale(centreRosace, distanceOrigine+i*hauteur, hauteur, 0));
  }
  //////////////////////////////////////////////////////////////////////////////////////////
   
}

//////////////////////////////////////////////////////////////////////////////////////
/**
* Paramètre globaux qui serviront au dessin des pétales
*/
float deltaAngle = PI/200;
float phase      = deltaAngle;
int   repet      = 3;

//-----------------------------------------------------------------------------------
/**
* Ensemble de touches pour modifier les cercles et vitesses angulaires des PETALES
*/
void keyPressed(){
  println(int(key));
  
  switch(key){
     case 's' : phase = 0.0; break;
     
     case CODED:
          switch(keyCode){
            case UP    : repet++; break;
            case DOWN  : repet = (repet > 2)? repet-1 : repet; break;
            
            case RIGHT : phase += deltaAngle; break;
            case LEFT  : phase -= deltaAngle; break;
          }
          break;
  }
  
  if(int(key) < 58 && int(key) > 47 && int(key)-48 < nbPetales){
      int index = int(key)-48;
      petales.set(index, new Petale(centreRosace, distanceOrigine+index*hauteur, hauteur, 0));
  }
  
}
///////////////////////////////////////////////////////////////////////////////////////////////////

void draw(){
  background(255);
  
  //-----------------------------------------------------------------------
  //DESSIN DES PETALES
  noStroke();
  
  int sens = 1;
  for(int i = 0; i < petales.size(); i++){
     petales.get(i).repeter(int(repet*i*1.5), centreRosace, sens*exp(-i)*phase);
     sens *= -1;
  }
}
