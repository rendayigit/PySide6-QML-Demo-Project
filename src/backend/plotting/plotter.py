"""
Plotting System - variable plotting functionality

This module provides a plotting system for visualizing variables
with support for multiple variables, real-time updates, and proper
data management.
"""

from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass, field
from PySide6.QtWidgets import QWidget, QVBoxLayout
from PySide6.QtCore import QObject, Signal, Slot, Property
from PySide6.QtGui import QCloseEvent
import pyqtgraph as pg


@dataclass
class PlotData:
    """Container for plot data with metadata"""

    x_data: List[float] = field(default_factory=list)
    y_data: List[float] = field(default_factory=list)
    variable_path: str = ""
    display_name: str = ""
    color: Tuple[int, int, int] = (255, 255, 255)
    max_points: int = 1000


class GenericPlotter(QWidget):
    """
    Generic plotter for real-time variable visualization

    Features:
    - Multiple variable support with automatic color assignment
    - Data point limiting for performance
    - Dynamic axis scaling
    - Legend management
    - Thread-safe operations
    """

    # Qt signals for communication
    plotClosed = Signal(str)  # plot_id

    # Predefined color palette for consistent visualization
    COLOR_PALETTE = [
        (255, 0, 0),  # Red
        (0, 255, 0),  # Green
        (0, 0, 255),  # Blue
        (255, 255, 0),  # Yellow
        (255, 0, 255),  # Magenta
        (0, 255, 255),  # Cyan
        (255, 128, 0),  # Orange
        (128, 0, 255),  # Purple
        (0, 128, 255),  # Light Blue
        (255, 0, 128),  # Pink
        (128, 255, 0),  # Lime
        (255, 128, 128),  # Light Red
    ]

    def __init__(self, plot_id: str, title: str = "Variable Plot", xlabel: str = "Time", ylabel: str = "Value", max_data_points: int = 1000):
        """
        Initialize the plotter

        Args:
            plot_id: Unique identifier for this plot
            title: Plot window title
            xlabel: X-axis label
            ylabel: Y-axis label
            max_data_points: Maximum number of data points to retain
        """
        super().__init__()

        self.plot_id = plot_id
        self.max_data_points = max_data_points
        self.plot_data: Dict[str, PlotData] = {}
        self.plot_lines: Dict[str, pg.PlotDataItem] = {}
        self.color_index = 0
        self.auto_scale = True
        self.time_window = 60.0  # Default to 60 seconds visible window
        self.current_theme = "light"  # Track current theme

        self._setup_ui(title, xlabel, ylabel)

    def _setup_ui(self, title: str, xlabel: str, ylabel: str):
        """Setup the user interface"""
        self.setWindowTitle(title)
        self.setGeometry(100, 100, 800, 600)

        # Central widget and layout
        self.main_layout = QVBoxLayout()
        self.setLayout(self.main_layout)

        # Plot widget with proper configuration
        self.plot_widget = pg.PlotWidget(title=title)
        self.plot_widget.setLabel("bottom", xlabel)
        self.plot_widget.setLabel("left", ylabel)
        self.plot_widget.showGrid(x=True, y=True, alpha=0.3)
        self.plot_widget.addLegend()

        # Enable mouse interaction
        self.plot_widget.enableAutoRange(enable=True)
        self.plot_widget.setMouseEnabled(x=False, y=False)

        # Apply initial theme
        self._apply_theme()

        self.main_layout.addWidget(self.plot_widget)

    def add_variable(self, variable_path: str, display_name: Optional[str] = None) -> bool:
        """
        Add a new variable to the plot

        Args:
            variable_path: Unique path identifier for the variable
            display_name: Human-readable name for legend (defaults to variable_path)

        Returns:
            True if variable was added, False if already exists
        """
        if variable_path in self.plot_data:
            return False

        # Setup plot data
        color = self.COLOR_PALETTE[self.color_index % len(self.COLOR_PALETTE)]
        plot_data = PlotData(variable_path=variable_path, display_name=display_name or variable_path, color=color, max_points=self.max_data_points)

        # Create plot line
        pen = pg.mkPen(color=color, width=2)
        line = self.plot_widget.plot(pen=pen, name=plot_data.display_name)

        # Store references
        self.plot_data[variable_path] = plot_data
        self.plot_lines[variable_path] = line
        self.color_index += 1

        return True

    def remove_variable(self, variable_path: str) -> bool:
        """
        Remove a variable from the plot

        Args:
            variable_path: Path of variable to remove

        Returns:
            True if variable was removed, False if not found
        """
        if variable_path not in self.plot_data:
            return False

        # Remove plot line
        self.plot_widget.removeItem(self.plot_lines[variable_path])

        # Clean up data
        del self.plot_data[variable_path]
        del self.plot_lines[variable_path]

        return True

    def update_variable(self, variable_path: str, time_value: float, data_value: float):
        """
        Update variable data with new time/value pair

        Args:
            variable_path: Path of variable to update
            time_value: Time/X coordinate value
            data_value: Data/Y coordinate value
        """
        if variable_path not in self.plot_data:
            return

        plot_data = self.plot_data[variable_path]

        # Add new data point
        plot_data.x_data.append(time_value)
        plot_data.y_data.append(data_value)

        # Limit data points for performance - keep sliding window
        if len(plot_data.x_data) > plot_data.max_points:
            plot_data.x_data = plot_data.x_data[-plot_data.max_points :]
            plot_data.y_data = plot_data.y_data[-plot_data.max_points :]

        # Update plot line
        line = self.plot_lines[variable_path]
        line.setData(plot_data.x_data, plot_data.y_data)

        # Auto-scale based on visible time window, not all data
        if self.auto_scale:
            self._update_time_window_scale()

    def _update_time_window_scale(self):
        """Update plot scaling based on recent time window for consistent resolution"""
        if not self.plot_data:
            return

        # Get the latest time from any variable
        latest_times = []
        for plot_data in self.plot_data.values():
            if plot_data.x_data:
                latest_times.append(max(plot_data.x_data))

        if not latest_times:
            return

        current_time = max(latest_times)

        # Use configurable time window for consistent resolution
        window_start = current_time - self.time_window

        # Collect data points within the time window
        window_y_values = []

        for plot_data in self.plot_data.values():
            for i, x_val in enumerate(plot_data.x_data):
                if x_val >= window_start:
                    window_y_values.append(plot_data.y_data[i])

        if not window_y_values:
            return

        # Calculate Y range with padding
        y_min, y_max = min(window_y_values), max(window_y_values)
        y_range = y_max - y_min if y_max != y_min else 1.0
        y_padding = y_range * 0.05  # 5% padding

        # Set fixed time window and calculated Y range
        self.plot_widget.setXRange(window_start, current_time)
        self.plot_widget.setYRange(y_min - y_padding, y_max + y_padding)

    def get_variable_list(self) -> List[str]:
        """Get list of currently plotted variables"""
        return list(self.plot_data.keys())

    def set_auto_scale(self, enabled: bool):
        """Enable or disable automatic scaling"""
        self.auto_scale = enabled
        if enabled:
            self._update_time_window_scale()

    def set_time_window(self, seconds: float):
        """Set the visible time window in seconds"""
        self.time_window = max(1.0, seconds)  # Minimum 1 second
        if self.auto_scale:
            self._update_time_window_scale()

    def closeEvent(self, event: QCloseEvent):
        """Handle window close event"""
        self.plotClosed.emit(self.plot_id)
        super().closeEvent(event)

    def _apply_theme(self):
        """Apply theme colors to the plot"""
        if self.current_theme == "dark":
            # Dark theme colors
            bg_color = "#242424"
            fg_color = "#ffffff"
        else:
            # Light theme colors
            bg_color = "#fafafa"
            fg_color = "#000000"

        # Set plot widget background
        self.plot_widget.setBackground(bg_color)

        # Set axis colors
        self.plot_widget.getAxis("bottom").setPen(fg_color)
        self.plot_widget.getAxis("left").setPen(fg_color)
        self.plot_widget.getAxis("bottom").setTextPen(fg_color)
        self.plot_widget.getAxis("left").setTextPen(fg_color)

        # Update grid color
        self.plot_widget.showGrid(x=True, y=True, alpha=0.3)

    def set_theme(self, theme: str):
        """Set the plot theme (light/dark)"""
        if theme in ["light", "dark"]:
            self.current_theme = theme
            self._apply_theme()


