import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _enteredMessage = '';

  void _sendMessage() async {
     FocusScope.of(context).unfocus();
    //  final user = await FirebaseAuth.instance.currentUser();
    //  final userData = await Firestore.instance.collection('users').document(user.uid).get();
    //  Firestore.instance.collection('chats').add({
    //    'text' : _enteredMessage,
    //    'createdAt' : Timestamp.now(),
    //    'userId' : user.uid,
    //    'username' :userData['username'],
    //    'userImage' : userData['image_url'],
    //  });
     _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              controller: _controller,
              decoration: const InputDecoration(hintText: 'Send Message'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: const Icon(Icons.send),
            onPressed: _enteredMessage.trim().isEmpty 
            ? null 
            : _sendMessage,
          )
        ],
      ),
    );
  }
}