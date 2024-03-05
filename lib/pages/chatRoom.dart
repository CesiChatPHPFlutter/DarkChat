import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:message_app/models/message.dart';

import '../repositories/message_repositoru.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE3MDk1NjIyNDgsImlzcyI6ImNlc2kubG9jYWwiLCJuYmYiOjE3MDk1NjIyNDgsImV4cCI6MTcwOTU4Mzg0OCwiZGF0YXMiOnsidXNlcklkIjoxLCJtYWlsIjoiVXNlcjFAbWFpbC5jb20iLCJuYW1lIjoiVXNlcjEifX0.eZZ9hNrND1VoQ_i2mKGB015jCFYu7BIiuLMqI7UW9mTvxRcWlnrC3uhI47_4JLtiE1JVFec7UfTugLBiZg085Q";
  int userId = 2;

  List<Message> messages = [];
  final ScrollController _scrollController = ScrollController();

  static const _pageSize = 5;
  bool isLoading = true;
  int page = 1;
  bool isLoadingMore = false;
  bool noMoreMessages = false;

  void getMessages() async {
    try {
      final loadedMessages = await MessageRepository.messagesWithUserId(token, userId, page, _pageSize*4);
      setState(() {
        messages = loadedMessages;
        isLoading = false;
      });
    } catch (error) {
      // if (error is ExpireTokenException) {
      //   AuthentificationRepository.deleteUser();
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => const Login()),
      //   );
      //}
      print('Erreur lors du chargement des message: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _scrollListener() {
    // print('fffffffffffffffffff');
    // print(_scrollController.position.pixels);
    // print(_scrollController.position.maxScrollExtent);
    // print(_scrollController.position.maxScrollExtent * 0.1);
    // print(_scrollController.position.minScrollExtent);
    // print(_scrollController.position.minScrollExtent * 0.1);
    // if (_scrollController.position.pixels <= _scrollController.position.maxScrollExtent * 0.5 &&
    //     !isLoadingMore && !noMoreMessages) {
    if(_scrollController.position.userScrollDirection == ScrollDirection.reverse
        && _scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8
        && !isLoadingMore && !noMoreMessages) {
    // if (_scrollController.position.pixels <= _scrollController.position.maxScrollExtent * 0.5 &&
    //     !isLoadingMore && !noMoreMessages) {

      setState(() {
        isLoadingMore = true;
      });
      loadMore();
    }
  }

  Future<void> loadMore() async {
    try {
      final moreMessages = await MessageRepository.messagesWithUserId(
          token, userId, page, _pageSize);
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
    // on ExpireTokenException catch (error){
    //   AuthentificationRepository.deleteUser();
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const Login()),
    //   );
    // }
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
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        // Reaching top of the list, load more messages
        // if (index == 0) {
        //   return Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }
        if (isLoadingMore && !noMoreMessages) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        // Subtracting index by 1 to match messages index
        final message = messages[index];
        return _buildMessageItem(message);
      },
    );
  }

  Widget _buildMessageItem(Message message) {
    var alignment = message.sender_id != userId
        ? Alignment.centerRight
        : Alignment.centerLeft;

    var row = Column(children: [Text("${message.message_id}"), Text(message.content!)]);

    return Container(
      alignment: alignment,
      child: row,
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            obscureText: false,
            decoration: new InputDecoration.collapsed(hintText: 'Aa'),
          ),
        ),
        IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            )
        )
      ],
    );
  }

  void sendMessage() {

  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    getMessages();

    // Scroll to bottom when initialized
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dark Profil'),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: _buildMessageList(),

            ),
            _buildMessageInput(),
          ],
        ),
      // body: _buildMessageList(),
    );
  }
}