import sys
import os
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

def main():
    app = QGuiApplication(sys.argv)

    # Create QML engine
    engine = QQmlApplicationEngine()

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
