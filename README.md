```markdown
# 🚀 BPA Position Manager EA v1.06

## 📋 Overview

**BPA Position Manager** is a sophisticated MetaTrader 5 Expert Advisor designed for automated trade execution with advanced position management capabilities. This EA provides comprehensive trading tools including stop orders, limit orders, market orders, and autopilot functionality with intelligent bias-based trading. Version 1.06 introduces a real-time bar close countdown timer and enhanced risk management features.

<div align="center">

**MetaTrader 5** | **Expert Advisor** | **Automated Trading** | **Risk Management** | **Real-Time Timer**
:---: | :---: | :---: | :---: | :---:
✅ | ✅ | ✅ | ✅ | ✅

</div>

## 🆕 What's New in v1.06

### 🕐 Bar Close Countdown Timer
- **Real-time countdown** showing minutes:seconds until current bar closes
- **Color-coded alerts**: Green (>60s), Yellow (30-60s), Red (<30s)
- **Visual progress bar** showing bar completion percentage
- **Configurable sound alerts** at key thresholds (60s, 30s, 10s, 5s, 0s)
- **Multi-timeframe support**: Proper formatting for M1, H1, D1 and higher timeframes

### 🎯 Enhanced Instant SL Adjustment
- **Intelligent price detection** before stop loss adjustment
- **Automatic market closure** when price has breached intended stop level
- **Prevents failed SL modifications** and broker rejections
- **Better risk management** by closing immediately when stop levels are breached

### 📊 Improved Position Management
- **Consistent market closure logic** across all position management functions
- **Enhanced logging and alerts** for better trade visibility
- **Optimized performance** with more efficient price checking

## ✨ Features

### 🎯 Core Trading Features
- **Buy/Sell Stop Orders** - Entry at previous bar extremes with spread adjustment
- **Buy/Sell Limit Orders** - Entry at reversal points with customizable multipliers
- **Market Orders** - Instant execution based on AI bias selection
- **Autopilot Mode** - Automated trade placement with directional bias
- **Scale-In Functionality** - Multiple positions with shared stop loss

### 🕐 Timer Features
- **Real-time countdown** until bar close with MM:SS format
- **Visual progress indicator** showing bar completion percentage
- **Color-coded thresholds** for easy visual reference
- **Audible alerts** at configurable time intervals
- **Auto-reset on new bar** - no manual intervention needed

### 📊 Position Management
- **Multiple Position Support** - Scale into trades with controlled risk
- **Average Price Visualization** - Dynamic price line for multiple positions
- **Intelligent SL Adjustment** - Closes positions at market when stop levels breached
- **Reverse on Failure** - Adjust SL and place reverse pending orders
- **Close All Positions** - One-click position closing with safety toggle

### ⚙️ Risk Management
- **Risk-Based Position Sizing** - Calculates lots based on preferred risk amount
- **Spread Adjustment** - Configurable spread multiplier for better entries
- **Stop Distance Protection** - Ensures minimum distance requirements
- **Risk Limits** - Prevents exceeding maximum allowed risk when scaling
- **Price-Breached Protection** - Auto-close when stop levels already passed

## 🛠️ Installation

### Prerequisites
- MetaTrader 5 platform
- Trading account with your broker

### Installation Steps
1. **Download** the `BPA_Position_Manager.mq5` file
2. **Copy** it to your MT5 Experts folder: `MetaTrader 5/MQL5/Experts/`
3. **Restart MT5** or refresh the Navigator window
4. **Drag and drop** the EA from the Navigator to your chart
5. **Enable** 'Allow Algo Trading' and 'Allow DLL imports' if needed
6. **Configure** input parameters and press OK

## ⚙️ Input Parameters

### Risk Parameters
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `PreferredRiskPercent` | double | 0.1 | Preferred risk as % of account balance |
| `StopOrderTPMultiplier` | double | 1.0 | Stop order TP distance multiplier |
| `StopOrderSLMultiplier` | double | 1.0 | Stop order SL distance multiplier |
| `SpreadMultiplier` | double | 1.0 | Spread adjustment multiplier |
| `MagicNumber` | int | 000001 | Unique EA identifier |
| `TradeComment` | string | "BPA_Position_Manager" | Comment on trades |

### Order Parameters
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `LimitOrderTPMultiplier` | double | 1.0 | Limit order TP distance multiplier |
| `LimitOrderSLMultiplier` | double | 1.0 | Limit order SL distance multiplier |
| `MarketOrderStopLoss` | double | 20.0 | Market order SL in points |

### Position Management
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `MaxOpenPositions` | int | 2 | Maximum positions when Scale In enabled |
| `EnableCloseAllInput` | bool | false | Initial state of Close All feature |

### Timer Configuration
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `EnableCountdownTimer` | bool | true | Show bar close countdown timer |
| `WarningThreshold1` | int | 60 | Yellow alert threshold (seconds) |
| `WarningThreshold2` | int | 30 | Red alert threshold (seconds) |
| `EnableSoundAlerts` | bool | false | Play sound alerts at thresholds |
| `ShowProgressBar` | bool | true | Show visual progress bar |
| `NormalColor` | color | clrGreen | Normal timer color (>60s) |
| `WarningColor` | color | clrGold | Warning timer color (30-60s) |
| `CriticalColor` | color | clrRed | Critical timer color (<30s) |

## 🎮 User Interface

### Control Panel Layout v1.06
```
┌─────────────────────────────────────┐
│ [BUY STOP]  [BUY LIMIT]  [MARKET]   │
│ [SELL STOP] [SELL LIMIT]            │
│                                     │
│ [AUTOPILOT (SELECT BIAS)]           │
│ [AI LONG]           [AI SHORT]      │
│ [SCALE IN: OFF] [ENABLE CLOSE ALL]  │
│ [CLOSE ALL]                         │
│                                     │
│ Autopilot: OFF | Bias: NONE         │
│ Bid: X.XXXXX | Ask: X.XXXXX         │
│ Spread: XX pts (X.XXXXX)            │
│ Prev Bar: H=X.XXXXX L=X.XXXXX       │
│ Risk: X.X% ($X.XX), SM: X.X, LM: X.X│
│ Position: None                      │
│ Status: Ready                       │
│ Bar closes in: 04:23 (Green/Yellow/Red)│
│                                     │
│ [Instant SL Adjustment]             │
│ [Reverse On Failure]                │
└─────────────────────────────────────┘
│ [===============    ] 75%           │ ← Progress Bar (optional)
└─────────────────────────────────────┘
```

### Button Functions

#### Order Execution
- **<span style="color:green">BUY STOP</span>**: Places buy stop at previous bar high + 1 tick + spread
- **<span style="color:red">SELL STOP</span>**: Places sell stop at previous bar low - 1 tick
- **<span style="color:limegreen">BUY LIMIT</span>**: Places buy limit at previous bar low + spread adjustment
- **<span style="color:orangered">SELL LIMIT</span>**: Places sell limit at previous bar high
- **<span style="color:gold">MARKET ORDER</span>**: Executes market order based on selected AI bias

#### Mode Control
- **<span style="color:blue">AUTOPILOT</span>**: Toggles automated trading (requires bias selection)
- **<span style="color:darkgreen">AI LONG</span>**: Sets bias to long-only trading
- **<span style="color:darkred">AI SHORT</span>**: Sets bias to short-only trading
- **<span style="color:gray">SCALE IN</span>**: Enables multiple position scaling

#### Position Management
- **<span style="color:orange">INSTANT SL ADJUSTMENT</span>**: Intelligently adjusts SL or closes at market if price breached
- **<span style="color:purple">REVERSE ON FAILURE</span>**: Adjusts SL and places reverse pending order
- **<span style="color:gray">ENABLE CLOSE ALL</span>**: Toggle to enable Close All button
- **<span style="color:darkslategray">CLOSE ALL</span>**: Closes all open positions (requires toggle enabled)

## 🔄 Trading Logic

### Stop Order Placement
```
Buy Stop:
  Entry: PreviousBarHigh + 1 tick + spread adjustment
  SL: PreviousBarLow - 1 tick
  TP: Entry + (Entry - SL) × RiskMultiplier

