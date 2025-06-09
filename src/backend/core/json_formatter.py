"""
JSON Formatting Utilities

This module provides utilities for formatting JSON data into human-readable text
without brackets, quotes, and commas, using proper indentation for hierarchy.
"""

import json
from typing import Any


class JSONFormatter:
    """Handles formatting of JSON data for human-readable display"""

    INDENT_SIZE = 4  # Number of spaces per indentation level

    @staticmethod
    def is_json_string(value: str) -> bool:
        """
        Check if a string represents valid JSON data

        Args:
            value: String to check

        Returns:
            True if the string is valid JSON, False otherwise
        """
        if not isinstance(value, str):
            return False

        # Remove surrounding whitespace
        value = value.strip()

        # Check if it looks like JSON (starts with { or [)
        if not (value.startswith("{") or value.startswith("[")):
            return False

        try:
            json.loads(value)
            return True
        except (ValueError, json.JSONDecodeError):
            return False

    @classmethod
    def format_json_for_display(cls, json_str: str) -> str:
        """
        Format JSON string for human-readable display

        Args:
            json_str: JSON string to format

        Returns:
            Formatted string without brackets, quotes, and commas
        """
        try:
            data = json.loads(json_str)
            if isinstance(data, dict):
                return cls._format_dict_for_display(data)
            if isinstance(data, list):
                return cls._format_list_for_display(data)
            return str(data)
        except (ValueError, json.JSONDecodeError):
            return json_str

    @classmethod
    def _format_dict_for_display(cls, data: dict, indent_level: int = 0) -> str:
        """
        Format dictionary for readable display without brackets and commas

        Args:
            data: Dictionary to format
            indent_level: Current indentation level

        Returns:
            Formatted string representation
        """
        if not data:
            return ""

        # Use 4 spaces for each indentation level to make hierarchy more visible
        indent = " " * (cls.INDENT_SIZE * indent_level)

        items = []
        for key, value in data.items():
            if isinstance(value, dict):
                if value:  # Only show non-empty dictionaries
                    items.append(f"{indent}{key}:")
                    items.append(cls._format_dict_for_display(value, indent_level + 1))
                else:
                    items.append(f"{indent}{key}")
            elif isinstance(value, list):
                if value:  # Only show non-empty lists
                    items.append(f"{indent}{key}:")
                    items.append(cls._format_list_for_display(value, indent_level + 1))
                else:
                    # For empty lists, just show the key name without colon
                    items.append(f"{indent}{key}")
            elif isinstance(value, str):
                items.append(f"{indent}{key}: {value}")
            else:
                items.append(f"{indent}{key}: {value}")

        return "\n".join(filter(None, items))  # Filter out empty strings

    @classmethod
    def _format_list_for_display(cls, data: list, indent_level: int = 0) -> str:
        """
        Format list for readable display without brackets and commas

        Args:
            data: List to format
            indent_level: Current indentation level

        Returns:
            Formatted string representation
        """
        if not data:
            return ""  # Return empty string for empty lists

        # Use 4 spaces for each indentation level to make hierarchy more visible
        indent = " " * (cls.INDENT_SIZE * indent_level)

        items = []
        for item in data:  # Remove the enumerate to get rid of [i] indices
            if isinstance(item, dict):
                # Handle dictionaries in lists - extract and format their content
                dict_content = cls._format_dict_for_display(item, indent_level)
                if dict_content:
                    items.append(dict_content)
            elif isinstance(item, list):
                list_content = cls._format_list_for_display(item, indent_level + 1)
                if list_content:
                    items.append(list_content)
            elif isinstance(item, str):
                items.append(f"{indent}{item}")
            else:
                items.append(f"{indent}{item}")

        return "\n".join(filter(None, items))  # Filter out empty strings

    @classmethod
    def format_variable_value(cls, value: Any) -> str:
        """
        Format variable value for display in the variables table

        Args:
            value: Value to format (can be any type)

        Returns:
            Formatted string representation
        """
        if isinstance(value, (int, float)):
            return f"{value:.3f}" if isinstance(value, float) else str(value)
        if isinstance(value, bool):
            return "true" if value else "false"
        if isinstance(value, (list, dict)):
            # Convert to JSON string first, then format for display
            json_str = json.dumps(value)
            return cls.format_json_for_display(json_str)

        value_str = str(value)
        # Check if the string value is JSON and format it
        if cls.is_json_string(value_str):
            return cls.format_json_for_display(value_str)
        return value_str

    @classmethod
    def format_message_for_display(cls, message: str) -> str:
        """
        Format message for display, handling embedded JSON within log messages

        This method finds JSON objects and arrays within mixed text content
        (like log messages) and formats them for better readability.

        Args:
            message: Message string that may contain embedded JSON

        Returns:
            Formatted message with JSON content made readable
        """
        if not isinstance(message, str):
            message = str(message)

        # Check if the entire message is JSON
        if cls.is_json_string(message):
            return cls.format_json_for_display(message)

        # Look for JSON patterns within the message using sophisticated parsing
        return cls._find_and_format_embedded_json(message)

    @classmethod
    def _find_and_format_embedded_json(cls, text: str) -> str:
        """
        Find JSON objects and arrays in text and format them

        This method parses through text character by character to find complete
        JSON structures (handling nested brackets and string escaping properly)
        and formats them while leaving the rest of the text unchanged.

        Args:
            text: Text that may contain embedded JSON

        Returns:
            Text with embedded JSON formatted for readability
        """
        result = []
        i = 0

        while i < len(text):
            char = text[i]

            # Look for start of JSON object or array
            if char in ["{", "["]:
                # Try to extract a complete JSON structure
                json_start = i
                bracket_count = 0
                in_string = False
                escape_next = False

                # Find the complete JSON structure
                for j in range(i, len(text)):
                    current_char = text[j]

                    if escape_next:
                        escape_next = False
                        continue

                    if current_char == "\\":
                        escape_next = True
                        continue

                    if current_char == '"' and not escape_next:
                        in_string = not in_string
                        continue

                    if not in_string:
                        if current_char in ["{", "["]:
                            bracket_count += 1
                        elif current_char in ["}", "]"]:
                            bracket_count -= 1

                            if bracket_count == 0:
                                # Found complete JSON structure
                                json_candidate = text[json_start : j + 1]

                                if cls.is_json_string(json_candidate):
                                    # Format the JSON and add to result
                                    formatted_json = cls.format_json_for_display(json_candidate)
                                    result.append(formatted_json)

                                    # Move past this JSON
                                    i = j + 1
                                    break
                                else:
                                    # Not valid JSON, continue character by character
                                    result.append(char)
                                    i += 1
                                    break
                else:
                    # Reached end without finding complete JSON
                    result.append(char)
                    i += 1
            else:
                result.append(char)
                i += 1

        return "".join(result)
