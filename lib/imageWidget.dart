import 'package:flutter/material.dart';
import 'package:ticketmaster/app_constants.dart';

class ImageToggleWidget extends StatefulWidget {
  final Map<String, dynamic> ticketData;

  ImageToggleWidget({required this.ticketData});

  @override
  _ImageToggleWidgetState createState() => _ImageToggleWidgetState();
}

class _ImageToggleWidgetState extends State<ImageToggleWidget> {
  bool _isImageVisible = true;

  void _toggleVisibility() {
    setState(() {
      _isImageVisible = !_isImageVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleVisibility,
          child: Text(
            "View Barcode",
            style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
          ),
        ),
        SizedBox(height: 10),
        _isImageVisible
            ? SizedBox(
          width: double.infinity,
          height: 200, // Adjust the height as needed
          child: Image.network(
            "${AppConstants.imageUrl}${widget.ticketData["image"]}", // Use the image URL from ticketData
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Center(
              child: Text(
                'Image not available',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
            : Center(
          child: Text(
            "Ticket Barcode",
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
      ],
    );
  }
}