Sell Stop:
  Entry: PreviousBarLow - 1 tick
  SL: PreviousBarHigh + 1 tick + spread adjustment
  TP: Entry - (SL - Entry) × RiskMultiplier
```

### Limit Order Placement
```
Buy Limit:
  Entry: PreviousBarLow + spread adjustment
  SL: Entry - (Entry - PreviousBarLow) × LimitOrderSLMultiplier
  TP: PreviousBarHigh × LimitOrderTPMultiplier

Sell Limit:
  Entry: PreviousBarHigh
  SL: Entry + (PreviousBarHigh + spread - Entry) × LimitOrderSLMultiplier
  TP: (PreviousBarLow + spread) × LimitOrderTPMultiplier
```

### Enhanced Instant SL Adjustment Logic
```
For LONG positions:
  If Current Bid ≤ (PreviousBarLow - 1 tick):
    → Close position at market immediately
  Else:
    → Adjust SL to PreviousBarLow - 1 tick

For SHORT positions:
  If Current Ask ≥ (PreviousBarHigh + 1 tick + spread):
    → Close position at market immediately
  Else:
    → Adjust SL to PreviousBarHigh + 1 tick + spread
```

### Timer Logic
```
On each tick:
  1. Calculate remaining seconds: NextBarTime - CurrentTime
  2. Format based on timeframe:
     - M1-M30: MM:SS
     - H1-H4: HH:MM:SS
     - D1+: Days HH:MM:SS
  3. Update color based on thresholds
  4. Update progress bar percentage
  5. Play sound alerts at configured thresholds
  6. Reset on new bar detection
