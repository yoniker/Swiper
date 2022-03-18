import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/widgets/bubbles_list_widget.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class MyHobbiesScreen extends StatefulWidget {
  static const String routeName = '/my_hobbies_screen';
  const MyHobbiesScreen({Key? key}) : super(key: key);

  @override
  State<MyHobbiesScreen> createState() => _MyHobbiesScreenState();
}

class _MyHobbiesScreenState extends State<MyHobbiesScreen> {
  List<String> hobbies = [
    'Dogs  🐕',
    'Cats  🐈',
    'Art  🎨',
    'Dancing  💃',
    'Make-up  💄',
    'Singing  🎤',
    'Photography  📷',
    'Cycling  🚲',
    'Swimming  🏊‍♀️',
    'Working-out  💪',
    'Sports  🏒',
    'Yoga  🧘',
    'Bars  🍻',
    'Coffee-shops  ☕',
    'Movies  🎦',
    'TV-shows  📺',
    'Festivals  🎇',
    'Cooking  🍳',
    'Gaming  🕹️',
    'Social games  🎲',
    'Reading  📚',
    'Music  🎵',
    'Sushi  🍣',
    'Pizza  🍕',
    'Barbeque  🍖',
    'Vegan  🥗',
    'Sweets  🍬',
    'Camping  ⛺',
    'Backpacking  🏕️',
    'Hiking  ⛰',
    'Travel  🛫',
    'Fishing  🎣',
    'Beach  🏖️',
    'Winter activities  🎿',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundThemeColor,
      appBar: CustomAppBar(
        hasTopPadding: true,
        hasBackButton: true,
        showAppLogo: false,
        title: 'My hobbies',
      ),
      body: BubblesListWidget(
        bubbles: hobbies,
        headline: 'Choose up to 6 hobbies to highlight for your profile',
        maxChoices: 6,
      ),
    );
  }
}
