import 'dart:async';
import 'dart:convert';
import 'dart:convert' as json;
import 'package:betabeta/models/infoMessage.dart';
import 'package:betabeta/models/infoUser.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';


enum NetworkTaskStatus { completed, inProgress, notExist } //possible statuses for long ongoing tasks on the server

enum TaskResult {success,failed}


class ChatNetworkHelper {
  static const SERVER_ADDR = 'dordating.com:8085';
  static final ChatNetworkHelper _instance = ChatNetworkHelper._internal();
  static const MIN_TASK_STATUS_CALL_INTERVAL = Duration(seconds: 1);

  factory ChatNetworkHelper() {
    return _instance;
  }

  ChatNetworkHelper._internal();

  static Future<List<InfoUser>> getAllUsers() async {
    //TODO currently no one uses this method, remove if really redundant
    Uri usersLinkUri = Uri.https(SERVER_ADDR, 'users/${SettingsData().facebookId}');
    http.Response resp = await http.get(usersLinkUri);
    if (resp.statusCode == 200) {
      //TODO think how to handle network errors
      List<dynamic> parsed = json.jsonDecode(resp.body);
      List<InfoUser> users = parsed.map((e) => InfoUser.fromJson(e)).toList();
      return users;
    }

    return [];
  }





  static postUserSettings() async {
    SettingsData settings = SettingsData();
    Map<String, String> toSend = {
      SettingsData.NAME_KEY: settings.name,
      SettingsData.FCM_TOKEN_KEY: settings.fcmToken,
      SettingsData.FACEBOOK_ID_KEY : settings.facebookId,
      SettingsData.FACEBOOK_PROFILE_IMAGE_URL_KEY:settings.facebookProfileImageUrl,
    };
    String encoded = jsonEncode(toSend);
    Uri postSettingsUri =
    Uri.https(SERVER_ADDR, '/register/${settings.facebookId}');
    print('sending user data...');
    http.Response response = await http.post(postSettingsUri,
        body: encoded); //TODO something if response wasnt 200
    if (response.statusCode == 200){
      SettingsData().registered = true;
    }
  }

  static Future<TaskResult> sendMessage(String facebookUserId,String startingConversationContent,double senderEpochTime) async{
    Map<String, dynamic> toSend = {
      'other_user_id':facebookUserId,
      'message_content':startingConversationContent,
      'sender_epoch_time':senderEpochTime
    };
    String encoded = jsonEncode(toSend);
    Uri postMessageUri =
    Uri.https(SERVER_ADDR, '/send_message/${SettingsData().facebookId}');
    http.Response response = await http.post(postMessageUri, body: encoded);
    if(response.statusCode==200){
      return TaskResult.success;
    }
    return TaskResult.failed;
  }

  static Future<Tuple2<List<InfoMessage>,List<dynamic>>> getMessagesByTimestamp()async{
    print('going to sync with ${SettingsData().lastSync}');
    Uri syncChatDataUri = Uri.https(SERVER_ADDR, '/sync/${SettingsData().facebookId}/${SettingsData().lastSync}');
    http.Response response = await http.get(syncChatDataUri);
    var unparsedData = json.jsonDecode(response.body);
    List<dynamic> unparsedMessages = unparsedData['messages_data'];
    List<dynamic> unparsedMatchesChanges = unparsedData['matches_data'];
    List<InfoMessage> messages = unparsedMessages.map((message) => InfoMessage.fromJson(message)).toList();
    return Tuple2(messages,unparsedMatchesChanges);

  }

  static Future<bool> markConversationAsRead(String conversationId) async{
    Uri syncChatDataUri = Uri.https(SERVER_ADDR, '/mark_conversation_read/${SettingsData().facebookId}/$conversationId');
    http.Response response = await http.get(syncChatDataUri); //TODO something when there's an error
    if(response.statusCode==200){
      return true;
    }
    return false;
  }



}