```

### Autopilot Logic
1. **Requires bias selection** (AI LONG or AI SHORT)
2. **Places pending orders** based on selected bias
3. **Cancels all pending orders** when position opens
4. **New bar triggers** order replacement if no position open
5. **Resumes after position close** if autopilot remains enabled

### Scale-In Logic
1. **Each position** uses same stop loss as initial position
2. **Risk per position** = PreferredRisk ÷ MaxOpenPositions
3. **Maximum total risk** = PreferredRisk × 1.12
4. **Average price line** appears when 2+ positions open
5. **Shared stop loss** ensures consistent risk management

## 📈 Risk Calculations

### Position Size Formula
```
StopDistance = |Entry - SL| in points
PointValue = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE) × (Point ÷ TickSize)
Lots = RiskPerPosition ÷ (StopDistance × PointValue)

Where RiskPerPosition = 
  PreferredRisk ÷ MaxOpenPositions (if Scale In enabled)
  PreferredRisk (otherwise)
  PreferredRisk = AccountBalance × (PreferredRiskPercent ÷ 100)
```

### Risk Limits
- **Minimum stop distance**: Symbol stop level + 10 points buffer
- **Maximum risk when scaling**: PreferredRisk × 1.12
- **Lot size constraints**: Respects symbol min/max/step lots

## 🏗️ System Architecture v1.06

### Core Components
```
┌─────────────────────────────────────────────────────┐
│                    MetaTrader 5                      │
├─────────────────────────────────────────────────────┤
│              BPA Position Manager EA                 │
├──────────────┬──────────────┬───────────────────────┤
│  UI Layer    │  Logic Layer │   Trade Layer         │
│  • Buttons   │  • Risk Calc │   • Order Execution   │
│  • Displays  │  • Position  │   • Position Mgmt     │
│  • Timer     │    Mgmt      │   • Order Mgmt        │
│  • Progress  │  • Autopilot │   • Market Closure    │
│    Bar       │  • Timer     │                       │
└──────────────┴──────────────┴───────────────────────┘
```

### Key Functions
```mql5
// Order Placement Functions
void PlaceBuyStopOrder()
void PlaceSellStopOrder()
void PlaceBuyLimitOrder()
void PlaceSellLimitOrder()
void PlaceMarketOrder()

// Management Functions
void ToggleAutopilot()
void SetAlwaysInLong()
void SetAlwaysInShort()
void ToggleScaleIn()
void CloseAllPositions()
void AdjustStopLoss()     // Enhanced in v1.06
void ReverseOnFailure()

// Timer Functions (New in v1.06)
void UpdateTimer()
void UpdateTimerDisplay()
void UpdateProgressBar()
void CheckTimerAlerts()

// Helper Functions
double CalculatePositionSize()
double CalculatePointValue()
double GetTotalRisk()
double GetAveragePrice()
bool ClosePositionAtMarket()  // New helper in v1.06
```

## 📊 Data Flow v1.06

### Tick Processing Flow
```
OnTick() → UpdateDisplay() → CheckNewBar() → HandleAutopilot()
    ↓             ↓               ↓               ↓
Price data   UI updates    Bar detection   Autopilot logic
    ↓             ↓
