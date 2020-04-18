final int TERRAIN_W = 200;
final int TERRAIN_H = 150;
final int TERRAIN_TILE_WH = 4;

public class Terrain {
  static final float noiseScale = 0.02;
  static final int noiseOctaves = 3;
  static final float noiseFallOff = 0.2;
  
  private float[][] data;
  private Boolean[][] isMountain;
  private float hardness;
  
  
  public Terrain(int seed, float hardness) {
    this.hardness = hardness;
    
    noiseSeed(seed);
    noiseDetail(noiseOctaves, noiseFallOff);
    data = new float[TERRAIN_H][TERRAIN_W];
    isMountain = new Boolean[TERRAIN_H][TERRAIN_W];
    for (int row = 0; row < TERRAIN_H; row++) {
      for (int col = 0; col < TERRAIN_W; col++) {
        float value = map(noise(col*noiseScale, row*noiseScale), 0.0f, perlinNoiseMax(noiseOctaves, noiseFallOff), 0.0f, 1.0f);
        println(value);
        isMountain[row][col] = value > hardness;
        if (isMountain[row][col]) {
          data[row][col] = map(value, hardness, 1.0f, 0.0f, 1.0f);
        }
        else {
          data[row][col] = map(min(0.5f, value), 0.0f, 0.5f, 0.0f, 1.0f);
        }
        //data[row][col] = noise(col*noiseScale, row*noiseScale);
      }
      println();
    }
  }
  
  public void display() {
    for (int row = 0; row < TERRAIN_H; ++row) {
      for (int col = 0; col < TERRAIN_W; ++col) {
        int x = col*TERRAIN_TILE_WH;
        int y = row*TERRAIN_TILE_WH;
        if (isMountain[row][col]) {
          fill((1-data[row][col])*255, 0, 0);
        }
        else {
          //fill(255,255,255);
          fill(0, (1-data[row][col])*255, 0);
        }
        noStroke();
        rect(x, y, TERRAIN_TILE_WH, TERRAIN_TILE_WH);
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
}
