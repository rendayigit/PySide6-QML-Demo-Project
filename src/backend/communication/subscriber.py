"""
ZMQ Subscriber Module

This module handles ZeroMQ subscription to simulation engine topics including
TIME, STATUS, EVENT, FIELDS, and MODEL_TREE messages.
"""

import threading
import json
import zmq
from typing import Protocol, Optional
from PySide6.QtCore import QObject


class SubscriberCallbacks(Protocol):
    """Protocol defining the callback interface for subscriber events"""
    
    def update_all_times(self, sim_time: str, mission_time: str, 
                        epoch_time: str, zulu_time: str) -> None:
        """Called when TIME topic is received"""
        ...
    
    def update_simulation_status(self, is_running: bool) -> None:
        """Called when STATUS topic is received"""
        ...
    
    def send_event_log(self, level: str, message: str) -> None:
        """Called when EVENT topic is received"""
        ...
    
    def update_fields(self, fields_data: list) -> None:
        """Called when FIELDS topic is received"""
        ...
    
    def update_model_tree(self, tree_data: dict) -> None:
        """Called when MODEL_TREE topic is received"""
        ...


class ZMQSubscriber(QObject):
    """
    ZeroMQ subscriber for simulation engine communication
    
    This class handles subscribing to various topics from the simulation engine
    and dispatching the received messages to appropriate callback methods.
    """
    
    # ZMQ connection settings
    DEFAULT_HOST = "localhost"
    DEFAULT_PORT = 12345
    
    # Subscribed topics
    TOPICS = ["TIME", "STATUS", "EVENT", "FIELDS", "MODEL_TREE"]
    
    def __init__(self, callback_handler: SubscriberCallbacks, 
                 host: str = DEFAULT_HOST, port: int = DEFAULT_PORT):
        """
        Initialize the ZMQ subscriber
        
        Args:
            callback_handler: Object implementing SubscriberCallbacks protocol
            host: ZMQ server host (default: localhost)
            port: ZMQ server port (default: 12345)
        """
        super().__init__()
        self.callback_handler = callback_handler
        self.host = host
        self.port = port
        
        # ZMQ components
        self.context: Optional[zmq.Context] = None
        self.subscriber: Optional[zmq.Socket] = None
        
        # Threading
        self.is_running = False
        self.thread: Optional[threading.Thread] = None
        
        self._initialize_zmq()
    
    def _initialize_zmq(self) -> None:
        """Initialize ZeroMQ context and socket"""
        try:
            self.context = zmq.Context(1)
            self.subscriber = self.context.socket(zmq.SUB)
            
            # Connect to the simulation engine
            connection_string = f"tcp://{self.host}:{self.port}"
            self.subscriber.connect(connection_string)
            print(f"ZMQ subscriber connected to {connection_string}")
            
            # Subscribe to all required topics
            for topic in self.TOPICS:
                self.subscriber.set(zmq.SUBSCRIBE, topic.encode())
                print(f"Subscribed to topic: {topic}")
                
        except Exception as e:
            print(f"Failed to initialize ZMQ subscriber: {e}")
            raise
    
    def start(self) -> None:
        """Start the subscriber thread"""
        if not self.is_running and self.subscriber:
            self.is_running = True
            self.thread = threading.Thread(target=self._subscriber_thread, daemon=True)
            self.thread.start()
            print("ZMQ subscriber thread started")
        else:
            print("Subscriber already running or not initialized")
    
    def stop(self) -> None:
        """Stop the subscriber thread and cleanup resources"""
        if self.is_running:
            self.is_running = False
            
            # Wait for thread to finish
            if self.thread and self.thread.is_alive():
                self.thread.join(timeout=2.0)
                if self.thread.is_alive():
                    print("Warning: Subscriber thread did not stop gracefully")
        
        # Cleanup ZMQ resources
        self._cleanup_zmq()
        print("ZMQ subscriber stopped")
    
    def _cleanup_zmq(self) -> None:
        """Cleanup ZeroMQ resources"""
        if self.subscriber:
            self.subscriber.close()
            self.subscriber = None
        
        if self.context:
            self.context.term()
            self.context = None
    
    def _subscriber_thread(self) -> None:
        """
        Main subscriber thread loop
        
        This method runs in a separate thread and continuously receives
        messages from the simulation engine, dispatching them to the
        appropriate callback methods.
        """
        print("Subscriber thread started")
        
        while self.is_running and self.subscriber:
            try:
                # Receive multipart message with non-blocking timeout
                if self.subscriber.poll(timeout=1000):  # 1 second timeout
                    frames = self.subscriber.recv_multipart(copy=False, flags=zmq.NOBLOCK)
                    self._process_message(frames)
                    
            except zmq.Again:
                # No message received within timeout, continue loop
                continue
            except zmq.ZMQError as e:
                if self.is_running:  # Only log if we're supposed to be running
                    print(f"ZMQ error in subscriber thread: {e}")
                break
            except RuntimeError:
                # Main window has been closed, stop gracefully
                print("Main window closed, stopping subscriber")
                break
            except Exception as e:
                print(f"Unexpected error in subscriber thread: {e}")
                break
        
        print("Subscriber thread ended")
    
    def _process_message(self, frames: list) -> None:
        """
        Process a received ZMQ message
        
        Args:
            frames: List of message frames from ZMQ
        """
        try:
            if len(frames) < 2:
                print("Invalid message format: insufficient frames")
                return
            
            # Extract topic and JSON data
            topic = bytes(frames[0]).decode()
            json_data = json.loads(bytes(frames[1]).decode())
            
            # Route message to appropriate handler
            self._route_message(topic, json_data)
            
        except json.JSONDecodeError as e:
            print(f"Failed to decode JSON message: {e}")
        except Exception as e:
            print(f"Error processing message: {e}")
    
    def _route_message(self, topic: str, data: dict) -> None:
        """
        Route message to appropriate callback based on topic
        
        Args:
            topic: Message topic string
            data: Parsed JSON data
        """
        try:
            if topic == "TIME":
                self._handle_time_message(data)
            elif topic == "STATUS":
                self._handle_status_message(data)
            elif topic == "EVENT":
                self._handle_event_message(data)
            elif topic == "FIELDS":
                self._handle_fields_message(data)
            elif topic == "MODEL_TREE":
                self._handle_model_tree_message(data)
            else:
                print(f"Unknown topic received: {topic}")
                
        except Exception as e:
            print(f"Error handling {topic} message: {e}")
    
    def _handle_time_message(self, data: dict) -> None:
        """Handle TIME topic messages"""
        sim_time = data.get("simulationTime", "-")
        mission_time = data.get("missionTime", "-")
        epoch_time = data.get("epochTime", "-")
        zulu_time = data.get("zuluTime", "-")
        
        self.callback_handler.update_all_times(sim_time, mission_time, epoch_time, zulu_time)
    
    def _handle_status_message(self, data: dict) -> None:
        """Handle STATUS topic messages"""
        scheduler_running = data.get("schedulerIsRunning", False)
        self.callback_handler.update_simulation_status(scheduler_running)
    
    def _handle_event_message(self, data: dict) -> None:
        """Handle EVENT topic messages"""
        log_level = data.get("level", "INFO")
        log_message = data.get("log", "")
        self.callback_handler.send_event_log(log_level, log_message)
    
    def _handle_fields_message(self, data: list) -> None:
        """Handle FIELDS topic messages"""
        # The data is a list of field objects with variablePath and variableValue
        self.callback_handler.update_fields(data)
    
    def _handle_model_tree_message(self, data: dict) -> None:
        """Handle MODEL_TREE topic messages"""
        self.callback_handler.update_model_tree(data)
