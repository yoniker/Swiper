import 'package:betabeta/models/chatuser.dart';
import 'package:betabeta/screens/chat_screen.dart';
import 'package:betabeta/widgets/chat_profile.dart';
import 'package:flutter/material.dart';

class MainMessagesScreen extends StatefulWidget {
  MainMessagesScreen({Key key}) : super(key: key);
  static const String routeName = '/main_messages_screen';

  @override
  _MainMessagesScreenState createState() => _MainMessagesScreenState();
}

class _MainMessagesScreenState extends State<MainMessagesScreen>
    with AutomaticKeepAliveClientMixin<MainMessagesScreen> {

  Widget _searchBar(){
    return Padding(
      padding: EdgeInsets.only(top: 16,left: 16,right: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.all(8),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: Colors.grey.shade100
              )
          ),
        ),
      ),
    );

  }


  @override
  Widget build(BuildContext context) {
    // call super.build() method to facilitate the preservation of our state.
    super.build(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 16,right: 16,top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Conversations",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
                  Container(
                    padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.pink[50],
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.add,color: Colors.pink,size: 20,),
                        SizedBox(width: 2,),
                        Text("Add New",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          _searchBar(),
          Expanded(
            flex: 1,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: ChatUser.mockChatUsers.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              itemBuilder: (context, index){
                return
                  GestureDetector(
                    onTap: (){
                      print('tapped!!');
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ChatScreen();
                      }));
                    },
                child:
                  ChatProfile(
                  name: ChatUser.mockChatUsers[index].name,
                  messageText: ChatUser.mockChatUsers[index].messageText,
                  imageUrl: ChatUser.mockChatUsers[index].imageURL,
                  time: ChatUser.mockChatUsers[index].time,
                  isMessageRead: (index == 0 || index == 3)?true:false,
                ));
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  // This necessarily helps to preserve the state of our App.
  bool get wantKeepAlive => true;
}
