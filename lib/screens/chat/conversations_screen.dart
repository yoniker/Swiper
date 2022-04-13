import 'package:betabeta/services/chatData.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/contacts_widget.dart';
import 'package:betabeta/widgets/conversations_preview_widget.dart';
import 'package:flutter/material.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({Key? key}) : super(key: key);
  static const String routeName = '/conversations_screen';

  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen>
    with MountedStateMixin, AutomaticKeepAliveClientMixin {
  void listen() {
    setStateIfMounted(() {});
  }

  @override
  void initState() {
    ChatData.instance
        .updateAllUsersDataFromServer(); //TODO not optimal,see chatdata for more info
    ChatData.instance.addListener(listen);
    super.initState();
  }

  String searchProfile = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.white38,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextFormField(
                    onChanged: (newProfileName) {
                      setState(() {
                        searchProfile = newProfileName;
                      });
                    },
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 1,
                    maxLength: 15,
                    style: const TextStyle(fontSize: 20, color: Colors.black87),
                    decoration: InputDecoration(
                      counterText: '',
                      suffixIcon: Icon(Icons.search),
                      hintStyle:
                          const TextStyle(color: Colors.black26, fontSize: 18),
                      hintText: ' Search my matches',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black26),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ContactsWidget(
                          search: searchProfile.toLowerCase(),
                        ),
                        if (ChatData.instance.users.isNotEmpty) Divider(),
                        ConversationsPreviewWidget(
                          search: searchProfile.toLowerCase(),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    ChatData.instance.removeListener(listen);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
