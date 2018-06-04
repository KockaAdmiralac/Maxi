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
 output = createWriter("simulacija.txt");
  noStroke();
}
 //<>//


void draw()
{
  noLoop();
  float tempX=0,tempY=0,tempZ=0,tempU=0;
  float dX,dY,dZ;
  float d0x,d0y,d1x,d1y,d2x,d2y;
  float min=99999999;
  float TempGreska;
  float biggestError=0;
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
       println("v1="+v1+" v2="+v2+" v3="+v3);
        errorDistanceX = random(-13.65,13.65)*(1/sqrt(v1))+random(-0.9885,0.9885);
        errorDistanceY = random(-15.65,15.65)*(1/sqrt(v2))+random(-1.495,1.495);
        errorDistanceZ = random(-1.4,1.4)*(1/sqrt(v3))+random(-1.347,1.347);
        dX=errorDistanceX+RealDistanceX;
        dY=errorDistanceY+RealDistanceY;
        dZ=errorDistanceZ+RealDistanceZ;
        min=999999999;
        for(int x=0;x<100;++x) {
          for(int y=0;y<100;++y) {
            d0x = (sensor[0].x - x);
            d0y = (sensor[0].y - y);
            d1x = (sensor[1].x - x);
            d1y = (sensor[1].y - y);
            d2x = (sensor[2].x - x);
            d2y = (sensor[2].y - y);
            tempX = sqrt(d0x*d0x+d0y*d0y);
            tempY = sqrt(d1x*d1x+d1y*d1y);
            tempZ = sqrt(d2x*d2x+d2y*d2y);
            tempU = abs(tempX - dX)+abs(tempY - dY) + abs(tempZ - dZ);
            if(tempU < min)
            {
             errorI=x;
             errorJ=y;
             min = tempU;
             
            }
          }
        }
        
      // errorJ=sqrt((((((RealDistanceZ-RealDistanceY)*(RealDistanceZ+RealDistanceY)+10000)/200)*(((RealDistanceZ-RealDistanceY)*(RealDistanceZ+RealDistanceY)+10000)/200))+(RealDistanceY*RealDistanceY)));
       //errorI=sqrt((((((RealDistanceX-RealDistanceY)*(RealDistanceX+RealDistanceY)+10000)/200)*(((RealDistanceX-RealDistanceY)*(RealDistanceX+RealDistanceY)+10000)/200))+(RealDistanceY*RealDistanceY)));
      
      
      
       //debug-----------------------------------
       
       fill(0,255,0);
       ellipse(i*7.2,j*7.2,5,5);
       
       fill(255,0,0);
       ellipse(errorI*7.2,errorJ*7.2,5,5);
       
       println("i="+i+" j="+j+" errorI="+errorI+" errorJ="+errorJ);
       println("RealDistanceX= "+RealDistanceX+" RealDistanceY="+RealDistanceY+" RealDistanceZ="+RealDistanceZ);
       println("errorDistanceX= "+errorDistanceZ+" errorDistanceY"+errorDistanceY+" errorDistanceZ="+errorDistanceZ);
       //debug ----------------------------------
       
       
       
           
       TempGreska=sqrt((i-errorI)*(i-errorI)+(j-errorJ)*(j-errorJ)); //<>//
       Zbir+=TempGreska;
     if(TempGreska>biggestError){biggestError=TempGreska;}
       output.print(TempGreska + " ");
       output.flush();
            
    }
    output.println();
 }
 output.println();
 output.print("BIGGEST ERROR="+biggestError+"cm");
 output.flush();
  double prosecnaGreska=Zbir/10000;
 output.println();
 output.print("Average ERROR="+prosecnaGreska+"cm");
 output.flush();
}
