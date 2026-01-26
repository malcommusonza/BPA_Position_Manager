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
