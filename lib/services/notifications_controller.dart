
import 'package:betabeta/models/chatData.dart';
import 'package:betabeta/models/infoUser.dart';
import 'package:betabeta/screens/chat_screen.dart';
import 'package:betabeta/screens/conversations_screen.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/services/app_state_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert' as json;

import 'package:get/get.dart';


enum NotificationType {
  newMessage,
  newMatch,
}

class NotificationsController{

  static const String NEW_MESSAGE_NOTIFICATION = 'new_message_notification';
  static const String NOTIFICATION_TYPE = 'notification_type';
  static const String SENDER_ID = 'sender_id';
  int latestTabOnMainNavigation = 1 ; //Ugly as fuck as this couples this object with main navigataion, but I didn't think of a better solution. See https://stackoverflow.com/questions/70542493/show-a-snackbar-depending-on-current-page-route-state

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationsController._privateConstructor();

  static final NotificationsController instance = NotificationsController._privateConstructor();

  static Future selectNotification(String? payload) async {
    if(payload==null){return;}
    Map<String,dynamic> notificationData = json.jsonDecode(payload);
    if(notificationData[NOTIFICATION_TYPE]==NEW_MESSAGE_NOTIFICATION){
      String senderId = notificationData[SENDER_ID]!;
      InfoUser? collocutor = ChatData().getUserById(senderId);

      if(collocutor!=null){
        Get.toNamed(ChatScreen.getRouteWithUserId(collocutor.facebookId));
      }

    }

  }

  Future<bool?> requestIOSPermissions() async{
    final bool? result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    return result;
  }
  



  Future<void> initialize()async{
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );


    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification
    );



  }

  bool shouldShowMessageSnackbar(String senderId){
    //Goal: No snackbar on conversations tab, no snackbar when in chat with the same user...
    var uri = Uri.parse(Get.currentRoute);
    if(uri.path == MainNavigationScreen.routeName &&latestTabOnMainNavigation==MainNavigationScreen.CONVERSATIONS_PAGE_INDEX) {
      return false;
    }
    if(uri.path == ChatScreen.routeName && uri.queryParameters.containsKey(ChatScreen.USERID_PARAM) && uri.queryParameters[ChatScreen.USERID_PARAM] == senderId){
      return false;
    }
  return true;
  }


  Future<bool> navigateChatOnBackgroundNotification()async{
    final notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      latestTabOnMainNavigation = MainNavigationScreen.CONVERSATIONS_PAGE_INDEX;
      Get.offAllNamed(MainNavigationScreen.routeName);  //So that the back button will go to conversations screen rather than (splash/main screen)
      selectNotification(notificationAppLaunchDetails!.payload);

      return true;
    }
    return false;
  }



  Future<void> showNewMessageNotification(
      {required String senderName, required String senderId,bool dontNotifyOnForeground=true,bool showSnackIfResumed=true}
      )async{
    if(AppStateInfo.instance.appState==AppLifecycleState.resumed){ //The app is in the foreground. Let's see what to do
      if(showSnackIfResumed && shouldShowMessageSnackbar(senderId)){
        Get.snackbar("You got a new message!", 'New message from $senderName',duration: Duration(seconds: 3),
            onTap: (snackBar){
          Get.toNamed(ChatScreen.getRouteWithUserId(senderId));
        });
      }
      
      if(dontNotifyOnForeground) {return;}
    } 
    
    const AndroidNotificationDetails _androidNotificationDetails =
    AndroidNotificationDetails(
      'DorChat channel ID',
      'DorChat channel name',
      channelDescription: 'DorChat channel description',
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,
    );

    const IOSNotificationDetails _iOSNotificationDetails =
    IOSNotificationDetails(threadIdentifier: 'DorChat_thread_id');


    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(
        android: _androidNotificationDetails,
        iOS: _iOSNotificationDetails);

    Map<String,String> payloadData = {
      NOTIFICATION_TYPE:NEW_MESSAGE_NOTIFICATION,
      SENDER_ID:senderId
    };
    await flutterLocalNotificationsPlugin.cancelAll(); //Clear all raw notifications before showing current notification
    await flutterLocalNotificationsPlugin.show(
      0,
      'ChatDor',
      'You got a new message from $senderName',
      platformChannelSpecifics,
      payload: json.jsonEncode(payloadData),
    );

  }





}