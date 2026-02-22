# 🚀 BPA Position Manager EA v1.09

## 📋 Overview

**BPA Position Manager** is a sophisticated MetaTrader 5 Expert Advisor designed for automated trade execution with advanced position management capabilities. This EA provides comprehensive trading tools including stop orders, limit orders, market orders, and autopilot functionality with intelligent bias-based trading. Version 1.09 introduces three powerful new features: **Static Lot Sizing**, **Click-to-Set Stop Loss**, and **Automatic Breakeven on TP%**, along with enhanced UI layout for better usability.

<div align="center">

**MetaTrader 5** | **Expert Advisor** | **Automated Trading** | **Risk Management** | **Real-Time Timer** | **Click SL** | **Auto Breakeven**
:---: | :---: | :---: | :---: | :---: | :---: | :---:
✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅

</div>

## 🆕 What's New in v1.09

### 📊 Static Lot Sizing
- **Fixed position sizing** independent of account balance
- **Toggle between** risk-based and static lot sizing on-the-fly
- **Perfect for** consistent position sizing regardless of account fluctuations
- **Real-time display** of current static lot setting in the info panel

### 🖱️ Click-to-Set Stop Loss
- **Visual SL placement** - click directly on any bar to set your stop loss
- **Bias-aware calculation** - automatically calculates correct SL based on LONG/SHORT bias
- **Visual confirmation** - orange dashed line shows your selected SL price
- **Toggle usage** - enable/disable clicked SL with a single button
- **Smart defaults** - auto-enables when you click, auto-disables when positions close

### 🎯 Automatic Breakeven on TP%
- **Profit protection** - automatically moves SL to breakeven when trade reaches X% of TP
- **Configurable threshold** - default 80%, adjustable via input
- **Smart detection** - only triggers once per position
- **Toggle control** - enable/disable via dedicated button
- **Visual indicator** - shows current threshold in info panel

### 🎨 Enhanced UI Layout
- **Expanded panel height** to 590px - accommodates all buttons comfortably
- **No overlap** - fixed Reverse on Failure button overlapping with progress bar
- **Clean organization** - all 11 button rows with proper spacing
- **Progress bar** - neatly positioned below the panel

## ✨ Features

### 🎯 Core Trading Features
- **Buy/Sell Stop Orders** - Entry at previous bar extremes with spread adjustment
- **Buy/Sell Limit Orders** - Entry at reversal points with customizable multipliers
- **Market Orders** - Instant execution based on AI bias selection
- **Autopilot Mode** - Automated trade placement with directional bias
- **Scale-In Functionality** - Multiple positions with shared stop loss

### 🖱️ Advanced SL Management
- **Click-to-Set SL** - Visual stop loss placement on chart
- **Bias-aware calculation** - correct SL for both LONG and SHORT
- **Visual SL line** - orange dashed line for easy reference
- **Toggle usage** - enable/disable clicked SL as needed
- **Auto-reset** - clears when positions are closed

### 🎯 Profit Protection
- **Automatic breakeven** - locks in profits at configurable TP percentage
- **Configurable threshold** - default 80%, adjustable in inputs
- **Smart triggering** - only moves SL once per position
- **Toggle control** - enable/disable on-the-fly

### 📊 Position Sizing Options
- **Risk-based sizing** - calculates lots based on account risk percentage
- **Static sizing** - fixed lot size independent of account balance
- **On-the-fly toggling** - switch between modes anytime
- **Real-time display** - shows current sizing mode and lot size

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
- **Static Position Sizing** - Fixed lot size option
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

### Static Sizing Configuration
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `StaticLotSize` | double | 0.01 | Fixed lot size when static sizing enabled |

### Breakeven on TP% Configuration
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `EnableBreakevenOnTPPercent` | bool | false | Enable auto breakeven at TP percentage |
| `BreakevenOnTPPercent` | double | 80.0 | Percentage of TP to trigger breakeven |

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

