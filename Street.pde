class Street
{
  PVector originalPos;
  PVector pos;
  PVector dir;
  float v;
  float len;
  float branchThreshold=20;
  boolean intersect=false;
  boolean divided=false;
  Street sc1, sc2, parent;
  Brush brush;

  float size;

  Street(PVector p, PVector d, Street parent_, float s)
  {
    originalPos=p.copy();
    pos=p.copy();
    dir=d.copy();
    v=1.0;
    len=0;
    parent=parent_;
    size=s;
    brush=new Brush(pos.x, pos.y, dir, size*30);
  }

  void update()
  {
    if (intersect==false) {
      for (Street other : allStreets)
      {
        // pos.x+dir.x*2 确保当前延长线有可能和other线段相交
        if (other!=this&&other!=parent&&LineIntersect(originalPos.x, originalPos.y, pos.x+dir.x*2, pos.y+dir.y*2, other.originalPos.x, other.originalPos.y, other.pos.x, other.pos.y))
        {
          intersect=true;
        }
      }
      if (pos.x>width||pos.x<0||pos.y<0||pos.y>height)
      {
        intersect=true;
      }

      pos.add(dir.copy().mult(v));
      len=PVector.dist(pos, originalPos);
      brush.update(pos.x, pos.y);
    }

    if (divided) {
      sc1.update();
      sc2.update();
    }
  }

  void branch()
  {
    if (len>branchThreshold&&intersect&&divided==false) {
      float p1=random(0.05, 0.95);
      float p2=random(0.05, 0.95);
      PVector branchPos1=PVector.lerp(originalPos, pos, p1);
      PVector branchPos2=PVector.lerp(originalPos, pos, p2);
      PVector branchDir1=this.dir.copy().rotate(PI/2);
      PVector branchDir2=this.dir.copy().rotate(-PI/2);
      sc1=new Street(branchPos1, branchDir1, this, size*0.95);
      sc2=new Street(branchPos2, branchDir2, this, size*0.95);
      allStreets.add(sc1);
      allStreets.add(sc2);
      divided=true;
    }
    if (divided) {
      sc1.branch();
      sc2.branch();
    }
  }

  void render()
  {
    stroke(0);
    strokeWeight(size);
    point(pos.x, pos.y);
    brush.render();
    if (divided) {
      sc1.render();
      sc2.render();
    }
  }
}
