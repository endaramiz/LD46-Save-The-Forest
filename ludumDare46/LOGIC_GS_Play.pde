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

public class GS_Play extends GameState {
  private Terrain terrain;
  private Boolean mouseRead;

  private FiremanButton firemanButton;
  private RangerButton rangerButton;

  private boolean addFireman;
  private boolean addRanger;
  
  private int freeWorkers, maxWorkers;

  private PFont font;
  
  public GS_Play() {
    terrain = new Terrain(0, 0.7f);
    maxWorkers = 1;
    
    mouseRead = true;

    firemanButton = new FiremanButton(80, 600-80, 80, 80);
    rangerButton = new RangerButton(80+(80)*1, 600-80, 80, 80);

    addFireman = false;
    addRanger = false;
    
    font = createFont("font/SourceCodePro-Regular.ttf", 32);
  }

  public void iterateLogic(Engine state_context) {
    freeWorkers = maxWorkers - terrain.getWorkers();
    
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


    colorMode(RGB, 255, 255, 255);
    fill(255, 255, 255);
    textAlign(CENTER, CENTER);
    textFont(font, 14);
    text("Workers", 40, 18);
    textFont(font, 32);
    text(freeWorkers, 40, 40);
    
    popMatrix();
  }
}
