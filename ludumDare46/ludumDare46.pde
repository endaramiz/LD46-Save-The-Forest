Engine engine;

void setup() {
  //size(TERRAIN_W*TERRAIN_TILE_WH, TERRAIN_H*TERRAIN_TILE_WH); jaja LOL Can't be
  size(800, 600);
  engine = new Engine();
}


void draw() {
  engine.iterateLogic();
  engine.iterateDraw();
}
