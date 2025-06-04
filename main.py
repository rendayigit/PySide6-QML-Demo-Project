import sys
import os
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType
from PySide6.QtCore import QObject, Signal, Property
from subscriber import Subscriber

class Backend(QObject):
    """Backend class to handle communication between Python and QML"""
    
    # Signals to notify QML of changes
    simulationTimeChanged = Signal(str)
    simulationStatusChanged = Signal(bool)
    statusTextChanged = Signal(str)
    
    def __init__(self):
        super().__init__()
        self._simulation_time = "0.000"
        self._is_running = False
        self._status_text = "Simulator ready"
        self._subscriber = None
        
    @Property(str, notify=simulationTimeChanged)
    def simulationTime(self):
        return self._simulation_time
    
    @Property(bool, notify=simulationStatusChanged)
    def isRunning(self):
        return self._is_running
    
    @Property(str, notify=statusTextChanged)
    def statusText(self):
        return self._status_text
    
    def set_simulation_time(self, value):
        """Internal method to set simulation time"""
        if self._simulation_time != value:
            self._simulation_time = value
            self.simulationTimeChanged.emit(value)
    
    def set_simulation_status(self, value):
        """Internal method to set simulation running status"""
        if self._is_running != value:
            self._is_running = value
            self.simulationStatusChanged.emit(value)
    
    def set_status_text(self, value):
        """Internal method to set status text"""
        if self._status_text != value:
            self._status_text = value
            self.statusTextChanged.emit(value)
    
    def update_simulation_time(self, time_value):
        """Called by subscriber to update simulation time"""
        # Format the time to 3 decimal places
        formatted_time = f"{float(time_value):.3f}"
        self.set_simulation_time(formatted_time)
    
    def update_simulation_status(self, is_running):
        """Called by subscriber to update simulation status"""
        self.set_simulation_status(is_running)
        if is_running:
            self.set_status_text("Simulation executing")
        else:
            self.set_status_text("Simulation standing by")
    
    def start_subscriber(self):
        """Start the ZMQ subscriber"""
        try:
            self._subscriber = Subscriber(self)
            self._subscriber.start()
            print("ZMQ Subscriber started")
        except ImportError as e:
            print(f"Failed to start subscriber - missing zmq library: {e}")
        except ConnectionError as e:
            print(f"Failed to connect to ZMQ server: {e}")
        except OSError as e:
            print(f"ZMQ connection error: {e}")
    
    def stop_subscriber(self):
        """Stop the ZMQ subscriber"""
        if self._subscriber:
            self._subscriber.stop()
            print("ZMQ Subscriber stopped")

def main():
    app = QGuiApplication(sys.argv)
    
    # Register the Backend type with QML
    qmlRegisterType(Backend, "Backend", 1, 0, "Backend")
    
    # Create QML engine
    engine = QQmlApplicationEngine()
    
    # Create backend instance
    backend = Backend()
    
    # Make backend available to QML
    engine.rootContext().setContextProperty("backend", backend)

    # Get the directory of this script
    current_dir = os.path.dirname(os.path.abspath(__file__))
    qml_file = os.path.join(current_dir, "main.qml")

    # Load the QML file
    engine.load(qml_file)

    # Check if QML loaded successfully
    if not engine.rootObjects():
        print("Failed to load QML file")
        sys.exit(-1)
    
    # Start the ZMQ subscriber
    backend.start_subscriber()
    
    # Handle application quit to properly stop subscriber
    def cleanup():
        backend.stop_subscriber()
    
    app.aboutToQuit.connect(cleanup)

    # Run the application
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
