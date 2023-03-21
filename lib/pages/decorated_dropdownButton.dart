import 'package:flutter/material.dart';

class DecoratedDropdownButton<V> extends StatelessWidget {
  const DecoratedDropdownButton({
    required this.labelText,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemBuilder,
    super.key,
  });

  final String labelText;

  final V? value;

  final Iterable<V> items;

  final DropdownMenuItem<V> Function(V value) itemBuilder;

  final ValueChanged<V?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(label: Text(labelText)),
      child: DropdownButton<V>(
        value: value,
        items: items.map(itemBuilder).toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
        isExpanded: true,
        isDense: true,
      ),
    );
  }
}
