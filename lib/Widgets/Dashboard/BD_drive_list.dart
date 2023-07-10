import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_manager/data_manager.dart';

class BloodDonationDriveDetails extends StatelessWidget {
  const BloodDonationDriveDetails({Key? key, required this.driveId})
      : super(key: key);

  final String driveId;

  @override
  Widget build(BuildContext context) {
    final dataManager = Provider.of<DataManagerProvider>(context);
    final driveData = dataManager.getDriveDetails;

    if (driveData != null) {
      return Scaffold(
        body: Stack(
          children: [
            Hero(
              tag: driveData.driveId,
              child: Image.network(
                driveData.imageUrl,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            DraggableScrollableSheet(
              maxChildSize: .8,
              initialChildSize: .6,
              minChildSize: .6,
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
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
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driveData.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Date: ${driveData.date}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Time: ${driveData.time}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Location: ${driveData.location}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Description:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              driveData.description,
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle edit button action
                                    // Navigate to edit screen or show an edit dialog
                                  },
                                  child: Text('Edit'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle delete button action
                                    // Show a confirmation dialog and delete the details
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                  ),
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}