### Control Panel Layout v1.09
┌─────────────────────────────────┐
│ BUY STOP BUY LIMIT MARKET │
│ SELL STOP SELL LIMIT │
│ AUTOPILOT (SELECT BIAS) │
│ AI LONG AI SHORT │
│ SCALE IN: OFF ENABLE CLOSE ALL │
│ CLOSE ALL │
│ CLICK SET SL: OFF USE CLICK SL │
│ USE STATIC SIZING: OFF │
│ BREAKEVEN ON TP%: OFF │
├─────────────────────────────────┤
│ Autopilot: OFF | Bias: NONE │
│ Clicked SL: Not Set │
│ Static Sizing: OFF (0.01 lots) │
│ Breakeven on TP%: OFF (80%) │
│ Bid: 1.23456 | Ask: 1.23459 │
│ Spread: 3 pts (0.00003) │
│ Prev Bar: H=1.23500 L=1.23300 │
│ Risk: 0.1% ($10.00) │
│ Position: None │
│ Status: Ready │
│ Bar closes in: 02:30 │
├─────────────────────────────────┤
│ Instant SL Adjustment │
│ Reverse On Failure │
└─────────────────────────────────┘
[████████░░░░░░░░░░] 40% (Progress Bar)
Avg Price: 1.23456 (2 positions)


### Button Functions

| Button | Function |
|--------|----------|
| **BUY STOP** | Places buy stop above previous bar high |
| **SELL STOP** | Places sell stop below previous bar low |
| **BUY LIMIT** | Places buy limit at previous bar low |
| **SELL LIMIT** | Places sell limit at previous bar high |
| **MARKET** | Places market order with current bias |
| **AUTOPILOT** | Toggles automated trading mode |
| **AI LONG** | Sets bias to LONG |
| **AI SHORT** | Sets bias to SHORT |
| **SCALE IN** | Toggles multiple position capability |
| **ENABLE CLOSE ALL** | Safety toggle for Close All |
| **CLOSE ALL** | Closes all positions (when enabled) |
| **CLICK SET SL** | Enables click-to-set SL mode |
| **USE CLICK SL** | Toggles usage of clicked SL price |
| **USE STATIC SIZING** | Toggles between static and risk-based sizing |
| **BREAKEVEN ON TP%** | Toggles automatic breakeven feature |
| **Instant SL Adjustment** | Adjusts SL to previous bar levels |
| **Reverse On Failure** | Adjusts SL and places reverse order |

## 🎯 How to Use Key Features

### Click-to-Set Stop Loss
1. **Select bias** - Choose AI LONG or AI SHORT
2. **Enable Click SL** - Click "CLICK SET SL: OFF" button
3. **Click on chart** - Click any bar to set SL price
4. **Confirm** - Orange dashed line appears at your SL
5. **Toggle usage** - Use "USE CLICK SL" to enable/disable
6. **Trade** - Place your order - it will use your clicked SL

### Automatic Breakeven
1. **Enable feature** - Click "BREAKEVEN ON TP%: OFF" button
2. **Set threshold** - Configure via input (default 80%)
3. **Place trade** - Ensure TP is set on your order
4. **Let it run** - EA automatically moves SL to breakeven when threshold reached
5. **Monitor** - Check info panel for current status

### Static Lot Sizing
1. **Configure** - Set `StaticLotSize` in inputs (default 0.01)
2. **Toggle on** - Click "USE STATIC SIZING: OFF" button
3. **Confirm** - Info panel shows "Static Sizing: ON (0.01 lots)"
4. **Trade** - All orders use fixed lot size
5. **Toggle off** - Click again to return to risk-based sizing

## 🔧 Compatibility

- **Platform**: MetaTrader 5
- **Symbols**: All forex pairs, metals, indices, commodities
- **Timeframes**: All timeframes supported (M1 to MN1)
- **Brokers**: Compatible with all MT5 brokers

## 📈 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.09 | 2026 | Added Static Lot Sizing, Click-to-Set SL, Breakeven on TP%, UI layout fixes |
| 1.08 | 2026 | Optimized position sizing, improved gold calculations |
| 1.07 | 2026 | Added timer enhancements, progress bar, sound alerts |
| 1.06 | 2026 | Added bar close countdown timer, enhanced Instant SL |
| 1.05 | 2026 | Initial release with core functionality |

## ⚠️ Risk Disclaimer

Trading forex and CFDs carries a high level of risk and may not be suitable for all investors. Before using this EA, ensure you understand the risks involved. Past performance does not guarantee future results. Always test on a demo account first.

## 📝 License

Copyright © 2026 Malcom T Musonza. All rights reserved.

---

<div align="center">
**Happy Trading!** 📈
</div>
