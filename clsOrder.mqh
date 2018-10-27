//+------------------------------------------------------------------+
//|                                                     clsOrder.mqh |
//|                                                      FutureRobot |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "FutureRobot"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class clsOrder
  {
private:

public:
                     double GetValueFromPercetnage(double Prct,double LotSize);
                     clsOrder();
                    ~clsOrder();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double clsOrder::GetValueFromPercetnage(double _Prct,double _lotsize)
{  
    double balance   = AccountBalance()/1000;
    //double tickvalue = MarketInfo(_Symbol, MODE_TICKVALUE);
    double lotsize   = MarketInfo(_Symbol, MODE_LOTSIZE);
    double spread    = MarketInfo(_Symbol, MODE_SPREAD);
    //double point     = MarketInfo(_Symbol, MODE_POINT);
    double ticksize  = MarketInfo(_Symbol, MODE_TICKSIZE);
    
    // fix for extremely rare occasion when a change in ticksize leads to a change in tickvalue
    //double reliable_tickvalue = tickvalue * point / ticksize;           
    
    double stopLossPips = MathFloor((_Prct/100) * (balance) / (_lotsize * lotsize * ticksize ) - spread);
    
    //double stopLossPips = _Prct * balance / (_lotsize * lotsize * reliable_tickvalue ) - spread;

   return (stopLossPips);
}

clsOrder::clsOrder()
  {
   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
clsOrder::~clsOrder()
  {
  }
//+------------------------------------------------------------------+
