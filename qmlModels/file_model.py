from PySide2 import QtQuick, QtCore, QtGui, QtQml

class FileModel(QtCore.QAbstractListModel):
    PublicRole = QtCore.Qt.UserRole + 1000
    NameRole = QtCore.Qt.UserRole + 1001
    
    def __init__(self, Files, parent=None):
        super(FileModel, self).__init__(parent)
        self._Files = Files

    def rowCount(self, parent=QtCore.QModelIndex()):
        if parent.isValid():
            return 0
        return len(self._Files)

    def data(self, index, role=QtCore.Qt.DisplayRole):
        if 0 <= index.row() < self.rowCount() and index.isValid():
            item = self._Files[index.row()]
            if role == FileModel.NameRole:
                return item["name"]
            elif role == FileModel.PublicRole:
                return item["pubstr"]


    def roleNames(self):
        roles = {}
        roles[FileModel.NameRole] = b"name"
        roles[FileModel.PublicRole] = b"pubstr"
        return roles

    def appendRow(self, row):
        self.beginInsertRows(QtCore.QModelIndex(), self.rowCount(), self.rowCount())
        self._Files.append(row)
        self.endInsertRows()
    
    def reset(self, new_Files):
        self.beginResetModel()
        self._Files = new_Files
        self.endResetModel()

    @QtCore.Slot(int, result=str)
    def getName(self, index):
        if index not in range(0, self.rowCount()):
            return ''
        return self._Files[index]['name']
    

class FileModelProvider(QtCore.QObject):
    def __init__(self, Files, parent=None):
        super(FileModelProvider, self).__init__(parent)
        self._model = FileModel(Files)

    @QtCore.Property(QtCore.QObject, constant=True)
    def model(self):
        return self._model