class PlotManager(QObject):
    """
    Plot manager for handling multiple plot windows

    Manages creation, destruction, and data routing for multiple plot windows.
    Thread-safe operations for real-time data updates.
    """

    # Signals
    plotCreated = Signal(str)  # plot_id
    plotClosed = Signal(str)  # plot_id

    def __init__(self):
        super().__init__()
        self.plots: Dict[str, GenericPlotter] = {}
        self.plot_titles: Dict[str, str] = {}  # Track plot titles
        self.next_plot_id = 1
        self.current_theme = "light"  # Track current theme

    @Slot(list, str, str, str, result=str)
    def create_plot(self, variable_paths: List[str], title: str = "", xlabel: str = "Time", ylabel: str = "Value") -> str:
        """
        Create a new plot window with specified variables

        Args:
            variable_paths: List of variable paths to plot
            title: Plot title (auto-generated if empty)
            xlabel: X-axis label
            ylabel: Y-axis label

        Returns:
            plot_id: Unique identifier for the created plot
        """
        plot_id = f"plot_{self.next_plot_id}"
        self.next_plot_id += 1

        # Generate title if not provided
        if not title:
            if len(variable_paths) == 1:
                # Use just the variable name (last part after dot)
                var_name = variable_paths[0].split(".")[-1] if "." in variable_paths[0] else variable_paths[0]
                title = f"Plot: {var_name}"
            else:
                # Show all variable names
                var_names = []
                for path in variable_paths:
                    var_name = path.split(".")[-1] if "." in path else path
                    var_names.append(var_name)
                title = f"Plot: {', '.join(var_names)}"

        # Create plotter window
        plotter = GenericPlotter(plot_id=plot_id, title=title, xlabel=xlabel, ylabel=ylabel)

        # Set theme
        plotter.set_theme(self.current_theme)

        # Add variables
        for var_path in variable_paths:
            plotter.add_variable(var_path)

        # Connect signals
        plotter.plotClosed.connect(self._on_plot_closed)

        # Store and show
        self.plots[plot_id] = plotter
        self.plot_titles[plot_id] = title  # Store the title
        plotter.show()

        self.plotCreated.emit(plot_id)
        return plot_id

    @Slot(str)
    def close_plot(self, plot_id: str):
        """Close a specific plot"""
        if plot_id in self.plots:
            self.plots[plot_id].close()

    @Slot()
    def close_all_plots(self):
        """Close all open plots"""
        for plot in list(self.plots.values()):
            plot.close()

    @Slot(str, float, float)
    def update_variable_data(self, variable_path: str, time_value: float, data_value: float):
        """
        Update variable data across all plots

        Args:
            variable_path: Path of variable to update
            time_value: Time/X coordinate
            data_value: Data/Y coordinate value
        """
        for plotter in self.plots.values():
            if variable_path in plotter.get_variable_list():
                plotter.update_variable(variable_path, time_value, data_value)

    def _on_plot_closed(self, plot_id: str):
        """Handle plot window closure"""
        if plot_id in self.plots:
            del self.plots[plot_id]
            if plot_id in self.plot_titles:
                del self.plot_titles[plot_id]
            self.plotClosed.emit(plot_id)

    def get_active_plots(self) -> List[str]:
        """Get list of active plot IDs"""
        return list(self.plots.keys())

    @Property(int, notify=plotCreated)
    def plot_count(self) -> int:
        """Number of active plots"""
        return len(self.plots)

    @Slot(result=list)
    def get_plot_info_list(self) -> List[Dict[str, str]]:
        """Get list of plots with their IDs and titles"""
        plot_info = []
        for plot_id in self.plots:
            title = self.plot_titles.get(plot_id, f"Plot {plot_id}")
            plot_info.append({"plot_id": plot_id, "title": title})
        return plot_info

    @Slot(str)
    def set_theme(self, theme: str):
        """Set theme for all plots"""
        if theme in ["light", "dark"]:
            self.current_theme = theme
            # Update all existing plots
            for plotter in self.plots.values():
                plotter.set_theme(theme)
