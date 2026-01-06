//+------------------------------------------------------------------+
//|                                      BPA_Position_Manager.mq5   |
//|                        Copyright 2026, Malcom T Musonza                 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Malcom T Musonza"
#property version   "1.00"
#property description "Automated Execution EA with Buy/Sell Stop Orders and Autopilot"
#property strict

#include <Trade/Trade.mqh>
#include <Trade/PositionInfo.mqh>
#include <Trade/OrderInfo.mqh>

//+------------------------------------------------------------------+
//| Input Parameters                                                |
//+------------------------------------------------------------------+
input double   PreferredRisk = 50.0;          // Preferred Risk ($)
input double   RiskMultiplier = 1.0;          // TP Distance Multiplier
input double   SpreadMultiplier = 1.0;        // Spread Adjustment Multiplier
input int      MagicNumber = 000001;          // Magic Number
input string   TradeComment = "MTLBOV1";      // Trade Comment

//+------------------------------------------------------------------+
//| Global Variables                                                |
//+------------------------------------------------------------------+
CTrade          trade;
CPositionInfo   positionInfo;
COrderInfo      orderInfo;

double          previousBarHigh = 0.0;
double          previousBarLow = 0.0;
bool            autopilotEnabled = false;
bool            alwaysInLong = false;
bool            alwaysInShort = false;
datetime        lastBarTime = 0;

// Panel dimensions and position
int panelX = 10;
int panelY = 20;
int panelWidth = 280;  // Increased width for better text display
int panelHeight = 320; // Increased height to fit all text
color panelBgColor = C'240,240,240';  // Light gray
color textColor = clrBlack;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // Set magic number for trade object
   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetMarginMode();
   trade.SetTypeFillingBySymbol(Symbol());
   
   // Create UI
   CreateUI();
   
   Print("MTLBOV1 Automated Execution EA initialized");
   Print("Symbol: ", Symbol(), ", Point: ", _Point, ", Digits: ", _Digits);
   Print("Stop Level: ", SymbolInfoInteger(Symbol(), SYMBOL_TRADE_STOPS_LEVEL), " points");
   
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Clean up UI objects
   ObjectDelete(0, "PanelBackground");
   ObjectDelete(0, "btnBuyStop");
   ObjectDelete(0, "btnSellStop");
   ObjectDelete(0, "btnAutopilot");
   ObjectDelete(0, "btnAlwaysLong");
   ObjectDelete(0, "btnAlwaysShort");
   ObjectDelete(0, "lblStatus");
   ObjectDelete(0, "lblSpread");
   ObjectDelete(0, "lblPosition");
   ObjectDelete(0, "lblPrevBar");
   ObjectDelete(0, "lblMarketInfo");
   ObjectDelete(0, "lblRiskInfo");
   ObjectDelete(0, "lblAutopilot");
   
   Print("MTLBOV1 Automated Execution EA deinitialized");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // Update display every tick
   UpdateDisplay();
   
   // Check for new bar
   CheckNewBar();
   
   // Handle autopilot if enabled
   if(autopilotEnabled)
   {
      HandleAutopilot();
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
   // Handle button clicks
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      if(sparam == "btnBuyStop")
      {
         Print("Buy Stop button clicked");
         PlaceBuyStopOrder();
      }
      else if(sparam == "btnSellStop")
      {
         Print("Sell Stop button clicked");
         PlaceSellStopOrder();
      }
      else if(sparam == "btnAutopilot")
      {
         Print("Autopilot button clicked");
         ToggleAutopilot();
      }
      else if(sparam == "btnAlwaysLong")
      {
         Print("Always In Long button clicked");
         SetAlwaysInLong();
      }
      else if(sparam == "btnAlwaysShort")
      {
         Print("Always In Short button clicked");
         SetAlwaysInShort();
      }
   }
}

