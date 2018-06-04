final PVector pos = new PVector(0,0);
float v1,v2,v3;
final PVector[] sensor = new PVector[] {
  new PVector(0,100),
  new PVector(0,0),
  new PVector(100,0)
};
float RealDistanceX;
double Zbir;
float RealDistanceY;
float RealDistanceZ;
float errorDistanceX;
float errorDistanceY;
float errorDistanceZ;
float errorI;
float errorJ;
PrintWriter output;

void setup()
{
 size(720,720);
 output = createWriter("simulacija2.txt");
  noStroke();
}  



void draw()
{
noLoop();

 for(int i=0;i<100;i++)
 {
    for(int j=0;j<100;j++)
    {
      println("===========================================================================");
        RealDistanceX=sqrt((sensor[0].x-i)*(sensor[0].x-i)+(sensor[0].y-j)*(sensor[0].y-j));
        RealDistanceY=sqrt((sensor[1].x-i)*(sensor[1].x-i)+(sensor[1].y-j)*(sensor[1].y-j));
        RealDistanceZ=sqrt((sensor[2].x-i)*(sensor[2].x-i)+(sensor[2].y-j)*(sensor[2].y-j));
        
        v3 = (2356.7/(RealDistanceZ+66.535))*(2356.7/(RealDistanceZ+66.535));
        v2 = (1603.3/(RealDistanceY+43.249))*(1603.3/(RealDistanceY+43.249));   
        v1 = (1956.9/(RealDistanceX+57.712))*(1956.9/(RealDistanceX+57.712));
    }
 }
}
