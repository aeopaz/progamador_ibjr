import 'dart:convert';
import 'dart:developer';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:programador/helpers/notifications.dart';

class MyPusherClient {
  final _apiKey = '64d694ba871a0a873ff6';
  final _cluster = 'mt1';
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  final channelName;
  final eventName;

  MyPusherClient({this.channelName, this.eventName});

  void onConnect() async {
    try {
      await pusher.init(
        apiKey: _apiKey,
        cluster: _cluster,
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        onSubscriptionCount: onSubscriptionCount,
        // authEndpoint: kServerWebsockets,
        // onAuthorizer: onAuthorizer
      );
      await pusher.subscribe(channelName: channelName);
      await pusher.connect();
    } catch (e) {
      print("ERROR: $e");
    }
    // await initNotifications();
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print("Connection: $currentState");
  }

  void onError(String message, int? code, dynamic e) {
    print("onError: $message code: $code exception: $e");
  }

  void onEvent(PusherEvent event) {
    print("onEvent: $event");
    showNotificacion(dataNotificacion: event);
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) async {
    print("onSubscriptionSucceeded: $channelName data: $data");
    final me = pusher.getChannel(channelName)?.me;
    print("Me: $me");
  }

  void onSubscriptionError(String message, dynamic e) {
    print("onSubscriptionError: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    print("onDecryptionFailure: $event reason: $reason");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    print("onMemberAdded: $channelName user: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    print("onMemberRemoved: $channelName user: $member");
  }

  void onSubscriptionCount(String channelName, int subscriptionCount) {
    print(
        "onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount");
  }

  dynamic onAuthorizer(
      String channelName, String socketId, dynamic options) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic token = prefs.getString("token");

    var authUrl = '';
    print(authUrl);
    var result = await http.post(
      Uri.parse(authUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ${token}',
      },
      body: 'socket_id=' + socketId + '&channel_name=' + channelName,
    );
    var json = jsonDecode(result.body);
    // print(json);
    return json;
    //https://stackoverflow.com/questions/73783564/how-to-use-private-channel-of-pusher-in-flutter
  }
}