UpdateTimer()  TimerDisplay
    ↓
CheckTimerAlerts()
```

### Enhanced SL Adjustment Flow
```
AdjustStopLoss() clicked
    ↓
For each position:
    ↓
Calculate intended SL (PrevBarLow - tick for LONG, PrevBarHigh + tick for SHORT)
    ↓
Check current price vs intended SL
    ↓
IF price breached intended SL:
    ClosePositionAtMarket()
ELSE:
    Validate stop distance
    Adjust SL to intended level
    ↓
Update logging and UI
```

## ⚠️ Important Notes

### Requirements
- MetaTrader 5 build 2000 or higher
- Account with margin trading enabled
- Symbol with reasonable spread and liquidity

### Limitations
- Designed for forex pairs and major indices
- Not suitable for highly volatile or illiquid instruments
- Always test in demo before live trading
- Past performance does not guarantee future results

### Best Practices
1. **Start with demo account** to understand EA behavior
2. **Use conservative risk settings** initially (0.1-0.5%)
3. **Monitor during high-impact news events**
4. **Regularly review and adjust settings**
5. **Keep trading journal** of EA performance
6. **Use timer to anticipate new bar events** for autopilot trading

## 🐛 Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| EA not placing orders | Check Algo Trading permission, symbol compatibility |
| Orders rejected by broker | Verify stop distance meets broker requirements |
| Invalid stops message | Increase stop distance, check spread multiplier |
| No average price line | Line only appears with 2+ positions |
| Close All not working | Enable Close All toggle first |
| Timer not showing | Ensure EnableCountdownTimer is set to true |
| Timer colors not changing | Adjust WarningThreshold1/2 parameters |

### Error Messages
- **"ERROR: Please select AI LONG or AI SHORT"**: Select bias before enabling autopilot
- **"Cannot toggle Scale In while positions are open"**: Close positions first
- **"Adding this position would exceed maximum allowed risk"**: Reduce position size or risk
- **"Price breached stop level! Closing position at market"**: Normal behavior when price moved past intended SL

## 🔮 Future Enhancements

### Planned Features
1. **Trailing Stop Functionality**
2. **Time-Based Exit Strategies**
3. **Advanced Risk Management Profiles**
4. **Performance Analytics Dashboard**
5. **Multi-Timeframe Analysis**
6. **News Event Filtering**
7. **Correlation-Based Hedging**

### Technical Improvements
1. **Modular Architecture**: Separate DLL for complex calculations
2. **Database Integration**: Trade history and performance tracking
3. **Machine Learning**: Adaptive parameter optimization
4. **Cloud Sync**: Multi-terminal synchronization
5. **API Integration**: External signal providers

## 🧪 Testing Strategy

### Test Categories
1. **Unit Tests**: Individual function validation
2. **Integration Tests**: Component interaction
3. **Scenario Tests**: Complete trading scenarios
4. **Stress Tests**: High-frequency trading conditions
5. **Compatibility Tests**: Different brokers and symbols

### Test Environment
- **Demo Accounts**: Multiple broker environments
- **Historical Data**: Various market conditions
- **Edge Cases**: Extreme spreads, gaps, news events

## 📄 License

This Expert Advisor is provided for educational and research purposes. Use at your own risk. The author is not responsible for any financial losses incurred while using this software.

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📞 Support

For issues, questions, or suggestions:
1. Check the existing issues on GitHub
2. Review the documentation thoroughly
3. Create a detailed issue with reproduction steps

## 📚 References

### MT5 Documentation
- [CTrade Class](https://www.mql5.com/en/docs/standardlibrary/tradeclasses/ctrade)
- [CPositionInfo Class](https://www.mql5.com/en/docs/standardlibrary/tradeclasses/cpositioninfo)
- [Chart Objects](https://www.mql5.com/en/docs/constants/objectconstants/enum_object)

### Trading Concepts
- Risk Management Principles
- Position Sizing Models
- Technical Analysis Basics
- Order Types and Execution

---

<div align="center">

**Last Updated**: January 2026  
**Version**: 1.06  
**Author**: Malcom T Musonza  
**Copyright © 2026**

**Key Updates in v1.06**:
• Added real-time bar close countdown timer  
• Enhanced Instant SL Adjustment with market closure on price breach  
• Improved position management and risk controls  
• Added progress bar and visual timer indicators  

</div>
```
