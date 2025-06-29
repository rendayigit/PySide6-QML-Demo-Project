# Plotting System Documentation

## Overview

The plotting system provides robust real-time visualization of simulation variables with the following features:

- **Multiple Variable Support**: Plot multiple variables on the same chart with automatic color assignment
- **Real-time Updates**: Seamlessly updates plots as simulation data changes
- **Performance Optimized**: Limits data points to maintain smooth performance (default: 1000 points)
- **Interactive Plots**: Full mouse controls for zooming, panning, and exploring data
- **Context Menu Integration**: Right-click variables in the Variable Table to create plots
- **Plot Management**: Dedicated Plot Manager window for managing multiple plots

## Architecture

### Components

1. **PlotManager**: Central coordinator for multiple plot windows
2. **GenericPlotter**: Individual plot window with pyqtgraph visualization
3. **PlottingBackend**: Integration layer between data system and plots
4. **PlotWindow**: QML interface for plot management

### Data Flow

```
Variable Updates → Backend → PlottingBackend → PlotManager → GenericPlotter → pyqtgraph
```

## Usage

### Creating Plots

#### From Variable Table Context Menu:
1. Select one or more variables in the Variable Table
2. Right-click to open context menu
3. Select "Plot Selection (N)" to create a new plot

#### From Plot Manager:
1. Open Plot Manager from "Variable Display" → "Plot Manager" menu
2. Use the interface to manage existing plots

#### Programmatically:
```python
# Create plot through backend
plot_id = backend.plotting.create_plot(
    variable_paths=["var1", "var2"], 
    title="My Plot",
    xlabel="Time", 
    ylabel="Value"
)
```

### Plot Features

- **Auto-scaling**: Automatically adjusts axes to fit all data
- **Legend**: Shows variable names with color coding
- **Grid**: Optional grid lines for easier reading
- **Zoom/Pan**: Mouse controls for detailed inspection
- **Data Limiting**: Keeps only recent data points for performance

### Plot Management

- **Multiple Plots**: Create unlimited number of plot windows
- **Close Individual**: Close specific plots via Plot Manager
- **Close All**: Bulk close all open plots
- **Real-time Updates**: All plots update automatically with simulation data

## Implementation Details

### Performance Considerations

- **Data Point Limiting**: Each variable limited to 1000 points by default
- **Efficient Updates**: Only redraws when data changes
- **Color Palette**: Pre-defined 12-color palette with cycling
- **Memory Management**: Automatic cleanup when plots are closed

### Thread Safety

- All plot operations are thread-safe
- Updates can be called from any thread
- Qt signals ensure proper thread communication

### Error Handling

- Graceful handling of non-numeric data
- Automatic conversion of string numbers
- Silent failure for incompatible data types

## Configuration

### Default Settings

```python
max_data_points = 1000      # Maximum points per variable
auto_scale = True           # Automatic axis scaling
grid = True                 # Show grid lines
legend = True               # Show legend
```

### Color Palette

The system uses a 12-color palette that cycles:
- Red, Green, Blue, Yellow, Magenta, Cyan
- Orange, Purple, Light Blue, Pink, Lime, Light Red

## API Reference

### PlotManager Methods

```python
create_plot(variable_paths: List[str], title: str, xlabel: str, ylabel: str) -> str
close_plot(plot_id: str)
close_all_plots()
update_variable_data(variable_path: str, time_value: float, data_value: float)
get_active_plots() -> List[str]
```

### PlottingBackend Methods

```python
create_plot(variable_paths: list, title: str, xlabel: str, ylabel: str) -> str
close_plot(plot_id: str)
close_all_plots()
update_simulation_time(time_value: float)
update_variable_value(variable_path: str, value: Any)
```

## Troubleshooting

### Common Issues

1. **Plot Not Updating**: Ensure simulation is running and variables are receiving data
2. **No Plot Window**: Check that QApplication (not QGuiApplication) is used
3. **Performance Issues**: Reduce max_data_points if plotting many variables
4. **Memory Issues**: Close unused plots to free resources

### Dependencies

- PySide6 (QtWidgets required, not just QtGui)
- pyqtgraph
- numpy (indirect dependency via pyqtgraph)

### Logging

The system logs plot creation and closure events:
```
qml: Creating plot for variables: [var1, var2]
qml: Created plot with ID: plot_1
```
