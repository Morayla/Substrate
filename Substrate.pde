import processing.javafx.*;

float EPS=0.0001;
Street generator;
ArrayList<Street> allStreets;

int palMax = 256;
int palNum = 0;
color[] palette = new color[palMax];

void setup()
{
  size(500, 500,FX2D);
  pixelDensity(2);
  colorMode(RGB,255);
  fillPalette("monet.jpg");
  generator=new Street(new PVector(random(width), random(height)), PVector.random2D(), null,2);
  allStreets=new ArrayList<Street>();
  allStreets.add(generator);
  background(255);
  frameRate(60);
}

void draw()
{
  generator.update();
  generator.render();
  generator.branch();
  println(allStreets.size());
}

// 在palette中填充各不相同的颜色
void fillPalette(String fn) {
  PImage b;
  b = loadImage(fn);
  image(b,0,0,width,height);
  for (int x=0;x<width;x++){
    for (int y=0;y<height;y++) {
      color c = get(x,y);
      boolean exists = false;
      for (int n=0;n<palNum;n++) {
        if (c==palette[n]) {
          exists = true;
          break;
        }
      }
      if (!exists) {
        // add color to pal
        if (palNum<palMax) {
          palette[palNum] = c;
          palNum++;
        } else {
          break;
        }
      }
    }
  }
  
  // 调色板加入黑白的颜色来控制的颜色的饱和度
  // add white and black to palette to control saturation
  int saturationControl=6;
  if (palNum<palMax-saturationControl) {
    for (int i=0; i<saturationControl; i++) {
      palette[palNum]=#000000;
      palNum++;
      palette[palNum]=#FFFFFF;
      palNum++;
    }
  }
  println(palNum);
}

boolean LineIntersect(
  float x1, float y1,
  float x2, float y2,
  float x3, float y3,
  float x4, float y4
  )
{
  float mua, mub;
  float denom, numera, numerb;

  denom  = (y4-y3) * (x2-x1) - (x4-x3) * (y2-y1);
  numera = (x4-x3) * (y1-y3) - (y4-y3) * (x1-x3);
  numerb = (x2-x1) * (y1-y3) - (y2-y1) * (x1-x3);

  /* Are the line coincident? */
  if (abs(numera) < EPS && abs(numerb) < EPS && abs(denom) < EPS) {

    return true;
  }

  /* Are the line parallel */
  if (abs(denom) < EPS) {

    return false;
  }

  /* Is the intersection along the the segments */
  mua = numera / denom;
  mub = numerb / denom;
  if (mua < 0 || mua > 1 || mub < 0 || mub > 1) {

    return false;
  }

  return true;
}
