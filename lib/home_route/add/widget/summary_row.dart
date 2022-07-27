import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class SummaryRow extends StatelessWidget {
  final IconData iconData;
  final String text;

  const SummaryRow({
    Key? key,
    required this.iconData,
    required this.text,
  }) : super(key: key);

  const SummaryRow.name({
    Key? key,
    required this.text,
  })  : iconData = Icons.location_history,
        super(key: key);

  const SummaryRow.description({
    Key? key,
    required this.text,
  })  : iconData = Icons.search,
        super(key: key);

  SummaryRow.from({
    Key? key,
    required DateTime from,
  })  : text =
            '${from.day}/${from.month}/${from.year} ${from.hour}:${from.minute}',
        iconData = Icons.date_range,
        super(key: key);

  SummaryRow.to({
    Key? key,
    required DateTime to,
  })  : text = '${to.day}/${to.month}/${to.year} ${to.hour}:${to.minute}',
        iconData = Icons.date_range,
        super(key: key);

  const SummaryRow.pay({
    Key? key,
    required num pay,
  })  : iconData = Icons.euro,
        text = '$pay',
        super(key: key);

  const SummaryRow.location({
    Key? key,
    required LatLng location,
  })  : iconData = Icons.location_on,
        text = '$location',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(iconData),
            Text(text),
          ],
        ),
        const Divider(),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
