import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/app_constants.dart';
import 'package:ticketmaster/slide_show.dart';


class InsertTicketScreen extends StatefulWidget {
  @override
  _InsertTicketScreenState createState() => _InsertTicketScreenState();
}

class _InsertTicketScreenState extends State<InsertTicketScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController sectionController = TextEditingController();
  TextEditingController rowController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController tourNameController = TextEditingController();
  TextEditingController levelController = TextEditingController();

  Future<void> insertTicket() async {
    // final String apiUrl = 'http://10.0.2.2/ticketmaster/index.php'; // Replace with your PHP script URL
    const String apiUrl = AppConstants.baseUrl; // Replace with your PHP script URL

    var response = await http.post(Uri.parse(apiUrl), body: {
      "section": sectionController.text,
      "row": rowController.text,
      "date": dateController.text,
      "image": imageController.text,
      "tourName": tourNameController.text,
      "level": levelController.text,
    });

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 'success') {
        String token = jsonResponse['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SlideshowScreen(token: token)),
        );
      } else {
        // Handle error case
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(jsonResponse['message']),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      // Handle other HTTP status codes
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to connect to server'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Insert Ticket'),
      ),
      // bottomNavigationBar: BottomNavigationBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: sectionController,
                decoration: InputDecoration(labelText: 'Section'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter section';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: rowController,
                decoration: InputDecoration(labelText: 'Row'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter row';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter image URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: tourNameController,
                decoration: InputDecoration(labelText: 'Tour Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter tour name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: levelController,
                decoration: InputDecoration(labelText: 'Level'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter level';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    insertTicket();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
