

public class GS_Play extends GameState {
  private Terrain terrain;
  
  public GS_Play() {
    terrain = new Terrain(0, 0.7f);
  }
  
  public void iterateLogic(Engine state_context) {
    if (mousePressed) {
      if (mouseButton == LEFT) {
        terrain.startFire(mouseY/TERRAIN_TILE_WH, mouseX/TERRAIN_TILE_WH);
      }
      if (mouseButton == RIGHT) {
        terrain.addFireMan(mouseY/TERRAIN_TILE_WH, mouseX/TERRAIN_TILE_WH);
      }
    }
    terrain.update();
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
