import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BloodDonationDriveCard extends StatelessWidget {
  final String driveId;

  const BloodDonationDriveCard({super.key, required this.driveId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('BDDrives').doc(driveId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final driveData = snapshot.data!.data() as Map<String, dynamic>;
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driveData['name'],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: ${(driveData['date'] as Timestamp).toDate().toString()}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Time: ${driveData['time']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Location: ${driveData['location']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description:',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    driveData['description'],
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
