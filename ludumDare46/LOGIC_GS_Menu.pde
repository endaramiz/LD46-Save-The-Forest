import java.util.*;

private static enum MenuSelections {
  Play, Exit, a, b
};

public class GS_Menu extends GameState {
  private final int FontSize = 24;

  private Map<MenuSelections, TextButton> buttons;

  public GS_Menu() {
    PFont font = createFont("font/SourceCodePro-Regular.ttf", FontSize);
    buttons  = new HashMap();
    //int i = 1;
    int n = MenuSelections.values().length+1;
    for (MenuSelections ms : MenuSelections.values()) {
      TextButton tb = new TextButton(ms.toString(), 0, height*(ms.ordinal()+1)/n, width, FontSize, font, FontSize);
      buttons.put(ms, tb);
      //++i;
    }
  }

  public void iterateLogic(Engine state_context) {
    if (mousePressed) {
      for (MenuSelections ms : MenuSelections.values()) {
        TextButton tb = buttons.get(ms);
        if (tb.isOver(mouseX, mouseY)) {
          switch (ms) {
          case Play:
            GS_Play level = new GS_Play();
            level.loadLevel(0);
            state_context.setState(level);
            break;
          case Exit:
            state_context.endGame();
            break;
          }
        }
      }
    }
  }

  public void iterateDraw() {
    colorMode(RGB, 255, 255, 255);
    fill(255, 255, 255);
    for (TextButton tb : buttons.values()) {
      tb.display(tb.isOver(mouseX, mouseY));
    }
  }
}
