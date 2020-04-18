

public class GS_Play extends GameState {
  private Terrain terrain;
  
  public GS_Play() {
    terrain = new Terrain(0, 0.7f);
  }
  
  public void iterateLogic(Engine state_context) {
    /*
    if (mousePressed) {
      state_context.endGame();
    }
    */
  }
  
  public void iterateDraw() {
    terrain.display();
  }
}
