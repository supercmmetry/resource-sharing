import snet


if __name__ == '__main__':
    srv = snet.SNetServer('127.0.0.1', snet.DataType.TEXT)
    srv.setText('Hello SNet!')
    srv.start()
