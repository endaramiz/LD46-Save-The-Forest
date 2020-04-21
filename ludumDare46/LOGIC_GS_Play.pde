public class FiremanButton extends Button {
  public FiremanButton(int x, int y, int w, int h) {
    super(x, y, w, h);
  }

  public void display(boolean selected, boolean disabled) {
    pushMatrix();
    translate(x, y);
    colorMode(RGB, 255, 255, 255);
    stroke(0, 0, 255);
    if (disabled) {
      fill(56, 0, 0);
    } else if (selected) {
      fill(0, 0, 56);
    } else {
      fill(0, 0, 0);
    }
    strokeWeight(4);

    beginShape();
    vertex(16, 12);
    vertex(w-16, 12);
    vertex(w-12, 16);
    vertex(w-12, h-16);
    vertex(w-16, h-12);
    vertex(16, h-12);
    vertex(12, h-16);
    vertex(12, 16);
    endShape(CLOSE);

    popMatrix();
  }
}

public class RangerButton extends Button {
  public RangerButton(int x, int y, int w, int h) {
    super(x, y, w, h);
  }

  public void display(boolean selected, boolean disabled) {
    pushMatrix();
    translate(x, y);
    colorMode(RGB, 255, 255, 255);
    stroke(255, 255, 0);
    if (disabled) {
      fill(56, 0, 0);
    } else if (selected) {
      fill(56, 56, 0);
    } else {
      fill(0, 0, 0);
    }
    strokeWeight(4);

    beginShape();
    vertex(16, 12);
    vertex(w-16, 12);
    vertex(w-12, 16);
    vertex(w-12, h-16);
    vertex(w-16, h-12);
    vertex(16, h-12);
    vertex(12, h-16);
    vertex(12, 16);
    endShape(CLOSE);

    popMatrix();
  }
}

public class Level {
  public int seed;
  public int fireX, fireY;
  public float hardness;
  public int maxWorkers;
  public float target;
  public Level(int seed, int fireX, int fireY, float hardness, int workers, float target) {
    this.seed = seed;
    this.fireX = fireX;
    this.fireY = fireY;
    this.hardness = hardness;
    this.maxWorkers = workers;
    this.target = target;
  }
}

public class GS_Play extends GameState {
  private Vector<Level> levels;
  private int levelID;
  private Terrain terrain;

  private Boolean mouseRead;

  private FiremanButton firemanButton;
  private RangerButton rangerButton;

  private boolean addFireman;
  private boolean addRanger;

  private int freeWorkers;
  private int initialForestValue, targetForestValue;

  private PFont font;

  private int time0;

  public GS_Play(SoundManager soundManager) {
    levels = readLevels();

    mouseRead = true;

    firemanButton = new FiremanButton(80, 600-80, 80, 80);
    rangerButton = new RangerButton(80+(80)*1, 600-80, 80, 80);

    font = createFont("font/SourceCodePro-Regular.ttf", 32);
    soundManager.playMusic();
    time0 = millis();
  }

  public void loadLevel(int ID) {
    levelID = ID;
    Level lvl = levels.get(levelID);
    terrain = new Terrain(lvl.seed, 200, 130, 4, lvl.hardness);
    initialForestValue = (int) terrain.getForestValue();
    targetForestValue = int (initialForestValue*lvl.target);
    freeWorkers = lvl.maxWorkers;

    addFireman = false;
    addRanger = false;

    terrain.startFire(lvl.fireX, lvl.fireY);
  }

