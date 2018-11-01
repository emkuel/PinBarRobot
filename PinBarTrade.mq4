//+------------------------------------------------------------------+
//|                                                  PinBarTrade.mq4 |
//|                                                      FutureRobot |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "FutureRobot"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <clsPinBar.mqh>
#include <clsOrder.mqh>

enum Profit
{   
   Pips=0,
   Percentage=1
};

extern Profit StopLossMode;
extern double StopLoss = 150;
extern Profit TakeProfitMode;
extern double TakeProfit = 200;
input double LotSize = 1.0;

extern bool OpenPositionOnNewPinBar=false;
extern int MaxOpenPosition = 2;

input int CandleNumber =1;
extern double BodyPinBarPart = 40.0;
extern double MinSize = 50.0;

double _StopLoss;
double _TakeProfit;
clsPinBar PinBar(BodyPinBarPart,MinSize,LotSize,MaxOpenPosition,OpenPositionOnNewPinBar,CandleNumber);
clsOrder Order();

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {     
  
  _StopLoss = Order.GetValueFromPercetnage(StopLoss,LotSize,StopLossMode);
  _TakeProfit = Order.GetValueFromPercetnage(TakeProfit,LotSize,TakeProfitMode);
  
  PinBar.stoploss=_StopLoss;
  PinBar.takeprofit=_TakeProfit;
  
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if (PinBar.PinBarInitBar())
      if (PinBar.PinBarCandle())   
         PinBar.OpenOrder();
     
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
