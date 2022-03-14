import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  List<String> pickedHobbies = [];

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
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Text(
                  'Choose up to 6 hobbies to highlight for your profile',
                  style: smallTitleLighterBlack,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: hobbies
                        .map((h) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (pickedHobbies.length < 7) {
                                    if (pickedHobbies.contains(h) != true) {
                                      pickedHobbies.add(h);
                                    } else {
                                      pickedHobbies.remove(h);
                                    }
                                  }
                                  if (pickedHobbies.length == 7)
                                    pickedHobbies.remove(h);
                                });
                                print(pickedHobbies);
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: pickedHobbies.contains(h)
                                        ? Colors.blue[200]
                                        : null,
                                    border: Border.all(
                                        color: Colors.black, width: 1.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 4),
                                  child: Text(
                                    '$h',
                                    style: smallBoldedTitleBlack,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          if (pickedHobbies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton.extended(
                backgroundColor: Colors.blueGrey.withOpacity(0.8),
                onPressed: () {},
                label: Text(
                  'OK (${pickedHobbies.length}/6)',
                  style: boldTextStyleWhite,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
