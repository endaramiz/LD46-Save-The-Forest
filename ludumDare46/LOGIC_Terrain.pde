final int TERRAIN_W = 200;
final int TERRAIN_H = 130;
final int TERRAIN_TILE_WH = 4;


public class FireMan {
  private static final int MaxLife = 60*5;
  private static final int d = 4;
  public int row, col;
  public int life;
  
  public FireMan(int row, int col) {
    this.row = row;
    this.col = col;
    life = MaxLife;
  }
  
  public void update() {
    life -= 1;
  }
  
  public void display(float[][] m) {
    colorMode(RGB, 255, 255, 255, 1.0f);
    noStroke();
    
    for (int i = row-d; i <= row+d; ++i) {
      for (int j = col-d; j <= col+d; ++j) {
        if (dist(i, j, row, col) <= d &&
        i > 0 && i < m.length && j > 0 && j < m[i].length) {
          fill(0, 0, 255, 0.16f);
          rect(j*TERRAIN_TILE_WH, i*TERRAIN_TILE_WH, TERRAIN_TILE_WH, TERRAIN_TILE_WH);
        }
      }
    }
    
    fill(0, 0, map(life, 0, MaxLife, 0, 255));
    rect(col*TERRAIN_TILE_WH, row*TERRAIN_TILE_WH, TERRAIN_TILE_WH, TERRAIN_TILE_WH);
  }
  
  public Boolean isDead() {
   return life <= 0; 
  }
  
  public void protect(Boolean[][] m) {
    for (int i = row-d; i <= row+d; ++i) {
      for (int j = col-d; j <= col+d; ++j) {
        if (dist(i, j, row, col) <= d &&
        i > 0 && i < m.length && j > 0 && j < m[i].length) {
          m[i][j] = true;
        }
      }
    }
  }
}

public class Ranger {
  private static final int MaxLife = 60*3;
  private static final int d = 4;
  public int row, col;
  public int life;
  
  public Ranger(int row, int col) {
    this.row = row;
    this.col = col;
    life = MaxLife;
  }
  
  public void update() {
    life -= 1;
  }
  
  public void display(float[][] m) {
    colorMode(RGB, 255, 255, 255, 1.0f);
    /*
    for (int i = row-d; i <= row+d; ++i) {
      for (int j = col-d; j <= col+d; ++j) {
        if (dist(i, j, row, col) <= d &&
        i > 0 && i < m.length && j > 0 && j < m[i].length) {
          fill(255, 255, 0, 0.2f);
          rect(j*TERRAIN_TILE_WH, i*TERRAIN_TILE_WH, TERRAIN_TILE_WH, TERRAIN_TILE_WH);
        }
      }
    }
    */
    
    noStroke();
    //fill(map(life, 0, MaxLife, 192, 255), map(life, 0, MaxLife, 192, 255), 0);
    fill(255, 255, 0);
    rect(col*TERRAIN_TILE_WH, row*TERRAIN_TILE_WH, TERRAIN_TILE_WH, TERRAIN_TILE_WH);
  }
  
  public Boolean isDead() {
   return life <= 0; 
  }
  
  public void cleanForest(float[][] m) {
    //println("CleanForest:");
    for (int i = row-d; i <= row+d; ++i) {
      for (int j = col-d; j <= col+d; ++j) {
        //if (abs(i-row) + abs(j-col) <=  d &&
        if (dist(i, j, row, col) <= d &&
        i > 0 && i < m.length && j > 0 && j < m[i].length) {
          //if (i == row-d && j == col-d) println("Life "+life+": "+m[i][j]+"-"+0.1f/(float)MaxLife);
          m[i][j] = max(0.0f, m[i][j]-(0.6f/(float)MaxLife));
        }
      }
    }
  }
}

public class Terrain {
  static final float noiseScale1 = 0.02;
  static final float noiseScale2 = 0.1;
  static final int noiseOctaves = 8;
  static final float noiseFallOff = 0.5;

