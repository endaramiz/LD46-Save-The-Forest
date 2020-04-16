public class GS_SplashLogo extends GameState {
  private final int TIME_TO_END = 10;
  private boolean started;
  private int t0;
  
  public GS_SplashLogo() {
    started = false;
  }
  
  public void iterateLogic(Engine state_context) {
    if (!started) {
      started = true;
      t0 = millis();
    }
    if ( (millis() - t0)/1000 > TIME_TO_END ) {
      state_context.exit();
    }
  }
  
  public void iterateDraw() {
    fill((millis() - t0)/1000/TIME_TO_END*255);
    ellipse(mouseX, mouseY, 80, 80);
  }
}
