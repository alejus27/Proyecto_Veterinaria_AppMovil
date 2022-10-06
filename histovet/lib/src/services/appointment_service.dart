import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment.dart';

import 'package:firebase_database/firebase_database.dart';

// Clase encargada de realizar las operaciones con medicina en la base de datos de Firebase
class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final databaseRef = FirebaseDatabase.instance.ref();

  Appointment appointment = Appointment("", "", "", "", "", 0, "","");

  // Permite obtener una medicina de la base de datos de Firebase
  // Retorna la medicina que se la haya especificado
  Future<Appointment> getAppointment(String id) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('appointment').doc(id).get();
    Appointment appointment = Appointment(
        snapshot["id"],
        snapshot["code"],
        snapshot["ownerName"],
        snapshot["petName"],
        snapshot["email"],
        snapshot["phone"],
        snapshot["reason"],
        snapshot["fecha"]);
    //print(appointment.toString());
    return appointment;
  }

  // Permite obtener todas las medicinas que coincidan con el nombre recibido en Firebase
  // Retorna una lista con las medicinas que haya encontrado
  Future<List<Appointment>> searchAppointment(String name) async {
    List<Appointment> appointments = [];
    try {
      final collection = FirebaseFirestore.instance
          .collection('appointment')
          .where("name", isEqualTo: name);
      collection.snapshots().listen((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data();
          // print("encontró");
          // print(doc.data());
          Appointment newAppointment = Appointment(
              data["id"],
              data["code"],
              data["onerName"],
              data["petName"],
              data["email"],
              data["phone"],
              data["reason"],
              data["fecha"]);
          appointments.add(newAppointment);
        }
      });
      return appointments;
    } catch (e) {
      return appointments;
    }
  }

  CollectionReference appointmentAll =
      FirebaseFirestore.instance.collection("appointment");

  // Permite agregar una medicina a la base de datos de Firebase
  // Retorna true, si se pudo agregar la medicina a la base de datos
  Future<bool> addAppointment(Appointment appointment) async {
    final DocumentReference appointmentDoc =
        _firestore.collection("appointment").doc();

    try {
      await appointmentDoc.set({
        "id": appointmentDoc.id,
        "code": appointment.code,
        "ownerName": appointment.ownerName,
        "petName": appointment.petName,
        "email": appointment.email,
        "phone": appointment.phone,
        "reason": appointment.reason,
        "fecha": appointment.fecha
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Permite actualizar una medicina en la base de datos de Firebase
  // Retorna true, si se pudo actualizar la medicina en la base de datos
  Future<bool> updateAppointment(Appointment appointment) async {
    try {
      await FirebaseFirestore.instance
          .collection("appointment")
          .doc(appointment.id)
          .set({
        "id": appointment.id,
        "code": appointment.code,
        "ownerName": appointment.ownerName,
        "petName": appointment.petName,
        "email": appointment.email,
        "phone": appointment.phone,
        "reason": appointment.reason,
        "fecha": appointment.fecha
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      return false;
    }
  }

  // Permite eliminar una medicina indicada de la base de datos de Firebase
  // Retorna true, si se pudo eliminar la medicina que se especifico de la base de datos
  Future<bool> deleteAppointmentFromFirebase(id) async {
    try {
      await _firestore.collection("appointment").doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Permite obtener todas las medicinas de la base de datos de Firebase
  // Retorna una lista con las medicinas que haya encontrado
  Future<List<Appointment>> getAppointments() async {
    List<Appointment> appointments = [];
    try {
      final collection = FirebaseFirestore.instance.collection('appointment');
      collection.snapshots().listen((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data();
          //print(doc.data());
          Appointment newAppointment = Appointment(
              data["id"],
              data["code"],
              data["onerName"],
              data["petName"],
              data["email"],
              data["phone"],
              data["reason"],
              data["fecha"]);
          appointments.add(newAppointment);
        }
      });
      return appointments;
    } catch (e) {
      return appointments;
    }
  }
}