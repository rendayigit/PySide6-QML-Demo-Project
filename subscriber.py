"""Subscriber utilities for GUI"""

import threading
import json
import zmq


class Subscriber:
    """Subscriber utilities for GUI"""

    _instance = None  # Class-level instance variable for singleton implementation

    def __new__(cls, main_window):
        """Singleton instance"""
        if cls._instance is None:
            cls.main_window = main_window
            # Create the singleton instance
            cls._instance = super(Subscriber, cls).__new__(cls)

            # Initialize ZeroMQ context and socket
            cls._instance.context = zmq.Context(1)
            cls._instance.subscriber = cls._instance.context.socket(zmq.SUB)
            cls._instance.subscriber.connect("tcp://localhost:12345")
            cls._instance.subscriber.set(zmq.SUBSCRIBE, "TIME".encode())
            cls._instance.subscriber.set(zmq.SUBSCRIBE, "STATUS".encode())
            cls._instance.subscriber.set(zmq.SUBSCRIBE, "EVENT".encode())
            cls._instance.subscriber.set(zmq.SUBSCRIBE, "FIELDS".encode())
            cls._instance.subscriber.set(zmq.SUBSCRIBE, "MODEL_TREE".encode())

            cls._instance.is_running = False

        return cls._instance

    def __init__(self, main_window):
        # Explicitly define attributes for better static analysis
        if not hasattr(self, "subscriber"):  # Prevent reinitialization in the singleton
            self.main_window = main_window
            self.context = None
            self.subscriber = None
            self.is_running = False
            self.thread = threading.Thread(target=self._subscriber_thread)

    def start(self):
        """Starts the subscriber thread"""
        if not self.is_running:
            self.is_running = True
            self.thread = threading.Thread(target=self._subscriber_thread)
            self.thread.start()

    def stop(self):
        """Stops the subscriber thread"""
        if self.thread.is_alive():
            self.is_running = False
            self.thread.join()


    def _subscriber_thread(self):
        """Subscriber thread"""
        while self.is_running:
            frames = self.subscriber.recv_multipart(copy=False)
            topic = bytes(frames[0]).decode()
            command_json = json.loads(bytes(frames[1]).decode())

            try:
                if topic == "TIME":
                    # Extract all time fields from the TIME topic
                    sim_time = command_json.get("simulationTime", "-")
                    mission_time = command_json.get("missionTime", "-")
                    epoch_time = command_json.get("epochTime", "-")
                    zulu_time = command_json.get("zuluTime", "-")
                    
                    # Send all time fields to gui
                    if hasattr(self.main_window, 'update_all_times'):
                        self.main_window.update_all_times(sim_time, mission_time, epoch_time, zulu_time)
                elif topic == "STATUS":
                    scheduler_running = command_json["schedulerIsRunning"]
                    # Update simulation status in GUI
                    if hasattr(self.main_window, 'update_simulation_status'):
                        self.main_window.update_simulation_status(scheduler_running)
                elif topic == "EVENT":
                    log_level = command_json["level"]
                    log_message = command_json["log"]
                    # Send log to gui
                    if hasattr(self.main_window, 'send_event_log'):
                        self.main_window.send_event_log(log_level, log_message)
                elif topic == "FIELDS":
                    # Handle individual field variables
                    # The command_json is a list of field objects with variablePath and variableValue
                    if hasattr(self.main_window, 'update_fields'):
                        self.main_window.update_fields(command_json)
                elif topic == "MODEL_TREE":
                    # Handle hierarchical model tree structure
                    # Update the model tree in the GUI
                    if hasattr(self.main_window, 'update_model_tree'):
                        self.main_window.update_model_tree(command_json)
            except RuntimeError:
                # The main window has been closed
                return
