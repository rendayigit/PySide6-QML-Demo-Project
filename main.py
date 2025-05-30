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
    """Backend class to demonstrate Python-QML integration"""

    # Signal to notify QML when message changes
    messageChanged = Signal(str)

    def __init__(self):
        super().__init__()
        self._message = "Hello from PySide6!"
        self._counter = 0

    @Property(str, notify=messageChanged)
    def message(self):
        return self._message

    @message.setter
    def message(self, value):
        if self._message != value:
            self._message = value
            self.messageChanged.emit(value)

    @Slot()
    def incrementCounter(self):
        """Slot to increment counter and update message"""
        self._counter += 1
        self.message = f"Button clicked {self._counter} times!"

    @Slot(str)
    def updateMessage(self, new_message):
        """Slot to update message from QML"""
        self.message = new_message


def main():
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
