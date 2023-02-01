import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SurvivalItemCreateForm extends StatefulWidget {
  const SurvivalItemCreateForm({super.key});

  @override
  State<SurvivalItemCreateForm> createState() => _SurvivalItemCreateFormState();
}

class _SurvivalItemCreateFormState extends State<SurvivalItemCreateForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      icon: Icon(Icons.text_fields),
                      labelText: 'Enter title',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    controller: dateInput,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        icon: Icon(Icons.calendar_today),
                        labelText: "Enter Date" //label text of field
                        ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime initialDate = DateTime.now();
                      try {
                        initialDate = DateFormat.yMMMd().parse(dateInput.text);
                      } catch (e) {
                        // Ignore
                      }
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 10000)),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat.yMMMd().format(pickedDate);
                        setState(() {
                          dateInput.text = formattedDate;
                        });
                      }
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ))
            ],
          )),
    );
  }
}