  public void iterateLogic(Engine state_context) {
    freeWorkers = levels.get(levelID).maxWorkers - terrain.getWorkers();

/*
    // DEBUG
    if (mousePressed && mouseButton == RIGHT) {
      //terrain.startFire(mouseY/TERRAIN_TILE_WH, mouseX/TERRAIN_TILE_WH);
      terrain.addRanger(mouseY/terrain.getTileWH(), mouseX/terrain.getTileWH());
    }
*/

    if (mousePressed && !mouseRead) {
      mouseRead = true;
      if (isTimeToPlay()) {
        if (mouseY < 600-80) {
          if (mouseButton == LEFT) {
            if (addFireman) {
              terrain.addFireMan(mouseY/terrain.getTileWH(), mouseX/terrain.getTileWH());
              addFireman = false;
            } else if (addRanger) {
              terrain.addRanger(mouseY/terrain.getTileWH(), mouseX/terrain.getTileWH());
              addRanger = false;
            }
          }
        } else if (!addFireman && !addRanger) {
          if (firemanButton.isOver(mouseX, mouseY) && freeWorkers > 0) {
            addFireman = true;
          } else if (rangerButton.isOver(mouseX, mouseY) && freeWorkers > 0) {
            addRanger = true;
          }
        }
      }
    }

    if (!mousePressed) {
      mouseRead = false;
    }

    terrain.update();

    state_context.soundManager.updateMusic();

    // MISSION COMPLETE/FAIL
    if (!terrain.existFire()) {
      state_context.soundManager.stopSong();

      //levelID = (levelID+1)%levels.size();
      GS_MComplete stateMComplete = new GS_MComplete();
      LvlFinishData lvlData = new LvlFinishData();
      lvlData.terrain = terrain;
      lvlData.ID = levelID;
      lvlData.scoreIni = initialForestValue;
      lvlData.scoreMision = targetForestValue;
      lvlData.scoreFin = (int) terrain.getForestValue();
      lvlData.levelsCount = levels.size();
      stateMComplete.setLevelData(lvlData);
      state_context.setState(stateMComplete);
    }
  }

  public void iterateDraw() {
    terrain.display();
    displayGUI();
    firemanButton.display(firemanButton.isOver(mouseX, mouseY) || addFireman, freeWorkers == 0 && !addFireman);
    rangerButton.display(rangerButton.isOver(mouseX, mouseY) || addRanger, freeWorkers == 0 && !addRanger);
  }

  private void displayGUI() {
    pushMatrix();
    translate(0, 600-80);
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
    vertex(80, 78);
    vertex(80, 2);

    vertex(508, 78);
    vertex(508, 2);
    endShape();

    // Workers
    colorMode(RGB, 255, 255, 255);
    if (isTimeToPlay()) {
      fill(255, 255, 255);
    } else {
      fill(255, 0, 0);
    }
    textAlign(CENTER, CENTER);
    textFont(font, 14);
    text("Workers", 40, 18);
    textFont(font, 32);
    text(freeWorkers, 40, 40);

    // Forest Info
    fill(255, 255, 255);
    textFont(font, 14);
    textAlign(LEFT, CENTER);
    text("Initial Forest:", 510+20, 20);
    text("Mission Forest:", 510+20, 40);
    text("Actual Forest:", 510+20, 60);
    textAlign(RIGHT, CENTER);
    text(initialForestValue, 800-20, 20);
    text(targetForestValue, 800-20, 40);
    text((int) terrain.getForestValue(), 800-20, 60);

    popMatrix();
  }

  private Vector<Level> readLevels() {
    Vector levels = new Vector();
    //Level(int seed, int fireR, int fireC, float hardness, int maxWorkers, float target)
    levels.add(new Level(7, 400/4, 600/4, 0.6, 5, 0.5));
    //levels.add(new Level(2, 200/4, 500/4, 0.5, 5, 0.5));
    levels.add(new Level(0, 500/4, 400/4, 0.7, 5, 0.5));
    //levels.add(new Level(1, 200/4, 500/4, 0.7, 5, 0.5));
    randomSeed(millis());
    for (int n = 0; n < 50; ++n) {
      int seed = (int) random(99999);
      int fireR = (int) random(500/4);
      int fireC = (int) random(800/4);
      float hardness = random(0.5, 1.0);
      int maxWorkers = (int) random(3, 7);
      float target = random(0.4, 0.6);
      levels.add(new Level(seed, fireR, fireC, hardness, maxWorkers, target));
    }
    return levels;
  }

  private boolean isTimeToPlay() {
    return (millis() - time0) > 5000;
  }
}
