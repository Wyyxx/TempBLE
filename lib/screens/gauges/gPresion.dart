import 'package:flutter/cupertino.dart';
import 'package:remedial3/config/config.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Gpresion extends StatelessWidget {
  const Gpresion({super.key, required this.value});
  final double value;
  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SfLinearGauge(
            minimum: 0,
            maximum: 1100,
            orientation: LinearGaugeOrientation.vertical,
            showLabels: false,
            showTicks: false,
            axisTrackStyle: const LinearAxisTrackStyle(
                thickness: 15, borderColor: Colors.black, borderWidth: 1),
            markerPointers: <LinearMarkerPointer>[
              LinearWidgetPointer(
                value: 900,
                enableAnimation: false,
                position: LinearElementPosition.inside,
                child: Container(
                  height: 75,
                  width: 5,
                  color: Colors.orange,
                ),
              ),
              LinearWidgetPointer(
                markerAlignment: LinearMarkerAlignment.end,
                value: 0,
                enableAnimation: false,
                child: Container(
                  height: 20,
                  width: 90,
                  color: const Color(0xff0074E3),
                ),
              ),
              LinearWidgetPointer(
                markerAlignment: LinearMarkerAlignment.end,
                value: 0,
                enableAnimation: false,
                child: Container(
                  height: 30,
                  width: 90,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      left: BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                      right: BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                      bottom: BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            barPointers: <LinearBarPointer>[
              LinearBarPointer(
                value: value,
                enableAnimation: false,
                position: LinearElementPosition.cross,
                thickness: 13,
                color: const Color(0xff0074E3),
              )
            ]),
        const SizedBox(
          width: 20,
        ),
        Text(
          "Presión: $value hPa",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
