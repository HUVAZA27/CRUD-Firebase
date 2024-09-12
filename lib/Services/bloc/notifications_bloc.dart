import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:crud_firebase/Services/local_notifications/local_notifications.dart';
import 'package:crud_firebase/preferences/pref_usuarios.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

//metodo para rtevibir las notificaciones cuando la aplicacion no este abierta

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Random random = Random();
  var id = random.nextInt(10000);
  var mensaje = message.data;
  var body = mensaje['body'];
  var title = mensaje['title'];

  LocalNotification.showLocalNotification(
    id: id,
    title: title,
    body: body,
  );
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(NotificationsInitial()) {
    _onForegroundMessage();
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    await LocalNotification.requestPermissionLocalNotifications();
    settings.authorizationStatus;
    _getToken();
  }

  void _getToken() async {
    final settings = await messaging.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;

    final token = await messaging.getToken();
    if (token != null) {
      final prefs = PreferencesUser();
      prefs.token = token;
    }
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  void handleRemoteMessage(RemoteMessage message) {
    Random random = Random();
    var id = random.nextInt(10000);
    var mensaje = message.data;
    var body = mensaje['body'];
    var title = mensaje['title'];

    LocalNotification.showLocalNotification(
      id: id,
      title: title,
      body: body,
    );
  }
}
