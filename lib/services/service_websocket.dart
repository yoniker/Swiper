import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:betabeta/services/settings_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class ServiceWebsocket {


  late StreamController _streamController;
  late StreamSubscription subscription;
  bool _exposedStreamActive = false;
  ServiceWebsocket._privateConstructor(){
    connectWs();
    _streamController = StreamController<dynamic>(
        onCancel: (){_exposedStreamActive=false;},
        onListen: (){_exposedStreamActive=true;},
        onPause: (){_exposedStreamActive=false;},
        onResume: (){_exposedStreamActive=true;}
    );
    StreamSubscription subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      delayConnect(delayTime:Duration(milliseconds: 200));
    });


  }

  static final ServiceWebsocket _instance = ServiceWebsocket._privateConstructor();

  static ServiceWebsocket get instance => _instance;

  bool _creatingConnection = false;
  WebSocket? _channel;
  Timer? _dbouncer;


  Stream<dynamic> get stream{
    return _streamController.stream;
  }

  void _listenRawMessages(dynamic message){
    var decoded_message = json.decode(message);
    Map<String,dynamic> content = decoded_message;
    if(_exposedStreamActive){
      _streamController.add(content);
    }
  }

  connectWs() async{
    if(_creatingConnection==true ||(_channel!=null && _channel!.readyState==WebSocket.open)){return;}
    try {
      _creatingConnection = true;
      await _waitUntilConnected();
      while(_channel==null || _channel!.readyState!=WebSocket.open){
        _channel =  await WebSocket.connect('wss://services.voilaserver.com/websockets/register',headers: {'user_id':SettingsData.instance.uid});
        if(_channel==null){await Future.delayed(Duration(seconds: 2));}
      }
      print('Registering my WS!');
      var encoded = jsonEncode({'user_id':SettingsData.instance.uid});
      _channel!.add(encoded);
      _channel!.listen(_listenRawMessages,onError: (error){
        delayConnect(delayTime: Duration(milliseconds: 200));
        print('ERROR $error HAS OCCURED!');},onDone:
          (){
        delayConnect(delayTime: Duration(milliseconds: 200));
        print('STREAM IS DONE!!!');
      });
      return;
    }
    catch  (e) {
      print("Error! can not connect WS connectWs " + e.toString());
      delayConnect(delayTime: Duration(milliseconds: 200));
    }
    finally
    {_creatingConnection = false;}

  }

  Future<void> _waitUntilConnected({Duration checkEvery = const Duration(seconds: 1)})async{
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    while(connectivityResult == ConnectivityResult.none){
      print('No connection detected');
      await Future.delayed(checkEvery);
      connectivityResult = await Connectivity().checkConnectivity();

    }
  }



  void delayConnect({Duration delayTime = const Duration(seconds: 1)})async{
    if(_dbouncer!=null && _dbouncer!.isActive){
      print('Debouncer is active so not going to try to reconnect on top of existing reconnect..');
      return;}
    _dbouncer = Timer(delayTime,()async{
      await connectWs();

    });

  }




}