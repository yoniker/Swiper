import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/screens/full_image_screen.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyLookALikeScreen extends StatefulWidget {
  const MyLookALikeScreen({Key? key}) : super(key: key);

  @override
  State<MyLookALikeScreen> createState() => _MyLookALikeScreenState();
  static const String routeName = '/my_celeb_look_a_like';
}

class _MyLookALikeScreenState extends State<MyLookALikeScreen> {
  final double percentage = 75;
  final String celebMock = 'Bruce Willis';
  late String selectedImage = '';

  @override
  void initState() {
    setState(() {
      selectedImage = NewNetworkService.getProfileImageUrl(
          SettingsData.instance.profileImagesUrls.first);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenerWidget(
      notifier: SettingsData.instance,
      builder: (context) {
        final _imageUrls = SettingsData.instance.profileImagesUrls;
        return Scaffold(
          backgroundColor: backgroundThemeColor,
          appBar: CustomAppBar(
            hasTopPadding: true,
            title: 'My Celeb Look-A-Like',
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Pick a picture to find out!',
                    style: LargeTitleStyle.copyWith(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: 8.0,
                    bottom: 12.0,
                    left: 5.0,
                    right: 5.0,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 30.5,
                      maxHeight: 100.5,
                      minWidth: 250.0,
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    child: !(_imageUrls.length > 0)
                        ? Center(
                            child: Text(
                              'No Profile image Available for match',
                              style: mediumBoldedCharStyle,
                            ),
                          )
                        : ListView.separated(
                            key: UniqueKey(),
                            scrollDirection: Axis.horizontal,
                            itemCount: _imageUrls.length,
                            itemBuilder: (cntx, index) {
                              final String _url =
                                  NewNetworkService.getProfileImageUrl(
                                      _imageUrls[index]);
                              return GestureDetector(
                                onTap: () {
                                  print(SettingsData
                                      .instance.profileImagesUrls.first);
                                  setState(() {
                                    selectedImage = _url;
                                  });
                                  print(selectedImage);
                                },
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: 30.5,
                                    maxHeight: 100.5,
                                    minWidth: 30.5,
                                    maxWidth: 100.5,
                                  ),
                                  // height: 80.5,
                                  // width: 100.0,
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: selectedImage == _url
                                            ? Border.all(
                                                width: 2, color: appMainColor)
                                            : null,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Card(
                                        margin: EdgeInsets.all(0.0),
                                        clipBehavior: Clip.antiAlias,
                                        elevation: 2.1,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        child: PrecachedImage.network(
                                          imageURL: _url,
                                          fadeIn: true,
                                          shouldPrecache: false,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (cntx, index) {
                              return SizedBox(width: 16.0);
                            },
                          ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: kSettingsBlockBoxDecor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('You look $percentage% like',
                            style: boldTextStyle),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/BruceWillis.jpg'),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Text(
                        celebMock,
                        style: LargeTitleStyle,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
