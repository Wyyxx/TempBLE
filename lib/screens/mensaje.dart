import 'package:remedial3/config/config.dart';

class Mensaje extends StatelessWidget {
  const Mensaje({super.key, required this.temp});
  final double temp;
  @override
  Widget build(BuildContext context) {
    Color? color;
    IconData? icon;
    String msg = '';
    if (temp <= 0) {
      color = Colors.blue;
      icon = Icons.ac_unit;
      msg = "Hace frio";
    } else if (temp > 0 && temp <= 30) {
      color = Colors.green;
      icon = Icons.sunny;
      msg = "La temperatura está agradable";
    } else if (temp > 30) {
      color = Colors.red;
      icon = Icons.local_fire_department_rounded;
      msg = "La temperatura está muy alta";
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        Icon(icon),
        const SizedBox(
          width: 5,
        ),
        Text(
          msg,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]),
    );

  }
}
