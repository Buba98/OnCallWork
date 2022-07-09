import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PayLocationInputScreen extends StatefulWidget {
  final Function(LatLng, num) onPressed;

  const PayLocationInputScreen({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PayLocationInputScreenState();
}

class _PayLocationInputScreenState extends State<PayLocationInputScreen> {
  final MapController mapController = MapController();
  final TextEditingController payTextEditingController =
      TextEditingController();

  LatLng? latLng;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text('Enter name and description of your job offer'),
        ),
        TextField(
          keyboardType: const TextInputType.numberWithOptions(),
          controller: payTextEditingController,
          decoration: const InputDecoration(
            labelText: 'Pay',
          ),
        ),
        const Spacer(
          flex: 1,
        ),
        Flexible(
          flex: 10,
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              onTap: (tapPosition, LatLng point) {
                setState(() => latLng = point);
              },
              center: LatLng(51.5, -0.09),
              zoom: 7.0,
              maxZoom: 10.0,
              minZoom: 3.0,
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c']),
              MarkerLayerOptions(
                markers: [
                  if (latLng != null)
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: latLng!,
                      builder: (ctx) => Container(
                        key: const Key('blue'),
                        child: const FlutterLogo(),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(
          flex: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: ElevatedButton(
            onPressed: _onPressed,
            child: const Text('Next'),
          ),
        ),
      ],
    );
  }

  void _onPressed() {
    if (payTextEditingController.text.isNotEmpty && latLng != null) {
      widget.onPressed(latLng!, num.parse(payTextEditingController.text));
    }
  }
}
