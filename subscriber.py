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
                    sim_time = command_json["simulationTime"]
                    # Send sim time to gui
                    if hasattr(self.main_window, 'update_simulation_time'):
                        self.main_window.update_simulation_time(sim_time)
                elif topic == "STATUS":
                    scheduler_running = command_json["schedulerIsRunning"]
                    # Update simulation status in GUI
                    if hasattr(self.main_window, 'update_simulation_status'):
                        self.main_window.update_simulation_status(scheduler_running)
                elif topic == "EVENT":
                    log_level = command_json["level"]
                    log_message = command_json["log"]
                    # TODO:Send log to gui
                elif topic == "FIELDS":
                    # TODO: Update the variable values in the GUI
                    # The command_json example output is as follows:
                        # {
                        #     "variablePath": "Sample Model.outflow",
                        #     "variableValue": 0.0
                        # },
                        # {
                        #     "variablePath": "Sample Model.Double Variable",
                        #     "variableValue": 123.4
                        # },
                        # {
                        #     "variablePath": "Sample Model.Integer Variable",
                        #     "variableValue": 1
                        # },
                        # {
                        #     "variablePath": "Sample Model.Boolean Variable",
                        #     "variableValue": true
                        # },
                        # {
                        #     "variablePath": "Sample Model.String Variable",
                        #     "variableValue": "ABCD"
                        # },
                        # {
                        #     "variablePath": "Sample Model.Structure Variable",
                        #     "variableValue": {
                        #     "boolean": true,
                        #     "integer": 4,
                        #     "string": "Default structure string"
                        #     }
                        # },
                        # {
                        #     "variablePath": "Sample Model.Uint",
                        #     "variableValue": 15
                        # },
                        # {
                        #     "variablePath": "Sample Model.Model Variable Vector",
                        #     "variableValue": [
                        #     3,
                        #     3,
                        #     5
                        #     ]
                        # },
                        # {
                        #     "variablePath": "Sample Model.Sample Child 1.Sample Grand Child.State",
                        #     "variableValue": "on_state"
                        # }
                    pass
                elif topic == "MODEL_TREE":
                    # TODO: Populate the model tree in the gui
                    # The command_json example output is as follows:
                    # {
                    #     "Payload Model": [
                    #         {
                    #         "CSU Power A": []
                    #         },
                    #         {
                    #         "DCU1 Power": []
                    #         },
                    #         {
                    #         "DCU2 Power": []
                    #         },
                    #         {
                    #         "AFS CU Power": []
                    #         },
                    #         {
                    #         "HCU TMD 1 A": []
                    #         },
                    #         {
                    #         "HCU TMD 1 B": []
                    #         },
                    #         {
                    #         "HCU SPP 1 A": []
                    #         },
                    #         {
                    #         "HCU SPP 1 B": []
                    #         },
                    #         {
                    #         "HCU UPP 1 A": []
                    #         },
                    #         {
                    #         "HCU UPP 1 B": []
                    #         }
                    #     ],
                    #     "Power Control Subsystem": [
                    #         {
                    #         "Battery Charge": []
                    #         },
                    #         {
                    #         "Power From Panels": []
                    #         },
                    #         {
                    #         "Power From Battery": []
                    #         },
                    #         {
                    #         "Panel Voltage": []
                    #         },
                    #         {
                    #         "Panel Current": []
                    #         },
                    #         {
                    #         "Battery Voltage": []
                    #         },
                    #         {
                    #         "Battery Current": []
                    #         },
                    #         {
                    #         "Battery Age Years": []
                    #         },
                    #         {
                    #         "Panel Age Years": []
                    #         },
                    #         {
                    #         "Sun Angle": []
                    #         },
                    #         {
                    #         "Power Consumption": []
                    #         }
                    #     ],
                    #     "Sample Model": [
                    #         {
                    #         "outflow": []
                    #         },
                    #         {
                    #         "Double Variable": []
                    #         },
                    #         {
                    #         "Integer Variable": []
                    #         },
                    #         {
                    #         "Boolean Variable": []
                    #         },
                    #         {
                    #         "String Variable": []
                    #         },
                    #         {
                    #         "Structure Variable": []
                    #         },
                    #         {
                    #         "Uint": []
                    #         },
                    #         {
                    #         "Model Variable Vector": []
                    #         },
                    #         {
                    #         "Array Variable[0]": []
                    #         },
                    #         {
                    #         "Array Variable[1]": []
                    #         },
                    #         {
                    #         "Array Variable[2]": []
                    #         },
                    #         {
                    #         "Array Variable[3]": []
                    #         },
                    #         {
                    #         "Sample Child 1": [
                    #             {
                    #             "inflow": []
                    #             },
                    #             {
                    #             "Sample Grand Child": [
                    #                 {
                    #                 "vbus": []
                    #                 },
                    #                 {
                    #                 "gnd": []
                    #                 },
                    #                 {
                    #                 "activeVoltageConsumption": []
                    #                 },
                    #                 {
                    #                 "activeTemperature": []
                    #                 },
                    #                 {
                    #                 "activePowerConsumption": []
                    #                 },
                    #                 {
                    #                 "State": []
                    #                 },
                    #                 {
                    #                 "Boolean Variable": []
                    #                 }
                    #             ]
                    #             },
                    #             {
                    #             "Integer Variable": []
                    #             }
                    #         ]
                    #         },
                    #         {
                    #         "Sample Child 2": [
                    #             {
                    #             "inflow": []
                    #             },
                    #             {
                    #             "Sample Grand Child": [
                    #                 {
                    #                 "vbus": []
                    #                 },
                    #                 {
                    #                 "gnd": []
                    #                 },
                    #                 {
                    #                 "activeVoltageConsumption": []
                    #                 },
                    #                 {
                    #                 "activeTemperature": []
                    #                 },
                    #                 {
                    #                 "activePowerConsumption": []
                    #                 },
                    #                 {
                    #                 "State": []
                    #                 },
                    #                 {
                    #                 "Boolean Variable": []
                    #                 }
                    #             ]
                    #             },
                    #             {
                    #             "Integer Variable": []
                    #             }
                    #         ]
                    #         },
                    #         {
                    #         "Sample Child 3": [
                    #             {
                    #             "inflow": []
                    #             },
                    #             {
                    #             "Sample Grand Child": [
                    #                 {
                    #                 "vbus": []
                    #                 },
                    #                 {
                    #                 "gnd": []
                    #                 },
                    #                 {
                    #                 "activeVoltageConsumption": []
                    #                 },
                    #                 {
                    #                 "activeTemperature": []
                    #                 },
                    #                 {
                    #                 "activePowerConsumption": []
                    #                 },
                    #                 {
                    #                 "State": []
                    #                 },
                    #                 {
                    #                 "Boolean Variable": []
                    #                 }
                    #             ]
                    #             },
                    #             {
                    #             "Integer Variable": []
                    #             }
                    #         ]
                    #         }
                    #     ]
                    #     }
                    pass
            except RuntimeError:
                # The main window has been closed
                return
