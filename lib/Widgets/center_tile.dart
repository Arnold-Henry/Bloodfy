import 'package:bloodfy/Models/donation_center_model.dart';
import 'package:bloodfy/Screens/details_screen.dart';
import 'package:bloodfy/theme/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'random_color.dart';

Widget centerTile(DonationCenterModel model, BuildContext context, ){
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      boxShadow: <BoxShadow>[
        const BoxShadow(
          offset: Offset(4, 4),
          blurRadius: 10,
          color: Colors.black26,
        ),
        BoxShadow(
          offset: const Offset(-3, 0),
          blurRadius: 15,
          color: Colors.grey.withOpacity(.1),
        )
      ]
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(13)),
          child: Hero(
            tag: 'tag1', 
            child: Container(
              height: 55,
              width: 55,
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: randomColor(context) ,
              ),
              child: Image.network(
                model.image,
                loadingBuilder: (context, child, loading){
                  if(loading == null) {
                    return child;
                  } else{
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.redAccent),
                    );
                  }
                },
                height: 50,
                width: 50,
                fit: BoxFit.fill,
              ),
            )),
        ),
        title: Text(model.centerName,
            style: const TextStyle(fontWeight: FontWeight.bold)
            .copyWith(fontSize: 16, color: Colors.black),
        ),
        subtitle: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.center.centerFullName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12*1.2 )
                .copyWith(fontSize: 12.0),),
                const SizedBox(
                  height: 4.0,
                ),
                Text(model.centerStatus.status, style: TextStyle(
                  color: model.centerStatus.status == 'Open' ? Colors.green : Colors.red,
                ),)
              ],
            )
          ],
        ),
        trailing: Icon(Icons.keyboard_arrow_right,
        size: 30,
        color: Theme.of(context).primaryColor,),
        
      ),
    ).ripple((){
      Navigator.push(context,
       CupertinoPageRoute(builder: (context) => DetailScreen(model: model)));
    },
    borderRadius: const BorderRadius.all(Radius.circular(20)),
    ),
  );
}