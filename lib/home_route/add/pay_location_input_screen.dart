import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:on_call_work/home_route/add/add_bloc.dart';
import 'package:on_call_work/widget/k_button.dart';
import 'package:on_call_work/widget/k_text.dart';
import 'package:on_call_work/widget/k_user_input.dart';

class PayLocationInputScreen extends StatefulWidget {
  final AddPayLocationState state;

  const PayLocationInputScreen({
    Key? key,
    required this.state,
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
  void initState() {
    if (widget.state.location != null) {
      latLng = widget.state.location!;
    }

    if (widget.state.pay != null) {
      payTextEditingController.text = '${widget.state.pay}';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: KText('Enter name and description of your job offer'),
        ),
        KUserInput(
          keyboardType: const TextInputType.numberWithOptions(),
          controller: payTextEditingController,
          hintText: 'Pay',
          errorText: 'Pay cannot be below 0',
          isError: widget.state.isPayBelowZero,
          prefixIcon: Icons.euro,
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
              center: widget.state.location ?? LatLng(45.4781014, 9.2250675),
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
                      builder: (ctx) => const Icon(Icons.location_on),
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
          child: KButton(
            onPressed: _onPressed,
            text: 'Next',
          ),
        ),
      ],
    );
  }

  void _onPressed() {
    if (payTextEditingController.text.isNotEmpty && latLng != null) {
      context.read<AddBloc>().add(AddPayLocationEvent(
          location: latLng!, pay: num.parse(payTextEditingController.text)));
    }
  }
}
