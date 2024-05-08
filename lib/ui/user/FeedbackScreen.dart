import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyConstanta.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/model/feedbackModel.dart';
//import 'package:pontianak_smartcity/model/feedbackModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
//import 'package:toast/toast.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController _pesanController = TextEditingController();
  bool isLoading = false;

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
        title: Text('Kritik dan Saran'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: _pesanController,
                keyboardType: TextInputType.multiline,
                autofocus: false,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Kritik dan Saran',
                  contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
            ),
            !isLoading
                ? ElevatedButton(
                    onPressed: () async {
                      if (_pesanController.text.length < 1) {
                        MyHelper.toast(
                          context,
                          'Mohon masukkan kritik dan saran anda',
                          // context,
                        );
                        return;
                      }
                      setState(() {
                        isLoading = true;
                      });
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var map = new Map<String, dynamic>();
                      map["user_id"] = prefs.getString(MyConstanta.userId);
                      map["pesan"] = _pesanController.text;

                      var response =
                          await http.post(Uri.parse(ApiService.userFeedback),
                              headers: {
                                "Accept": "application/json",
                                "Authorization":
                                    prefs.getString(MyConstanta.saveToken) ?? ''
                              },
                              body: map);

                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        var result = json.decode(response.body);

                        print(result.toString());

                        setState(() {
                          isLoading = true;
                        });

                        if (result["status"] == "success") {
                          _pesanController.clear();
                          MyHelper.toast(
                            context,
                            result["message"],
                          );
                          Navigator.of(context).pop();
                        } else {
                          MyHelper.toast(context, MyString.msgError);
                        }
                      } else {
                        MyHelper.toast(
                          context,
                          MyString.msgError,
                        );
                      }
                    },
                    child: Text(
                      'Kirim Kritik dan Saran',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(15)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: feedbacks.length,
                itemBuilder: (context, index) {
                  FeedbackModel feedback = feedbacks[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMessage(feedback.pesan),
                      _buildReply(feedback.replies),
                    ],
                  );
                },
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
}
