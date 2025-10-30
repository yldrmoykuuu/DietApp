import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';


class CustomMultiSelect extends StatelessWidget {
  final List<String> items;
  final String title;
  final IconData icon;
  final List<String> selectedItems;
  final Function(List<String>) onConfirm;

  const CustomMultiSelect({
    super.key,
    required this.items,
    required this.title,
    required this.icon,
    required this.selectedItems,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField(
      items: items.map((e) => MultiSelectItem(e, e)).toList(),
      title: Text(title),
      selectedColor: Colors.green.shade400,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      buttonIcon: Icon(icon),
      buttonText: Text(title),
      initialValue: selectedItems,
      onConfirm: (values) => onConfirm(values.cast<String>()),
    );
  }
}
