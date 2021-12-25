import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pi_drone/joystick/joystick.dart';
import 'package:pi_drone/main.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ControllerPage extends StatefulWidget {
  final WebSocketChannel? channel;
  const ControllerPage({Key? key, this.channel}) : super(key: key);

  @override
  _ControllerPageState createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  int lx = 0;
  int ly = 0;
  int rx = 0;
  int ry = 0;
  String arm = 'ARM';
  Color armcolor = Colors.blue;
  Color textcolor = Colors.white;
  String height = '0 M';
  String rssi = '0.00 DB';
  String flighttime = '00:00';
  bool connected = false;
  int throttle = 1000;
  double batteryVoltage = 4.20;
  Color button1color = Colors.blue;
  Color button2color = Colors.blue;
  String errortext = ' ';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int batteryLevel =
        (((batteryVoltage - battLowVolatage) / (4.20 - battLowVolatage)) * 100)
            .toInt();

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(onPressed: () {}, child: const Text('Mode')),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.settings),
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 80,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black.withOpacity(0.1), width: 1.0),
                        borderRadius: BorderRadius.circular(20.0),
                        color: const Color(0x15000000)),
                    child: Center(
                        child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 25,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5))),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Container(
                            width: 25,
                            height: 8,
                            decoration: BoxDecoration(color: Colors.green),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Container(
                            width: 25,
                            height: 8,
                            decoration: BoxDecoration(color: Colors.green),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Container(
                            width: 25,
                            height: 8,
                            decoration: BoxDecoration(color: Colors.green),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Container(
                            width: 25,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5))),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '$batteryLevel %',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    )),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (connected) {
                            connected = false;
                            button1color = Colors.blue;
                            arm = 'ARM';
                            armcolor = Colors.blue;
                          } else {
                            connected = true;
                            button1color = Colors.green;
                          }
                        });
                      },
                      child: const Text('Aux 1'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(button1color))),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (button2color == Colors.blue) {
                          button2color = Colors.red;
                        } else {
                          button2color = Colors.blue;
                        }
                      });
                    },
                    child: const Text('Aux 2'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(button2color)),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.1),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(20.0),
                              color: const Color(0x15000000)),
                          child: Center(child: Text('$lx\n$ly')),
                        ),
                        Joystick(
                          listener: (details) {
                            setState(() {
                              lx = ((details.x) * 100).toInt();
                              ly = -((details.y) * 100).toInt();
                              sendData();
                            });
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 35,
                          child: Center(
                              child: Text(
                            errortext,
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        displayWidget(),
                        const SizedBox(
                          height: 10,
                        ),
                        armButton(context),
                        // const SizedBox(
                        //   height: 10,
                        // )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.1),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(20.0),
                              color: const Color(0x15000000)),
                          child: Center(child: Text('$rx\n$ry')),
                        ),
                        Joystick(
                          listener: (details) {
                            setState(() {
                              rx = ((details.x) * 100).toInt();
                              ry = -((details.y) * 100).toInt();
                              sendData();
                            });
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget armButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: armcolor, borderRadius: BorderRadius.circular(8)),
        width: 100,
        height: 40,
        child: Center(
            child: Text(
          arm,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        )),
      ),
      onTap: () {
        if (connected) {
          if (arm == 'ARM') {
            setState(() {
              errortext = 'Long press to Arm';
              Future.delayed(const Duration(seconds: 2), () {
                clearError();
              });
            });
          } else {
            setState(() {
              errortext = 'Long press to Disarm';
              Future.delayed(const Duration(seconds: 2), () {
                clearError();
              });
            });
          }
        } else {
          connectDialog(context);
        }
      },
      onLongPress: () {
        setState(() {
          if (connected) {
            if (arm == 'ARM') {
              arm = 'ARMED';
              armcolor = Colors.red;
            } else {
              arm = 'ARM';
              armcolor = Colors.blue;
            }
          } else {
            connectDialog(context);
          }
        });
      },
    );
  }

  Widget displayWidget() {
    return Container(
      width: 150,
      height: 200,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Height : $height',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 15),
            ),
            Text('RSSI : $rssi',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15)),
            Text('Throttle : $throttle',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15)),
            Text('Flight Time : $flighttime',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15)),
            Text(connected ? 'Connected' : 'Not Connected',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15))
          ],
        ),
      ),
    );
  }

  Future connectDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Not Connected"),
            content: const Text(
              "Pi Drone is not connected",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Open WiFi"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void clearError() {
    setState(() {
      errortext = ' ';
    });
  }

  void sendData() {
    List<int> data = [lx,ly,rx,ry];
    widget.channel!.sink.add(data.toString());
  }
}
