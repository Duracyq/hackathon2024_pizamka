import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


class FcmService extends StatefulWidget {
  @override
  _FcmServiceState createState() => _FcmServiceState();
}

class _FcmServiceState extends State<FcmService> {
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    requestPermission();
    getToken();
    
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(notification.title ?? 'No Title'),
            content: Text(notification.body ?? 'No Body'),
          ),
        );
      }
    });
  }

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> getToken() async {
    _fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $_fcmToken");
    // You can send this token to your backend to store it for later use
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FCM Push Notifications')),
      body: Center(
        child: Text(
          _fcmToken != null ? 'FCM Token: $_fcmToken' : 'Fetching FCM Token...',
        ),
      ),
    );
  }
}
