"""Transmit commands to Galactron Engine"""

import json
import zmq


class Commanding:
    """Singleton class to transmit commands to Galactron Engine"""

    _instance = None  # Class-level instance variable for singleton implementation

    def __new__(cls):
        if cls._instance is None:
            # Create the singleton instance
            cls._instance = super(Commanding, cls).__new__(cls)

            # Initialize ZeroMQ context and socket
            cls._instance.context = zmq.Context(1)
            cls._instance.socket = cls._instance.context.socket(zmq.REQ)
            cls._instance.socket.connect("tcp://localhost:12340")

        return cls._instance

    def __init__(self):
        # Explicitly define socket attribute for better static analysis
        if not hasattr(self, "socket"):  # Prevent reinitialization in the singleton
            self.socket = None
            self.context = None

    def request(self, command: str, timeout_ms: int = 2000) -> str:
        """Send a command and wait for a response from Galactron Engine
        
        Args:
            command: The command to send as a string
            timeout_ms: Timeout in milliseconds (default: 2000ms = 2 seconds)

        Returns:
            Response from the server as a string
            
        Raises:
            TimeoutError: If no response is received within the timeout period
            zmq.ZMQError: If there's a ZMQ communication error
        """
        # Set receive timeout
        self.socket.setsockopt(zmq.RCVTIMEO, timeout_ms)
        
        try:
            self.socket.send_string(json.dumps(command))  # Send the command
            return self.socket.recv_json()  # Receive and decode the response
        except zmq.Again:
            # Timeout occurred
            raise TimeoutError(f"No response received within {timeout_ms}ms timeout")
        except zmq.ZMQError as e:
            # Other ZMQ errors
            raise zmq.ZMQError(f"ZMQ communication error: {e}")
