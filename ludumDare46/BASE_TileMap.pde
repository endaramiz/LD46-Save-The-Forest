class TileMapLayer {
  public String name;
  public int[][] data;
}

class TileMapSet {
  public String name;
  public int firstID, tileCount;
  public int imageW, imageH;
  public int rows, cols;
  public String imagePath;
}

class TileMap {
  private int rows, cols;
  private int tileW, tileH;
  private Map<String, TileMapLayer> layers;
  private Map<String, TileMapSet> tilesets;

  private Map<Integer, PImage> tiles;

  public TileMap(String path) {
    JSONObject file = loadJSONObject(path);
    rows = file.getInt("width");
    cols = file.getInt("height");
    tileW = file.getInt("tilewidth");
    tileH = file.getInt("tileheight");

    layers = new HashMap();
    JSONArray fileLayers = file.getJSONArray("layers");
    for (int li = 0; li < fileLayers.size(); ++li) {
      JSONObject fileLayer = fileLayers.getJSONObject(li);
      TileMapLayer layer = new TileMapLayer();
      layer.name = fileLayer.getString("name");
      layer.data = new int[rows][cols];
      JSONArray fileLayerData = fileLayer.getJSONArray("data");
      for (int di = 0; di < fileLayerData.size(); ++di) {
        layer.data[di/cols][di%cols] = fileLayerData.getInt(di);
      }
      layers.put(layer.name, layer);
    }

    tilesets = new HashMap();
    JSONArray fileTilesets = file.getJSONArray("tilesets");
    for (int i = 0; i < fileTilesets.size(); ++i) {
      JSONObject fileTileset = fileTilesets.getJSONObject(i);
      TileMapSet tileset = new TileMapSet();

      tileset.name = fileTileset.getString("name");
      tileset.firstID = fileTileset.getInt("firstgid");
      tileset.tileCount = fileTileset.getInt("tilecount");
      tileset.imageW = fileTileset.getInt("imagewidth");
      tileset.imageH = fileTileset.getInt("imageheight");
      tileset.cols = fileTileset.getInt("columns");
      tileset.rows = tileset.tileCount/cols;
      if (tileset.tileCount%cols > 0) ++tileset.rows;
      tileset.imagePath = fileTileset.getString("image");
      
      tilesets.put(tileset.name, tileset);
    }
    
    tiles = new HashMap();
    for (TileMapSet tileset : tilesets.values()) {
      PImage tilesetImg = loadImage("maps/"+tileset.imagePath);
      for (int n = 0; n < tileset.tileCount; ++n) { //<>//
        int id = tileset.firstID + n;
        int i = n/tileset.cols;
        int j = n%tileset.cols;
        int x = j*tileW;
        int y = i*tileH;
        PImage tile = createImage(tileW, tileH, ARGB); 
        tile.copy(tilesetImg, x, y, tileW, tileH, 0, 0, tileW, tileH);
        tiles.put(id, tile);
      }
    }
  }

  public void display(float x, float y) {
    pushMatrix();
    translate(x, y);
    TileMapLayer terrain = layers.get("Terrain0");
    for (int i = 0; i < rows; ++i) {
      for (int j = 0; j < cols; ++j) {
        int tileID = terrain.data[i][j];
        image(tiles.get(tileID), j*tileW, i*tileH);
      }
    }
    popMatrix();
  }
}
