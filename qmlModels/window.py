from PySide2 import QtQuick, QtCore, QtGui, QtQml

class BackendWindow(QtCore.QObject):
    def __init__(self, parent=None):
        QtCore.QObject.__init__(self)
        self.onWindowClose = None

    @QtCore.Slot()
    def onClose(self):
        if self.onWindowClose == None:
            return
        self.onWindowClose()



