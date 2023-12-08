import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/features/chat/chat_gigInfo.dart';
import 'package:freegig_app/features/chat/chat_page_appbar.dart';
import 'package:freegig_app/services/chat/chat_service.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String receiverUid;
  final String gigSubjectUid;
  const ChatPage({
    super.key,
    required this.receiverUid,
    required this.gigSubjectUid,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _chatService = ChatService();
  final _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUid, _messageController.text, widget.gigSubjectUid);
      _messageController.clear();
    }
  }

  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  void initState() {
    _chatService.lastSeen(widget.receiverUid, widget.gigSubjectUid);
    super.initState();
  }

  @override
  void dispose() {
    _chatService.lastSeen(widget.receiverUid, widget.gigSubjectUid);

    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: ChatPageAppBar(receiverUid: widget.receiverUid),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          //header
          ChatGigInfo(gigSubjectUid: widget.gigSubjectUid),

          //messages
          Expanded(
            child: _buildMessageList(),
          ),

          // user input
          _buildMessageInput(),
        ],
      ),
    );
  }

  // build message list

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.receiverUid,
        _firebaseAuth.currentUser!.uid,
        widget.gigSubjectUid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }

        scrollDown();

        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          ),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //define a posicao da mensagem
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    //define o alinhamento da mensagem
    var columnAlignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    //define a cor do container da mensagem
    var colorContainer = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Colors.blue
        : Color.fromARGB(255, 236, 236, 236);

    //define a cor do container da mensagem
    var colorText = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Colors.white
        : Colors.black;

    // Formata a hora do timestamp
    Timestamp timestamp = data['timestamp'];
    DateTime dateTime = timestamp.toDate();

    String horaFormatada = DateFormat('HH:mm').format(dateTime);
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: columnAlignment,
        children: [
          InkWell(
            onLongPress: () {
              if (data['senderId'] == _firebaseAuth.currentUser!.uid) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Fechar',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _chatService.deleteGigMessages(
                                    _firebaseAuth.currentUser!.uid,
                                    widget.receiverUid,
                                    widget.gigSubjectUid,
                                    data['msgUid']);
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Apagar',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ));
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: colorContainer),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  data['message'],
                  style:
                      TextStyle(color: colorText, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          SizedBox(height: 3),
          Text(
            horaFormatada + '  ',
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  // build message input
  FocusNode _messageFocusNode = FocusNode();

  Widget _buildMessageInput() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                focusNode: _messageFocusNode,
                controller: _messageController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: "Digite sua mensagem",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                sendMessage();
                // Adicione o código para ocultar o teclado
                _messageFocusNode.unfocus();
              },
              icon: Icon(
                Icons.send,
                size: 35,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
