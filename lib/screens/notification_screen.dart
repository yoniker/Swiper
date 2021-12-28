import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:flutter/material.dart';

/// The implementation for the Notification screen.
class NotificationScreen extends StatefulWidget {
  static const String routeName = '/notifications';

  NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        hasTopPadding: true,
        showAppLogo: false,
        trailing: PrecachedImage.asset(
          imageURI: BetaIconPaths.notificationIconFilled01,
          scale: 5.0,
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(
              5,
              (index) => NotificationBox(
                message: 'This is the number $index notification!',
                onTap: () {
                  // TODO: Open notification.
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
