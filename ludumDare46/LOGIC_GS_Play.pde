

public class GS_Play extends GameState {
  private Terrain terrain;
  private Boolean mouseRead;
  
  public GS_Play() {
    terrain = new Terrain(0, 0.7f);
    mouseRead = false;
  }
  
  public void iterateLogic(Engine state_context) {
    if (mousePressed && !mouseRead) {
      mouseRead = true;
      if (mouseButton == LEFT) {
        terrain.startFire(mouseY/TERRAIN_TILE_WH, mouseX/TERRAIN_TILE_WH);
      }
      if (mouseButton == RIGHT) {
        terrain.addRanger(mouseY/TERRAIN_TILE_WH, mouseX/TERRAIN_TILE_WH);
      }
    }
    
    if (!mousePressed) {
      mouseRead = false;
    }
    
    terrain.update();
  }
  
  public void iterateDraw() {
    terrain.display();
  }
}
