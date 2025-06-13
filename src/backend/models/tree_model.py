"""
Tree Model for Qt TreeView Component

This module provides a QAbstractItemModel implementation for hierarchical tree data
that can be used with Qt's TreeView component in QML.
"""

from typing import Any, Optional, List, Dict
from PySide6.QtCore import QAbstractItemModel, QModelIndex, Qt, QObject, Slot
from PySide6.QtQml import qmlRegisterType


class TreeItem:
    """A tree item that holds data and manages parent-child relationships"""
    
    def __init__(self, data: Dict[str, Any], parent: Optional['TreeItem'] = None):
        self.item_data = data
        self.parent_item = parent
        self.child_items: List['TreeItem'] = []
        
    def append_child(self, item: 'TreeItem'):
        """Add a child item"""
        item.parent_item = self
        self.child_items.append(item)
        
    def child(self, row: int) -> Optional['TreeItem']:
        """Get child at given row"""
        if 0 <= row < len(self.child_items):
            return self.child_items[row]
        return None
        
    def child_count(self) -> int:
        """Get number of children"""
        return len(self.child_items)
        
    def column_count(self) -> int:
        """Get number of columns (always 1 for our tree)"""
        return 1
        
    def data(self, column: int) -> Any:
        """Get data for given column"""
        if column == 0:
            return self.item_data.get('name', '')
        return None
        
    def parent(self) -> Optional['TreeItem']:
        """Get parent item"""
        return self.parent_item
        
    def row(self) -> int:
        """Get row index in parent"""
        if self.parent_item:
            return self.parent_item.child_items.index(self)
        return 0


class TreeModel(QAbstractItemModel):
    """
    QAbstractItemModel implementation for hierarchical tree data
    
    This model can be used with Qt's TreeView component and provides
    proper model-view architecture for tree structures.
    """
    
    def __init__(self, parent: Optional[QObject] = None):
        super().__init__(parent)
        self.root_item = TreeItem({'name': 'Root'})
        
    def index(self, row: int, column: int, parent: QModelIndex = QModelIndex()) -> QModelIndex:
        """Create model index for given row, column, and parent"""
        if not self.hasIndex(row, column, parent):
            return QModelIndex()
            
        if not parent.isValid():
            parent_item = self.root_item
        else:
            parent_item = parent.internalPointer()
            
        child_item = parent_item.child(row)
        if child_item:
            return self.createIndex(row, column, child_item)
        return QModelIndex()
        
    def parent(self, index: QModelIndex) -> QModelIndex:
        """Get parent index for given child index"""
        if not index.isValid():
            return QModelIndex()
            
        child_item = index.internalPointer()
        parent_item = child_item.parent()
        
        if parent_item == self.root_item or parent_item is None:
            return QModelIndex()
            
        return self.createIndex(parent_item.row(), 0, parent_item)
        
    def rowCount(self, parent: QModelIndex = QModelIndex()) -> int:
        """Get number of rows under given parent"""
        if parent.column() > 0:
            return 0
            
        if not parent.isValid():
            parent_item = self.root_item
        else:
            parent_item = parent.internalPointer()
            
        return parent_item.child_count()
        
    def columnCount(self, parent: QModelIndex = QModelIndex()) -> int:
        """Get number of columns"""
        return 1
        
    def data(self, index: QModelIndex, role: int = Qt.DisplayRole) -> Any:
        """Get data for given index and role"""
        if not index.isValid():
            return None
            
        item = index.internalPointer()
        
        if role == Qt.DisplayRole:
            return item.data(index.column())
        elif role == Qt.UserRole:  # Custom role for full path
            return item.item_data.get('fullPath', '')
        elif role == Qt.UserRole + 1:  # Custom role for hasChildren
            return item.item_data.get('hasChildren', False)
        elif role == Qt.UserRole + 2:  # Custom role for level
            return item.item_data.get('level', 0)
            
        return None
        
    def headerData(self, section: int, orientation: Qt.Orientation, role: int = Qt.DisplayRole) -> Any:
        """Get header data"""
        if orientation == Qt.Horizontal and role == Qt.DisplayRole and section == 0:
            return "Name"
        return None
        
    def clear_model(self):
        """Clear all data from the model"""
        self.beginResetModel()
        self.root_item = TreeItem({'name': 'Root'})
        self.endResetModel()
        
    def populate_from_flat_data(self, flat_data: List[Dict[str, Any]]):
        """
        Populate the model from flat hierarchical data
        
        Args:
            flat_data: List of dictionaries with keys: name, fullPath, hasChildren, level
        """
        self.beginResetModel()
        
        # Clear existing data
        self.root_item = TreeItem({'name': 'Root'})
        
        if not flat_data:
            self.endResetModel()
            return
            
        # Build item hierarchy
        item_map = {}  # Map fullPath to TreeItem
        
        # Sort by level to ensure parents are created before children
        sorted_data = sorted(flat_data, key=lambda x: x.get('level', 0))
        
        for data in sorted_data:
            item = TreeItem(data)
            item_map[data.get('fullPath', '')] = item
            
            level = data.get('level', 0)
            if level == 0:
                # Top-level item
                self.root_item.append_child(item)
            else:
                # Find parent by checking path prefixes
                full_path = data.get('fullPath', '')
                parent_item = self._find_parent_item(full_path, item_map)
                if parent_item:
                    parent_item.append_child(item)
                else:
                    # Fallback: add to root if parent not found
                    self.root_item.append_child(item)
                    
        self.endResetModel()
        
    def _find_parent_item(self, child_path: str, item_map: Dict[str, TreeItem]) -> Optional[TreeItem]:
        """Find parent item for given child path"""
        parts = child_path.split('.')
        for i in range(len(parts) - 1, 0, -1):
            parent_path = '.'.join(parts[:i])
            if parent_path in item_map:
                return item_map[parent_path]
        return None
        
    def get_item_data(self, index: QModelIndex) -> Dict[str, Any]:
        """Get the full data dictionary for an item"""
        if not index.isValid():
            return {}
        item = index.internalPointer()
        return item.item_data.copy()

    @Slot(QModelIndex, result="QVariant")
    def get_item_data_qml(self, index: QModelIndex) -> Dict[str, Any]:
        """QML-callable version of get_item_data"""
        return self.get_item_data(index)


# Register the model type for QML
def register_tree_model():
    """Register TreeModel for use in QML"""
    qmlRegisterType(TreeModel, "TreeModels", 1, 0, "TreeModel")
