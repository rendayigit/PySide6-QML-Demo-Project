"""
Backend Core Module

This module contains the core backend functionality including the main Backend class,
data management, and JSON formatting utilities.
"""

from .backend import Backend
from .data_manager import DataManager
from .json_formatter import JSONFormatter

__all__ = ['Backend', 'DataManager', 'JSONFormatter']