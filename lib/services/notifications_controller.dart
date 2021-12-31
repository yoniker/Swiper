
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

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationsController._privateConstructor();

  static final NotificationsController instance = NotificationsController._privateConstructor();

  static Future selectNotification(String? payload) async {
    if(payload==null){return;}
    Map<String,dynamic> handleNotificationData = json.jsonDecode(payload);
    if(handleNotificationData[NOTIFICATION_TYPE]==NEW_MESSAGE_NOTIFICATION){
      String senderId = handleNotificationData[SENDER_ID]!;
      InfoUser? collocutor = ChatData().getUserById(senderId);

      if(collocutor!=null){
        Get.toNamed(ChatScreen.routeName,arguments: collocutor);
      }

    }

  }

  void requestIOSPermissions(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
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


  Future<bool> navigateChatOnBackgroundNotification()async{
    final notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      Get.offAll(MainNavigationScreen(pageIndex: MainNavigationScreen.CONVERSATIONS_PAGE_INDEX));  //So that the back button will go to conversations screen rather than (splash/main screen)
      selectNotification(notificationAppLaunchDetails!.payload);

      return true;
    }
    return false;
  }



  Future<void> showNewMessageNotification(
      {required String senderName, required String senderId,bool dontNotifyOnForeground=true,bool showSnackIfResumed=true}
      )async{
    if(AppStateInfo.instance.appState==AppLifecycleState.resumed){ //The app is in the foreground. Let's see what to do
      if(showSnackIfResumed){
        for(var _ in [1,2,3,4,5]) {print('\n');}
        print('*************Trying to show current path********');
        for(var _ in [1,2,3,4,5]) {print('\n');}
        Get.snackbar("TITLE", Get.currentRoute,duration: Duration(seconds: 3));
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
    await flutterLocalNotificationsPlugin.show(
      0,
      'ChatDor',
      'You got a new message from $senderName',
      platformChannelSpecifics,
      payload: json.jsonEncode(payloadData),
    );

  }





}