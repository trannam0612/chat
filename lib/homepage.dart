import 'package:chat/chatpage.dart';
import 'package:chat/checkdata.dart';
import 'package:chat/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  String email;
  HomePage({this.email});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FireData _fireData = new FireData();
  String member;
  String _email;
  String idRoom;
  String myName;

  @override
  void initState() {
    getName();
  }

  getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myName = prefs.getString('myName');
    });
  }

  _display() {
    if (myName != null) {
      return Text(myName);
    } else {
      return Text('Do not data...');
    }
  }

  Future<void> _createRoom() async {
    String idRoomChat = getChatRoomId(_email, myName);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idRoom = idRoomChat;
    prefs.setString('idRoom', idRoom);
    print(idRoom);
    // Map<String, String> roomsId = {"sendby": _email, "message": myName};
    // _fireData.upLoadRoomId(idRoomChat, roomsId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[400],
        title: _display(),
        actions: [
          IconButton(
            icon: Image(image: AssetImage('assets/images/logout.png')),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder(
        // ignore: deprecated_member_use
        stream: Firestore.instance.collection('user').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('Loading data...'),
            );
          }
          return ListView(
            // ignore: deprecated_member_use
            children: snapshot.data.documents.map((document) {
              return Center(
                  child: Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                width: 400,
                height: 50,
                // ignore: deprecated_member_use
                child: FlatButton(
                  shape: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  onPressed: () {
                    _onClick();
                    _email = document['mail'];
                    member = document['name'];
                    _createRoom();
                    print('member: ${this.member}');
                  },
                  child: Text(document['name']),
                ),
                // Text(document['name'])
              ));
            }).toList(),

            // // ignore: deprecated_member_use
            // title: Text(snapshot.data.documents[index]['mail']),
            // // ignore: deprecated_member_use
            // subtitle: Text(snapshot.data.documents[index]['name']));
          );
        },
      ),
    );
  }

  void _onClick() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ChatPage(member: member),
    ));
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
