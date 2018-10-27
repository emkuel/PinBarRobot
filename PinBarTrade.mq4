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

extern double Percentage_StopLoss = 2;
extern double Percentage_TakeProfit = 2;

extern double LotSize = 1.0;

extern double BodyPinBarPart = 25.0;
extern double MinSize = 50.0;
extern int MaxOpenPosition = 2;

double StopLoss;
double TakeProfit;
clsPinBar PinBar(BodyPinBarPart,MinSize,LotSize,MaxOpenPosition);
clsOrder Order();

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {     
  
  StopLoss = Order.GetValueFromPercetnage(Percentage_StopLoss,LotSize);
  if (Percentage_StopLoss==Percentage_TakeProfit)
      TakeProfit = StopLoss;
  else
      TakeProfit = Order.GetValueFromPercetnage(Percentage_TakeProfit,LotSize);
  
  PinBar.stoploss=StopLoss;
  PinBar.takeprofit=TakeProfit;
  
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
   if (PinBar.PinBarCandle())
   {
      if(PinBar.CheckOrderPinBar())
         PinBar.OpenOrder();
   }
     
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
