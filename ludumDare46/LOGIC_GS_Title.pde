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
    
    // Display clouds
    colorMode(RGB, 255, 255, 255, 1.0f);
    fill(255, 255, 255);
    noiseSeed(0);
    noiseDetail(8, 0.5);
    for (int i = 0; i < 75; ++i) {
      for (int j = 0; j < 100; ++j) {
        float v = noise(j*0.02 + millis()/8000.0, i*0.02 + millis()/20000.0);
        fill(220, 220, 220, map(v, 0.2, 0.8, 0.0, 1.0));
        rect(j*8, i*8, 8, 8);
      }
    }

    
    colorMode(RGB, 255, 255, 255);
    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    textFont(font, 96);
    text("Save The\n      Forest", width/2, height/2);
  }
}
