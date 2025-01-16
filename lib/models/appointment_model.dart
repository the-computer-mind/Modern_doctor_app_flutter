import 'package:hive/hive.dart';

part 'appointment_model.g.dart';

@HiveType(typeId: 1)
class AppointmentModel extends HiveObject {
  @HiveField(0)
  final String doctorName;

  @HiveField(1)
  final String specialty;

  @HiveField(2)
  DateTime appointmentDate;

  @HiveField(3)
  String timeSlot;

  @HiveField(4)
  final String location;

  @HiveField(5)
  final double rating;

  @HiveField(6)
  final String profileImage;

  @HiveField(7)
  bool hasAppointment;

  @HiveField(8)
  final String experience;

  @HiveField(9)
  final int patientCount;

  @HiveField(10)
  final int reviewCount;

  AppointmentModel({
    required this.doctorName,
    required this.specialty,
    required this.appointmentDate,
    required this.timeSlot,
    required this.location,
    required this.rating,
    required this.profileImage,
    required this.hasAppointment,
    required this.experience,
    required this.patientCount,
    required this.reviewCount,
  });
}
