public class Wall{
  PVector start, end, s;

  public Wall(int x1, int y1, int x2, int y2){
    this.start = new PVector(x1, y1);
    this.end = new PVector(x2, y2);
    this.s = PVector.sub(end, start);
  }
  
  public void draw(){
    line(start.x, start.y, start.x + s.x, start.y + s.y);
  }
}
