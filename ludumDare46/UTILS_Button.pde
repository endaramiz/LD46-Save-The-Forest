public abstract class Button {
  public int x, y, w, h;
  
  public Button(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  public boolean isOver(int mx, int my) {
    if (mx < x) return false;
    if (mx > x+w) return false;
    if (my < y) return false;
    if (my > y+h) return false;
    return true;
  }
  
  public abstract void display(boolean selected);
}

public class TextButton extends Button {
  private String s;
  PFont font;
  int size;
  
  public TextButton(String s, int x, int y, int w, int h, PFont font, int size) {
    super(x, y, w, h);
    this.s = s;
    this.font = font;
    this.size = size;
  }
  
  public void display() {
    display(false);
  }
  
  public void display(boolean selected) {
    //fill(255,0,0);
    //rect(x, y, w, h);
    textFont(font);
    textAlign(CENTER, CENTER);
    if (selected) {
      textSize(size*1.4);
    }
    else {
      textSize(size);
    }
    //fill(255);
    text(s, x + w/2, y + h/2);
  }
}
