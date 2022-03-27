import 'package:betabeta/models/chatData.dart';
import 'package:betabeta/models/infoUser.dart';
import 'package:betabeta/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsWidget extends StatefulWidget {
  const ContactsWidget({Key? key}) : super(key: key);

  @override
  _ContactsWidgetState createState() => _ContactsWidgetState();
}

class _ContactsWidgetState extends State<ContactsWidget> {
  List<InfoUser> users = ChatData.instance.users;

  void listenContacts(){setState(() {
    users = ChatData.instance.users;
  });}

  @override
  void initState() {
    ChatData.instance.addListener(listenContacts); //TODO add an option to listen only to users box changes on the ChatData API
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('My contacts',style: TextStyle(color: Colors.blueGrey,fontSize: 18.0,fontWeight: FontWeight.bold,letterSpacing: 1.0),),
                IconButton(onPressed: (){}, icon: Icon(Icons.search),iconSize: 30.0,color: Colors.blueGrey,)
              ],),
          ),
          Container(height: 120,
              child:
              ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context,index){
                    InfoUser currentUser = users[index];
                    return GestureDetector(
                      onTap: (){

                        {Get.toNamed(ChatScreen.getRouteWithUserId(currentUser.uid));}

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            CircleAvatar(radius: 35.0,backgroundImage: NetworkImage(currentUser.imageUrls![0]),),
                            SizedBox(height: 6.0,),
                            Text(currentUser.username.split(' ')[0],style: TextStyle(color:Colors.blueGrey,fontSize: 16.0,fontWeight: FontWeight.w600),),
                          ],
                        ),
                      ),
                    );
                  })
          ),

        ],
      ),
    );
  }

  @override
  void dispose() {
    ChatData.instance.removeListener(listenContacts);
    super.dispose();
  }
}
