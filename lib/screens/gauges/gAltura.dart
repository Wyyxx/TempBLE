import 'package:remedial3/config/config.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Galtura extends StatelessWidget {
  const Galtura({super.key, required this.value});
  final double value;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SfLinearGauge(
            minimum: 0,
            maximum: 3000,
            minorTicksPerInterval: 4,
            orientation: LinearGaugeOrientation.vertical,
            axisTrackStyle: const LinearAxisTrackStyle(thickness: 15),
            markerPointers: <LinearMarkerPointer>[
              LinearWidgetPointer(
                value: value,
                enableAnimation: false,
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: Image.asset(
                    'assets/images/triangle_pointer.png',
                    color: Colors.red,
                  ),
                ),
              ),
            ],
            barPointers: <LinearBarPointer>[
              LinearBarPointer(
                value: value,
                enableAnimation: false,
                thickness: 8,
                color: const Color(0xff0074E3),
              )
            ]),
        const SizedBox(
          width: 20,
        ),
        Text(
          "Altura: $value m",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
