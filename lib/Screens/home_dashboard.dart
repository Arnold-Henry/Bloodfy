import 'package:bloodfy/Screens/notfication_screen.dart';
import 'package:bloodfy/Screens/profile_screen.dart';
import 'package:bloodfy/Widgets/drawee.dart';
import 'package:bloodfy/Widgets/searching_screen.dart';
import 'package:bloodfy/data_manager/data_manager.dart';
import 'package:bloodfy/firebase_data/firebase_data.dart';
import 'package:bloodfy/theme/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../Widgets/Dashboard/center_list.dart';
import '../Widgets/Dashboard/drive_list.dart';
import '../Widgets/header.dart';
import '../theme/text_styles.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textController = TextEditingController();
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      if (textController.text.isNotEmpty) {
        Provider.of<DataManagerProvider>(context, listen: false)
            .searchList
            .clear();
        Provider.of<DataManagerProvider>(context, listen: false)
            .setIsSearching(true);
        Provider.of<DataManagerProvider>(context, listen: false)
            .getSearch(textController.text);
      } else {
        Provider.of<DataManagerProvider>(context, listen: false)
            .setIsSearching(false);
      }
    });
    _controller = VideoPlayerController.network(
        'https://ice-8495.imgix.net/Why%20should%20you%20donate%20blood-%20-%20');
    _controller.initialize().then((_) {
      setState(() {}); // Trigger a rebuild to show the first frame
    });
    getAllCenters(context);
    getAvailableCenters(context);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const Drawee(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            scaffoldKey.currentState?.openDrawer();
          },
          child: const Icon(
            Icons.menu,
            size: 30,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const NotficationsScreen()));
              print('nnnnnnnnnnnnnnnnnnn');
            },
            child: const Icon(
              Icons.notifications_none,
              size: 30,
              color: Colors.grey,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const UserProfileScreen()));

              print('jjjjjjjjjjjjjjjjjjjj');
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(13)),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                  ),
                  child: Image.asset(
                    "images/user.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Consumer<DataManagerProvider>(
        builder: (context, providerData, child) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const Header(),
                    Container(
                      height: 55,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(13)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey.withOpacity(.8),
                            blurRadius: 15,
                            offset: const Offset(5, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: textController,
                        onChanged: (value) {
                          print(value);
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          border: InputBorder.none,
                          hintText: "Search...",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Color.fromARGB(255, 205, 185, 185),
                          ),
                          suffixIcon: SizedBox(
                            width: 50,
                            child: Icon(
                              Icons.search,
                              color: Color.fromARGB(255, 176, 39, 39),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        right: 16,
                        left: 16,
                        bottom: 4,
                      ),
                      child: Text(
                        "Why You Should Donate Blood ",
                        style: TextStyles.title.bold,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(13)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey.withOpacity(.8),
                            blurRadius: 15,
                            offset: const Offset(5, 5),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        child: _controller.value.isInitialized
                            ? Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(13)),
                                ),
                                child: AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                ),
                              )
                            : Container(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _launchURL();
                      },
                      child: providerData.searchingStart
                          ? const SearchingScreen()
                          : driveList(context),
                    ),
                  ],
                ),
              ),
              providerData.searchingStart
                  ? const SearchingScreen()
                  : centerList(providerData.getAllCenters, context),
            ],
          );
        },
      ),
    );
  }
}

_launchURL() async {
  final Uri url = Uri.parse(
      'https://www.redcrossblood.org/donate-blood/how-to-donate/eligibility-requirements.html');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
