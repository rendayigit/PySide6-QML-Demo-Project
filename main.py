#!/usr/bin/env python3
"""
PySide6 + QML Demo Application
A simple demo showing PySide6 integration with QML
"""

import sys
import os
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType
from PySide6.QtCore import QObject, Signal, Slot, Property


class Backend(QObject):
    """
    Backend class to demonstrate Python-QML integration.

    This class serves as a bridge between Python logic and QML UI components,
    providing properties and methods that can be accessed from QML. It manages
    a message property and a counter to demonstrate bidirectional communication
    between Python and QML.

    Attributes:
        _message (str): Private storage for the message property
        _counter (int): Private counter for tracking button clicks

    Signals:
        messageChanged: Emitted when the message property changes
    """

    # Signal to notify QML when message changes
    messageChanged = Signal(str)

    def __init__(self):
        """
        Initialize the Backend instance.

        Sets up the initial state with a default message and zero counter value.
        """
        super().__init__()
        self._message = "Hello from PySide6!"
        self._counter = 0

    @Property(str, notify=messageChanged)
    def message(self):
        """
        Get the current message.

        This property is exposed to QML and automatically notifies QML
        when the value changes through the messageChanged signal.

        Returns:
            str: The current message string
        """
        return self._message

    @message.setter
    def message(self, value):
        """
        Set the message property.

        Updates the message only if the new value is different from the current
        value, and emits the messageChanged signal to notify QML of the change.

        Args:
            value (str): The new message string to set
        """
        if self._message != value:
            self._message = value
            self.messageChanged.emit(value)

    @Slot()
    def increment_counter(self):
        """
        Increment the internal counter and update the message.

        This slot can be called from QML to increment the counter and
        automatically update the message to show the current count.
        The message will display "Button clicked X times!" where X is
        the number of times this method has been called.
        """
        self._counter += 1
        self._message = f"Button clicked {self._counter} times!"
        self.messageChanged.emit(self._message)

    @Slot(str)
    def update_message(self, new_message):
        """
        Update the message from QML.

        This slot allows QML components to directly set a new message
        by calling this method with the desired message text.

        Args:
            new_message (str): The new message to set
        """
        self.message = new_message


def main():
    """
    Main application entry point.

    This function initializes and runs the PySide6 QML application by:
    1. Creating a QGuiApplication instance
    2. Registering the Backend class with QML for use in QML files
    3. Setting up the QML application engine
    4. Creating a Backend instance and exposing it to QML context
    5. Loading the main.qml file from the same directory
    6. Starting the application event loop

    The function handles QML loading errors and exits gracefully if the
    QML file cannot be loaded.

    Raises:
        SystemExit: If QML file loading fails or when the application closes
    """
    app = QGuiApplication(sys.argv)

    # Register the Backend class with QML
    qmlRegisterType(Backend, "Demo", 1, 0, "Backend")

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

    # Run the application
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
