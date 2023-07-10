import 'package:bloodfy/Models/donation_center_model.dart';
import 'package:bloodfy/theme/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Widgets/pic_up_location.dart';
import '../Widgets/progress_widget.dart';
import '../firebase_data/firebase_data.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../theme/theme.dart';
import 'Appointments/make_appointment.dart';

class DetailScreen extends StatefulWidget {
  final DonationCenterModel model;
  const DetailScreen({super.key, required this.model});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late DonationCenterModel model;

  @override
  void initState() {
    model = widget.model;
    getAppointmentFromFirebase(widget.model.center.centerId, context);
    super.initState();
  }

  _launchCaller(String phone) async {
    String url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _smsLauncher(String phoneNumber) async {
    // Android
    String message = '';
    String uri = 'sms:$phoneNumber?body=$message';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch';
    }
  }

  Widget _appbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const <Widget>[
        BackButton(
          color: Colors.white,
        ),
        // IconButton(
        //   icon: Icon(
        //     model.isfavourite ? Icons.favorite : Icons.favorite_border,
        //     color: model.isfavourite ? Colors.deepOrange : Colors.white,
        //   ),
        //   onPressed: () {
        //     setState(() {
        //       model.isfavourite = !model.isfavourite;
        //     });
        //   },
        // )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyles.title.copyWith(fontSize: 25).bold;
    if (AppTheme.fullWidth(context) < 393) {
      titleStyle = TextStyles.title.copyWith(fontSize: 23).bold;
    }
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Stack(
            children: <Widget>[
              Hero(
                  tag: 'tag1',
                  transitionOnUserGestures: true,
                  child: Container(
                    color: Colors.redAccent,
                    width: MediaQuery.of(context).size.width * 1.0,
                    height: MediaQuery.of(context).size.height * 0.45,
                  child: Image.network(
                    model.image,
                    loadingBuilder: (context, child, loading) {
                      if (loading == null)
                        return child;
                      else {
                        return Center(
                          child: CircularProgressIndicator(color: Colors.cyan),
                        );
                      }
                    },
                    fit: BoxFit.fitHeight,
                  ))),
              DraggableScrollableSheet(
                  maxChildSize: .8,
                  initialChildSize: .6,
                  minChildSize: .6,
                  builder: (context, scrollController) {
                    return Container(
                      height: AppTheme.fullHeight(context) * .5,
                      padding: const EdgeInsets.only(
                        left: 19,
                        right: 19,
                        top: 16,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    model.centerName,
                                    style: titleStyle.copyWith(
                                        color: Colors.black),
                                  )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.check_circle,
                                    size: 18,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: SmoothStarRating(
                                        onRatingChanged: (v) {},
                                        starCount: 5,
                                        rating: model.rating,
                                        size: 20.0,
                                        filledIconData: Icons.star,
                                        halfFilledIconData: Icons.star,
                                        color: Colors.yellow,
                                        borderColor: Colors.yellow,
                                        spacing: 0.0),
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    model.center.centerFullName,
                                    style: TextStyles.bodySm.subTitleColor.bold,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    model.centerStatus.status,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: model.centerStatus.status == 'Open'
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    model.seats,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  const Icon(
                                    Icons.event_seat,
                                    color: Colors.deepOrangeAccent,
                                  )
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: .3,
                              color: LightColor.grey,
                            ),
                            Row(
                              children: <Widget>[
                                ProgressWidget(
                                  value: model.goodReviews.toDouble(),
                                  totalValue: 1000,
                                  activeColor: LightColor.purpleExtraLight,
                                  backgroundColor:
                                      LightColor.grey.withOpacity(.3),
                                  title: "Good Reviews",
                                  durationTime: 500,
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: .3,
                              color: LightColor.grey,
                            ),
                            Text("About", style: titleStyle).vP16,
                            Text(
                              model.description,
                              style: TextStyles.body.subTitleColor,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text("Address", style: titleStyle).vP16,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.blueAccent,
                                  size: 20,
                                ),
                                Expanded(
                                  child: Text(
                                    model.location.address,
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 15.0),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 1.0,
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                      color: const Color(0xffb8b5cb))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: PickedUpLocation(
                                    latitude: model.location.latitude,
                                    longitude: model.location.longitude),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: LightColor.grey.withAlpha(150),
                                  ),
                                  child: const Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                ).ripple(
                                  () {
                                    _launchCaller(model.center.centerContact);
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                AbsorbPointer(
                                  absorbing: model.centerStatus.status == 'Open'
                                      ? false
                                      : true,
                                  child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                        color:
                                            model.centerStatus.status == 'Open'
                                                ? Theme.of(context).primaryColor
                                                : Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    DonorAppointmentScreen(
                                                      centerName:
                                                          model.centerName,
                                                      centerFullName: model
                                                          .center
                                                          .centerFullName,
                                                      centerAddress: model
                                                          .location.address,
                                                      centerContact: model
                                                          .center.centerContact,
                                                      centerId:
                                                          model.center.centerId,
                                                      startTime: model
                                                          .centerStatus
                                                          .startTime,
                                                      endTime: model
                                                          .centerStatus.endTime,
                                                      seats: int.parse(
                                                          model.seats),
                                                    )));
                                      },
                                      child: Text(
                                        model.centerStatus.status == 'Open'
                                            ? "Make an appointment"
                                            : 'Closed',
                                        style: TextStyles.titleNormal.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ).vP16
                          ],
                        ),
                      ),
                    );
                  }),
              _appbar()
            ],
          )),
    );
  }
}
