/*
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/material.dart';

// Future<bool> ensureLocationPermissions(BuildContext context) async {
//   geolocator.LocationPermission permission = await geolocator.Geolocator.checkPermission();
//   if (permission == geolocator.LocationPermission.denied) {
//     permission = await geolocator.Geolocator.requestPermission();
//   }
//   if (permission == geolocator.LocationPermission.deniedForever) {
//     await showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('Permission required'),
//         content: Text('Please enable location permission (Allow all the time) in app settings.'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
//           TextButton(
//               onPressed: () {
//                 openAppSettings();
//                 Navigator.pop(context);
//               },
//               child: Text('Open Settings')),
//         ],
//       ),
//     );
//     return false;
//   }

//   final status = await Permission.locationAlways.status;
//   if (!status.isGranted) {
//     final result = await Permission.locationAlways.request();
//     if (!result.isGranted) {
//       await showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: Text('Background location needed'),
//           content: Text('This app needs background location to trigger reminders when you arrive.'),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
//             TextButton(
//                 onPressed: () {
//                   openAppSettings();
//                   Navigator.pop(context);
//                 },
//                 child: Text('Open Settings')),
//           ],
//         ),
//       );
//       return false;
//     }
//   }
//   if (await Permission.notification.isDenied) {
//     await Permission.notification.request();
//   }

//   return true;
// }
*/
