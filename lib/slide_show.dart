import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/app_constants.dart';
import 'package:ticketmaster/inser_screen.dart';

class SlideshowScreen extends StatefulWidget {
  final String token;
  const SlideshowScreen({super.key, required this.token});

  @override
  State<SlideshowScreen> createState() => _SlideshowScreenState();
}

class _SlideshowScreenState extends State<SlideshowScreen> {
  Future<Map<String, dynamic>> fetchTicketByToken(String token) async {
    // final String apiUrl = 'http://10.0.2.2/ticketmaster/index.php?token=$token'; // Replace with your PHP script URL
    final String apiUrl = '${AppConstants.baseUrl}?token=$token';

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
  @override
  void initState() {
    super.initState(); // Check if token exists in SharedPreferences on app startup
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
                      removeToken(context);
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
                      'My Tickets',
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
      body: FutureBuilder(
        future: fetchTicketByToken(widget.token),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            Map<String, dynamic> ticketData = snapshot.data!;
            return CarouselSlider.builder(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height,
                viewportFraction: 0.85,
                initialPage: 0,
                enableInfiniteScroll: false,
                reverse: false,
                autoPlay: false,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
              itemCount: 4,
              itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                  buildListView(context, itemIndex + 1, ticketData),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget buildListView(BuildContext context, int seatNumber, Map<String, dynamic> ticketData) {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          height: MediaQuery.of(context).size.height - 190,
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            color: Colors.blueAccent,
          ),
          child: Column(
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Verified Fan Offer",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    margin: const EdgeInsets.only(bottom: 5),
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Column(
                          children: [
                            TextWidget(text: "SEC"),
                            Text(ticketData["section"].toString(),
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 26),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            TextWidget(text: "ROW"),
                            Text(ticketData["row"].toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 26)),
                          ],
                        ),
                        Column(
                          children: [
                            const TextWidget(text: "SEAT"),
                            Text(seatNumber.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 26),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 600 / 60),
                    color: Colors.grey,
                    width: double.maxFinite,
                    height: 600 / 3,
                    child: Stack(
                      children: [
                        // Image background
                        SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image.network("${AppConstants.imageUrl}"+ticketData["image"]
                            , // Use the image URL from ticketData
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Transparent black overlay
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                        ),
                        // Centered text
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Center(
                              child: Text(
                                ticketData["tourName"], // Display tourName from ticketData
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                ticketData["date"], // Display date from ticketData
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          width: double.maxFinite,
                          height: 600 / 6,
                          child: const Center(
                            child: Text(
                              "LOWER LEVEL",
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code_scanner_outlined, color: Colors.white),
                              SizedBox(width: 10),
                              TextWidget(text: "View Barcode"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 600 / 60),
                        const Text("Ticket Details"),
                        const SizedBox(height: 600 / 24),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationZ(2.5), // Adjust the angle here (in radians)
                          child: Icon(
                            CupertinoIcons.ticket_fill,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        TextWidget(text: "ticketmasterverified"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 60,
          width: 100,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.blueAccent,
                ),
                child: const TextWidget(
                  text: "Transfer",
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey,
                ),
                child: const TextWidget(
                  text: "Sell",
                ),
              ),
            ],
          ),
        ),
      ],
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
