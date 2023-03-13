class Brush {
  //current position
  float x, y;
  //brushing direction
  PVector dir;
  //amplitude of brush
  float brushWidth;
  //brush color
  color strokeColor;
  //theta variable that controls the changeing width of brush
  float theta;
  float maxtheta;

  Brush(float x_, float y_, PVector dir_,float bw_) {
    x = x_;
    y = y_;
    dir=dir_;
    brushWidth = bw_;
    strokeColor = palette[int(random(palNum))];
    theta = random(0.01, 0.1);
    maxtheta = 0.3;
  }

  void update(float currentX,float currentY)
  {
    x=currentX;
    y=currentY;
  }
  
  void render() {
    theta+=random(-0.042, 0.042);
    theta=constrain(theta, -maxtheta, maxtheta);
    if (abs(theta)<0.01) {
      if (random(10000)>9900) strokeColor = palette[int(random(palNum))];
    }

    // 涂抹在当前点
    stroke(strokeColor, 22);
    point(x, y);

    // 涂抹在当前点垂直于涂抹方向dir的上下
    // number of brushing points below and above brush position
    float scatterNum = 100;
    for (int i=0; i<scatterNum; i++) {
      // 离笔刷中心越近，浓度越高，反之越低，线形衰减
      float alpha = 255*0.1*(1-i/scatterNum);
      stroke(strokeColor, alpha);
      // 确保上下对称
      //point(x, y + brushWidth*sin(i*theta*0.005));
      //point(x, y - brushWidth*sin(i*theta*0.005));
      float p=sin(i*theta*0.005);
      point(x+brushWidth*dir.y*p, y - brushWidth*dir.x*p);
      point(x-brushWidth*dir.y*p, y + brushWidth*dir.x*p);
    }
  }
}
