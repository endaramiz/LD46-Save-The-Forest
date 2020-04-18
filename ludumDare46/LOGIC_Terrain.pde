final int TERRAIN_W = 200;
final int TERRAIN_H = 150;
final int TERRAIN_TILE_WH = 4;

/*
public class Fire {
 private Boolean isOnFire;
 private float fuel;
 
 public Fire() {
 isOnFire = false;
 }
 
 public void startFire(float fuel) {
 this.fuel = fuel;
 }
 
 public void update() {
 
 }
 }
 */

public class Terrain {
  static final float noiseScale = 0.02;
  static final int noiseOctaves = 8;
  static final float noiseFallOff = 0.5;

  private PGraphics backgr;
  private float[][] data;
  //private Boolean[][] isMountain;
  private Boolean[][] isOnFire;
  //private float hardness;


  public Terrain(int seed, float hardness) {
    //this.hardness = hardness;

    noiseSeed(seed);
    noiseDetail(noiseOctaves, noiseFallOff);
    backgr = createGraphics(width, height);
    data = new float[TERRAIN_H][TERRAIN_W];
    //isMountain = new Boolean[TERRAIN_H][TERRAIN_W];
    
    backgr.beginDraw();
    backgr.noStroke();
    for (int row = 0; row < TERRAIN_H; row++) {
      for (int col = 0; col < TERRAIN_W; col++) {
        float value = map(noise(col*noiseScale, row*noiseScale), 0.0f, perlinNoiseMax(noiseOctaves, noiseFallOff), 0.0f, 1.0f);
        
        int x = col*TERRAIN_TILE_WH;
        int y = row*TERRAIN_TILE_WH;
        backgr.colorMode(HSB, 360, 100, 100);
        backgr.fill(43, map(1-value, 0.0f, 1.0f, 16.0f, 100.0f ), 30);
        backgr.rect(x, y, TERRAIN_TILE_WH, TERRAIN_TILE_WH);
        
        println(value);
        /*
        isMountain[row][col] = value > hardness;
        if (isMountain[row][col]) {
          data[row][col] = map(value, hardness, 1.0f, 0.0f, 1.0f);
        } else {
          data[row][col] = map(min(0.5f, value), 0.0f, 0.5f, 0.0f, 1.0f);
        }
        */
        final float dy = (1-hardness);
        float new_v = max(0, (1-value)-dy);
        new_v = map(new_v, 0.0f, 1-dy, 0.0f, 1.0f);
        data[row][col] = new_v;
        /*
        if (random(1.0f)*1.5f > value) {
          data[row][col] = 1-value;//noise(col*noiseScale, row*noiseScale);
        }
        else {
          data[row][col] = 0;
        }
        */
        println(data[row][col]);
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

  public void display() {
    colorMode(HSB, 360, 100, 100);
    noStroke();
    
    image(backgr, 0, 0);
    
    for (int row = 0; row < TERRAIN_H; ++row) {
      for (int col = 0; col < TERRAIN_W; ++col) {
        int x = col*TERRAIN_TILE_WH;
        int y = row*TERRAIN_TILE_WH;
        /*
        if (isMountain[row][col]) {
          fill(43, map(1-data[row][col], 0.0f, 1.0f, 16.0f, 100.0f ), 30);
        } else {
          //fill(255,255,255);
          //fill(0, (1-data[row][col])*255, 0);
          if (isOnFire[row][col]) {
            fill(360, 100, map(data[row][col], 0.0f, 1.0f, 0, 100));
          } else {
            fill(79, 100, map(1-data[row][col], 0.0f, 1.0f, 20, 80)); //60 - 90
          }
        }
        */
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
  }

  private float perlinNoiseMax(int octaves, float fallOff) {
    float res = 0;
    float v = 0.5f;
    for (int i = 0; i < octaves; ++i) {
      res += v;
      v *= fallOff;
    }
    return res;
  }

  public void startFire(int row, int col) {
    isOnFire[row][col] = true;
  }

  public void propagateFire() {
    for (int r = 0; r < TERRAIN_H; ++r) {
      for (int c = 0; c < TERRAIN_W; ++c) {
        if (isOnFire[r][c]) {
          data[r][c] = max(0, data[r][c] - 0.02);
        }
      }
    }
    
    for (int r = 0; r < TERRAIN_H; ++r) {
      for (int c = 0; c < TERRAIN_W; ++c) {
        if (data[r][c] > 0.0001) {
          float fireAround = 0;

          int[] dr = {-1, -1, -1, 0, 0, 1, 1, 1};
          int[] dc = {-1, 0, 1, -1, 1, -1, 0, 1};
          for (int i = 0; i < 8; ++i) {
            int rs = r+dr[i];
            int cs = c+dc[i];
            if (rs >= 0 && rs < TERRAIN_H && cs >= 0 && cs < TERRAIN_W) {
              if (isOnFire[rs][cs]) {
                fireAround += data[rs][cs];
              }
            }
          }

          if (random(16) < fireAround) {
            isOnFire[r][c] = true;
          }
        }
      }
    }
  }
}
