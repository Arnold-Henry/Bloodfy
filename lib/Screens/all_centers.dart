import 'package:bloodfy/Widgets/center_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Components/text_form_field.dart';
import '../data_manager/data_manager.dart';

class AllCenters extends StatefulWidget {
  const AllCenters({Key? key}) : super(key: key);

  @override
  State<AllCenters> createState() => _AllCentersState();
}

class _AllCentersState extends State<AllCenters> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the searchController when the widget is disposed
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // Display a leading back button in the app bar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color.fromARGB(255, 214, 57, 57)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: SizedBox(
          height: 40,
          child: TextFormField(
            controller: searchController,
            cursorColor: const Color.fromARGB(255, 255, 113, 113),
            style: const TextStyle(fontSize: 18.0),
            decoration: InputDecoration(
              hintText: 'Search...',
              suffixIcon: const Icon(
                CupertinoIcons.search,
              ),
              suffixIconColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.focused)
                      ? Color.fromARGB(255, 247, 125, 125)
                      : Color.fromARGB(255, 214, 57, 57)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 252, 86, 86),
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 214, 57, 57),
                  width: 1.0,
                ),
              ),
            ),
            onChanged: (value) {
              // Perform search when the text changes
              Provider.of<DataManagerProvider>(context, listen: false)
                  .searchCenters(value);
            },
          ),
        ),
      ),
      body: Listener(
        onPointerDown: (_) {}, // Provide an empty listener to handle pointer events
        child: CustomScrollView(
          slivers: [
            Consumer<DataManagerProvider>(
              builder: (context, data, child) {
                final filteredCenters = data.searchList
                    .where((center) => center.centerName
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()))
                    .toList();

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final donationCenter = filteredCenters[index];
                      return centerTile(donationCenter, context);
                    },
                    childCount: filteredCenters.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
