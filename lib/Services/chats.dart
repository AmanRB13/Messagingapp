import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:messagingapp/Theme/themeprovider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class Chatsscreen extends StatefulWidget {
  final String receiverUid;
  final String receiverEmail;

  const Chatsscreen({
    super.key,
    required this.receiverUid,
    required this.receiverEmail,
  });

  @override
  State<Chatsscreen> createState() => _ChatsscreenState();
}

class _ChatsscreenState extends State<Chatsscreen> {
  final TextEditingController _textcontroller = TextEditingController();

  late final String chatId;

  @override
  void initState() {
    super.initState();

    final currentUid = FirebaseAuth.instance.currentUser!.uid;
    chatId = getChatId(currentUid, widget.receiverUid);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, model, child) {
        final isDark = model.isDark;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            title: Text(widget.receiverEmail),
          ),
          body: Column(
            children: [
              ///  MESSAGES
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(chatId)
                      .collection('messages')
                      .orderBy('timestamp')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text('Messages will appear here'));
                    }

                    final docs = snapshot.data!.docs;
                    final myUid = FirebaseAuth.instance.currentUser!.uid;

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final msg = docs[index];
                        final bool isMe = msg['senderUid'] == myUid;

                        final now = DateTime.now();
                        final formattedDate = DateFormat('dd MMM').format(now);
                        final time = DateFormat('h :mm a').format(now);

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                  onLongPress: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      builder: (_) {
                                        return SafeArea(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: const Icon(Icons.copy),
                                                title: const Text('Copy'),
                                                onTap: () async {
                                                  Clipboard.setData(
                                                    ClipboardData(
                                                        text: msg['text']),
                                                  );
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              if (isMe)
                                                ListTile(
                                                  leading: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red),
                                                  title: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  onTap: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('chats')
                                                        .doc(chatId)
                                                        .collection('messages')
                                                        .doc(msg.id)
                                                        .delete();

                                                    Navigator.pop(context);
                                                  },
                                                ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  onPressed: null,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isMe
                                          ? Colors.blueAccent.withOpacity(0.25)
                                          : Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      msg['text'],
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Text('${formattedDate} At ${time}',
                                    style: const TextStyle(fontSize: 10)),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              /// INPUT
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isDark ? Colors.grey[900] : Colors.grey[200]),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                         child:  TextField(
  controller: _textcontroller,
  keyboardType: TextInputType.multiline,
  textInputAction: TextInputAction.newline,
  minLines: 1,
  maxLines: 5,
  style: TextStyle(
    color: isDark ? Colors.white : Colors.black87,
  ),
  decoration: InputDecoration(
    hintText: 'Enter your message...',
    hintStyle: TextStyle(
      color: isDark ? Colors.white70 : Colors.grey,
    ),
    border: InputBorder.none,
  ),
),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        if (_textcontroller.text.trim().isEmpty) return;

                        final text = _textcontroller.text.trim();
                        _textcontroller.clear();

                        await FirebaseFirestore.instance
                            .collection('chats')
                            .doc(chatId)
                            .collection('messages')
                            .add({
                          'text': text,
                          'senderUid': FirebaseAuth.instance.currentUser!.uid,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

String getChatId(String uid1, String uid2) {
  return uid1.compareTo(uid2) < 0 ? '${uid1}_$uid2' : '${uid2}_$uid1';
}
