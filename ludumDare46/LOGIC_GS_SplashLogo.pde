public class GS_SplashLogo extends GameState {
  private final int TIME_TO_END = 300;
  private boolean started;
  private int t0;
  private PImage img; 
  
  public GS_SplashLogo() {
    started = false;
    img = loadImage("images/splash_amstudio.png");
  }
  
  public void iterateLogic(Engine state_context) {
    if (!started) {
      started = true;
      t0 = millis();
    }
    if ( (millis() - t0) > TIME_TO_END ) {
      state_context.setState(new GS_Menu());
      //state_context.endGame();
    }
  }
  
  public void iterateDraw() {
    background(255);
    image(img, width/2 - img.width/2, height/2 - img.height/2);
  }
}
