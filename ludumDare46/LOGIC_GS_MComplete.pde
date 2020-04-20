private class LvlFinishData {
  Terrain terrain;
  int ID, levelsCount;
  int scoreIni, scoreMision, scoreFin;
}

public class GS_MComplete extends GameState {
  PFont font;
  private final int FontSize = 24;
  private Boolean mouseRead;

  private LvlFinishData levelData;

  public GS_MComplete() {
    font = createFont("font/SourceCodePro-Regular.ttf", FontSize);

    mouseRead = true;
  }

  public void iterateLogic(Engine stateContext) {
    if (mousePressed && !mouseRead) {
      if (isWin()) {
        GS_Play nextLevel = new GS_Play();
        nextLevel.loadLevel((levelData.ID+1)%levelData.levelsCount);
        stateContext.setState(nextLevel);
      } else {
        stateContext.setState(new GS_Menu());
      }
    }

    if (!mousePressed) {
      mouseRead = false;
    }
  }

  public void iterateDraw() {
    levelData.terrain.display();

    pushMatrix();
    translate(0, 600-80);

    textFont(font, 14);

    colorMode(RGB, 255, 255, 255);
    stroke(255, 255, 255);
    noFill();
    strokeWeight(4);
    beginShape();
    vertex(8, 2);
    vertex(800-8, 2);
    vertex(800-2, 8);
    vertex(800-2, 80-8);
    vertex(800-8, 80-2);
    vertex(8, 80-2);
    vertex(2, 80-8);
    vertex(2, 8);
    endShape(CLOSE);
    beginShape(LINES);
    vertex(508, 78);
    vertex(508, 2);
    endShape();

    fill(255, 255, 255);
    textAlign(LEFT, CENTER);
    text("Initial Forest:", 510+20, 20);
    text("Mission Forest:", 510+20, 40);
    text("Actual Forest:", 510+20, 60);
    textAlign(RIGHT, CENTER);
    text(levelData.scoreIni, 800-20, 20);
    text(levelData.scoreMision, 800-20, 40);
    text(levelData.scoreFin, 800-20, 60);

    textFont(font, 40);
    textAlign(CENTER, CENTER);
    if (isWin()) {
      fill(0, 250, 0);
      text("Mission Complete", 255, 40);
    } else {
      fill(250, 0, 0);
      text("Mission Fail", 255, 40);
    }

    popMatrix();
  }

  public void setLevelData(LvlFinishData data) {
    levelData = data;
  }

  private boolean isWin() {
    return levelData.scoreFin >= levelData.scoreMision;
  }
}
