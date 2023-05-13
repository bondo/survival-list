import 'package:flutter/material.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class PersonFormField extends StatelessWidget {
  const PersonFormField({
    required this.value,
    required this.options,
    required this.onChanged,
    required this.label,
    super.key,
  });

  final Person? value;
  final List<Person>? options;
  final void Function(Person) onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    final items = options
        ?.map(
          (person) => DropdownMenuItem<Person>(
            value: person,
            child: Text(person.name), // '${person.name} ${person.id}'
          ),
        )
        .toList();

    return DropdownButtonFormField<Person>(
      value: value,
      items: items,
      onChanged: (person) {
        if (person != null) {
          onChanged(person);
        }
      },
      decoration: InputDecoration(
        icon: const Icon(Icons.person),
        labelText: label,
      ),
    );
  }
}
