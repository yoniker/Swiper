import 'dart:async';
import 'dart:convert';
import 'dart:convert' as json;
import 'package:betabeta/models/infoMessage.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

enum NetworkTaskStatus {
  completed,
  inProgress,
  notExist
} //possible statuses for long ongoing tasks on the server

enum TaskResult { success, failed }

class ChatNetworkHelper {
  static const SERVER_ADDR = 'dordating.com:8085';
  static final ChatNetworkHelper _instance = ChatNetworkHelper._internal();
  static const MIN_TASK_STATUS_CALL_INTERVAL = Duration(seconds: 1);

  factory ChatNetworkHelper() {
    return _instance;
  }

  ChatNetworkHelper._internal();

  static Future<TaskResult> sendMessage(String uid,
      String startingConversationContent, double senderEpochTime) async {
    Map<String, dynamic> toSend = {
      'other_user_id': uid,
      'message_content': startingConversationContent,
      'sender_epoch_time': senderEpochTime
    };
    String encoded = jsonEncode(toSend);
    Uri postMessageUri =
        Uri.https(SERVER_ADDR, '/send_message/${SettingsData.instance.uid}');
    http.Response response = await http.post(postMessageUri, body: encoded);
    if (response.statusCode == 200) {
      return TaskResult.success;
    }
    return TaskResult.failed;
  }

  static Future<Tuple2<List<InfoMessage>, List<dynamic>>>
      getMessagesByTimestamp() async {
    Uri syncChatDataUri = Uri.https(SERVER_ADDR,
        '/sync/${SettingsData.instance.uid}/${SettingsData.instance.lastSync}');
    http.Response response = await http.get(syncChatDataUri);
    var unparsedData = json.jsonDecode(response.body);
    List<dynamic> unparsedMessages = unparsedData['messages_data'];
    List<dynamic> unparsedMatchesChanges = unparsedData['matches_data'];
    List<InfoMessage> messages = unparsedMessages
        .map((message) => InfoMessage.fromJson(message))
        .toList();
    return Tuple2(messages, unparsedMatchesChanges);
  }

  static Future<bool> markConversationAsRead(String conversationId) async {
    Uri syncChatDataUri = Uri.https(SERVER_ADDR,
        '/mark_conversation_read/${SettingsData.instance.uid}/$conversationId');
    http.Response response =
        await http.get(syncChatDataUri); //TODO something when there's an error
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<void> deleteAccount() async {
    Uri deleteAccountUri =
        Uri.https(SERVER_ADDR, '/delete_account/${SettingsData.instance.uid}');
    http.Response response = await http.get(deleteAccountUri);
    //TODO check for a successful response and give user feedback if not successful
  }

  static Future<String> registerUid({required String firebaseIdToken}) async {
    Uri verifyTokenUri = Uri.https(SERVER_ADDR, '/register_firebase_uid');
    http.Response response = await http
        .get(verifyTokenUri, headers: {'firebase_id_token': firebaseIdToken});
    if (response.statusCode != 200) {
      //TODO throw error (bad jwt? server down?)
    }

    return json.jsonDecode(response.body)['uid'];
  }
}
