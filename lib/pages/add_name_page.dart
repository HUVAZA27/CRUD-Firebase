import 'package:crud_firebase/Services/firebase_service.dart';
import 'package:flutter/material.dart';

class AddNamePage extends StatefulWidget {
  const AddNamePage({super.key});

  @override
  State<AddNamePage> createState() => _AddNamePageState();
}

class _AddNamePageState extends State<AddNamePage> {
  TextEditingController nameController = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Name'),
        elevation: 5,
        shadowColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(hintText: "Ingrese el nuevo nombre"),
            ),
            ElevatedButton(
                onPressed: () async {
                  await addPeople(nameController.text).then((_) {
                    setState(() {
                      Navigator.pop(context);
                    });
                  });
                  print(nameController.text);
                },
                child: const Text("Guardar"))
          ],
        ),
      ),
    );
  }
}
