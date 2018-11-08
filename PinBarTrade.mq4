//+------------------------------------------------------------------+
//|                                                  PinBarTrade.mq4 |
//|                                                      FutureRobot |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "FutureRobot"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#import "clsPinBar.ex4"
   void initPinBarClass(double _bodycandle,double _minsize , int _maxopenposition,
                              bool _OpenPositionOnNewPinBar, int _CandleNumber);
   bool PinBarInitBar();                    
   bool PinBarCandle();    
   double GetPrice();                    
   int GetOpenedOrder();
   int GetMagicNumber();
   int GetOrder();  
#import "clsOrder.ex4"
   double GetValueFromPercentage(double _Value,double _lotsize,int Mode);
   int OpenOrder(int OpenedOrder, int maxOpenPosition, int order,double lotsize, 
            double stoploss,double takeprofit, int magicnumber);
#import "clsCandle.ex4"
   bool CheckCurrentCandle();
#import

enum Profit
{   
   Pips=0,
   Percentage=1,
   OverPinBar=2
};


extern Profit StopLossMode;
extern double StopLoss = 150;
extern Profit TakeProfitMode;
extern double TakeProfit = 200;
extern double LotSize = 1.0;

extern bool OpenPositionOnNewPinBar=false;
extern int MaxOpenPosition = 2;

input int CandleNumber =1;
extern double BodyPinBarPart = 40.0;
extern double MinSize = 50.0;

int OnInit()
  {
  initPinBarClass(BodyPinBarPart,MinSize,MaxOpenPosition,OpenPositionOnNewPinBar,CandleNumber);
  
  Comment("Account Balance: " + (string)AccountBalance());
  StopLoss = GetValueFromPercentage(StopLoss,LotSize,StopLossMode);
  TakeProfit = GetValueFromPercentage(TakeProfit,LotSize,TakeProfitMode);
 
   return(INIT_SUCCEEDED);
  }
void OnDeinit(const int reason)
  {
  }
void OnTick()
  {   
    if(CheckCurrentCandle())
      if (PinBarInitBar())
          if (PinBarCandle())
               OpenOrder(GetOpenedOrder(),MaxOpenPosition,GetOrder(),LotSize,
                            StopLoss,TakeProfit,GetMagicNumber());
                                 
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+
