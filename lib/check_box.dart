
import 'package:flutter/material.dart';

class CheckboxRowWidget extends StatefulWidget {
  @override
  _CheckboxRowWidgetState createState() => _CheckboxRowWidgetState();
}

class _CheckboxRowWidgetState extends State<CheckboxRowWidget> {
  List<bool> _isChecked = List.generate(4, (index) => false);
  bool isVisible = true;
  int getSelectedCount() {
    return _isChecked.where((isSelected) => isSelected).length;
  }
  @override
  Widget build(BuildContext context) {
    return isVisible?Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(4, (index) {
            return Container(
              // margin: EdgeInsets.all(8.0),
              height: 320/4, // Adjust height as needed
              width: MediaQuery.of(context).size.width/4 - 20, // Adjust width as needed
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)
                ),
                // border: Border.all(color: Colors.white, width: 2.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)
                        ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Seat ${index + 1}",
                          style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Spacer(), // Pushes the checkbox to the bottom
                  Checkbox(
                    value: _isChecked[index],
                    activeColor: Colors.blue, // Color of the checkbox when checked
                    checkColor: Colors.white, // Color of the checkmark
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked[index] = value!;
                      });
                    },
                  ),
                ],
              ),
            );
          }),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${getSelectedCount()} Selected',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
              ),
              GestureDetector(
                onTap: (){
                  if(getSelectedCount() >= 1){
                    setState(() {
                      isVisible = false;
                    });
                    print("object" + getSelectedCount().toString());
                  }else{
                    print("None");
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Transfer',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.blueAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ):
    SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text("Transfer Ticket",
              style: TextStyle(color: Colors.black54, fontSize: 20),),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(
              thickness: 1,
              height: 1,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10,),
          Text("${getSelectedCount()} Ticket Selected", style: TextStyle(color: Colors.grey),),
          SizedBox(height: 10,),
          Form(
            child:Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                  labelText: 'First Name',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                  labelText: 'Last Name',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                  labelText: 'Email',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Description",
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10.0),
                  // labelText: 'Description',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isVisible=true;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_ios, color: Colors.blueAccent, size: 15,),
                          Text("Back", style: TextStyle(color: Colors.blueAccent),),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Center(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(width: 3, color: Colors.blueAccent)
                                      ),
                                      padding: EdgeInsets.all(15),
                                      child: Icon(Icons.done, size: 32, color: Colors.blueAccent,),
                                  ),
                              ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Successful !',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold), // Center align the text
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Ticket Transfer was successful",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the popup
                                  },
                                  child: Container(
                                      color: Colors.blueAccent,
                                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                      width: double.maxFinite,
                                      child: Center(child: Text('OK', style: TextStyle(color: Colors.white),))),
                                ),
                              ],
                            );
                          },
                        );

                      },
                      child: Container(
                          decoration: BoxDecoration(color: Colors.blueAccent),
                          child: Text("Transfer Ticket", style: TextStyle(color: Colors.white),),
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
            ],
            ),
          ),
        ],
      ),
    );
  }
}