//+------------------------------------------------------------------+
//|                                                    clsPinBar.mq4 |
//|                                                      FutureRobot |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property library
#property copyright "FutureRobot"
#property link      "https://www.mql5.com"
#property version   "1.00"
//#property strict
    
int maxOpenPosition;
double bodycandle; 
double minSize;
double lotsize;
int order;
bool OpenPositionOnNewPinBar;
int magicnumber; 
double arrayBar[1][6];
string arraySymbol[1];
int CandleNumber;
double CandlePrice;
                                          
double GetPrice(){return(CandlePrice);};                     
int GetOpenedOrder(){return((int)arrayBar[0][5]);};
int GetMagicNumber(){return(magicnumber);};
int GetOrder(){return(order);};

bool PinBarInitBar()
{
   CreateArrayBar();
   
   if(!OpenPositionOnNewPinBar)
      if (CheckOrderPinBar())
            return(true);
      else
            return(false);
   else
      if (arrayBar[0][5] < arrayBar[0][4]
         && arraySymbol[0] ==_Symbol)
            return(true);
      else
            return(false);
}

bool PinBarCandle()
{  
   
   double total = arrayBar[0][2]-arrayBar[0][3];
   double body=MathAbs(arrayBar[0][0]-arrayBar[0][1]);
  
   double maxSize = total*bodycandle;
  
     if (body<maxSize && total >minSize*Point
         && arrayBar[0][2]-arrayBar[0][0]<maxSize
         && arrayBar[0][3]<Low[CandleNumber+1]
         && arrayBar[0][3]<Low[CandleNumber+2])
     {
            order=0;
            CandlePrice = Low[CandleNumber];
            Print("UP1");
            return(true);
     }
     
     else if (body<maxSize && total >minSize*Point
         && arrayBar[0][0]>arrayBar[0][1]
         && arrayBar[0][2]-arrayBar[0][1]<maxSize
         && arrayBar[0][3]>Low[CandleNumber+1]
         && arrayBar[0][3]>Low[CandleNumber+2])      
     {
            order=0;
            CandlePrice = Low[CandleNumber];
            Print("UP2");
            return(true);
     }
     
     else if (body<maxSize &&  total >minSize*Point
         && arrayBar[0][0]>arrayBar[0][1]
         && arrayBar[0][0]-arrayBar[0][3]<maxSize
         && arrayBar[0][2]>High[CandleNumber+1]
         && arrayBar[0][2]>High[CandleNumber+2])
     {
            order=1;
            CandlePrice = High[CandleNumber];
            Print("DOWN1");
            return(true);
     }
     
     else if (body<maxSize &&  total >minSize*Point
         && arrayBar[0][0]<arrayBar[0][1]
         && arrayBar[0][1]-arrayBar[0][3]<maxSize
         && arrayBar[0][2]>High[CandleNumber+1]
         && arrayBar[0][2]>High[CandleNumber+2])
    {
            order=1;
            CandlePrice = High[CandleNumber];
            Print("DOWN2");
            return(true);
    }
    
    return (false);
}

bool CheckOrderPinBar()  
{  
   double OrderPair = GetPairOrder();
   
   if (OrderPair != arrayBar[0][4]
      && arraySymbol[0]==_Symbol)
         arrayBar[0][5] = OrderPair;    
 
   if (arrayBar[0][5] < arrayBar[0][4]
      && arraySymbol[0]==_Symbol) 
         return(true);
   else
         return(false);
}

void CreateArrayBar()
{
      arrayBar[0][0]=Open[CandleNumber];  //Open
      arrayBar[0][1]=Close[CandleNumber]; //Close
      arrayBar[0][2]=High[CandleNumber];  //High
      arrayBar[0][3]=Low[CandleNumber];   //Low
      arrayBar[0][4]=maxOpenPosition;     //Max Open Positions
      arrayBar[0][5]=0;                   //Opened Positions   
      arraySymbol[0]=_Symbol;             //Pairs
}

double GetPairs(string sSymbol)
{
   if (sSymbol == "EURUSD")
      return (0);
   else if (sSymbol == "USDJPY")
      return (1);
   else return(-1);
}
double GetPairOrder()
{
  double TotalOrder=0;
  for (int i=OrdersTotal()-1; i >= 0 ;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==arraySymbol[0])
             TotalOrder+=1;
   }
   
   return (TotalOrder);
 }

void initPinBarClass(double _bodycandle,double _minsize, int _maxopenposition, 
                     bool _OpenPositionOnNewPinBar, int _CandleNumber)
  {         
         bodycandle=_bodycandle *.01;
         minSize=_minsize;
         maxOpenPosition = _maxopenposition;
         magicnumber=1;
         OpenPositionOnNewPinBar=_OpenPositionOnNewPinBar;
         CandleNumber=_CandleNumber;
         //ArrayResize(arrPosition,_maxopenposition);
         order = -1;
         CandlePrice=-1;
  }
