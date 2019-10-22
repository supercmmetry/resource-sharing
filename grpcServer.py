from concurrent import futures
import threading
import grpc
import proto.stresmg_pb2 as pb2
import proto.stresmg_pb2_grpc as pb2grpc
import utils



class gRPCService(pb2grpc.uploadServiceServicer):

    def GetFiles(self, request, context):
        print(utils.getPublicFilesDB_thread())
        return pb2.FilesResponse(data=utils.convlisttojson(utils.getPublicFilesDB_thread()))
    
    def GetFile(self, request, context):
        f = open(request.filename, 'rb')
        data = f.read()
        return pb2.FileResponse(data=data)


class Server(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
        self.maxMsgLen = 10485760
    

    def stop(self):
        self.server.stop(0)

    def run(self):
        #serve grpc
        server = grpc.server(futures.ThreadPoolExecutor(max_workers=10),options=[
                            ('grpc.max_send_message_length', self.maxMsgLen),
                            ('grpc.max_receive_message_length', self.maxMsgLen)
                            ])
        self.server = server
        pb2grpc.add_uploadServiceServicer_to_server(gRPCService(), server)
        server.add_insecure_port('0.0.0.0:8081')
        server.start()
        server.wait_for_termination()
