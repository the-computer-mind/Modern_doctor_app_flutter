import 'package:doctor_app_webarts/utils/hextoColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import '../fakeData.dart';
import '../models/appointment_model.dart';

class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  late Box<AppointmentModel> appointmentBox;

  @override
  void initState() {
    super.initState();
    appointmentBox = Hive.box<AppointmentModel>('appointments');
  }

  Future<void> _showCancelDialog(
      int indexx, AppointmentModel appointmentModel) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Appointment"),
        content:
            const Text("Are you sure you want to cancel this appointment?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    if (result == true) {
      // Update hasAppointment in doctorData
      final index = doctorData.indexWhere(
          (doctor) => doctor.doctorName == appointmentModel.doctorName);
      if (index != -1) {
        setState(() {
          doctorData[index].hasAppointment = false;

          appointmentBox.deleteAt(indexx);
        });

        // Remove appointment from Hive
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointmentBox = Hive.box<AppointmentModel>('appointments');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointments',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: appointmentBox.listenable(),
        builder: (context, Box<AppointmentModel> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Text('No Appointments Found'),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: box.length,
            itemBuilder: (context, index) {
              final appointment = box.getAt(index);

              return Column(
                children: [
                  InkWell(
                    child: AppointmentCard(
                      doctorName: appointment!.doctorName,
                      timeSlot: appointment.timeSlot,
                      date: appointment.appointmentDate,
                      speciality: appointment.specialty,
                      onCancel: () {
                        _showCancelDialog(index, appointment);
                      },
                      onConfirm: () {},
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentDetailScreen(
                              appointment: appointment!),
                        ),
                      );
                    },
                  ),
                  index == box.length - 1
                      ? SizedBox(
                          height: 100,
                        )
                      : SizedBox()
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String doctorName;
  final DateTime date;
  final String timeSlot;
  final String speciality;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const AppointmentCard({
    Key? key,
    required this.doctorName,
    required this.date,
    required this.timeSlot,
    required this.onCancel,
    required this.onConfirm,
    required this.speciality,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: hexToColor("#b591fe").withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$doctorName",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, color: hexToColor("#b591fe")),
              const SizedBox(width: 8),
              Text(
                "${date.day}-${date.month}-${date.year}",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, color: hexToColor("#b591fe")),
              const SizedBox(width: 8),
              Text(
                timeSlot,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Symbols.medical_services, color: hexToColor("#b591fe")),
              const SizedBox(width: 8),
              Text(
                speciality,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: onCancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: hexToColor("#b591fe"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("Confirm", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppointmentDetailScreen extends StatelessWidget {
  final AppointmentModel appointment;

  AppointmentDetailScreen({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doctor Name: ${appointment.doctorName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Specialty: ${appointment.specialty}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Appointment Date: ${appointment.appointmentDate.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Time Slot: ${appointment.timeSlot}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
