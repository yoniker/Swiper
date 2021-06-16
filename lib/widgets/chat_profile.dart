import 'package:flutter/material.dart';

class ChatProfile extends StatefulWidget{
  final String name;
  final String messageText;
  final String imageUrl;
  final String time;
  final bool isMessageRead;
  ChatProfile({@required this.name,@required this.messageText,@required this.imageUrl,@required this.time,@required this.isMessageRead});
  @override
  _ChatProfileState createState() => _ChatProfileState();
}

class _ChatProfileState extends State<ChatProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage(widget.imageUrl),
                  maxRadius: 30,
                ),
                SizedBox(width: 16,),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.name, style: TextStyle(fontSize: 16),),
                        SizedBox(height: 6,),
                        Text(widget.messageText,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(widget.time,style: TextStyle(fontSize: 12,fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
        ],
      ),
    );
  }
}