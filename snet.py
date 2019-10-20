import socket
import threading
import os
from enum import Enum


def sendSizeHeader(sconn, size):
    ss = str(size)
    sconn.send((('0' * (1024 - len(ss))) + ss).encode())


def sendTypeHeader(sconn, dtype):
    sconn.send(str(dtype).encode())


class DataType(Enum):
    FILE = 1
    TEXT = 2


class SNetServer(threading.Thread):
    def __init__(self, ip, dtype):
        threading.Thread.__init__(self)
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.port = 8081
        self.targ_online = False
        self.ip = ip
        self.dtype = dtype
    

    def setFileName(self, filename):
        self.filename = filename


    def setText(self, text):
        self.text = text


    def run(self):
        self.sock.bind((self.ip, self.port))
        self.sock.listen(5)
        if self.dtype == DataType.FILE:
            self.sendFile(self.filename)
        if self.dtype == DataType.TEXT:
            self.sendText(self.text)
    
    
    def sendText(self, text):
        c, addr = self.sock.accept()
        sendTypeHeader(c, self.dtype.value)
        sendSizeHeader(c, len(text))
        c.send(text.encode())
        c.close()

    
    def sendFile(self, filename):
        if os.path.isfile(filename):
            c, addr = self.sock.accept()
            sendTypeHeader(c, self.dtype.value)
            sendSizeHeader(c, len(filename))
            c.send(filename.encode())
            
            fsize = os.stat(filename).st_size
            sendSizeHeader(c, fsize)

            f = open(filename, 'rb')
            data = f.read()
            
            c.send(data)
            
            c.close()


class SNetClient(threading.Thread):
    def __init__(self, ip):
        threading.Thread.__init__(self)
        self.port = 8081
        self.sock = socket.socket()
        self.ip = ip
        self.isBusy = True


    def run(self):
        self.sock.connect((self.ip, self.port))
        enumval = int(self.sock.recv(1))
        if enumval == 1:
            self.dtype = DataType.FILE
        elif enumval == 2:
            self.dtype = DataType.TEXT

        if self.dtype == DataType.FILE:
            fnsize = int(self.sock.recv(1024))
            filename = self.sock.recv(fnsize)
            print(filename)
            fsize = int(self.sock.recv(1024))
            filedata = self.sock.recv(fsize)
            print(filedata)
        elif self.dtype == DataType.TEXT:
            tsize = int(self.sock.recv(1024))
            text = self.sock.recv(tsize)
            print(text)
        
        self.sock.close()



        
