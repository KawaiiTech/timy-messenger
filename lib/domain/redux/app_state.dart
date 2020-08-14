import "package:built_collection/built_collection.dart";
import "package:built_value/built_value.dart";
import "package:circles_app/domain/redux/ui/ui_state.dart";
import "package:circles_app/model/calendar_entry.dart";
import 'package:circles_app/model/channel.dart';
import "package:circles_app/model/channel_state.dart";
import "package:circles_app/model/group.dart";
import "package:circles_app/model/in_app_notification.dart";
import "package:circles_app/model/message.dart";
import "package:circles_app/model/user.dart";

import '../../model/message.dart';
import '../../model/message.dart';

part 'app_state.g.dart';

/// This class holds the whole application state.
/// Which can include:
/// - user calendar
/// - current user profile
/// - joined channels
/// - received messages
/// - etc.
///
abstract class AppState implements Built<AppState, AppStateBuilder> {
  BuiltList<CalendarEntry> get userCalendar;

  BuiltMap<String, Group> get groups;

  @nullable
  String get selectedGroupId;

  @nullable
  User get user;

  BuiltList<User> get groupUsers;

  ChannelState get channelState;

  BuiltList<Message> get messagesOnScreen;

  @nullable
  String get fcmToken;

  @nullable
  InAppNotification get inAppNotification;

  UiState get uiState;

  AppState._();

  factory AppState([void Function(AppStateBuilder) updates]) = _$AppState;

  factory AppState.init() => AppState((a) => a
    ..user.name = "Lily"
    ..user.uid = "user1"
    ..user.email = "e@mail.com"
    ..selectedGroupId = "groupid"
    ..groups.addAll({
      "groupid": Group((g) => g
        ..id = "groupid"
        ..name = "groupname"
        ..hexColor = "#abc5f5"
        ..abbreviation = "LL"
        ..channels.addAll(
          {
            "channel1": _createChannel(),
            "channel2": _createChannel2(),
          },
        ))
    })
    ..channelState = ChannelState.init().toBuilder()
    ..channelState.selectedChannel = "channel1"
    ..messagesOnScreen.addAll([
      Message((m) => m
        ..id = "1"
        ..body = "When are going to the park?? 🐕"
        ..authorId = "user1"
        ..messageType = MessageType.USER),
      Message((m) => m
        ..id = "2"
        ..body = "Good morning everyone! 😁 http://example.com"
        ..authorId = "user2"
        ..messageType = MessageType.USER),
    ])
    ..groupUsers.addAll([_user(), _user2()])
    ..userCalendar = ListBuilder()
    ..uiState = UiState().toBuilder());

  static User _user() {
    return User((u) => u
      ..name = "Lily"
      ..uid = "user1"
      ..email = "e@e.com");
  }

  static User _user2() {
    return User((u) => u
      ..name = "Coco"
      ..uid = "user2"
      ..email = "e@e.com");
  }

  static Channel _createChannel() {
    return Channel((c) => c
      ..id = "channel1"
      ..name = "Dogs are the best"
      ..visibility = ChannelVisibility.OPEN
      ..type = ChannelType.TOPIC
      ..hasUpdates = false
      ..users.addAll([
        ChannelUser((cu) => cu
          ..id = "user1"
          ..rsvp = RSVP.UNSET),
        ChannelUser((cu) => cu
          ..id = "user2"
          ..rsvp = RSVP.UNSET),
      ]));
  }

  static Channel _createChannel2() {
    return Channel((c) => c
      ..id = "channel2"
      ..name = "Cute Animals"
      ..visibility = ChannelVisibility.OPEN
      ..type = ChannelType.TOPIC
      ..hasUpdates = false
      ..users.addAll([
        ChannelUser((cu) => cu
          ..id = "user1"
          ..rsvp = RSVP.UNSET)
      ]));
  }

  AppState clear() {
    // keep the temporal fcm token even when clearing state
    // so it can be set again on login.
    //
    // Add here anything else that also needs to be carried over.
    return AppState.init().rebuild((s) => s..fcmToken = fcmToken);
  }
}
