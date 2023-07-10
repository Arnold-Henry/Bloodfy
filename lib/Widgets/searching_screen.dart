import 'package:bloodfy/data_manager/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'center_tile.dart';

class SearchingScreen extends StatelessWidget {
  const SearchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Consumer<DataManagerProvider>(
            builder: (context, data, child) {
              if(data.searchList.isNotEmpty){
                return Column(
                  children: data.getSearchList.map((x){
                    return centerTile(x, context);
                  }).toList()
                );
              } else{
                return const Align(
                  alignment: Alignment.topCenter,
                  child: Text('Results Not Found'),
                );
              }
              
            },
          )
        ]
      ),

    );
  }
}