//+------------------------------------------------------------------+
//| Create UI elements                                              |
//+------------------------------------------------------------------+
void CreateUI()
{
   int x = panelX;
   int y = panelY;
   int width = panelWidth - 10;
   int height = 25;
   int spacing = 30;
   
   // Create panel background
   ObjectCreate(0, "PanelBackground", OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, "PanelBackground", OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, "PanelBackground", OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, "PanelBackground", OBJPROP_XSIZE, panelWidth);
   ObjectSetInteger(0, "PanelBackground", OBJPROP_YSIZE, panelHeight);
   ObjectSetInteger(0, "PanelBackground", OBJPROP_BGCOLOR, panelBgColor);
   ObjectSetInteger(0, "PanelBackground", OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, "PanelBackground", OBJPROP_BORDER_COLOR, clrGray);
   ObjectSetInteger(0, "PanelBackground", OBJPROP_BACK, false);
   ObjectSetInteger(0, "PanelBackground", OBJPROP_SELECTABLE, false);
   
   // Create Buy Stop button
   ObjectCreate(0, "btnBuyStop", OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, "btnBuyStop", OBJPROP_XDISTANCE, x + 5);
   ObjectSetInteger(0, "btnBuyStop", OBJPROP_YDISTANCE, y + 5);
   ObjectSetInteger(0, "btnBuyStop", OBJPROP_XSIZE, width);
   ObjectSetInteger(0, "btnBuyStop", OBJPROP_YSIZE, height);
   ObjectSetString(0, "btnBuyStop", OBJPROP_TEXT, "BUY STOP");
   ObjectSetInteger(0, "btnBuyStop", OBJPROP_BGCOLOR, clrGreen);
   ObjectSetInteger(0, "btnBuyStop", OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, "btnBuyStop", OBJPROP_FONTSIZE, 9);
   
   y += spacing;
   
   // Create Sell Stop button
   ObjectCreate(0, "btnSellStop", OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, "btnSellStop", OBJPROP_XDISTANCE, x + 5);
   ObjectSetInteger(0, "btnSellStop", OBJPROP_YDISTANCE, y + 5);
   ObjectSetInteger(0, "btnSellStop", OBJPROP_XSIZE, width);
   ObjectSetInteger(0, "btnSellStop", OBJPROP_YSIZE, height);
   ObjectSetString(0, "btnSellStop", OBJPROP_TEXT, "SELL STOP");
   ObjectSetInteger(0, "btnSellStop", OBJPROP_BGCOLOR, clrRed);
   ObjectSetInteger(0, "btnSellStop", OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, "btnSellStop", OBJPROP_FONTSIZE, 9);
   
   y += spacing;
   
   // Create Autopilot button (initially disabled)
   ObjectCreate(0, "btnAutopilot", OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, "btnAutopilot", OBJPROP_XDISTANCE, x + 5);
   ObjectSetInteger(0, "btnAutopilot", OBJPROP_YDISTANCE, y + 5);
   ObjectSetInteger(0, "btnAutopilot", OBJPROP_XSIZE, width);
   ObjectSetInteger(0, "btnAutopilot", OBJPROP_YSIZE, height);
   ObjectSetString(0, "btnAutopilot", OBJPROP_TEXT, "AUTOPILOT (SELECT BIAS)");
   ObjectSetInteger(0, "btnAutopilot", OBJPROP_BGCOLOR, clrGray);
   ObjectSetInteger(0, "btnAutopilot", OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, "btnAutopilot", OBJPROP_FONTSIZE, 9);
   ObjectSetInteger(0, "btnAutopilot", OBJPROP_STATE, false); // Disabled
   
   y += spacing;
   
   // Create AI Long button (wider for better text fit)
   ObjectCreate(0, "btnAlwaysLong", OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, "btnAlwaysLong", OBJPROP_XDISTANCE, x + 5);
   ObjectSetInteger(0, "btnAlwaysLong", OBJPROP_YDISTANCE, y + 5);
   ObjectSetInteger(0, "btnAlwaysLong", OBJPROP_XSIZE, (width/2) - 2); // Wider
   ObjectSetInteger(0, "btnAlwaysLong", OBJPROP_YSIZE, height);
   ObjectSetString(0, "btnAlwaysLong", OBJPROP_TEXT, "AI LONG");
   ObjectSetInteger(0, "btnAlwaysLong", OBJPROP_BGCOLOR, clrDarkGreen);
   ObjectSetInteger(0, "btnAlwaysLong", OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, "btnAlwaysLong", OBJPROP_FONTSIZE, 9);
   
   // Create AI Short button (wider for better text fit)
   ObjectCreate(0, "btnAlwaysShort", OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, "btnAlwaysShort", OBJPROP_XDISTANCE, x + 5 + (width/2)); // Adjusted for wider button
   ObjectSetInteger(0, "btnAlwaysShort", OBJPROP_YDISTANCE, y + 5);
   ObjectSetInteger(0, "btnAlwaysShort", OBJPROP_XSIZE, (width/2) - 2); // Wider
   ObjectSetInteger(0, "btnAlwaysShort", OBJPROP_YSIZE, height);
   ObjectSetString(0, "btnAlwaysShort", OBJPROP_TEXT, "AI SHORT");
   ObjectSetInteger(0, "btnAlwaysShort", OBJPROP_BGCOLOR, clrDarkRed);
   ObjectSetInteger(0, "btnAlwaysShort", OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, "btnAlwaysShort", OBJPROP_FONTSIZE, 9);
   
   y += 50;
   
   // Create autopilot status label
   ObjectCreate(0, "lblAutopilot", OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, "lblAutopilot", OBJPROP_XDISTANCE, x + 5);
   ObjectSetInteger(0, "lblAutopilot", OBJPROP_YDISTANCE, y + 5);
   ObjectSetString(0, "lblAutopilot", OBJPROP_TEXT, "Autopilot: OFF | Bias: NONE");
   ObjectSetInteger(0, "lblAutopilot", OBJPROP_COLOR, textColor);
   ObjectSetInteger(0, "lblAutopilot", OBJPROP_FONTSIZE, 9);
   
   y += 20;
   
   // Create market info label
   ObjectCreate(0, "lblMarketInfo", OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, "lblMarketInfo", OBJPROP_XDISTANCE, x + 5);
   ObjectSetInteger(0, "lblMarketInfo", OBJPROP_YDISTANCE, y + 5);
   ObjectSetInteger(0, "lblMarketInfo", OBJPROP_COLOR, textColor);
   ObjectSetInteger(0, "lblMarketInfo", OBJPROP_FONTSIZE, 9);
   
   y += 20;
   
   // Create spread label
   ObjectCreate(0, "lblSpread", OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, "lblSpread", OBJPROP_XDISTANCE, x + 5);
   ObjectSetInteger(0, "lblSpread", OBJPROP_YDISTANCE, y + 5);
   ObjectSetInteger(0, "lblSpread", OBJPROP_COLOR, textColor);
   ObjectSetInteger(0, "lblSpread", OBJPROP_FONTSIZE, 9);
   
   y += 20;
   
   // Create previous bar label
   ObjectCreate(0, "lblPrevBar", OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, "lblPrevBar", OBJPROP_XDISTANCE, x + 5);
   ObjectSetInteger(0, "lblPrevBar", OBJPROP_YDISTANCE, y + 5);
   ObjectSetInteger(0, "lblPrevBar", OBJPROP_COLOR, textColor);
   ObjectSetInteger(0, "lblPrevBar", OBJPROP_FONTSIZE, 9);
   
   y += 20;
   
   // Create risk info label
   ObjectCreate(0, "lblRiskInfo", OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, "lblRiskInfo", OBJPROP_XDISTANCE, x + 5);
   ObjectSetInteger(0, "lblRiskInfo", OBJPROP_YDISTANCE, y + 5);
   ObjectSetInteger(0, "lblRiskInfo", OBJPROP_COLOR, textColor);
   ObjectSetInteger(0, "lblRiskInfo", OBJPROP_FONTSIZE, 9);
   
   y += 20;
   
   // Create position label
   ObjectCreate(0, "lblPosition", OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, "lblPosition", OBJPROP_XDISTANCE, x + 5);
   ObjectSetInteger(0, "lblPosition", OBJPROP_YDISTANCE, y + 5);
   ObjectSetString(0, "lblPosition", OBJPROP_TEXT, "Position: None");
   ObjectSetInteger(0, "lblPosition", OBJPROP_COLOR, textColor);
   ObjectSetInteger(0, "lblPosition", OBJPROP_FONTSIZE, 9);
   
   y += 20;
   
   // Create status label
   ObjectCreate(0, "lblStatus", OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, "lblStatus", OBJPROP_XDISTANCE, x + 5);
   ObjectSetInteger(0, "lblStatus", OBJPROP_YDISTANCE, y + 5);
   ObjectSetString(0, "lblStatus", OBJPROP_TEXT, "Status: Ready");
   ObjectSetInteger(0, "lblStatus", OBJPROP_COLOR, textColor);
   ObjectSetInteger(0, "lblStatus", OBJPROP_FONTSIZE, 9);
   
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Update display information                                       |
//+------------------------------------------------------------------+
void UpdateDisplay()
{
   // Get previous bar data
   previousBarHigh = iHigh(Symbol(), PERIOD_CURRENT, 1);
   previousBarLow = iLow(Symbol(), PERIOD_CURRENT, 1);
   
   // Get current market prices
   double bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);
   double ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
   
   // Calculate current spread in points
   int spreadPoints = (int)SymbolInfoInteger(Symbol(), SYMBOL_SPREAD);
   double spreadPrice = spreadPoints * _Point;
   
   // Update autopilot display
   string autopilotStatus = "Autopilot: " + (autopilotEnabled ? "ON" : "OFF");
   string biasStatus = " | Bias: ";
   if(alwaysInLong) biasStatus += "LONG";
   else if(alwaysInShort) biasStatus += "SHORT";
   else biasStatus += "NONE";
   ObjectSetString(0, "lblAutopilot", OBJPROP_TEXT, autopilotStatus + biasStatus);
   
   // Update market info display
   string marketText = StringFormat("Bid: %.5f | Ask: %.5f", bid, ask);
   ObjectSetString(0, "lblMarketInfo", OBJPROP_TEXT, marketText);
   
   // Update spread display
   string spreadText = StringFormat("Spread: %d pts (%.5f)", spreadPoints, spreadPrice);
   ObjectSetString(0, "lblSpread", OBJPROP_TEXT, spreadText);
   
   // Update previous bar display
   string prevBarText = StringFormat("Prev Bar: H=%.5f L=%.5f", previousBarHigh, previousBarLow);
   ObjectSetString(0, "lblPrevBar", OBJPROP_TEXT, prevBarText);
   
   // Update risk info display
   string riskText = StringFormat("Risk: $%.2f, Multiplier: %.1f", PreferredRisk, RiskMultiplier);
   ObjectSetString(0, "lblRiskInfo", OBJPROP_TEXT, riskText);
   
   // Update position info
   string positionText = GetPositionInfo();
   ObjectSetString(0, "lblPosition", OBJPROP_TEXT, positionText);
   
   // Update status
   if(HasOpenPosition())
   {
      ObjectSetString(0, "lblStatus", OBJPROP_TEXT, "Status: Position Open");
      ObjectSetInteger(0, "lblStatus", OBJPROP_COLOR, clrBlue);
   }
   else if(autopilotEnabled && (alwaysInLong || alwaysInShort))
   {
      ObjectSetString(0, "lblStatus", OBJPROP_TEXT, "Status: Autopilot Active");
      ObjectSetInteger(0, "lblStatus", OBJPROP_COLOR, clrPurple);
   }
   else
   {
      ObjectSetString(0, "lblStatus", OBJPROP_TEXT, "Status: Ready");
      ObjectSetInteger(0, "lblStatus", OBJPROP_COLOR, clrBlack);
   }
   
   // Update button colors and states
   UpdateButtonStates();
   
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Update button states                                             |
//+------------------------------------------------------------------+
void UpdateButtonStates()
{
   // Update autopilot button
   if(alwaysInLong || alwaysInShort)
   {
      // Bias is selected, enable autopilot button
      ObjectSetInteger(0, "btnAutopilot", OBJPROP_STATE, true); // Enable button
      
      if(autopilotEnabled)
      {
         ObjectSetInteger(0, "btnAutopilot", OBJPROP_BGCOLOR, clrGreen);
         ObjectSetString(0, "btnAutopilot", OBJPROP_TEXT, "AUTOPILOT ON");
      }
      else
      {
         ObjectSetInteger(0, "btnAutopilot", OBJPROP_BGCOLOR, clrBlue);
         ObjectSetString(0, "btnAutopilot", OBJPROP_TEXT, "AUTOPILOT OFF");
      }
   }
   else
   {
      // No bias selected, disable autopilot button
      ObjectSetInteger(0, "btnAutopilot", OBJPROP_STATE, false); // Disable button
      ObjectSetInteger(0, "btnAutopilot", OBJPROP_BGCOLOR, clrGray);
      ObjectSetString(0, "btnAutopilot", OBJPROP_TEXT, "AUTOPILOT (SELECT BIAS)");
   }
   
   // Update bias button colors
   if(alwaysInLong)
   {
      ObjectSetInteger(0, "btnAlwaysLong", OBJPROP_BGCOLOR, clrLime);
      ObjectSetInteger(0, "btnAlwaysShort", OBJPROP_BGCOLOR, clrDarkRed);
   }
   else if(alwaysInShort)
   {
      ObjectSetInteger(0, "btnAlwaysLong", OBJPROP_BGCOLOR, clrDarkGreen);
      ObjectSetInteger(0, "btnAlwaysShort", OBJPROP_BGCOLOR, clrOrangeRed);
   }
   else
   {
      ObjectSetInteger(0, "btnAlwaysLong", OBJPROP_BGCOLOR, clrDarkGreen);
      ObjectSetInteger(0, "btnAlwaysShort", OBJPROP_BGCOLOR, clrDarkRed);
   }
}

//+------------------------------------------------------------------+
//| Get position information                                         |
//+------------------------------------------------------------------+
string GetPositionInfo()
{
   if(HasOpenPosition())
   {
      for(int i = PositionsTotal() - 1; i >= 0; i--)
      {
         if(positionInfo.SelectByIndex(i))
         {
            if(positionInfo.Magic() == MagicNumber && positionInfo.Symbol() == Symbol())
            {
               ENUM_POSITION_TYPE posType = positionInfo.PositionType();
               double profit = positionInfo.Profit();
               double volume = positionInfo.Volume();
               string direction = (posType == POSITION_TYPE_BUY) ? "BUY" : "SELL";
               return StringFormat("Position: %s %.2f lots P/L: $%.2f", direction, volume, profit);
            }
         }
      }
   }
   return "Position: None";
}

//+------------------------------------------------------------------+
//| Check if we have an open position                                |
//+------------------------------------------------------------------+
bool HasOpenPosition()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(positionInfo.SelectByIndex(i))
      {
         if(positionInfo.Magic() == MagicNumber && positionInfo.Symbol() == Symbol())
         {
            return true;
         }
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//| Toggle autopilot mode                                            |
//+------------------------------------------------------------------+
void ToggleAutopilot()
{
   // Prevent enabling autopilot without bias
   if(!autopilotEnabled && !alwaysInLong && !alwaysInShort)
   {
      Alert("ERROR: Please select AI LONG or AI SHORT\nbefore enabling Autopilot!");
      Print("Autopilot blocked: No bias selected");
      return;
   }
   
   autopilotEnabled = !autopilotEnabled;
   
   if(autopilotEnabled)
   {
      Print("Autopilot ENABLED");
      // Cancel any existing pending orders first
      CancelAllPendingOrders();
      
      // Place initial orders
      if(!HasOpenPosition())
      {
         PlaceAutopilotOrder();
      }
      else
      {
         Print("Already have an open position. Autopilot will resume when position closes.");
      }
   }
   else
   {
      Print("Autopilot DISABLED");
      // Cancel all pending orders when autopilot is disabled
      CancelAllPendingOrders();
   }
   
   UpdateDisplay();
}

//+------------------------------------------------------------------+
//| Set Always In Long                                               |
//+------------------------------------------------------------------+
void SetAlwaysInLong()
{
   alwaysInLong = true;
   alwaysInShort = false;
   Print("Always In bias set to: LONG");
   
   // If autopilot is enabled and no position, place order
   if(autopilotEnabled && !HasOpenPosition())
   {
      CancelAllPendingOrders();
      PlaceAutopilotOrder();
   }
   
   UpdateDisplay();
}

//+------------------------------------------------------------------+
//| Set Always In Short                                              |
//+------------------------------------------------------------------+
void SetAlwaysInShort()
{
   alwaysInShort = true;
   alwaysInLong = false;
   Print("Always In bias set to: SHORT");
   
   // If autopilot is enabled and no position, place order
   if(autopilotEnabled && !HasOpenPosition())
   {
      CancelAllPendingOrders();
      PlaceAutopilotOrder();
   }
   
   UpdateDisplay();
}

//+------------------------------------------------------------------+
//| Place autopilot order based on current bias                      |
//+------------------------------------------------------------------+
void PlaceAutopilotOrder()
{
   if(HasOpenPosition())
   {
      Print("Autopilot: Already have open position, not placing new order");
      return;
   }
   
   if(alwaysInLong)
   {
      Print("Autopilot: Placing BUY STOP order");
      PlaceBuyStopOrder();
   }
   else if(alwaysInShort)
   {
      Print("Autopilot: Placing SELL STOP order");
      PlaceSellStopOrder();
   }
   else
   {
      Alert("ERROR: Autopilot requires bias selection!\nPlease select AI LONG or AI SHORT.");
      Print("Autopilot: No bias set, cannot place order");
   }
}

//+------------------------------------------------------------------+
//| Check for new bar                                                |
//+------------------------------------------------------------------+
void CheckNewBar()
{
   datetime currentBarTime = iTime(Symbol(), PERIOD_CURRENT, 0);
   
   if(currentBarTime != lastBarTime)
   {
      lastBarTime = currentBarTime;
      
      // If autopilot is enabled, handle new bar logic
      if(autopilotEnabled)
      {
         OnNewBar();
      }
   }
}

//+------------------------------------------------------------------+
//| Handle new bar event                                             |
//+------------------------------------------------------------------+
void OnNewBar()
{
   // If we have an open position, cancel all pending orders
   if(HasOpenPosition())
   {
      CancelAllPendingOrders();
      Print("New bar: Position open, cancelled pending orders");
      return;
   }
   
   // If no position and autopilot is enabled with bias, place new orders
   if(autopilotEnabled && (alwaysInLong || alwaysInShort))
   {
      CancelAllPendingOrders();
      PlaceAutopilotOrder();
      Print("New bar: Placing autopilot order");
   }
}

//+------------------------------------------------------------------+
//| Handle autopilot logic                                           |
//+------------------------------------------------------------------+
void HandleAutopilot()
{
   // This function is called every tick when autopilot is enabled
   // Add any continuous monitoring logic here if needed
   
   // For now, we're handling everything in OnNewBar()
   // This function can be expanded for more complex logic
}

//+------------------------------------------------------------------+
//| Calculate position size based on risk                            |
//+------------------------------------------------------------------+
double CalculatePositionSize(ENUM_ORDER_TYPE orderType, double entryPrice, double slPrice)
{
   if(PreferredRisk <= 0) 
   {
      Print("Error: Preferred risk must be positive");
      return 0;
   }
   
   // Calculate stop distance in points
   double stopDistancePoints;
   if(orderType == ORDER_TYPE_BUY_STOP)
   {
      stopDistancePoints = (entryPrice - slPrice) / _Point;
   }
   else if(orderType == ORDER_TYPE_SELL_STOP)
   {
      stopDistancePoints = (slPrice - entryPrice) / _Point;
   }
   else
   {
      Print("Error: Invalid order type for position calculation");
      return 0;
   }
   
   if(stopDistancePoints <= 0) 
   {
      Print("Error: Stop distance must be positive");
      return 0;
   }
   
   // Calculate point value
   double pointValue = CalculatePointValue();
   
   if(pointValue <= 0)
   {
      Print("Error: Invalid point value calculated");
      return 0;
   }
   
   // Calculate lots needed
   double lots = PreferredRisk / (stopDistancePoints * pointValue);
   
   // Apply lot size constraints
   double minLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
   double lotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
   
   // Normalize to step
   if(lotStep > 0)
      lots = MathFloor(lots / lotStep) * lotStep;
   
   // Apply min/max
   lots = MathMax(lots, minLot);
   lots = MathMin(lots, maxLot);
   
   return NormalizeDouble(lots, 2);
}

//+------------------------------------------------------------------+
//| Calculate point value for current symbol                         |
//+------------------------------------------------------------------+
double CalculatePointValue()
{
   double tickValue = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
   double tickSize = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
   
   if(tickSize > 0)
   {
      return tickValue * (_Point / tickSize);
   }
   
   return 0;
}

//+------------------------------------------------------------------+
//| Get minimum stop distance for current symbol                     |
//+------------------------------------------------------------------+
double GetMinStopDistance()
{
   // Get stop level in points
   int stopLevel = (int)SymbolInfoInteger(Symbol(), SYMBOL_TRADE_STOPS_LEVEL);
   double minStopDistance = stopLevel * _Point;
   
   // Add some buffer to ensure valid orders
   minStopDistance += 10 * _Point; // Add 10 points buffer
   
   return minStopDistance;
}

//+------------------------------------------------------------------+
//| Calculate spread-adjusted price                                  |
//+------------------------------------------------------------------+
double GetSpreadAdjustedPrice(bool forBuyOrder)
{
   double spread = SymbolInfoInteger(Symbol(), SYMBOL_SPREAD) * _Point;
   double spreadAdjustment = spread * SpreadMultiplier;
   
   if(forBuyOrder)
   {
      // For buy orders, spread is added to entry price
      return spreadAdjustment;
   }
   else
   {
      // For sell orders, spread is subtracted from TP
      return -spreadAdjustment;
   }
}

//+------------------------------------------------------------------+
//| Place Buy Stop order                                             |
//+------------------------------------------------------------------+
void PlaceBuyStopOrder()
{
   // Check if already have position
   if(HasOpenPosition())
   {
      Print("Cannot place order: Already have open position");
      return;
   }
   
   // Calculate spread adjustment for entry (positive value)
   double spreadAdjustmentEntry = MathAbs(GetSpreadAdjustedPrice(true));
   
   // Calculate entry price (previous high + 1 tick + spread adjustment)
   double entryPrice = previousBarHigh + _Point + spreadAdjustmentEntry;
   
   // Calculate stop loss price (previous low - 1 tick)
   double slPrice = previousBarLow - _Point;
   
   // Get current ask price and minimum stop distance
   double currentAsk = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
   double minStopDistance = GetMinStopDistance();
   
   // Ensure buy stop is above current ask by at least minStopDistance
   double requiredPrice = currentAsk + minStopDistance;
   entryPrice = MathMax(entryPrice, requiredPrice);
   
   // If calculated price is too close or below current price, adjust it
   if(entryPrice <= currentAsk)
   {
      entryPrice = currentAsk + minStopDistance;
      Print("Adjusted Buy Stop price to meet minimum distance requirement");
   }
   
   // Validate SL position
   if(slPrice >= entryPrice)
   {
      Print("Error: Stop loss must be below entry for BUY STOP");
      return;
   }
   
   // Calculate TP (entry + distance from entry to SL) - NO spread adjustment
   double distanceToSL = entryPrice - slPrice;
   double tpPrice = entryPrice + (distanceToSL * RiskMultiplier);
   
   // Calculate position size based on risk
   double lots = CalculatePositionSize(ORDER_TYPE_BUY_STOP, entryPrice, slPrice);
   if(lots <= 0) return;
   
   // Place the order
   entryPrice = NormalizeDouble(entryPrice, _Digits);
   slPrice = NormalizeDouble(slPrice, _Digits);
   tpPrice = NormalizeDouble(tpPrice, _Digits);
   
   Print("Placing BUY STOP:");
   Print("  Entry: ", entryPrice, " (+", spreadAdjustmentEntry, " spread adj)");
   Print("  SL: ", slPrice);
   Print("  TP: ", tpPrice, " (no spread adjustment)");
   Print("  Lots: ", lots);
   
   // Place the order with correct parameter order
   if(!trade.BuyStop(lots, entryPrice, Symbol(), slPrice, tpPrice, ORDER_TIME_GTC, 0, TradeComment))
   {
      Print("Failed to place BUY STOP. Error: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Place Sell Stop order                                            |
//+------------------------------------------------------------------+
void PlaceSellStopOrder()
{
   // Check if already have position
   if(HasOpenPosition())
   {
      Print("Cannot place order: Already have open position");
      return;
   }
   
   // Calculate spread adjustment (positive value for SL/TP movement)
   double spreadAdjustment = MathAbs(GetSpreadAdjustedPrice(false));
   
   // Calculate entry price (previous low - 1 tick)
   double entryPrice = previousBarLow - _Point;
   
   // Calculate stop loss price (previous high + 1 tick + spread adjustment)
   double slPrice = previousBarHigh + _Point + spreadAdjustment;
   
   // Get current bid price and minimum stop distance
   double currentBid = SymbolInfoDouble(Symbol(), SYMBOL_BID);
   double minStopDistance = GetMinStopDistance();
   
   // Ensure sell stop is below current bid by at least minStopDistance
   double requiredPrice = currentBid - minStopDistance;
   entryPrice = MathMin(entryPrice, requiredPrice);
   
   // If calculated price is too close or above current price, adjust it
   if(entryPrice >= currentBid)
   {
      entryPrice = currentBid - minStopDistance;
      Print("Adjusted Sell Stop price to meet minimum distance requirement");
   }
   
   // Validate SL position
   if(slPrice <= entryPrice)
   {
      Print("Error: Stop loss must be above entry for SELL STOP");
      return;
   }
   
   // Calculate TP (entry - distance from entry to SL + spread adjustment)
   double distanceToSL = slPrice - entryPrice;
   double tpPrice = entryPrice - (distanceToSL * RiskMultiplier) + spreadAdjustment;
   
   // Calculate position size based on risk
   double lots = CalculatePositionSize(ORDER_TYPE_SELL_STOP, entryPrice, slPrice);
   if(lots <= 0) return;
   
   // Place the order
   entryPrice = NormalizeDouble(entryPrice, _Digits);
   slPrice = NormalizeDouble(slPrice, _Digits);
   tpPrice = NormalizeDouble(tpPrice, _Digits);
   
   Print("Placing SELL STOP:");
   Print("  Entry: ", entryPrice);
   Print("  SL: ", slPrice);
   Print("  TP: ", tpPrice);
   Print("  Lots: ", lots);
   Print("  Spread Adjustment: +", spreadAdjustment, " (moves SL & TP up)");
   
   // Place the order with correct parameter order
   if(!trade.SellStop(lots, entryPrice, Symbol(), slPrice, tpPrice, ORDER_TIME_GTC, 0, TradeComment))
   {
      Print("Failed to place SELL STOP. Error: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Cancel all pending orders                                        |
//+------------------------------------------------------------------+
void CancelAllPendingOrders()
{
   int ordersCanceled = 0;
   
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      ulong orderTicket = OrderGetTicket(i);
      if(orderTicket > 0)
      {
         if(orderInfo.Select(orderTicket))
         {
            if(orderInfo.Magic() == MagicNumber && orderInfo.Symbol() == Symbol())
            {
               ENUM_ORDER_TYPE orderType = orderInfo.OrderType();
               if(orderType == ORDER_TYPE_BUY_STOP || orderType == ORDER_TYPE_SELL_STOP)
               {
                  if(trade.OrderDelete(orderTicket))
                  {
                     ordersCanceled++;
                  }
               }
            }
         }
      }
   }
   
   if(ordersCanceled > 0)
   {
      Print("Cancelled ", ordersCanceled, " pending orders");
   }
}

//+------------------------------------------------------------------+
//| OnTrade event handler                                            |
//+------------------------------------------------------------------+
void OnTrade()
{
   // When an order is filled (position opened), cancel all pending orders
   if(HasOpenPosition())
   {
      CancelAllPendingOrders();
      Print("Position opened, cancelled all pending orders");
   }
}