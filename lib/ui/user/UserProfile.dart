import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyConstanta.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/ui/master_layout/LayoutLoading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart'
    as dtp;

class UserProfile extends StatefulWidget {
  final Function callbackSelectDash;
  UserProfile(this.callbackSelectDash);

  @override
  _UseProfileState createState() => _UseProfileState();
}

class _UseProfileState extends State<UserProfile> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  // final _ktpController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  // Show some different formats.
  final format = DateFormat('yyyy-MM-dd');

  // Changeable in demo
  // InputType inputType = InputType.date;
  bool editable = false;
  DateTime? date;

  String dropdownValue = "Laki-laki";

  var _isLoading = true;
  var _loadingUpdate = false;

  @override
  void initState() {
    showData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/images/logo.png'),
      ),
    );

    final fullName = TextFormField(
      controller: _fullNameController,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        labelText: 'Nama Lengkap',
        contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );

    final username = TextFormField(
      controller: _usernameController,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        labelText: 'Username',
        contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );

    final email = TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        labelText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );

    // final ktp = TextFormField(
    //   controller: _ktpController,
    //   keyboardType: TextInputType.text,
    //   autofocus: false,
    //   decoration: InputDecoration(
    //     labelText: 'NIK',
    //     contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
    //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
    //   ),
    // );

    final birthday = dtp.DateTimeField(
      controller: _birthdayController,
      onShowPicker: (context, val) {
        return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: val ?? DateTime.now(),
            lastDate: DateTime.now());
      },
      format: format,
      decoration: InputDecoration(
        labelText: 'Tanggal Lahir',
        contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      onChanged: (dt) => setState(() => date = dt),
    );

    final gender = Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: Container(),
        value: dropdownValue,
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue ?? '';
          });
        },
        items: <String>['Laki-laki', 'Perempuan']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );

    final phone = TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        labelText: 'No HP',
        contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );

    final location = TextFormField(
      controller: _locationController,
      keyboardType: TextInputType.multiline,
      autofocus: false,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Alamat',
        contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );

    final updateButton = _loadingUpdate
        ? LayoutLoading()
        : ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.all(12),
              ),
            ),
            onPressed: () {
              _updateProfile();
            },
            // padding: EdgeInsets.all(12),
            // color: Colors.orange,
            child:
                Text('Update Profile', style: TextStyle(color: Colors.white)),
          );

    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah Profile'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: _isLoading
            ? Center(
                child: Container(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(),
              ))
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      fullName,
                      SizedBox(height: 16.0),
                      username,
                      SizedBox(height: 16.0),
                      email,
                      SizedBox(height: 16.0),
                      birthday,
                      SizedBox(height: 16.0),
                      gender,
                      SizedBox(height: 16.0),
                      phone,
                      SizedBox(height: 16.0),
                      location,
                      SizedBox(height: 16.0),
                      updateButton,
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<String> showData() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.post(Uri.parse(ApiService.userProfile), headers: {
      "Accept": "application/json",
      "Authorization": prefs.getString(MyConstanta.saveToken) ?? ''
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var result = json.decode(response.body);

      if (result["status"] == "success") {
        _fullNameController.text =
            MyHelper.returnToString(result["data"]["name"]);
        _usernameController.text =
            MyHelper.returnToString(result["data"]["username"]);
        _emailController.text =
            MyHelper.returnToString(result["data"]["email"]);
        // _ktpController.text = MyHelper.returnToString(result["data"]["identity_card"]);
        _birthdayController.text =
            MyHelper.returnToString(result["data"]["birthday"]);
        if (MyHelper.returnToString(result["data"]["gender"]) != "-")
          dropdownValue = MyHelper.returnToString(result["data"]["gender"]);
        _phoneController.text =
            MyHelper.returnToString(result["data"]["phone"]);
        _locationController.text =
            MyHelper.returnToString(result["data"]["location"]);
      } else {
        MyHelper.toast(context, MyString.msgError);
        ;
      }
    } else {
      MyHelper.toast(context, MyString.msgError);
      ;
    }

    setState(() {
      _isLoading = false;
    });

    return "Success!";
  }

  Future<String> _updateProfile() async {
    setState(() {
      _loadingUpdate = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var map = new Map<String, dynamic>();
    map["id"] = prefs.getString(MyConstanta.userId);
    map["name"] = _fullNameController.text;
    map["username"] = _usernameController.text;
    map["email"] = _emailController.text;
    // map["identity_card"] = _ktpController.text;
    map["birthday"] = _birthdayController.text;
//    map["gender"] = _genderController.text;
    map["gender"] = dropdownValue.toString();
    map["phone"] = _phoneController.text;
    map["location"] = _locationController.text;

    // print(map);

    var response = await http.post(Uri.parse(ApiService.userUpdateProfile),
        headers: {
          "Accept": "application/json",
          "Authorization": prefs.getString(MyConstanta.saveToken) ?? ''
        },
        body: map);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var result = json.decode(response.body);

      // print(result.toString());

      if (result["status"] == "success") {
        MyHelper.toast(
          context,
          result["message"],
        );
      } else {
        MyHelper.toast(context, MyString.msgError);
      }
    } else {
      MyHelper.toast(context, MyString.msgError);
    }

    setState(() {
      _loadingUpdate = false;
    });

    return "Success!";
  }
}
