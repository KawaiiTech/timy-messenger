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
    ..user.uid = "uid"
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
            "channelid": Channel((c) => c
              ..id = "channelid"
              ..name = "Dogs are the best"
              ..visibility = ChannelVisibility.OPEN
              ..type = ChannelType.TOPIC
              ..users.addAll([
                ChannelUser((cu) => cu
                  ..id = "uid"
                  ..rsvp = RSVP.UNSET)
              ])),
          },
        ))
    })
    ..channelState = ChannelState.init().toBuilder()
    ..channelState.selectedChannel = "channelid"
    ..messagesOnScreen = ListBuilder()
    ..groupUsers = ListBuilder()
    ..userCalendar = ListBuilder()
    ..uiState = UiState().toBuilder());

  AppState clear() {
    // keep the temporal fcm token even when clearing state
    // so it can be set again on login.
    //
    // Add here anything else that also needs to be carried over.
    return AppState.init().rebuild((s) => s..fcmToken = fcmToken);
  }
}
