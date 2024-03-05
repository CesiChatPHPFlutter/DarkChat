import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:message_app/models/message.dart';

import '../models/expireTokenException.dart';
import '../models/user.dart';
import '../repositories/message_repository.dart';
import 'login.dart';

class ChatRoom extends StatefulWidget {
  final User? user;
  final int otherUserId;
  const ChatRoom({Key? key, required this.user, required this.otherUserId})
      : super(key: key);

  @override
  State createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  // String token = widget.user!.token!;
  // final int userId = ;

  List<Message> messages = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditController = TextEditingController();
  late final Timer? timer;

  static const _pageSize = 30;
  bool isLoading = true;
  int page = 1;
  bool isLoadingMore = false;
  bool noMoreMessages = false;
  int currentTotalMessage = 0;

  void getMessages() async {
    try {
      final loadedMessages = await MessageRepository.messagesWithUserId(
          widget.user!.token!, widget.otherUserId, page, _pageSize);
      setState(() {
        messages = loadedMessages;
        page++;
        isLoading = false;
      });

      // Scroll to bottom when initialized
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent + 100);
      });
    } catch (error) {
      if (error is ExpireTokenException) {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const Login()),
        // );
        Navigator.of(context)
            .pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          ModalRoute.withName('/'),
        );
      }
      print('Erreur lors du chargement des message: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        _scrollController.position.pixels <=
            _scrollController.position.maxScrollExtent * 0.2 &&
        !isLoadingMore &&
        !noMoreMessages) {
      setState(() {
        isLoadingMore = true;
      });
      loadMore();
    }
  }

  Future<void> loadMore() async {
    try {
      final moreMessages = await MessageRepository.messagesWithUserId(
          widget.user!.token!, widget.otherUserId, page, _pageSize);
      if (moreMessages.isEmpty) {
        setState(() {
          isLoadingMore = false;
          noMoreMessages = true;
        });
      } else {
        setState(() {
          messages.addAll(moreMessages);
          page++;
          isLoadingMore = false;
        });
      }
    }
    on ExpireTokenException catch (error){
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const Login()),
      // );
      Navigator.of(context)
          .pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Login()),
        ModalRoute.withName('/'),
      );
    }
    catch (error) {
      print("Erreur lors du chargement des souvenirs: $error");
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      reverse: false,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        if (isLoadingMore && !noMoreMessages) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        // Subtracting index by 1 to match messages index
        final message = messages[messages.length - 1 - index];
        return _buildMessageItem(message);
      },
    );
  }

  Widget _buildMessageItem(Message message) {
    var alignment = message.sender_id != widget.otherUserId
        ? Alignment.centerRight
        : Alignment.centerLeft;

    var color = message.sender_id != widget.otherUserId ? Colors.black : Colors.white;
    double bottomLeftRadius = message.sender_id != widget.otherUserId ? 16 : 0;
    double bottomRightRadius = message.sender_id != widget.otherUserId ? 0 : 16;

    var decoration = BoxDecoration(
      borderRadius: BorderRadius.only(
        topRight: const Radius.circular(16),
        topLeft: const Radius.circular(16),
        bottomLeft: Radius.circular(bottomLeftRadius),
        bottomRight: Radius.circular(bottomRightRadius),
      ),
      color: message.sender_id != widget.otherUserId
          ? const Color.fromRGBO(234, 234, 234, 1)
          : Colors.black,
      border: Border.all(color: Colors.black),
    );

    var child = Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: decoration,
      constraints: const BoxConstraints(minWidth: 10, maxWidth: 200),
      child: Text(
        message.content!,
        style: TextStyle(
          color: color,
        ),
      ),
    );

    return Container(
      alignment: alignment,
      child: child,
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 4.0, color: Colors.black),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditController,
              textInputAction: TextInputAction.send,
              onSubmitted: (value) {
                 sendMessage();
              },
              obscureText: false,
              decoration: const InputDecoration(
                hintText: 'Aa',
              ),
            ),
          ),
          Container(
            color: Colors.black,
            child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 40,
                )),
          )
        ],
      )
    );
  }

  void sendMessage() async {
    if (_textEditController.text == "") return;

    final message = await MessageRepository.createMessage(
        widget.user!.token!, widget.otherUserId, _textEditController.text);

    if (message == null) return;

    _textEditController.text = '';
    page = 1;
    getMessages();
  }

  void checkMessageCount() async {
    final messageCount = await MessageRepository.totalMessagesWithUserId(
      widget.user!.token!,
      widget.otherUserId,
    );

    if (currentTotalMessage < messageCount) {
      currentTotalMessage = messageCount;
      page = 1;
      getMessages();
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => checkMessageCount());
    getMessages();
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _scrollController.dispose();
    _textEditController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dark Profil'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }
}
