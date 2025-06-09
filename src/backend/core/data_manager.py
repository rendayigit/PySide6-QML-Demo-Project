"""
Data Manager Module

This module handles the management of watched variables, model tree data,
and other simulation data structures.
"""

from typing import Dict, Any, List, Optional
from PySide6.QtCore import QObject, Signal
from .json_formatter import JSONFormatter


class DataManager(QObject):
    """Manages simulation data including watched variables and model tree"""
    
    # Signals for data changes
    variableAdded = Signal('QVariant')  # variable data
    variableUpdated = Signal(str, 'QVariant')  # variable path, complete variable data
    variableRemoved = Signal(str)  # variable path when removed
    variablesCleared = Signal()  # signal when all variables are cleared
    modelTreeUpdated = Signal('QVariant')  # model tree data
    
    def __init__(self):
        super().__init__()
        self._watched_variables: Dict[str, Dict[str, Any]] = {}
        self._json_formatter = JSONFormatter()
    
    # Variables Management
    def add_variable_to_watch(self, variable_path: str, description: str = "") -> bool:
        """
        Add a variable to the watch list
        
        Args:
            variable_path: Full path of the variable to watch
            description: Optional description of the variable
            
        Returns:
            True if variable was added, False if already exists
        """
        if variable_path in self._watched_variables:
            print(f"Variable '{variable_path}' is already being watched")
            return False
        
        # Add the variable to watch list with initial values
        variable_data = {
            "variablePath": variable_path,
            "description": description,
            "value": "-",  # Default value until updated
            "type": "unknown",
            "selected": False
        }
        
        self._watched_variables[variable_path] = variable_data
        print(f"Variable '{variable_path}' added to watch list")
        
        # Emit signal to notify QML to add the variable to the model
        self.variableAdded.emit(variable_data)
        return True
    
    def remove_variable_from_watch(self, variable_path: str) -> bool:
        """
        Remove a specific variable from the watch list
        
        Args:
            variable_path: Path of the variable to remove
            
        Returns:
            True if variable was removed, False if not found
        """
        if variable_path in self._watched_variables:
            del self._watched_variables[variable_path]
            print(f"Variable '{variable_path}' removed from watch list")
            # Emit signal to notify QML to remove the variable from the model
            self.variableRemoved.emit(variable_path)
            return True
        else:
            print(f"Variable '{variable_path}' not found in watch list")
            return False
    
    def clear_variable_table(self) -> bool:
        """
        Clear all variables from the watch list
        
        Returns:
            True if variables were cleared
        """
        self._watched_variables.clear()
        print("Variable table cleared")
        # Emit signal to clear QML model
        self.variablesCleared.emit()
        return True
    
    def update_variable_value(self, variable_path: str, value: Any, 
                            variable_type: Optional[str] = None) -> None:
        """
        Update the value of a watched variable
        
        Args:
            variable_path: Path of the variable to update
            value: New value for the variable
            variable_type: Optional type override
        """
        if variable_path not in self._watched_variables:
            return
        
        # Format the value for display
        formatted_value = self._json_formatter.format_variable_value(value)
        
        # Determine variable type if not provided
        if variable_type is None:
            variable_type = self._get_variable_type(value)
        
        # Update the variable data
        self._watched_variables[variable_path].update({
            "value": formatted_value,
            "type": variable_type
        })
        
        # Emit signal to update QML model
        self.variableUpdated.emit(variable_path, self._watched_variables[variable_path])
    
    def update_fields_data(self, fields_data: List[Dict[str, Any]]) -> None:
        """
        Update watched variables with new field data from FIELDS topic
        
        Args:
            fields_data: List of field data dictionaries
        """
        for field in fields_data:
            variable_path = field.get('path')
            value = field.get('value')
            
            if variable_path and variable_path in self._watched_variables:
                self.update_variable_value(variable_path, value)
    
    def _get_variable_type(self, value: Any) -> str:
        """
        Determine the type of a variable based on its value
        
        Args:
            value: Value to analyze
            
        Returns:
            String representation of the variable type
        """
        if isinstance(value, bool):
            return "bool"
        elif isinstance(value, int):
            return "int"
        elif isinstance(value, float):
            return "float"
        elif isinstance(value, (list, dict)):
            return "json" if isinstance(value, dict) else "array"
        elif isinstance(value, str):
            # Check if string contains JSON
            if self._json_formatter.is_json_string(value):
                return "json"
            else:
                return "string"
        else:
            return "unknown"
    
    def get_watched_variables(self) -> Dict[str, Dict[str, Any]]:
        """
        Get all currently watched variables
        
        Returns:
            Dictionary of watched variables
        """
        return self._watched_variables.copy()
    
    def is_variable_watched(self, variable_path: str) -> bool:
        """
        Check if a variable is currently being watched
        
        Args:
            variable_path: Path of the variable to check
            
        Returns:
            True if variable is being watched, False otherwise
        """
        return variable_path in self._watched_variables
    
    # Model Tree Management
    def update_model_tree(self, model_tree_data: Dict[str, Any]) -> None:
        """
        Update model tree data from MODEL_TREE topic
        
        This method converts the hierarchical model tree data to a flat list
        format that can be easily consumed by QML ListView components.
        
        Args:
            model_tree_data: Hierarchical model tree structure
        """
        # Convert the hierarchical model tree data to a flat list for QML
        tree_items = []
        
        def process_node(node_data: Any, parent_name: str = "", level: int = 0) -> None:
            """
            Recursively process model tree nodes
            
            Args:
                node_data: Current node data (dict, list, or value)
                parent_name: Name of the parent node
                level: Current tree depth level
            """
            if isinstance(node_data, dict):
                for key, children in node_data.items():
                    # Calculate full path for this node
                    full_path = f"{parent_name}.{key}" if parent_name else key
                    has_children = bool(children) if isinstance(children, (dict, list)) else False
                    
                    # Add this node to the tree items
                    tree_items.append({
                        "name": key,
                        "fullPath": full_path,
                        "level": level,
                        "hasChildren": has_children,
                        "expanded": False,  # Start collapsed
                        "visible": level == 0  # Only top level visible initially
                    })
                    
                    # Process children recursively
                    if has_children:
                        process_node(children, full_path, level + 1)
                        
            elif isinstance(node_data, list):
                for item in node_data:
                    if isinstance(item, dict):
                        process_node(item, parent_name, level)
        
        # Process the model tree data
        process_node(model_tree_data)
        
        # Emit signal to update QML model
        self.modelTreeUpdated.emit(tree_items)
        print(f"Model tree updated with {len(tree_items)} items")
