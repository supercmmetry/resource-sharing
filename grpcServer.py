from concurrent import futures
import threading
import grpc
import proto.stresmg_pb2 as pb2
import proto.stresmg_pb2_grpc as pb2grpc
import utils



class gRPCService(pb2grpc.uploadServiceServicer):
    def GetFiles(self, request, context):
        return pb2.FilesResponse(data=utils.convlisttojson(utils.getPublicFilesDB()))
    
    def GetFile(self, request, context):
        f = open(request.filename, 'rb')
        data = f.read()
        return pb2.FileResponse(data=data)


class gRPCServer(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
        self.maxMsgLen = 10485760
        

    def run(self):
        #serve grpc
        server = grpc.server(futures.ThreadPoolExecutor(max_workers=10),options=[
                            ('grpc.max_send_message_length', self.maxMsgLen),
                            ('grpc.max_receive_message_length', self.maxMsgLen)
                            ])
        pb2grpc.add_uploadServiceServicer_to_server(gRPCService(), server)
        server.add_insecure_port('localhost:8081')
        server.start()
        server.wait_for_termination()
