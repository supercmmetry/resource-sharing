import grpc
import utils
import proto.stresmg_pb2 as pb2
import proto.stresmg_pb2_grpc as pb2grpc



class Client():
    def __init__(self, ip):
        self.channel = grpc.insecure_channel(ip + ':8081', options=[('grpc.max_send_message_length', 10485760),
                                            ('grpc.max_receive_message_length', 10485760)])
        self.client = pb2grpc.uploadServiceStub(self.channel)
    
    def GetFile(self, filename):
        try:
            response = self.client.GetFile(pb2.FilesRequest(data=filename))
        except:
            return b""
        return response.data


    def GetFiles(self):
        try:
            response = self.client.GetFiles(pb2.FileRequest(filename='getfiles()'), timeout=1)
        except:
            return []
        return utils.convjsontolist(response.data)