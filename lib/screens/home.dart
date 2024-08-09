import 'dart:convert';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remedial3/config/config.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _bluetooth = FlutterBluetoothSerial.instance;

  BluetoothConnection? connection;
  bool BTConnected = false;

  double temp = 0, presion = 0, altura = 0;

  @override
  void initState() {
    super.initState();
    permissions();
    turnOnBluetooth();
    connectToDevice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Remedial 3ra unidad"),
        actions: [
          BTConnected
              ? IconButton(
                  onPressed: () {
                    sendData('datos');
                  },
                  icon: const Icon(Icons.restart_alt_sharp),
                )
              : const SizedBox(),
        ],
      ),
      body: Visibility(
        visible: BTConnected,
        replacement: const Center(
          child: Text("No hay un dispositivo conectado"),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Gtemp(value: temp,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Gpresion(value: presion,),
                  Galtura(value: altura,),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: BTConnected
            ? const Mensaje(
                temp: 30,
              )
            : null,
      ),
    );
  }

  void connectToDevice() async {
    try {
      connection = await BluetoothConnection.toAddress("A0:A3:B3:2B:3B:E2");
      BTConnected = true;
      getData();
    } catch (e) {
      print(e);
    }
  }

  void permissions() async {
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetooth.request();
    await Permission.location.request();
  }

  void turnOnBluetooth() async {
    await _bluetooth.requestEnable();
  }

  void sendData(String msg) {
    if (connection != null) {
      if (connection!.isConnected) {
        connection?.output.add(ascii.encode("$msg\n"));
      }
    }
  }

  void getData() {
    connection!.input!.listen((event) {
      List<String> content = String.fromCharCodes(event).split(',');
      if(content.length>=3){
        temp = double.parse(content[0]);
        presion = double.parse(content[1]);
        altura = double.parse(content[2]);
      }
      setState(() {});
    });
  }
}
