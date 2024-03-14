import 'package:flutter/material.dart';

class SpendWidget extends StatelessWidget {
  final String where;
  final int value;

  const SpendWidget({
    super.key,
    required this.where,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(where),
          Text('\$$value'),
        ],
      ),
    );
  }
}
