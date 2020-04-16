Engine engine;

void setup() {
  size(800, 600);
  engine = new Engine();
}


void draw() {
  engine.iterateLogic();
  engine.iterateDraw();
}