  private PGraphics backgr;
  private float[][] data;
  //private Boolean[][] isMountain;
  private Boolean[][] isOnFire;
  //private float hardness;
  private float levelWater;

  private Vector<FireMan> firemans;
  private Boolean[][] protectedZone;
  private Vector<Ranger> rangers;

  public Terrain(int seed, float hardness) {
    //this.hardness = hardness;
    levelWater = 1.0f-hardness;
    firemans = new Vector();
    protectedZone = new Boolean[TERRAIN_H][TERRAIN_W];
    rangers = new Vector();
    
    noiseSeed(seed);
    noiseDetail(noiseOctaves, noiseFallOff);
    backgr = createGraphics(width, height);
    data = new float[TERRAIN_H][TERRAIN_W];
    //isMountain = new Boolean[TERRAIN_H][TERRAIN_W];
    
    float[][] values = new float[TERRAIN_H][TERRAIN_W];
    for (int row = 0; row < TERRAIN_H; row++) {
      for (int col = 0; col < TERRAIN_W; col++) {
        //float value = map(noise(col*noiseScale1, row*noiseScale1), 0.0f, perlinNoiseMax(noiseOctaves, noiseFallOff), 0.0f, 1.0f);
        final float factorRnd = 0.3f;
        float value  = noise(col*noiseScale1, row*noiseScale1)*(1-factorRnd);
              value += noise(col*noiseScale2, row*noiseScale2)*factorRnd;
        values[row][col] = value;
      }
    }
    values = normalizeMatrix(values);
    
    backgr.beginDraw();
    backgr.noStroke();
    for (int row = 0; row < TERRAIN_H; row++) {
      for (int col = 0; col < TERRAIN_W; col++) {
        float value = values[row][col];
        int x = col*TERRAIN_TILE_WH;
        int y = row*TERRAIN_TILE_WH;
        backgr.colorMode(HSB, 360, 100, 100);
        if (value > levelWater) { // forest
          //backgr.fill(43, map(value, levelWater, 1.0f, 100.0f, 16.0f), 30);
          backgr.fill(32, 100, map(value, levelWater, 1.0f, 80, 30));
        }
        else { // water
          backgr.fill(210, 100, map(value, 0.0f, levelWater, 40.0f, 95.0f));
        }
        backgr.rect(x, y, TERRAIN_TILE_WH, TERRAIN_TILE_WH);
        
        //println(value);
        final float dy = levelWater;
        float new_v = max(0, value-dy);
        new_v = map(new_v, 0.0f, 1-dy, 0.0f, 1.0f);
        data[row][col] = new_v;
        if (random(0, 0.2) > data[row][col]) {
          data[row][col] = 0;
        }
        //println(data[row][col]);
      }
      println();
    }
    backgr.endDraw();

    isOnFire = new Boolean[TERRAIN_H][TERRAIN_W];
    for (int row = 0; row < TERRAIN_H; row++) {
      for (int col = 0; col < TERRAIN_W; col++) {
        isOnFire[row][col] = false;
      }
    }
  }

  public void update() {
    // Update FireMans
    for (int i = 0; i < firemans.size(); ++i) {
      firemans.get(i).update();
    }
    // Delete FireMans
    Vector<FireMan> firemansToDelete = new Vector<FireMan>();
    for (int i = 0; i < firemans.size(); ++i) {
      FireMan fireman = firemans.get(i);
      if (fireman.isDead()) {
        firemansToDelete.add(fireman);
      }
    }
    for (int i = 0; i < firemansToDelete.size(); ++i) {
      firemans.remove(firemansToDelete.get(i));
    }
    // Update Protected Zone
    for (int i = 0; i < protectedZone.length; ++i) {
      for (int j = 0; j < protectedZone[i].length; ++j) {
        protectedZone[i][j] = false;
      }
    }
    for (int i = 0; i < firemans.size(); ++i) {
      firemans.get(i).protect(protectedZone);
    }
    
    // Update Rangers
    for (int i = 0; i < rangers.size(); ++i) {
      rangers.get(i).update();
    }
    
    // Delete Rangers
    Vector<Ranger> forestrangersToDelete = new Vector<Ranger>();
    for (int i = 0; i < rangers.size(); ++i) {
      Ranger forestranger = rangers.get(i);
      if (forestranger.isDead()) {
        forestrangersToDelete.add(forestranger);
      }
    }
    for (int i = 0; i < forestrangersToDelete.size(); ++i) {
      rangers.remove(forestrangersToDelete.get(i));
    }
    
    // clean forest
    for (int i = 0; i < rangers.size(); ++i) {
      rangers.get(i).cleanForest(data);
    }
    
    propagateFire();
  }
  
