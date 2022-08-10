import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/data_models/celeb.dart';
import 'package:betabeta/models/celebs_info_model.dart';
import 'package:betabeta/services/aws_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/celeb_widget.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:flutter/material.dart';

class MyMirrorScreen extends StatefulWidget {
  const MyMirrorScreen({Key? key}) : super(key: key);

  @override
  State<MyMirrorScreen> createState() => _MyMirrorScreenState();
  static const String routeName = '/my_mirror';
}

class _MyMirrorScreenState extends State<MyMirrorScreen> {
  String selectedImage = '';
  ServerResponse currentState = ServerResponse.InProgress;
  List<String> facesUrls = [];
  Map traits = {};
  bool  profileIsBeingProcessed = false;
  bool traitsBeingFetched = false;

  Future<void> updateTraits(String link)async{
    setState(() {
      traitsBeingFetched = true;
    });
    traits = await AWSServer.instance.getTraitsByImageUrl(link);
    setState(() {
      traitsBeingFetched = false;
    });
  }



  Future<void> updateProfileFacesUrls()async{
    var response = await AWSServer.instance.getProfileFacesAnalysis();
    ServerResponse serverResponse = response.item2;
    List<String>? data = response.item1;
    while(serverResponse == ServerResponse.InProgress){
      setState(() {
        profileIsBeingProcessed = true;
      });
      //TODO Nitzan update UI to show this is being processed at the server
      await Future.delayed(Duration(seconds: 1)); //TODO in the future,might replace polling with a websocket/FCM push
      response = await AWSServer.instance.getProfileFacesAnalysis();
      serverResponse = response.item2;
      data = response.item1;
    }

    setState(() {
      profileIsBeingProcessed = false;
    });


    if(serverResponse==ServerResponse.Success && data!=null){
      setState(() {
        facesUrls = data!;
      });
    } //TODO what if not successful?
  }

  @override
  void initState() {
    updateProfileFacesUrls();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenerWidget(
      notifier: SettingsData.instance,
      builder: (context) {
        return Scaffold(
          backgroundColor: backgroundThemeColor,
          appBar: CustomAppBar(
            hasTopPadding: true,
            title: 'My Mirror - shitty working UI',
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
                    child: !(facesUrls.length > 0)
                        ? Center(
                      child: Text(
                        'No Profile image Available for match',
                        style: mediumBoldedCharStyle,
                      ),
                    )
                        : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: facesUrls.length,
                      itemBuilder: (cntx, index) {
                        final String _url = AWSServer.profileFaceLinkToFullUrl(
                            facesUrls[index]);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedImage = _url;

                            });
                            updateTraits(facesUrls[index]);
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
                  height: MediaQuery.of(context).size.width * 0.55,
                  decoration: kSettingsBlockBoxDecor,
                  child:
                  profileIsBeingProcessed?Text('Processing profile'): //TODO Nitzan - change this text to a nice looking widget
                  traitsBeingFetched? Text('Fetching traits'): //TODO Nitzan - change this text to a nice looking widget
                  Center(child: Text(traits.toString()))
                  ,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
