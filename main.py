import sys
import os
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType
from PySide6.QtCore import QObject, Signal, Property, Slot
from subscriber import Subscriber

class Backend(QObject):
    """Backend class to handle communication between Python and QML"""
    
    # Signals to notify QML of changes
    simulationTimeChanged = Signal(str)
    missionTimeChanged = Signal(str)
    epochTimeChanged = Signal(str)
    zuluTimeChanged = Signal(str)
    simulationStatusChanged = Signal(bool)
    statusTextChanged = Signal(str)
    eventLogReceived = Signal(str, str)  # level, message
    modelTreeUpdated = Signal('QVariant')  # model tree data
    variableAdded = Signal('QVariant')  # variable data
    variableUpdated = Signal(str, 'QVariant')  # variable path, complete variable data
    variableRemoved = Signal(str)  # variable path when removed
    variablesCleared = Signal()  # signal when all variables are cleared
    commandExecuted = Signal(str, bool)  # command name, success status
    
    def __init__(self):
        super().__init__()
        self._simulation_time = "-"
        self._mission_time = "-"
        self._epoch_time = "-"
        self._zulu_time = "-"
        self._is_running = False
        self._status_text = "Simulator ready"
        self._subscriber = None
        self._watched_variables = {}  # Store watched variables: {variablePath: {data}}
        self._commanding = None  # Commanding instance
        self._last_command_success = True  # Track last command success for UI feedback
        
    @Property(str, notify=simulationTimeChanged)
    def simulationTime(self):
        return self._simulation_time
    
    @Property(str, notify=missionTimeChanged)
    def missionTime(self):
        return self._mission_time
    
    @Property(str, notify=epochTimeChanged)
    def epochTime(self):
        return self._epoch_time
    
    @Property(str, notify=zuluTimeChanged)
    def zuluTime(self):
        return self._zulu_time
    
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
    
    def set_mission_time(self, value):
        """Internal method to set mission time"""
        if self._mission_time != value:
            self._mission_time = value
            self.missionTimeChanged.emit(value)
    
    def set_epoch_time(self, value):
        """Internal method to set epoch time"""
        if self._epoch_time != value:
            self._epoch_time = value
            self.epochTimeChanged.emit(value)
    
    def set_zulu_time(self, value):
        """Internal method to set zulu time"""
        if self._zulu_time != value:
            self._zulu_time = value
            self.zuluTimeChanged.emit(value)
    
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
    
    def get_commanding_instance(self):
        """Get or create commanding instance"""
        if self._commanding is None:
            from commanding import Commanding
            self._commanding = Commanding()
        return self._commanding
    
    def update_all_times(self, sim_time, mission_time, epoch_time, zulu_time):
        """Called by subscriber to update all time fields from TIME topic"""
        # Update all time properties
        self.set_simulation_time(sim_time)
        self.set_mission_time(mission_time)
        self.set_epoch_time(epoch_time)
        self.set_zulu_time(zulu_time)
    
    def update_simulation_time(self, time_value):
        """Called by subscriber to update simulation time (legacy method)"""
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
    
    def send_event_log(self, level, message):
        """Called by subscriber to send event log to GUI"""
        self.eventLogReceived.emit(level, message)
    
    def update_fields(self, fields_data):
        """Called by subscriber to handle FIELDS topic - individual field variables"""
        # Update watched variables with new values
        for field in fields_data:
            variable_path = field.get("variablePath", "")
            variable_value = field.get("variableValue", "")
            
            # If this variable is being watched, update it
            if variable_path in self._watched_variables:
                # Format the value for display
                formatted_value = self._format_variable_value(variable_value)
                
                # Determine the variable type from the actual value
                variable_type = self._get_variable_type(variable_value)
                
                # Update the stored variable data
                self._watched_variables[variable_path]["value"] = formatted_value
                self._watched_variables[variable_path]["type"] = variable_type
                
                # Create updated variable data for QML
                updated_data = {
                    "variablePath": variable_path,
                    "description": self._watched_variables[variable_path]["description"],
                    "value": formatted_value,
                    "type": variable_type
                }
                
                # Emit signal to update QML with complete data
                self.variableUpdated.emit(variable_path, updated_data)
    
    def _format_variable_value(self, value):
        """Format variable value for display"""
        if isinstance(value, (int, float)):
            return f"{value:.3f}" if isinstance(value, float) else str(value)
        elif isinstance(value, bool):
            return "true" if value else "false"
        elif isinstance(value, list):
            return str(value)
        elif isinstance(value, dict):
            return str(value)
        else:
            return str(value)
    
    def _get_variable_type(self, value):
        """Determine variable type from value"""
        if isinstance(value, bool):
            return "boolean"
        elif isinstance(value, int):
            return "integer"
        elif isinstance(value, float):
            return "double"
        elif isinstance(value, list):
            return "array"
        elif isinstance(value, dict):
            return "struct"
        else:
            return "string"
    
    def add_variable_to_watch(self, variable_path, description=""):
        """Add a variable to the watch list"""
        if variable_path not in self._watched_variables:
            # Create variable data
            variable_data = {
                "variablePath": variable_path,
                "description": description or variable_path.split(".")[-1],
                "value": "N/A",
                "type": "unknown"
            }
            
            # Store in watched variables
            self._watched_variables[variable_path] = variable_data
            
            # Emit signal to add to QML
            self.variableAdded.emit(variable_data)
            
            print(f"Added variable to watch: {variable_path}")
            return True
        else:
            print(f"Variable already being watched: {variable_path}")
            return False
    
    @Slot(str, str, result=bool)
    def addVariableToWatch(self, variable_path, description=""):
        """QML-callable method to add a variable to the watch list"""
        return self.add_variable_to_watch(variable_path, description)
    
    def clear_variable_table(self):
        """Clear all variables from the watch list"""
        self._watched_variables.clear()
        print("Variable table cleared")
        # Emit signal to clear QML model
        self.variablesCleared.emit()
        return True
    
    @Slot(result=bool)
    def clearVariableTable(self):
        """QML-callable method to clear all variables from the watch list"""
        return self.clear_variable_table()
    
    def remove_variable_from_watch(self, variable_path):
        """Remove a specific variable from the watch list"""
        if variable_path in self._watched_variables:
            del self._watched_variables[variable_path]
            print(f"Variable '{variable_path}' removed from watch list")
            # Emit signal to notify QML to remove the variable from the model
            self.variableRemoved.emit(variable_path)
            return True
        else:
            print(f"Variable '{variable_path}' not found in watch list")
            return False
    
    @Slot(str, result=bool)
    def removeVariableFromWatch(self, variable_path):
        """QML-callable method to remove a variable from the watch list"""
        return self.remove_variable_from_watch(variable_path)
    
    def update_model_tree(self, model_tree_data):
        """Called by subscriber to update model tree from MODEL_TREE topic"""
        # Convert the hierarchical model tree data to a flat list for QML
        tree_items = []
        
        def process_node(node_data, parent_name="", level=0):
            """Recursively process model tree nodes"""
            if isinstance(node_data, dict):
                for key, children in node_data.items():
                    # Add the current node
                    full_path = f"{parent_name}.{key}" if parent_name else key
                    
                    # Determine if this node has children
                    # Empty list [] means it's a leaf node (no children)
                    # Non-empty list means it has children
                    has_children = isinstance(children, list) and len(children) > 0
                    
                    tree_items.append({
                        "name": key,  # Don't include indentation in the name
                        "level": level,
                        "fullPath": full_path,
                        "hasChildren": has_children,
                        "expanded": False,  # Start collapsed by default
                        "visible": level == 0  # Only show top-level items initially
                    })
                    
                    # Process children only if they exist
                    if has_children:
                        for child in children:
                            process_node(child, full_path, level + 1)
            elif isinstance(node_data, list):
                for item in node_data:
                    process_node(item, parent_name, level)
        
        # Process the model tree data
        process_node(model_tree_data)
        
        # Emit signal to update QML model
        self.modelTreeUpdated.emit(tree_items)
    
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
    
    def request_model_tree(self):
        """Request the model tree from the Galactron Engine"""
        try:
            # Create commanding instance and request model tree
            commanding = self.get_commanding_instance()
            response = commanding.request({"command": "MODEL_TREE"})
            
            print(f"Model tree request successful: {response}")
            self.send_event_log("INFO", "Model tree requested from engine")
            
            return response
            
        except TimeoutError as e:
            error_msg = f"Model tree request timeout: {e}"
            print(error_msg)
            self.send_event_log("WARNING", "Model tree request timed out")
            
        except (ConnectionError, OSError) as e:
            error_msg = f"Model tree request connection failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"Model tree request connection failed: {str(e)}")
            
        except ValueError as e:
            error_msg = f"Model tree request data error: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"Model tree request data error: {str(e)}")
            
        except Exception as e:
            error_msg = f"Model tree request failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"Model tree request failed: {str(e)}")
            
        return None
    
    @Slot(result=bool)
    def requestModelTree(self):
        """QML-callable method to request model tree from engine"""
        response = self.request_model_tree()
        return response is not None

    def run_simulation(self):
        """Send RUN command to the Galactron Engine"""
        try:
            commanding = self.get_commanding_instance()
            response = commanding.request({"command": "RUN"})
            
            print(f"RUN command successful: {response}")
            self.send_event_log("INFO", "RUN command sent to engine")
            
            # Request status update - actual status will come via STATUS topic
            self.verify_simulation_status()
            
            # Emit command executed signal for UI feedback
            self.commandExecuted.emit("RUN", True)
            
            return response
            
        except TimeoutError as e:
            error_msg = f"RUN command timeout: {e}"
            print(error_msg)
            self.send_event_log("WARNING", "RUN command timed out")
            self.commandExecuted.emit("RUN", False)
            
        except (ConnectionError, OSError) as e:
            error_msg = f"RUN command connection failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"RUN command connection failed: {str(e)}")
            self.commandExecuted.emit("RUN", False)
            
        except ValueError as e:
            error_msg = f"RUN command data error: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"RUN command data error: {str(e)}")
            self.commandExecuted.emit("RUN", False)
            
        except Exception as e:
            error_msg = f"RUN command failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"RUN command failed: {str(e)}")
            self.commandExecuted.emit("RUN", False)
            
        return None
    
    def hold_simulation(self):
        """Send HOLD command to the Galactron Engine"""
        try:
            commanding = self.get_commanding_instance()
            response = commanding.request({"command": "HOLD"})
            
            print(f"HOLD command successful: {response}")
            self.send_event_log("INFO", "HOLD command sent to engine")
            
            # Request status update - actual status will come via STATUS topic
            self.verify_simulation_status()
            
            # Emit command executed signal for UI feedback
            self.commandExecuted.emit("HOLD", True)
            
            return response
            
        except TimeoutError as e:
            error_msg = f"HOLD command timeout: {e}"
            print(error_msg)
            self.send_event_log("WARNING", "HOLD command timed out")
            self.commandExecuted.emit("HOLD", False)
            
        except (ConnectionError, OSError) as e:
            error_msg = f"HOLD command connection failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"HOLD command connection failed: {str(e)}")
            self.commandExecuted.emit("HOLD", False)
            
        except ValueError as e:
            error_msg = f"HOLD command data error: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"HOLD command data error: {str(e)}")
            self.commandExecuted.emit("HOLD", False)
            
        except Exception as e:
            error_msg = f"HOLD command failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"HOLD command failed: {str(e)}")
            self.commandExecuted.emit("HOLD", False)
            
        return None
    
    def verify_simulation_status(self):
        """Request status update from engine - status will come via STATUS topic through subscriber"""
        try:
            commanding = self.get_commanding_instance()
            response = commanding.request({"command": "STATUS"})
            
            # The STATUS command just triggers the engine to publish status via STATUS topic
            # The actual status update will come through the subscriber's STATUS topic handler
            print(f"STATUS command sent successfully: {response}")
            self.send_event_log("INFO", "Status update requested from engine")
            
            return response
            
        except TimeoutError as e:
            error_msg = f"STATUS command timeout: {e}"
            print(error_msg)
            self.send_event_log("WARNING", "STATUS command timed out")
            
        except (ConnectionError, OSError) as e:
            error_msg = f"STATUS command connection failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"STATUS command connection failed: {str(e)}")
            
        except ValueError as e:
            error_msg = f"STATUS command data error: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"STATUS command data error: {str(e)}")
            
        except Exception as e:
            error_msg = f"STATUS command failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"STATUS command failed: {str(e)}")
            
        return None
    
    @Slot(result=bool)
    def runSimulation(self):
        """QML-callable method to run the simulation"""
        response = self.run_simulation()
        return response is not None
    
    @Slot(result=bool)
    def holdSimulation(self):
        """QML-callable method to hold the simulation"""
        response = self.hold_simulation()
        return response is not None
    
    def step_simulation(self):
        """Send STEP command to the Galactron Engine"""
        try:
            commanding = self.get_commanding_instance()
            response = commanding.request({"command": "STEP"})
            
            print(f"STEP command successful: {response}")
            self.send_event_log("INFO", "STEP command sent to engine")
            
            # Request status update after step - actual status will come via STATUS topic
            self.verify_simulation_status()
            
            # Emit command executed signal for UI feedback
            self.commandExecuted.emit("STEP", True)
            
            return response
            
        except TimeoutError as e:
            error_msg = f"STEP command timeout: {e}"
            print(error_msg)
            self.send_event_log("WARNING", "STEP command timed out")
            self.commandExecuted.emit("STEP", False)
            
        except (ConnectionError, OSError) as e:
            error_msg = f"STEP command connection failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"STEP command connection failed: {str(e)}")
            self.commandExecuted.emit("STEP", False)
            
        except ValueError as e:
            error_msg = f"STEP command data error: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"STEP command data error: {str(e)}")
            self.commandExecuted.emit("STEP", False)
            
        except Exception as e:
            error_msg = f"STEP command failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"STEP command failed: {str(e)}")
            self.commandExecuted.emit("STEP", False)
            
        return None

    @Slot(result=bool)
    def stepSimulation(self):
        """QML-callable method to step the simulation"""
        response = self.step_simulation()
        return response is not None

    @Slot(result=bool)
    def toggleSimulation(self):
        """QML-callable method to toggle simulation run/hold state"""
        if self._is_running:
            return self.holdSimulation()
        else:
            return self.runSimulation()

    def progress_simulation(self, total_milliseconds):
        """Send PROGRESS command to the Galactron Engine with specified time"""
        try:
            commanding = self.get_commanding_instance()
            response = commanding.request({"command": "PROGRESS", "millis": total_milliseconds})
            
            print(f"PROGRESS command successful: {response}")
            self.send_event_log("INFO", f"PROGRESS command sent to engine with {total_milliseconds}ms")
            
            # Request status update after progress - actual status will come via STATUS topic
            self.verify_simulation_status()
            
            # Emit command executed signal for UI feedback
            self.commandExecuted.emit("PROGRESS", True)
            
            return response
            
        except TimeoutError as e:
            error_msg = f"PROGRESS command timeout: {e}"
            print(error_msg)
            self.send_event_log("WARNING", "PROGRESS command timed out")
            self.commandExecuted.emit("PROGRESS", False)
            
        except (ConnectionError, OSError) as e:
            error_msg = f"PROGRESS command connection failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"PROGRESS command connection failed: {str(e)}")
            self.commandExecuted.emit("PROGRESS", False)
            
        except ValueError as e:
            error_msg = f"PROGRESS command data error: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"PROGRESS command data error: {str(e)}")
            self.commandExecuted.emit("PROGRESS", False)
            
        except Exception as e:
            error_msg = f"PROGRESS command failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"PROGRESS command failed: {str(e)}")
            self.commandExecuted.emit("PROGRESS", False)
            
        return None

    @Slot(int, result=bool)
    def progressSimulation(self, total_milliseconds):
        """QML-callable method to progress the simulation by specified time"""
        response = self.progress_simulation(total_milliseconds)
        return response is not None

    def set_simulation_rate(self, scale_value):
        """Send RATE command to the Galactron Engine with specified scale"""
        try:
            commanding = self.get_commanding_instance()
            response = commanding.request({"command": "RATE", "rate": scale_value})
            
            print(f"RATE command successful: {response}")
            self.send_event_log("INFO", f"RATE command sent to engine with scale {scale_value}")
            
            # Request status update after rate change - actual status will come via STATUS topic
            self.verify_simulation_status()
            
            # Emit command executed signal for UI feedback
            self.commandExecuted.emit("RATE", True)
            
            return response
            
        except TimeoutError as e:
            error_msg = f"RATE command timeout: {e}"
            print(error_msg)
            self.send_event_log("WARNING", "RATE command timed out")
            self.commandExecuted.emit("RATE", False)
            
        except (ConnectionError, OSError) as e:
            error_msg = f"RATE command connection failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"RATE command connection failed: {str(e)}")
            self.commandExecuted.emit("RATE", False)
            
        except ValueError as e:
            error_msg = f"RATE command data error: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"RATE command data error: {str(e)}")
            self.commandExecuted.emit("RATE", False)
            
        except Exception as e:
            error_msg = f"RATE command failed: {e}"
            print(error_msg)
            self.send_event_log("ERROR", f"RATE command failed: {str(e)}")
            self.commandExecuted.emit("RATE", False)
            
        return None

    @Slot(float, result=bool)
    def setSimulationRate(self, scale_value):
        """QML-callable method to set the simulation rate scale"""
        response = self.set_simulation_rate(scale_value)
        return response is not None

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
    
    # Give subscriber a moment to establish connection
    import time
    time.sleep(0.1)  # Brief delay to ensure subscriber is ready
    
    # Request initial status to set correct UI state at startup
    print("Requesting initial status from Galactron Engine...")
    backend.verify_simulation_status()
    
    # Request model tree from engine after subscriber is ready
    print("Requesting model tree from Galactron Engine...")
    backend.request_model_tree()
    
    # Handle application quit to properly stop subscriber
    def cleanup():
        backend.stop_subscriber()
    
    app.aboutToQuit.connect(cleanup)

    # Run the application
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
