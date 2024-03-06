/**
* Un motif est un objet dessinable, coloriable, et 
* répétable un certain nombre de fois suivant un cercle
*/

public interface Motif{
  //un motif est dessinable
  public void dessiner(color c);
  
  //un motif est répétable en cercle un certain nombre de fois
  // et autour d'un centre de rotation
  public void repeter(int nb, PVector centre, float phase);
  
}
