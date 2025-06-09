"""
Commanding Module

This module provides a command interface for sending commands to the 
Galactron simulation engine via ZeroMQ REQ-REP pattern.
"""

import json
import zmq
from typing import Dict, Any, Union
from PySide6.QtCore import QObject


class SimulationCommander(QObject):
    """
    Command interface for Galactron simulation engine
    
    This class provides methods to send various commands to the simulation
    engine including RUN, HOLD, STEP, PROGRESS, RATE, and STATUS commands.
    """
    
    # Default connection settings
    DEFAULT_HOST = "localhost"
    DEFAULT_PORT = 12340
    DEFAULT_TIMEOUT_MS = 2000
    
    def __init__(self, host: str = DEFAULT_HOST, port: int = DEFAULT_PORT):
        """
        Initialize the commanding interface
        
        Args:
            host: ZMQ server host (default: localhost)
            port: ZMQ server port (default: 12340)
        """
        super().__init__()
        self.host = host
        self.port = port
        
        # ZMQ components
        self.context = None
        self.socket = None
        
        self._initialize_zmq()
    
    def _initialize_zmq(self) -> None:
        """Initialize ZeroMQ context and socket"""
        try:
            self.context = zmq.Context(1)
            self.socket = self.context.socket(zmq.REQ)
            
            connection_string = f"tcp://{self.host}:{self.port}"
            self.socket.connect(connection_string)
            print(f"Command interface connected to {connection_string}")
            
        except Exception as e:
            print(f"Failed to initialize command interface: {e}")
            raise
    
    def send_command(self, command: Dict[str, Any], 
                    timeout_ms: int = DEFAULT_TIMEOUT_MS) -> Union[str, Dict, None]:
        """
        Send a command and wait for a response from Galactron Engine
        
        Args:
            command: The command dictionary to send
            timeout_ms: Timeout in milliseconds (default: 2000ms)

        Returns:
            Response from the server, or None if error occurred
            
        Raises:
            TimeoutError: If no response is received within the timeout period
            ConnectionError: If there's a ZMQ communication error
            ValueError: If the command format is invalid
        """
        if not self.socket:
            raise ConnectionError("Command interface not initialized")
        
        # Set receive timeout
        self.socket.setsockopt(zmq.RCVTIMEO, timeout_ms)
        
        try:
            # Send the command as JSON
            command_json = json.dumps(command)
            self.socket.send_string(command_json)
            
            # Receive and return the response
            response = self.socket.recv_json()
            return response
            
        except zmq.Again:
            # Timeout occurred
            raise TimeoutError(f"No response received within {timeout_ms}ms timeout")
        except zmq.ZMQError as e:
            # Other ZMQ errors
            raise ConnectionError(f"ZMQ communication error: {e}")
        except json.JSONEncodeError as e:
            raise ValueError(f"Invalid command format: {e}")
    
    def run_simulation(self) -> Union[str, Dict, None]:
        """
        Send RUN command to start the simulation
        
        Returns:
            Server response or None if error occurred
        """
        return self.send_command({"command": "RUN"})
    
    def hold_simulation(self) -> Union[str, Dict, None]:
        """
        Send HOLD command to pause the simulation
        
        Returns:
            Server response or None if error occurred
        """
        return self.send_command({"command": "HOLD"})
    
    def step_simulation(self) -> Union[str, Dict, None]:
        """
        Send STEP command to advance simulation by one step
        
        Returns:
            Server response or None if error occurred
        """
        return self.send_command({"command": "STEP"})
    
    def progress_simulation(self, milliseconds: int) -> Union[str, Dict, None]:
        """
        Send PROGRESS command to advance simulation by specified time
        
        Args:
            milliseconds: Number of milliseconds to advance simulation
            
        Returns:
            Server response or None if error occurred
        """
        return self.send_command({"command": "PROGRESS", "millis": milliseconds})
    
    def set_simulation_rate(self, rate: float) -> Union[str, Dict, None]:
        """
        Send RATE command to set simulation speed scale
        
        Args:
            rate: Simulation speed multiplier (e.g., 2.0 for 2x speed)
            
        Returns:
            Server response or None if error occurred
        """
        return self.send_command({"command": "RATE", "rate": rate})
    
    def request_status(self) -> Union[str, Dict, None]:
        """
        Send STATUS command to request current simulation status
        
        Returns:
            Server response or None if error occurred
        """
        return self.send_command({"command": "STATUS"})
    
    def request_model_tree(self) -> Union[str, Dict, None]:
        """
        Send MODEL_TREE command to request the simulation model hierarchy
        
        Returns:
            Server response or None if error occurred
        """
        return self.send_command({"command": "MODEL_TREE"})
    
    def cleanup(self) -> None:
        """Cleanup ZMQ resources"""
        if self.socket:
            self.socket.close()
            self.socket = None
        
        if self.context:
            self.context.term()
            self.context = None
        
        print("Command interface cleaned up")
    
    def __del__(self):
        """Destructor to ensure cleanup"""
        self.cleanup()
