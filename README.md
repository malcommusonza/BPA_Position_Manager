# 🚀 BPA Position Manager EA

## 📋 Overview

**BPA Position Manager** is a sophisticated MetaTrader 5 Expert Advisor designed for automated trade execution with advanced position management capabilities. This EA provides comprehensive trading tools including stop orders, limit orders, market orders, and autopilot functionality with intelligent bias-based trading.

<div align="center">

**MetaTrader 5** | **Expert Advisor** | **Automated Trading** | **Risk Management**
:---: | :---: | :---: | :---:
✅ | ✅ | ✅ | ✅

</div>

## ✨ Features

### 🎯 Core Trading Features
- **Buy/Sell Stop Orders** - Entry at previous bar extremes with spread adjustment
- **Buy/Sell Limit Orders** - Entry at reversal points with customizable multipliers
- **Market Orders** - Instant execution based on AI bias selection
- **Autopilot Mode** - Automated trade placement with directional bias
- **Scale-In Functionality** - Multiple positions with shared stop loss

### 📊 Position Management
- **Multiple Position Support** - Scale into trades with controlled risk
- **Average Price Visualization** - Dynamic price line for multiple positions
- **Instant SL Adjustment** - Modify all open positions to previous bar levels
- **Reverse on Failure** - Adjust SL and place reverse pending orders
- **Close All Positions** - One-click position closing with safety toggle

### ⚙️ Risk Management
- **Risk-Based Position Sizing** - Calculates lots based on preferred risk amount
- **Spread Adjustment** - Configurable spread multiplier for better entries
- **Stop Distance Protection** - Ensures minimum distance requirements
- **Risk Limits** - Prevents exceeding maximum allowed risk when scaling

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
| `PreferredRisk` | double | 50.0 | Preferred risk amount in USD |
| `RiskMultiplier` | double | 1.0 | Take profit distance multiplier |
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

## 🎮 User Interface

### Control Panel Layout
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
│ Risk: $XX.XX, Multiplier: X.X       │
│ Position: None                      │
│ Status: Ready                       │
│                                     │
│ [Instant SL Adjustment]             │
│ [Reverse On Failure]                │
└─────────────────────────────────────┘
```

### Button Functions

#### Order Execution
- **<span style="color:green">BUY STOP</span>**: Places buy stop at previous bar high + 1 tick + spread
- **<span style="color:red">SELL STOP</span>**: Places sell stop at previous bar low - 1 tick
- **<span style="color:orange">BUY LIMIT</span>**: Places buy limit at previous bar low + spread adjustment
- **<span style="color:orange">SELL LIMIT</span>**: Places sell limit at previous bar high
- **<span style="color:gold">MARKET ORDER</span>**: Executes market order based on selected AI bias

#### Mode Control
- **<span style="color:blue">AUTOPILOT</span>**: Toggles automated trading (requires bias selection)
- **<span style="color:green">AI LONG</span>**: Sets bias to long-only trading
- **<span style="color:red">AI SHORT</span>**: Sets bias to short-only trading
- **<span style="color:green">SCALE IN</span>**: Enables multiple position scaling

#### Position Management
- **<span style="color:orange">INSTANT SL ADJUSTMENT</span>**: Adjusts all open positions to previous bar levels
- **<span style="color:purple">REVERSE ON FAILURE</span>**: Adjusts SL and places reverse pending order
- **<span style="color:purple">ENABLE CLOSE ALL</span>**: Toggle to enable Close All button
- **<span style="color:purple">CLOSE ALL</span>**: Closes all open positions (requires toggle enabled)

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
```

### Risk Limits
- **Minimum stop distance**: Symbol stop level + 10 points buffer
- **Maximum risk when scaling**: PreferredRisk × 1.12
- **Lot size constraints**: Respects symbol min/max/step lots

## 🏗️ System Architecture

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
│  • Events    │    Mgmt      │   • Order Mgmt        │
│              │  • Autopilot │                       │
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
void AdjustStopLoss()
void ReverseOnFailure()

// Calculation Functions
double CalculatePositionSize()
double CalculatePointValue()
double GetTotalRisk()
double GetAveragePrice()
```

## 📊 Data Flow

### Order Placement Flow
```
1. User clicks button
2. OnChartEvent triggered
3. Button validation checks
4. Price calculations
5. Risk validation
6. Position size calculation
7. Order placement
8. UI update
```

### Tick Processing Flow
```
OnTick() → UpdateDisplay() → CheckNewBar() → HandleAutopilot()
    ↓             ↓               ↓               ↓
Price data   UI updates    Bar detection   Autopilot logic
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
2. **Use conservative risk settings** initially
3. **Monitor during high-impact news events**
4. **Regularly review and adjust settings**
5. **Keep trading journal** of EA performance

## 🐛 Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| EA not placing orders | Check Algo Trading permission, symbol compatibility |
| Orders rejected by broker | Verify stop distance meets broker requirements |
| Invalid stops message | Increase stop distance, check spread multiplier |
| No average price line | Line only appears with 2+ positions |
| Close All not working | Enable Close All toggle first |

### Error Messages
- **"ERROR: Please select AI LONG or AI SHORT"**: Select bias before enabling autopilot
- **"Cannot toggle Scale In while positions are open"**: Close positions first
- **"Adding this position would exceed maximum allowed risk"**: Reduce position size or risk

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
**Version**: 1.03  
**Author**: Malcom T Musonza  
**Copyright © 2026**

</div>
