public class GS_Play extends GameState {
  private TileMap map;
  
  public GS_Play() {
    map = new TileMap("maps/testMap.tmx");
  }
  
  public void iterateLogic(Engine state_context) {
    if (mousePressed) {
      state_context.endGame();
    }
  }
  
  public void iterateDraw() {
    map.display(0, 0);
  }
}
