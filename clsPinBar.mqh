//+------------------------------------------------------------------+
//|                                                    clsPinBar.mqh |
//|                                                      FutureRobot |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "FutureRobot"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

class clsPinBar
  {
private:       
                     int maxOpenPosition;
                     double bodycandle; 
                     double minSize;
                     double lotsize;
                     int order;
                     bool OpenPositionOnNewPinBar;
                     int magicnumber;
                     double arrayBar[1][7];
                     int CandleNumber;
                     bool CreateArray;
                     
                     bool CheckOrderPinBar();                     
                     void CheckArrayBar();
                     void CreateArrayBar();
                     double GetPairs(string sSymbol);
                     double GetPairOrder();
                                          
public:                                   
                     double stoploss;
                     double takeprofit;  
                     bool PinBarInitBar();                    
                     bool PinBarCandle();                     
                     void OpenOrder();
                     
                     clsPinBar(double _bodycandle,double _minsize, double _lotsize, int _maxopenposition,
                              bool _OpenPositionOnNewPinBar, int _CandleNumber);
                     ~clsPinBar();

};

bool clsPinBar::PinBarInitBar()
{
   CheckArrayBar();
   CreateArrayBar();
   
   if(!OpenPositionOnNewPinBar)
      if (CheckOrderPinBar())
            return(true);
      else
            return(false);
   else
      if (arrayBar[0][6] < arrayBar[0][5]
         && arrayBar[0][4] == GetPairs(_Symbol))
            return(true);
      else
            return(false);
}
bool clsPinBar::PinBarCandle()
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
            Print("DOWN2");
            return(true);
    }
    
    return (false);
}

void clsPinBar::OpenOrder()
{     
   if (arrayBar[0][6] < maxOpenPosition)
   {  
      if (order == 1)
      {                      
         if(OrderSend(Symbol(),order,lotsize,Bid,3,Bid+(stoploss*Point),Bid - (takeprofit* Point),NULL,0+magicnumber,0,clrGreen))         
            {
               magicnumber+=1;
               arrayBar[0][6]+=1;                        
               Print("Short transaction opened");
            }     
         else
            Print("Cannot open short transaction.");
      }
      else if (order == 0)
      {         
         if(OrderSend(Symbol(),order,lotsize,Ask,3,Ask - (stoploss * Point),Ask + (takeprofit * Point),NULL,0+magicnumber,0,clrGreen))
            {
               magicnumber+=1;
               arrayBar[0][6]+=1; 
               Print("Long transaction opened");
            }
         else
            Print("Cannot open long transaction.");      
      }
   }
             
}

bool clsPinBar::CheckOrderPinBar()  
{  
   double OrderPair = GetPairOrder();
   
   if (OrderPair != arrayBar[0][5]
      && arrayBar[0][4]==GetPairs(_Symbol))
         arrayBar[0][6] = OrderPair;    
 
   if (arrayBar[0][6] < arrayBar[0][5]
      && arrayBar[0][4]==GetPairs(_Symbol)) 
         return(true);
   else
         return(false);
}
void clsPinBar::CheckArrayBar()
{
   if (Open[CandleNumber] != arrayBar[0][0] 
      && Close[CandleNumber] != arrayBar[0][1]
      && High[CandleNumber] != arrayBar[0][2]
      && Low[CandleNumber] != arrayBar[0][3])         
         CreateArray=false;
      
}
void clsPinBar::CreateArrayBar()
{
   if (!CreateArray)
   {      
      arrayBar[0][0]=Open[CandleNumber];  //Open
      arrayBar[0][1]=Close[CandleNumber]; //Close
      arrayBar[0][2]=High[CandleNumber];  //High
      arrayBar[0][3]=Low[CandleNumber];   //Low
      arrayBar[0][4]=GetPairs(_Symbol);   //Pairs
      arrayBar[0][5]=maxOpenPosition;     //Max Open Positions
      arrayBar[0][6]=0;                   //Opened Positions
      CreateArray=true;                
   }
   
}
double clsPinBar::GetPairs(string sSymbol)
{
   if (sSymbol == "EURUSD")
      return (0);
   else if (sSymbol == "USDJPY")
      return (1);
   else return(-1);
}
double clsPinBar::GetPairOrder()
{
  double TotalOrder=0;
  for (int i=OrdersTotal()-1; i >= 0 ;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(GetPairs(OrderSymbol())==arrayBar[0][4])
             TotalOrder+=1;
   }
   
   return (TotalOrder);
 }

clsPinBar::clsPinBar(double _bodycandle,double _minsize, double _lotsize, int _maxopenposition, 
                     bool _OpenPositionOnNewPinBar, int _CandleNumber)
  {
         lotsize =_lotsize;
         bodycandle=_bodycandle *.01;
         minSize=_minsize;
         maxOpenPosition = _maxopenposition;
         magicnumber=1;
         OpenPositionOnNewPinBar=_OpenPositionOnNewPinBar;
         CandleNumber=_CandleNumber;
         //ArrayResize(arrPosition,_maxopenposition);
         CreateArray=false;
         order = -1;
  }


clsPinBar::~clsPinBar()
  {
  }
  
