import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:bubble/bubble.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:intl/intl.dart';

class chatRoom extends StatefulWidget {
  @override
  String peerId;

  String icon;
  chatRoom(this.peerId, this.icon);
  MyDemoState createState() => MyDemoState(
        peerId: this.peerId,
        icon: this.icon,
      );
}

class MyDemoState extends State<chatRoom> {
  String idFrom = 'idFrom';
  String peerId;
  String icon;
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  String groupChatId = '';
  List<QueryDocumentSnapshot> listMessage = [];
  final TextEditingController textEditingController = TextEditingController();
  MyDemoState({required this.peerId, required this.icon});
  void initState() {
    super.initState();
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }
  }

  void SendMessage(
      String content, String groupChatId, String currentUserId, String peerId) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(documentReference, {
          'idFrom': currentUserId,
          'idTo': peerId,
          'message': content,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        });
      });
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: Colors.red);
    }
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                style: TextStyle(color: Color.fromARGB(255, 182, 27, 27), fontSize: 15),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Color.fromARGB(255, 182, 27, 27)),
                ),
                // focusNode: focusNode,
              ),
            ),
          ),

          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  //onSendMessage(textEditingController.text, TypeMessage.text)
                  SendMessage(textEditingController.text, groupChatId,
                      currentUserId, peerId);
                },
                color: Color.fromARGB(255, 182, 27, 27),
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Color.fromARGB(255, 182, 27, 27), width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
        child: groupChatId.isNotEmpty
            ? StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .doc(groupChatId)
                    .collection(groupChatId)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    listMessage = snapshot.data!.docs;
                    if (listMessage.length > 0) {
                      return ListView.builder(
                        padding: EdgeInsets.all(11),
                        itemBuilder: (context, index) {
                          String idFrom = snapshot.data.docs[index]['idFrom'];

                          if (snapshot != null) {
                            if (idFrom == currentUserId) {
                              //myMessage
                              return Container(
                                child: Column(children: <Widget>[
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 180, top: 5, bottom: 5),
                                        width: 200,
                                        //width:120,
                                        child: BubbleSpecialThree(
                                          isSender: true,
                                          text: snapshot.data.docs[index]
                                              ['message'],
                                          color:
                                              Color.fromARGB(255, 182, 27, 27),
                                          tail: false,
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              );
                            } else {
                              print('mojeidFrom:${idFrom}');
                              return Container(
                                  child: Column(
                                    
                                children: [
                             

                                  Row(
                                      //mainAxisSize: MainAxisSize.max,

                                      children: <Widget>[
                                        Container(
                                            child: ClipOval(
                                          child: Image.network(
                                            icon,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  //  color: ColorConstants.themeColor,
                                                  value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null &&
                                                          loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, object, stackTrace) {
                                              return Icon(
                                                Icons.account_circle,
                                                size: 35,
                                                //color: ColorConstants.greyColor,
                                              );
                                            },
                                            width: 35,
                                            height: 35,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                        Container(
                                          width: 200,
                                          margin: EdgeInsets.only(
                                              right: 100, top: 5, bottom: 5),
                                          child: BubbleSpecialThree(
                                            isSender: false,
                                            text: snapshot.data.docs[index]
                                                ['message'],
                                            color: Colors.black,
                                            tail: false,
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ]),
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: 199, top: 0, bottom: 5),
                                    child: Text(
                                      DateFormat('dd MMM kk:mm').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              int.parse(snapshot.data
                                                  .docs[index]['timestamp']))),
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  )
                                ],
                              ));
                            }
                          } else {
                            return Center(child: Text('nie ma snapshotu'));
                          }
                        },
                        itemCount: snapshot.data?.docs.length,
                        reverse: true,
                      );
                    } else {
                      return Center(child: Text("No message here yet..."));
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    );
                  }
                })
            : Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Colors.pink.shade900,
                Colors.red.shade700,
              ])),
        ),
        title: Text('CHAT',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        // color: Colors.pink[900],
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                buildListMessage(),
                buildInput(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
