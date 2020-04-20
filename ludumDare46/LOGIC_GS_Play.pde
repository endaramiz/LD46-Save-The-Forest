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
    }
    else if (selected) {
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
    }
    else if (selected) {
      fill(56, 56, 0);
    }
    else {
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
  
  public GS_Play() {
    levels = readLevels();
    levelID = 0;
    loadLevel();
    
    mouseRead = true;

    firemanButton = new FiremanButton(80, 600-80, 80, 80);
    rangerButton = new RangerButton(80+(80)*1, 600-80, 80, 80);
    
    font = createFont("font/SourceCodePro-Regular.ttf", 32);
  }
  
  private void loadLevel() {
    Level lvl = levels.get(levelID);
    terrain = new Terrain(lvl.seed, lvl.hardness);
    initialForestValue = (int) terrain.getForestValue();
    targetForestValue = int (initialForestValue*lvl.target);
    freeWorkers = lvl.maxWorkers;
    
    addFireman = false;
    addRanger = false;
    
    terrain.startFire(lvl.fireX, lvl.fireY);
  }

  public void iterateLogic(Engine state_context) {
    freeWorkers = levels.get(levelID).maxWorkers - terrain.getWorkers();
    
    // DEBUG
    if (mousePressed && mouseButton == RIGHT) {
      terrain.startFire(mouseY/TERRAIN_TILE_WH, mouseX/TERRAIN_TILE_WH);
    }

    if (mousePressed && !mouseRead) {
      mouseRead = true;
      if (mouseY < 600-80) {
        if (mouseButton == LEFT) {
          if (addFireman) {
            terrain.addFireMan(mouseY/TERRAIN_TILE_WH, mouseX/TERRAIN_TILE_WH);
            addFireman = false;
          } else if (addRanger) {
            terrain.addRanger(mouseY/TERRAIN_TILE_WH, mouseX/TERRAIN_TILE_WH);
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

    if (!mousePressed) {
      mouseRead = false;
    }

    terrain.update();
    
    if (!terrain.existFire()) {
      levelID = (levelID+1)%levels.size();
      loadLevel();
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
    fill(255, 255, 255);
    textAlign(CENTER, CENTER);
    textFont(font, 14);
    text("Workers", 40, 18);
    textFont(font, 32);
    text(freeWorkers, 40, 40);
    
    // Forest Info
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
    //Level(int seed, int fireX, int fireY, float hardness, int maxWorkers, float target)
    levels.add(new Level(0, 500/TERRAIN_TILE_WH, 400/TERRAIN_TILE_WH, 0.7, 5, 0.5));
    levels.add(new Level(1, 200/TERRAIN_TILE_WH, 500/TERRAIN_TILE_WH, 0.7, 5, 0.5));
    return levels;
  }
}
