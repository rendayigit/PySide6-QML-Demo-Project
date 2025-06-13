#!/usr/bin/env python3
"""
Galactron GUI - Main Entry Point

This is the main entry point for the Galactron GUI application.
It initializes the Qt application, sets up the QML engine, and starts the backend.

The application has a modular architecture:
- Backend core modules handle data management and JSON formatting
- Communication modules manage ZMQ connections and command interface
- QML components provide organized UI with clear separation of concerns
"""

import sys
import os
from pathlib import Path
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl

# Import the main backend class
from backend.core.backend import Backend
from backend.models.tree_model import register_tree_model

# Constants
QML_DIR = "src/qml"
APP_NAME = "Galactron"
APP_VERSION = "1.0"
ORG_NAME = "rendayigit"


def setup_qml_engine(engine: QQmlApplicationEngine) -> None:
    """
    Configure the QML engine with necessary settings and imports.

    Args:
        engine: The QQmlApplicationEngine instance to configure
    """

    engine.addImportPath(str(QML_DIR))

    # Set additional QML debugging if needed
    if "--debug" in sys.argv:
        os.environ["QML_IMPORT_TRACE"] = "1"


def main() -> int:
    """
    Main application entry point.

    Returns:
        Exit code (0 for success, non-zero for error)
    """
    try:
        # Create Qt application
        app = QGuiApplication(sys.argv)
        app.setApplicationName(APP_NAME)
        app.setApplicationVersion(APP_VERSION)
        app.setOrganizationName(ORG_NAME)

        # Create QML engine
        engine = QQmlApplicationEngine()

        # Register custom QML types
        register_tree_model()

        # Setup QML engine
        setup_qml_engine(engine)

        # Create and configure backend
        backend = Backend()

        # Make backend available to QML
        engine.rootContext().setContextProperty("backend", backend)

        # Load the main QML file
        qml_file = QML_DIR + "/main.qml"
        if not Path(qml_file).exists():
            print(f"Error: QML file not found at {qml_file}")
            return 1

        engine.load(QUrl.fromLocalFile(str(qml_file)))

        # Check if QML was loaded successfully
        if not engine.rootObjects():
            print("Error: Failed to load QML file")
            return 1

        # Start the backend services
        print("Starting Galactron GUI...")
        print("Backend services initialized successfully")

        if hasattr(backend, "start_services"):
            backend.start_services()

        # Run the application
        exit_code = app.exec()

        # Cleanup
        print("Shutting down...")
        if hasattr(backend, "stop_services"):
            backend.stop_services()

        return exit_code

    except KeyboardInterrupt:
        print("\nApplication interrupted by user")
        return 0
    except Exception as e:
        print(f"Error: Failed to start application: {e}")
        import traceback

        traceback.print_exc()
        return 1


if __name__ == "__main__":
    sys.exit(main())
