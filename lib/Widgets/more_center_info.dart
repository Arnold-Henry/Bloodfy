import 'package:bloodfy/Components/text_form_field.dart';
import 'package:flutter/material.dart';

class ReusableTypeDropDown extends StatelessWidget {
  const ReusableTypeDropDown({Key? key, required this.onChanged}) : super(key: key);

  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: 'Select',
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 113, 113),
        ),
        items: <String>['Select','Government', 'Private', 'NGO']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: textFormFieldDecoration,
        onChanged: onChanged);
  }
}