import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyColor.dart';
import 'package:pontianak_smartcity/common/MyConstanta.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/model/feedbackModel.dart';
//import 'package:pontianak_smartcity/model/feedbackModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
//import 'package:toast/toast.dart';

class FeedbackScreenUpdate extends StatefulWidget {
  const FeedbackScreenUpdate({Key? key}) : super(key: key);

  @override
  _FeedbackScreenUpdateState createState() => _FeedbackScreenUpdateState();
}

class _FeedbackScreenUpdateState extends State<FeedbackScreenUpdate> {
  TextEditingController _pesanController = TextEditingController();
  bool isLoading = false;
  final _messages = <String>[];
  
  //feedbackchat
  List<FeedbackModel> feedbacks = [];

  @override
  void initState() {
    super.initState();
    fetchFeedback();
  }

  Future<void> fetchFeedback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse('https://jepin.pontianak.go.id/api/feedback'),
      headers: {
        "Accept": "application/json",
        "Authorization": prefs.getString(MyConstanta.saveToken) ?? '',
      },
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final result = responseData['data'] as List<dynamic>;
      setState(() {
        feedbacks = result.map((e) => FeedbackModel.fromMap(e)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: MyColor.colorAppbar,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        title: Text(
          "Kritik dan Saran",
          style: TextStyle(
              fontSize: MyFontSize.large,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                FeedbackModel feedback = feedbacks[index];
                return ListTile(
                  title: Text(_messages[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _messages.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pesanController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _sendMessage();
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Color(0xFFF9A91C),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildReply(List<Reply> replies) {
    if (replies.isEmpty) {
      return SizedBox(); // Return empty SizedBox if there are no replies
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: replies.map((reply) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(reply.pesan),
          ),
        );
      }).toList(),
    );
  }

  void _sendMessage() {
    final message = _pesanController.text;
    _pesanController.clear();
    setState(() {
      _messages.add(message);
    });
  }
}
