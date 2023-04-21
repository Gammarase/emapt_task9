import 'package:empat_task9/pages/custom_elements.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final TextEditingController nameTextController;

  @override
  void initState() {
    nameTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            const Text(
              'Реєстрація',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            TextField(
              maxLines: 1,
              controller: nameTextController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                fillColor: Colors.grey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: "Введіть ім'я",
              ),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            InkWell(
              onTap: () => Navigator.of(context).pop(nameTextController.text),
              child: const CustomButton(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Зареєcтруватися',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          ]
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: e,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
