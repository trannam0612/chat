import 'package:chat/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  String member;
  ChatPage({this.member});
  @override
  _ChatPageState createState() => _ChatPageState(member);
}

class _ChatPageState extends State<ChatPage> {
  String member;
  String message;
  String myName;
  String idRoom;
  bool showEmojiPicker = false;
  FocusNode textfieldFocus = FocusNode();
  FireData _fireData = new FireData();

  // ignore: deprecated_member_use

  TextEditingController messageController = new TextEditingController();
  void initState() {
    getName();
  }

  getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myName = prefs.getString('myName');
      idRoom = prefs.getString('idRoom');
    });
  }

  sendMessage() {
    // ignore: deprecated_member_use

    Map<String, dynamic> messageMap = {
      "message": messageController.text,
      "sendby": myName,
      "time": DateTime.now().millisecondsSinceEpoch
    };
    _fireData.upLoadMessage(idRoom, messageMap);

    print(messageController.text);
    messageController.text = "";
  }

  _ChatPageState(this.member);

  showKeyboard() => textfieldFocus.requestFocus();
  hideKeyboard() => textfieldFocus.unfocus();
  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(member),
      ),
      body: StreamBuilder(
        // ignore: deprecated_member_use
        stream: Firestore.instance
            .collection('roomsId')
            // ignore: deprecated_member_use
            .document(idRoom)
            .collection('chats')
            .orderBy('time', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Text('Loading data...');
          return Column(
            children: [
              Expanded(
                flex: 9,
                child: Container(
                    color: Colors.amber,
                    child: ListView(
                      // ignore: deprecated_member_use
                      children: snapshot.data.documents.map((document) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          child: myName == document['sendby']
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 16),
                                  margin: EdgeInsets.all(10),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    document['message'],
                                    style: TextStyle(
                                      backgroundColor: Colors.blue,
                                      fontSize: 24,
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 16),
                                  margin: EdgeInsets.all(10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    document['message'],
                                    style: TextStyle(
                                      backgroundColor: Colors.grey,
                                      fontSize: 24,
                                    ),
                                  )),
                          // Text(document['message']),
                        );
                      }).toList(),
                    )),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: TextField(
                        onTap: () => hideEmojiContainer(),
                        focusNode: textfieldFocus,
                        controller: messageController,
                        onSubmitted: (value) {
                          messageController.text = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Message...',
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(Icons.emoji_emotions),
                        onPressed: () {
                          print('emoji');
                          if (!showEmojiPicker) {
                            hideKeyboard();
                            showEmojiContainer();
                          } else {
                            showKeyboard();
                            hideEmojiContainer();
                          }
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          _onClicked();
                        },
                      ),
                    )
                  ],
                ),
              ),
              showEmojiPicker
                  ? Container(child: emojiContainer())
                  : Container(),
            ],
          );
        },
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          messageController.text = messageController.text + emoji.emoji;
        });
      },
    );
  }

  _onClicked() {
    sendMessage();
  }
}
