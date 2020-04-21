import java.util.Stack;

public abstract class GameState {
  public abstract void iterateLogic(Engine state_context);
  public abstract void iterateDraw();
}

public class Engine {
  private Stack<GameState> gstates;
  public SoundManager soundManager;

  public Engine() {
    soundManager = new SoundManager();
    setState(new GS_SplashLogo());
  }

  public void setState(GameState new_gstate) {
    gstates = new Stack<GameState>();
    pushState(new_gstate);
  }

  public void pushState(GameState new_gstate) {
    gstates.push(new_gstate);
  }

  public void popState() {
    gstates.pop();
  }


  public void iterateLogic() {
    gstates.peek().iterateLogic(this);
  }

  public void iterateDraw() {
    background(0);
    gstates.peek().iterateDraw();
  }

  public void endGame() {
    exit();
  }
}
