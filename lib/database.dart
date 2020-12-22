import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireData {
  upLoadUserInfo(userMap) {
    // ignore: deprecated_member_use
    Firestore.instance.collection("user").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  upLoadRoomId(String idRoomChat, roomMap) {
    // ignore: deprecated_member_use
    Firestore.instance
        .collection("roomsId")
        // ignore: deprecated_member_use
        .document(idRoomChat)
        .collection("chats")
        .add(roomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  upLoadMessage(String idRoomChat, messageMap) {
    // ignore: deprecated_member_use
    Firestore.instance
        .collection("roomsId")
        // ignore: deprecated_member_use
        .document(idRoomChat)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getMessages(String idRoom, roomsId) async {
    // ignore: deprecated_member_use
    return await Firestore.instance
        .collection('roomsId')
        // ignore: deprecated_member_use
        .document(idRoom)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  upLoadUser(String idRoom, userMapChat) {
    // ignore: deprecated_member_use
    Firestore.instance
        .collection("roomsId")
        // ignore: deprecated_member_use
        .document(idRoom)
        .set(userMapChat)
        // ignore: deprecated_member_use

        .catchError((e) {
      print(e.toString());
    });
  }
}
