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
                     int Opened;
                     int magicnumber;
                     
public:              
                     
                     double stoploss;
                     double takeprofit;  
                     bool CheckOrderPinBar();
                     bool PinBarCandle();
                     void OpenOrder();
                     clsPinBar(double _bodycandle,double _minsize, double _lotsize, int _maxopenposition);
                     ~clsPinBar();

};
bool clsPinBar::PinBarCandle()
{
   
   double total = High[1]-Low[1];
   double body=MathAbs(Open[1]-Close[1]);
  
   double maxSize = total*bodycandle;
  
     if (body<maxSize && total >minSize*Point
         && High[1]-Open[1]<maxSize
         && Low[1]<Low[2]
         && Low[1]<Low[3])
     {
            order=0;
            Print("UP1");
            return(true);
     }
     
     else if (body<maxSize &&  total >minSize*Point
         && Open[1]>Close[1]
         && High[1]-Close[1]<maxSize
         && Low[1]>Low[2]
         && Low[1]>Low[3])      
     {
            order=0;
            Print("UP2");
            return(true);
     }
     
     else if (body<maxSize &&  total >minSize*Point
         && Open[1]>Close[1]
         && Open[1]-Low[1]<maxSize
         && High[1]>High[2]
         && High[1]>High[3])
     {
            order=1;
            Print("DOWN1");
            return(true);
     }
     
     else if (body<maxSize &&  total >minSize*Point
         && Open[1]<Close[1]
         && Close[1]-Low[1]<maxSize
         && High[1]>High[1]
         && High[1]>High[2])
    {
            order=1;
            Print("DOWN2");
            return(true);
    }
    return (false);
}

void clsPinBar::OpenOrder()
{
   
   Print("Szukam pozycji...");
   
   if (Opened < maxOpenPosition)
   {
      Print("Jest miejsce...");
      if (order == 1)
      {                      
         if(OrderSend(Symbol(),order,lotsize,Bid,3,Bid+(stoploss*Point),Bid - (takeprofit* Point),NULL,0+magicnumber,0,clrGreen))         
            {
               magicnumber+=1;
               Opened+=1;                        
               Print("Otwarta pozycja short.");
            }     
         else
            Print("Cannot open short transaction.");
      }
      else if (order == 0)
      {         
         if(OrderSend(Symbol(),order,lotsize,Ask,3,Ask - (stoploss * Point),Ask + (takeprofit * Point),NULL,0+magicnumber,0,clrGreen))
            {
               magicnumber+=1;
               Opened+=1; 
               Print("Otwarta pozycja long.");
            }
         else
            Print("Cannot open long transaction.");      
      }
   }          
}

bool clsPinBar::CheckOrderPinBar()  
{  
   
   if (OrdersTotal()!= maxOpenPosition)
      Opened = OrdersTotal();    
   
   if (Opened < maxOpenPosition) 
      return(true);
   else
      return(false);
}
clsPinBar::clsPinBar(double _bodycandle,double _minsize, double _lotsize, int _maxopenposition)
  {
         lotsize =_lotsize;
         bodycandle=_bodycandle *.01;
         minSize=_minsize;
         maxOpenPosition = _maxopenposition;
         magicnumber=1;
         //ArrayResize(arrPosition,_maxopenposition);
         
         order = -1;
  }


clsPinBar::~clsPinBar()
  {
  }
  
