import 'package:flutter/material.dart';

class PetProfilePage extends StatefulWidget {
  @override
  State<PetProfilePage> createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _breed = '';
  String _age = '';
  String _weight = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text('Ficha de la Mascota', style: TextStyle(fontSize: 22)),
            TextFormField(
              decoration: InputDecoration(labelText: 'Nombre'),
              onSaved: (val) => _name = val ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Raza'),
              onSaved: (val) => _breed = val ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Edad'),
              onSaved: (val) => _age = val ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Peso'),
              onSaved: (val) => _weight = val ?? '',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _formKey.currentState?.save();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ficha guardada')),
                );
              },
              child: Text('Guardar ficha'),
            )
          ],
        ),
      ),
    );
  }
}
