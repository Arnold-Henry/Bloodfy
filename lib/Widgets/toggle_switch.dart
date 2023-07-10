import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class CenterStatusToggle extends StatefulWidget {
  final String centerId;
  const CenterStatusToggle({Key? key, required this.centerId}) : super(key: key);
  @override
  _CenterStatusToggleState createState() => _CenterStatusToggleState();
}
class _CenterStatusToggleState extends State<CenterStatusToggle> {
  bool _isCenterOpen = true;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Centers')
          .doc(widget.centerId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _isCenterOpen = snapshot.data!['isCenterOpen'];
        }
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: _isCenterOpen
              ? Icon(Icons.check_circle, color: Colors.green)
              : Icon(Icons.remove_circle, color: Colors.red),
        );
      },
    );
  }
}