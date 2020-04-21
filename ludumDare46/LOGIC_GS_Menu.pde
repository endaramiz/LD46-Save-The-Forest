import java.util.*;

private static enum MenuSelections {
  Play, Exit, a, b
};

public class GS_Menu extends GameState {
  private Terrain terrain;
  private final int FontSize = 24;

  private Map<MenuSelections, TextButton> buttons;

  public GS_Menu() {
    PFont font = createFont("font/SourceCodePro-Regular.ttf", FontSize);
    terrain = new Terrain(99, 200, 150, 4, 0.8f);
    buttons  = new HashMap();
    //int i = 1;
    int n = MenuSelections.values().length+1;
    for (MenuSelections ms : MenuSelections.values()) {
      TextButton tb = new TextButton(ms.toString(), 0, height*(ms.ordinal()+1)/n, width, FontSize, font, FontSize);
      buttons.put(ms, tb);
      //++i;
    }
  }

  public void iterateLogic(Engine stateContext) {
    if (mousePressed) {
      for (MenuSelections ms : MenuSelections.values()) {
        TextButton tb = buttons.get(ms);
        if (tb.isOver(mouseX, mouseY)) {
          switch (ms) {
          case Play:
            GS_Play level = new GS_Play(stateContext.soundManager);
            level.loadLevel(0);
            stateContext.setState(level);
            break;
          case Exit:
            stateContext.endGame();
            break;
          }
        }
      }
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
    
    fill(0, 0, 0);
    for (TextButton tb : buttons.values()) {
      tb.display(tb.isOver(mouseX, mouseY));
    }
  }
}
