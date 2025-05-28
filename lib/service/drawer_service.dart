import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pet_remainder_app/models/pet.dart';
import 'package:pet_remainder_app/ui/control_medico/control_medico_page.dart';
import 'package:pet_remainder_app/ui/treatment/treatment_page.dart';
import 'package:pet_remainder_app/ui/pet_profile_page.dart';
import 'package:pet_remainder_app/ui/remainder/reminder_page.dart';

import '../ui/util/drawer_item.dart';

class DrawerService {
  Future<List<DrawerItem>> fetchDrawerItems(BuildContext context, bool isDarkMode, Function toggleTheme) async {
    return await Future.delayed(Duration(seconds: 1), () {
      return [
        DrawerItem(
          icon: Icons.pets,
          title: 'Perfil de mascota',
          action: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PetProfilePage(
                pet: Pet(
                  id: 2,
                  nombre: 'Misu',
                  especie: 'Gato',
                  raza: 'Siames',
                  fechaNacimiento: DateTime(2021, 5, 18),
                ),
              ),
            ),
          ),
        ),
        DrawerItem(
          icon: Icons.alarm,
          title: 'Recordatorios',
          action: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReminderPage()),
          ),
        ),
        DrawerItem(
          icon: Icons.medical_services,
          title: 'Tratamientos',
          action: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TratamientoPage()),
          ),
        ),
        DrawerItem(
          icon: Icons.event_note,
          title: 'Eventos Médicos',
          action: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ControlMedicoPage(idMascota: 2)),
          ),
        ),
        DrawerItem(
          icon: Icons.brightness_6,
          title: isDarkMode ? 'Modo Claro' : 'Modo Oscuro',
          action: () => toggleTheme(),
        ),
        DrawerItem(
          icon: Icons.logout,
          title: 'Cerrar sesión',
          action: () => Navigator.pop(context),
        ),
      ];
    });
  }
}
