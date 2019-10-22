import grpc
import utils
import proto.stresmg_pb2 as pb2
import proto.stresmg_pb2_grpc as pb2grpc



class gRPCClient():
    def __init__(self, ip):
        self.channel = grpc.insecure_channel(ip + ':8081', options=[('grpc.max_send_message_length', 10485760),
                                            ('grpc.max_receive_message_length', 10485760)])
        self.client = pb2grpc.uploadServiceStub(self.channel)
    
    def GetFiles(self):
        response = self.client.GetFile(pb2.FilesRequest(data=''))
        return utils.convjsontolist(response.data)
    

    def GetFile(self, filename):
        response = self.client.GetFiles(pb2.FileRequest(filename=filename))
        return response.data #file-bytes