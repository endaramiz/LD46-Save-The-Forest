class GS_Title extends GameState {
  private Terrain terrain;
  private PFont font;
  private int time0;
  
  public GS_Title() {
    font = createFont("font/SourceCodePro-Regular.ttf", 48);
    terrain = new Terrain(99, 200, 150, 4, 0.8f);
    time0 = millis();
  }

  public void iterateLogic(Engine state_context) {
    if (mousePressed || keyPressed) {// || (millis()-time0)/1000 > 4) {
      state_context.setState(new GS_Menu());
    }
  }

  public void iterateDraw() {
    terrain.display();
    
    colorMode(RGB, 255, 255, 255);
    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    textFont(font, 52);
    text("Saves The\n      Forest", width/2, height/2);
  }
}
