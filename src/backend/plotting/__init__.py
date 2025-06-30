"""
Plotting Backend Integration

This module integrates the plotting system with the main backend,
providing seamless data flow from variables to plots.
"""

from typing import Dict, Any, Optional
from PySide6.QtCore import QObject, Signal, Slot, QTimer, Property
from .plotter import PlotManager


class PlottingBackend(QObject):
    """
    Backend integration for plotting system

    Handles the integration between the main backend data system
    and the plotting subsystem, managing data flow and plot lifecycle.
    """

    # Signals
    plotRequested = Signal(list)  # variable_paths

    def __init__(self, plot_manager: Optional[PlotManager] = None):
        super().__init__()

        # Initialize plot manager
        self.plot_manager = plot_manager or PlotManager()

        # Current simulation time for X-axis
        self._current_time = 0.0

        # Track variable data for plotting
        self._variable_data: Dict[str, Any] = {}

    @Property(QObject, constant=True)
    def plot_manager_object(self) -> QObject:
        """Expose plot manager for QML signal connections"""
        return self.plot_manager

    @Slot(list, str, str, str, result=str)
    def create_plot(self, variable_paths: list, title: str = "", xlabel: str = "Time", ylabel: str = "Value") -> str:
        """
        Create a new plot with specified variables

        Args:
            variable_paths: List of variable paths to plot
            title: Plot title
            xlabel: X-axis label
            ylabel: Y-axis label

        Returns:
            plot_id: Unique identifier for created plot
        """
        return self.plot_manager.create_plot(variable_paths, title, xlabel, ylabel)

    @Slot(str)
    def close_plot(self, plot_id: str):
        """Close a specific plot"""
        self.plot_manager.close_plot(plot_id)

    @Slot()
    def close_all_plots(self):
        """Close all plots"""
        self.plot_manager.close_all_plots()

    def update_simulation_time(self, time_value: float):
        """
        Update current simulation time

        Args:
            time_value: Current simulation time
        """
        self._current_time = time_value

    def update_variable_value(self, variable_path: str, value: Any):
        """
        Update variable value and propagate to plots

        Args:
            variable_path: Path of the variable
            value: New value (will be converted to float for plotting)
        """
        # Store the value
        self._variable_data[variable_path] = value

        # Convert value to float for plotting
        try:
            if isinstance(value, (int, float)):
                float_value = float(value)
            elif isinstance(value, str):
                # Try to parse string as number
                float_value = float(value)
            else:
                # For complex types, try to extract numeric value
                float_value = float(str(value))

            # Update plots with new data
            self.plot_manager.update_variable_data(variable_path, self._current_time, float_value)

        except (ValueError, TypeError):
            # Skip non-numeric values
            pass

    @Slot(str, result="QVariant")
    def get_variable_value(self, variable_path: str):
        """Get current value of a variable"""
        return self._variable_data.get(variable_path, None)

    @Slot(result=list)
    def get_active_plots(self) -> list:
        """Get list of active plot IDs"""
        return self.plot_manager.get_active_plots()

    @Slot(result=int)
    def get_plot_count(self) -> int:
        """Get number of active plots"""
        return len(self.plot_manager.plots)

    @Slot(str)
    def set_theme(self, theme: str):
        """Set theme for all plots"""
        self.plot_manager.set_theme(theme)

    @Slot(result=list)
    def get_plot_info_list(self) -> list:
        """Get list of plots with their IDs and titles"""
        return self.plot_manager.get_plot_info_list()
