import 'package:crud_firebase/Services/firebase_service.dart';
import 'package:flutter/material.dart';

class EditNamePage extends StatefulWidget {
  const EditNamePage({super.key});

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  TextEditingController editController = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    editController.text = arguments['name'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Name'),
        elevation: 5,
        shadowColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: editController,
              decoration:
                  const InputDecoration(hintText: "Ingrese la modificación"),
            ),
            ElevatedButton(
                onPressed: () async {
                  // print(arguments['uid']);
                  await updatePeople(arguments['uid'], editController.text)
                      .then(
                    (value) {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                  );
                },
                child: const Text("Actualizar"))
          ],
        ),
      ),
    );
  }
}
