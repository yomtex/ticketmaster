import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/app_constants.dart';
import 'package:ticketmaster/check_box.dart';
import 'package:ticketmaster/details.dart';
import 'package:ticketmaster/inser_screen.dart';
import 'package:ticketmaster/slide_show.dart';

class DetailScreen extends StatefulWidget {
  final String token;
  const DetailScreen({super.key, required this.token});


  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  Future<Map<String, dynamic>> fetchTicketByToken(String token) async {
    // final String apiUrl = 'http://10.0.2.2/ticketmaster/index.php?token=$token'; // Replace with your PHP script URL
    final String apiUrl = '${AppConstants.baseUrl}?token=$token';
    bool isVisible = true;
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 'success') {
        return jsonResponse['data'];
      } else {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception('Failed to load ticket');
    }
  }
  late Future<Map<String, dynamic>> _ticketDataFuture;
  Map<String, dynamic>? _ticketData;

  @override
  void initState() {
    super.initState();
    _ticketDataFuture = fetchTicketByToken(widget.token);
    // Check if token exists in SharedPreferences on app startup
  }

  void checkTokenExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SlideshowScreen(token: token)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InsertTicketScreen()),
      );
    }
  }

  void removeToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token'); // Remove token from SharedPreferences

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => InsertTicketScreen()),
    ); // Navigate back to previous screen (main.dart)
  }
  bool _isVisible = true;
  final List<Map<String, String>> details = [
    {'title': 'Location', 'value': 'Dublin, IE'},
    {'title': 'Order Number', 'value': '123456'},
    {'title': 'Ticket Type', 'value': 'Ticket'},
    {'title': 'Entrance', 'value': 'Block 516'},
    {'title': 'Information', 'value': "U16'S With 25+"},
    {'title': 'Purchase Date', 'value': 'Thu, Jul 20 2023 - 1:29PM'},
  ];

  final String ticketPrice = '122';
  final int ticketQuantity = 4;
  final String grandTotal = 'Grand Total Value';
  final String additionalItem = 'Additional Information at the bottom';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0), // Set the height here
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey[800],
          leading: null,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(bottom: 10.0), // Adjust bottom padding as needed
            child: Stack(
              children: [
                Positioned(
                  left: 10,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      // removeToken(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SlideshowScreen(token: widget.token,)),
                      );
                      // Add your remove action here
                    },
                  ),
                ),
                const Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Tickets Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 0,
                  child: TextButton(
                    onPressed: () {
                      // Add your help action here
                    },
                    child: const Text(
                      'Help',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body:   Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: details.length + 2, // Details + Ticket Price + Grand Total
                itemBuilder: (context, index) {
                  if (index < details.length) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              details[index]['title']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              details[index]['value']!,
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 15,)
                          ],
                        ),
                      ),
                    );
                  } else if (index == details.length) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ticket Price',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '$ticketPrice * $ticketQuantity',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Grand Total',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              grandTotal,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Terms & Conditions",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 7),
                    Text(
                      "This ticket is issued subject to Ticketmaster's Purchase Policy (available at https://www.ticketmaster.ie/legal/purchase.html). Venue and/or event organiser T&Cs may also apply (please check their respective websites). Please keep your ticket secure and safe at all times. Please check your ticket as mistakes cannot always be rectified.",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}


class TextWidget extends StatelessWidget {
  final String text;
  final Color color;

  const TextWidget({Key? key, required this.text, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color),
    );
  }
}