  public void display() {
    colorMode(HSB, 360, 100, 100);
    noStroke();
    
    image(backgr, 0, 0);
    
    for (int row = 0; row < TERRAIN_H; ++row) {
      for (int col = 0; col < TERRAIN_W; ++col) {
        int x = col*TERRAIN_TILE_WH;
        int y = row*TERRAIN_TILE_WH;
        if (data[row][col] > 0.0001) {
          if (isOnFire[row][col]) {
            fill(360, 100, map(data[row][col], 0.0f, 1.0f, 0, 100));
          } else {
            fill(79, 100, map(1-data[row][col], 0.0f, 1.0f, 20, 80)); //60 - 90
          }
          rect(x, y, TERRAIN_TILE_WH, TERRAIN_TILE_WH);
        }
      }
    }
    
    for (int i = 0; i < firemans.size(); ++i) {
      firemans.get(i).display(data);
    }
    
    for (int i = 0; i < rangers.size(); ++i) {
      rangers.get(i).display(data);
    }
  }

  public void startFire(int row, int col) {
    isOnFire[row][col] = true;
  }

  private void propagateFire() {
    for (int r = 0; r < TERRAIN_H; ++r) {
      for (int c = 0; c < TERRAIN_W; ++c) {
        if (isOnFire[r][c]) {
          data[r][c] -= 1/60.0/8.0;
          if (data[r][c] < 0) {
            data[r][c] = 0;
            isOnFire[r][c] = false;
          }
        }
      }
    }
    
    for (int r = 0; r < TERRAIN_H; ++r) {
      for (int c = 0; c < TERRAIN_W; ++c) {
        if (data[r][c] > 0.0001 && !protectedZone[r][c]) {
          float fireAround = 0;

          int[] dr = {-1, -1, -1, 0, 0, 1, 1, 1};
          int[] dc = {-1, 0, 1, -1, 1, -1, 0, 1};
          for (int i = 0; i < 8; ++i) {
            int rs = r+dr[i];
            int cs = c+dc[i];
            if (rs >= 0 && rs < TERRAIN_H && cs >= 0 && cs < TERRAIN_W) {
              if (isOnFire[rs][cs]) {
                fireAround += 0.7 + data[rs][cs]*0.3;
              }
            }
          }

          if (random(200) < fireAround) {
            isOnFire[r][c] = true;
          }
        }
      }
    }
  }
  
  public void addFireMan(int row, int col) {
    firemans.add(new FireMan(row, col));
  }
  
  public void addRanger(int row, int col) {
    rangers.add(new Ranger(row, col));
  }
  
  public int getWorkers() {
    return firemans.size() + rangers.size();
  }
  
  private float[][] normalizeMatrix(float[][] values) {
    float minV=999999;
    float maxV=-99999;
    
    for (int i = 0; i < values.length; ++i) {
      for (int j = 0; j < values[i].length; ++j) {
        minV = min(minV, values[i][j]);
        maxV = max(maxV, values[i][j]);
      }
    }
    
    float[][] newValues = values.clone();
    for (int i = 0; i < values.length; ++i) {
      for (int j = 0; j < values[i].length; ++j) {
        newValues[i][j] = map(values[i][j], minV, maxV, 0.0f, 1.0f);
      }
    }
    return newValues;
  }
}
