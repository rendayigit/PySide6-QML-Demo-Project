"""
Main Backend Module

This module contains the main Backend class that serves as the interface
between the QML frontend and the Python backend systems.
"""

from typing import Optional
from PySide6.QtCore import QObject, Signal, Property, Slot, QSettings
from PySide6.QtGui import QGuiApplication, QPalette, QColor

from .data_manager import DataManager
from .json_formatter import JSONFormatter
from ..communication.subscriber import ZMQSubscriber
from ..communication.commanding import SimulationCommander


class Backend(QObject):
    """
    Main backend class for the Galactron UI application

    This class serves as the central coordinator between the QML frontend
    and the various backend subsystems including data management,
    communication, and command execution.

    Implements SubscriberCallbacks protocol for ZMQ subscriber communication.
    """

    # Signals to notify QML of changes
    simulationTimeChanged = Signal(str)
    missionTimeChanged = Signal(str)
    epochTimeChanged = Signal(str)
    zuluTimeChanged = Signal(str)
    simulationStatusChanged = Signal(bool)
    statusTextChanged = Signal(str)
    eventLogReceived = Signal(str, str)  # level, message

    # Data management signals
    modelTreeUpdated = Signal(list)
    variableAdded = Signal("QVariant")
    variableUpdated = Signal(str, "QVariant")  # variable path, variable data
    variableRemoved = Signal(str)  # variable path
    variablesCleared = Signal()

    # Theme management signals
    themeChanged = Signal(str)  # theme name

    def __init__(self):
        """Initialize the backend with all subsystems"""
        super().__init__()

        # Time and status properties
        self._simulation_time = "-"
        self._mission_time = "-"
        self._epoch_time = "-"
        self._zulu_time = "-"
        self._is_running = False
        self._status_text = "Simulator ready"

        # Theme properties
        self._current_theme = "auto"
        self._is_system_dark = False

        # Initialize subsystems
        self._data_manager = DataManager()
        self._json_formatter = JSONFormatter()
        self._subscriber: Optional[ZMQSubscriber] = None
        self._commander: Optional[SimulationCommander] = None

        # Connect data manager signals to backend signals
        self._connect_data_manager_signals()

        # Initialize theme settings
        self._settings = QSettings("Galactron", "GalactronApp")
        self._load_and_apply_theme()

    def _connect_data_manager_signals(self) -> None:
        """Connect data manager signals to backend signals for QML"""
        self._data_manager.variableAdded.connect(self._on_variable_added)
        self._data_manager.variableUpdated.connect(self._on_variable_updated)
        self._data_manager.variableRemoved.connect(self._on_variable_removed)
        self._data_manager.variablesCleared.connect(self._on_variables_cleared)
        self._data_manager.modelTreeUpdated.connect(self._on_model_tree_updated)

    # QML Property definitions
    @Property(str, notify=simulationTimeChanged)
    def simulation_time(self) -> str:
        """Current simulation time"""
        return self._simulation_time

    @Property(str, notify=missionTimeChanged)
    def mission_time(self) -> str:
        """Current mission time"""
        return self._mission_time

    @Property(str, notify=epochTimeChanged)
    def epoch_time(self) -> str:
        """Current epoch time"""
        return self._epoch_time

    @Property(str, notify=zuluTimeChanged)
    def zulu_time(self) -> str:
        """Current Zulu (UTC) time"""
        return self._zulu_time

    @Property(bool, notify=simulationStatusChanged)
    def is_running(self) -> bool:
        """Whether simulation is currently running"""
        return self._is_running

    @Property(str, notify=statusTextChanged)
    def status_text(self) -> str:
        """Current status text"""
        return self._status_text

    # Property setters
    def set_simulation_time(self, value: str) -> None:
        """Set simulation time and emit change signal"""
        if self._simulation_time != value:
            self._simulation_time = value
            self.simulationTimeChanged.emit(value)

    def set_mission_time(self, value: str) -> None:
        """Set mission time and emit change signal"""
        if self._mission_time != value:
            self._mission_time = value
            self.missionTimeChanged.emit(value)

    def set_epoch_time(self, value: str) -> None:
        """Set epoch time and emit change signal"""
        if self._epoch_time != value:
            self._epoch_time = value
            self.epochTimeChanged.emit(value)

    def set_zulu_time(self, value: str) -> None:
        """Set Zulu time and emit change signal"""
        if self._zulu_time != value:
            self._zulu_time = value
            self.zuluTimeChanged.emit(value)

    def set_simulation_status(self, is_running: bool) -> None:
        """Set simulation status and emit change signal"""
        if self._is_running != is_running:
            self._is_running = is_running
            self.simulationStatusChanged.emit(is_running)

    # TODO: Use only to display simulator states
    def set_status_text(self, value: str) -> None:
        """Set status text and emit change signal"""
        if self._status_text != value:
            self._status_text = value
            self.statusTextChanged.emit(value)

    # Subsystem management
    def start_subscriber(self) -> None:
        """Start the ZMQ subscriber"""
        try:
            self._subscriber = ZMQSubscriber(self)
            self._subscriber.start()
            print("ZMQ Subscriber started")
        except Exception as e:
            print(f"Failed to start subscriber: {e}")
            self.send_event_log("ERROR", f"Failed to start subscriber: {str(e)}")

    def stop_subscriber(self) -> None:
        """Stop the ZMQ subscriber"""
        if self._subscriber:
            self._subscriber.stop()
            self._subscriber = None
            print("ZMQ Subscriber stopped")

    def get_commanding_instance(self) -> SimulationCommander:
        """Get or create commanding instance"""
        if self._commander is None:
            self._commander = SimulationCommander()
        return self._commander

    # Service lifecycle management
    def start_services(self) -> None:
        """Start all backend services"""
        try:
            # Start ZMQ subscriber for real-time data
            self.start_subscriber()

            # Request initial model tree
            self.request_model_tree()

            # Request initial status
            self.verify_simulation_status()

            print("All backend services started successfully")
            print("Backend services running")

        except Exception as e:
            error_msg = f"Failed to start backend services: {e}"
            print(error_msg)
            self.send_event_log("ERROR", error_msg)
            print("Backend service error")

    def stop_services(self) -> None:
        """Stop all backend services"""
        try:
            self.cleanup()
            print("All backend services stopped")
        except Exception as e:
            print(f"Error stopping services: {e}")

    # SubscriberCallbacks implementation
    def update_all_times(self, sim_time: str, mission_time: str, epoch_time: str, zulu_time: str) -> None:
        """Called by subscriber when TIME topic is received"""
        self.set_simulation_time(sim_time)
        self.set_mission_time(mission_time)
        self.set_epoch_time(epoch_time)
        self.set_zulu_time(zulu_time)

    def update_simulation_status(self, is_running: bool) -> None:
        """Called by subscriber when STATUS topic is received"""
        self.set_simulation_status(is_running)

    # TODO: Manage calls from gui
    def send_event_log(self, level: str, message: str) -> None:
        """Called by subscriber to send event log to GUI"""
        # Format JSON in the message if it contains JSON
        formatted_message = self._json_formatter.format_message_for_display(message)
        self.eventLogReceived.emit(level, formatted_message)

    def update_fields(self, fields_data: list) -> None:
        """Called by subscriber to handle FIELDS topic - individual field variables"""
        # Update watched variables with new values
        self._data_manager.update_fields_data(fields_data)

    def update_model_tree(self, tree_data: dict) -> None:
        """Called by subscriber to update model tree from MODEL_TREE topic"""
        self._data_manager.update_model_tree(tree_data)

    # Data manager signal handlers
    def _on_variable_added(self, variable_data) -> None:
        """Forward variable added signal to QML"""
        self.variableAdded.emit(variable_data)

    def _on_variable_updated(self, variable_path: str, variable_data) -> None:
        """Forward variable updated signal to QML"""
        self.variableUpdated.emit(variable_path, variable_data)

    def _on_variable_removed(self, variable_path: str) -> None:
        """Forward variable removed signal to QML"""
        self.variableRemoved.emit(variable_path)

    def _on_variables_cleared(self) -> None:
        """Forward variables cleared signal to QML"""
        self.variablesCleared.emit()

    def _on_model_tree_updated(self, tree_items) -> None:
        """Forward model tree updated signal to QML"""
        self.modelTreeUpdated.emit(tree_items)

    # QML-callable variable management methods
    @Slot(str, str, result=bool)
    def add_variable_to_watch(self, variable_path: str, description: str = "") -> bool:
        """QML-callable method to add a variable to the watch list"""
        result = self._data_manager.add_variable_to_watch(variable_path, description)
        return result

    @Slot(str, result=bool)
    def remove_variable_from_watch(self, variable_path: str) -> bool:
        """QML-callable method to remove a variable from the watch list"""
        return self._data_manager.remove_variable_from_watch(variable_path)

    @Slot(result=bool)
    def clear_variable_table(self) -> bool:
        """QML-callable method to clear all variables from the watch list"""
        return self._data_manager.clear_variable_table()

    # QML-callable command methods
    @Slot(result=bool)
    def run_simulation(self) -> bool:
        """QML-callable method to run the simulation"""
        try:
            commander = self.get_commanding_instance()
            response = commander.run_simulation()

            print(f"RUN command successful: {response}")
            self.send_event_log("INFO", "RUN command sent to engine")

            # Request status update after command
            self.verify_simulation_status()
            return True

        except Exception as e:
            error_msg = f"RUN command failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", error_msg)
            return False

    @Slot(result=bool)
    def hold_simulation(self) -> bool:
        """QML-callable method to hold the simulation"""
        try:
            commander = self.get_commanding_instance()
            response = commander.hold_simulation()

            print(f"HOLD command successful: {response}")
            self.send_event_log("INFO", "HOLD command sent to engine")

            # Request status update after command
            self.verify_simulation_status()
            return True

        except Exception as e:
            error_msg = f"HOLD command failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", error_msg)
            return False

    @Slot(result=bool)
    def step_simulation(self) -> bool:
        """QML-callable method to step the simulation"""
        try:
            commander = self.get_commanding_instance()
            response = commander.step_simulation()

            print(f"STEP command successful: {response}")
            self.send_event_log("INFO", "STEP command sent to engine")

            # Request status update after command
            self.verify_simulation_status()
            return True

        except Exception as e:
            error_msg = f"STEP command failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", error_msg)
            return False

    @Slot(result=bool)
    def toggle_simulation(self) -> bool:
        """QML-callable method to toggle simulation run/hold state"""
        if self._is_running:
            return self.hold_simulation()
        else:
            return self.run_simulation()

    @Slot(str, result=bool)
    def progress_simulation(self, total_milliseconds: str) -> bool:
        """QML-callable method to progress the simulation by specified time"""
        try:
            # Convert string to int for commander
            milliseconds_int = int(total_milliseconds)
            
            commander = self.get_commanding_instance()
            response = commander.progress_simulation(milliseconds_int)

            print(f"PROGRESS command successful: {response}")
            self.send_event_log("INFO", f"PROGRESS command sent to engine with {total_milliseconds}ms")

            # Request status update after command
            self.verify_simulation_status()
            return True

        except ValueError:
            error_msg = f"Invalid milliseconds value: {total_milliseconds}"
            print(error_msg)
            self.send_event_log("ERROR", error_msg)
            return False
        except Exception as e:
            error_msg = f"PROGRESS command failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", error_msg)
            return False

    @Slot(float, result=bool)
    def set_simulation_rate(self, scale_value: float) -> bool:
        """QML-callable method to set the simulation rate scale"""
        try:
            commander = self.get_commanding_instance()
            response = commander.set_simulation_rate(scale_value)

            print(f"RATE command successful: {response}")
            self.send_event_log("INFO", f"RATE command sent to engine with scale {scale_value}")

            # Request status update after command
            self.verify_simulation_status()
            return True

        except Exception as e:
            error_msg = f"RATE command failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", error_msg)
            return False

    @Slot(result=bool)
    def request_model_tree(self) -> bool:
        """QML-callable method to request model tree from engine"""
        try:
            commander = self.get_commanding_instance()
            response = commander.request_model_tree()

            print(f"Model tree request successful: {response}")
            self.send_event_log("INFO", "Model tree requested from engine")
            return True

        except Exception as e:
            error_msg = f"Model tree request failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", error_msg)
            return False

    def verify_simulation_status(self) -> None:
        """Request status update from engine"""
        try:
            commander = self.get_commanding_instance()
            response = commander.request_status()

            print(f"STATUS command sent successfully: {response}")
            self.send_event_log("INFO", "Status update requested from engine")

        except Exception as e:
            error_msg = f"STATUS command failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", error_msg)

    def cleanup(self) -> None:
        """Cleanup all backend resources"""
        self.stop_subscriber()

        if self._commander:
            self._commander.cleanup()
            self._commander = None

        print("Backend cleanup completed")

    # Theme management properties
    @Property(str, notify=themeChanged)
    def current_theme(self) -> str:
        """Current theme setting (light, dark, auto)"""
        return self._current_theme

    @Property(bool)
    def is_system_dark(self) -> bool:
        """Whether the system is using dark mode"""
        return self._is_system_dark

    def _detect_system_theme(self) -> bool:
        """Detect if the system is using dark theme"""
        try:
            app = QGuiApplication.instance()
            if app:
                palette = app.palette()
                # Check if window background is dark
                bg_color = palette.color(QPalette.ColorRole.Window)
                return bg_color.lightness() < 128
        except Exception as e:
            print(f"Failed to detect system theme: {e}")
        return False

    def _load_and_apply_theme(self) -> None:
        """Load theme setting and apply it"""
        try:
            # Load saved theme preference with proper type handling
            theme_value = self._settings.value("theme", "auto")
            self._current_theme = str(theme_value) if theme_value else "auto"
            
            # Detect system theme
            self._is_system_dark = self._detect_system_theme()
            
            # Apply the theme
            self._apply_theme()
            
            print(f"Theme loaded: {self._current_theme}")
        except Exception as e:
            print(f"Failed to load theme: {e}")
            # Fallback to light theme
            self._current_theme = "light"
            self._apply_theme()

    def _apply_theme(self) -> None:
        """Apply the current theme"""
        try:
            app = QGuiApplication.instance()
            if not app:
                return

            # Determine which theme to actually use
            if self._current_theme == "auto":
                use_dark = self._is_system_dark
            elif self._current_theme == "dark":
                use_dark = True
            else:  # light
                use_dark = False

            palette = QPalette()

            if use_dark:
                # Dark theme colors
                palette.setColor(QPalette.ColorRole.Window, QColor(53, 53, 53))
                palette.setColor(QPalette.ColorRole.WindowText, QColor(255, 255, 255))
                palette.setColor(QPalette.ColorRole.Base, QColor(25, 25, 25))
                palette.setColor(QPalette.ColorRole.AlternateBase, QColor(53, 53, 53))
                palette.setColor(QPalette.ColorRole.ToolTipBase, QColor(255, 255, 255))
                palette.setColor(QPalette.ColorRole.ToolTipText, QColor(0, 0, 0))
                palette.setColor(QPalette.ColorRole.Text, QColor(255, 255, 255))
                palette.setColor(QPalette.ColorRole.Button, QColor(53, 53, 53))
                palette.setColor(QPalette.ColorRole.ButtonText, QColor(255, 255, 255))
                palette.setColor(QPalette.ColorRole.BrightText, QColor(255, 0, 0))
                palette.setColor(QPalette.ColorRole.Link, QColor(42, 130, 218))
                palette.setColor(QPalette.ColorRole.Highlight, QColor(42, 130, 218))
                palette.setColor(QPalette.ColorRole.HighlightedText, QColor(255, 255, 255))
            else:
                # Light theme colors
                palette.setColor(QPalette.ColorRole.Window, QColor(240, 240, 240))
                palette.setColor(QPalette.ColorRole.WindowText, QColor(0, 0, 0))
                palette.setColor(QPalette.ColorRole.Base, QColor(255, 255, 255))
                palette.setColor(QPalette.ColorRole.AlternateBase, QColor(233, 231, 227))
                palette.setColor(QPalette.ColorRole.ToolTipBase, QColor(255, 255, 220))
                palette.setColor(QPalette.ColorRole.ToolTipText, QColor(0, 0, 0))
                palette.setColor(QPalette.ColorRole.Text, QColor(0, 0, 0))
                palette.setColor(QPalette.ColorRole.Button, QColor(240, 240, 240))
                palette.setColor(QPalette.ColorRole.ButtonText, QColor(0, 0, 0))
                palette.setColor(QPalette.ColorRole.BrightText, QColor(255, 0, 0))
                palette.setColor(QPalette.ColorRole.Link, QColor(0, 0, 255))
                palette.setColor(QPalette.ColorRole.Highlight, QColor(48, 140, 198))
                palette.setColor(QPalette.ColorRole.HighlightedText, QColor(255, 255, 255))

            app.setPalette(palette)
            
            # Emit theme changed signal
            actual_theme = "dark" if use_dark else "light"
            self.themeChanged.emit(actual_theme)
            
        except Exception as e:
            print(f"Failed to apply theme: {e}")

    @Slot(str)
    def set_theme(self, theme: str) -> None:
        """Set application theme (light, dark, auto)"""
        try:
            if theme in ["light", "dark", "auto"] and theme != self._current_theme:
                self._current_theme = theme
                
                # Save to settings
                self._settings.setValue("theme", theme)
                
                # Re-detect system theme if auto mode
                if theme == "auto":
                    self._is_system_dark = self._detect_system_theme()
                
                # Apply the theme
                self._apply_theme()
                
                print(f"Theme changed to: {theme}")
                
        except Exception as e:
            print(f"Failed to set theme: {e}")

    # Theme management
    def _load_theme(self) -> None:
        """Load the application theme from settings (deprecated - use _load_and_apply_theme)"""
        # This method is deprecated but kept for compatibility
        pass
