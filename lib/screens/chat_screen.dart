import 'package:betabeta/models/chat_message_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget{
  static const String routeName = '/chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          trailing: Icon(Icons.settings,color: Colors.black54,),
          customTitleBuilder:
              Container(
                width: 200,
                child: Row(children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/5.jpg"),
                    maxRadius: 20,
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Kriss Benwat",style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                        SizedBox(height: 6,),
                        Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                      ],
                    ),
                  ),

                ],
                ),
              ),
          hasTopPadding:true,
        ),
        body: Stack(
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(bottom: 45.0),
        child: ListView.builder(
          itemCount: ChatMessage.mockMessages.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 10,bottom: 10),
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index){
            return Container(
              padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
              child: Align(
                alignment: (ChatMessage.mockMessages[index].messageType == "receiver"?Alignment.topLeft:Alignment.topRight),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: (ChatMessage.mockMessages[index].messageType  == "receiver"?Colors.grey.shade200:Colors.blue[200]),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Text(ChatMessage.mockMessages[index].messageContent, style: TextStyle(fontSize: 15),),
                ),
              ),
            );
          },
        ),
      ),


    Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: (){
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(Icons.add, color: Colors.white, size: 20, ),
              ),
            ),
            SizedBox(width: 15,),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Write message...",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none
                ),
              ),
            ),
            SizedBox(width: 15,),
            FloatingActionButton(
              onPressed: (){},
              child: Icon(Icons.send,color: Colors.white,size: 18,),
              backgroundColor: Colors.blue,
              elevation: 0,
            ),
          ],

        ),
      ),
    ),
    ],
    ),
    );
  }
}