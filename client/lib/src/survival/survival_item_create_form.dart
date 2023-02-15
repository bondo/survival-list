import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:survival_list/src/api/client.dart';
import 'package:survival_list/src/survival/survival_item.dart';

class SurvivalItemCreateForm extends StatefulWidget {
  const SurvivalItemCreateForm({super.key});

  @override
  State<SurvivalItemCreateForm> createState() => _SurvivalItemCreateFormState();
}

class _SurvivalItemCreateFormState extends State<SurvivalItemCreateForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleInput = TextEditingController();
  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    titleInput.text = "";
    dateInput.text = "";
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
                    controller: titleInput,
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
                  child: Consumer<SurvivalItemListRefetchContainer>(
                      builder: (context, itemsContainer, child) {
                    return ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          var snackBarController =
                              ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                          Client.createTask(titleInput.text)
                              .then((value) => itemsContainer.refetch())
                              .then((value) {
                            snackBarController.close();
                            Navigator.pop(context);
                          }, onError: (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error')),
                            );
                          });
                        }
                      },
                      child: const Text('Submit'),
                    );
                  }))
            ],
          )),
    );
  }
}
