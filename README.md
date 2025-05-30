# PySide6 + QML Demo Project

A demonstration project showcasing PySide6 integration with QML for creating modern, cross-platform GUI applications.

## Features

- **Python-QML Integration**: Seamless communication between Python backend and QML frontend
- **Signal/Slot Mechanism**: Real-time updates between Python and QML
- **Modern UI**: Beautiful, responsive QML interface with animations
- **Cross-Platform**: Runs on Linux, Windows, and macOS

## Project Structure

```bash
./
├── main.py          # Python application entry point
├── main.qml         # QML user interface
├── requirements.txt # Python dependencies
└── README.md        # This file
```

## Installation

1. Make sure you have Python 3.7+ installed
2. Install PySide6:

   ```bash
   pip install -r requirements.txt
   ```

   Or directly:

   ```bash
   pip install PySide6
   ```

## Running the Application

```bash
python main.py
```

## What This Demo Shows

### Python Side (`main.py`)

- **Backend Class**: A QObject that exposes properties and methods to QML
- **Signal/Slot System**: Communication mechanism between Python and QML
- **Property Binding**: Automatic UI updates when Python data changes
- **QML Registration**: Making Python classes available in QML

### QML Side (`main.qml`)

- **Modern UI Components**: Using QtQuick.Controls 2.15
- **Layout Management**: Responsive design with ColumnLayout and RowLayout
- **Animations**: Smooth transitions and visual feedback
- **Event Handling**: Button clicks and text input processing
- **Data Binding**: Automatic updates from Python backend

## Key Concepts Demonstrated

1. **Two-Way Communication**:
   - Python can update QML properties
   - QML can call Python methods (slots)

2. **Property System**:
   - Python properties with change notifications
   - Automatic UI updates when data changes

3. **Modern QML UI**:
   - Material Design inspired interface
   - Smooth animations and transitions
   - Responsive layout

## Requirements

- Python 3.7+
- PySide6

## License

This is a demo project for educational purposes.
