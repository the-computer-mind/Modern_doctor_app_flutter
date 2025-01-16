// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentModelAdapter extends TypeAdapter<AppointmentModel> {
  @override
  final int typeId = 1;

  @override
  AppointmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppointmentModel(
      doctorName: fields[0] as String,
      specialty: fields[1] as String,
      appointmentDate: fields[2] as DateTime,
      timeSlot: fields[3] as String,
      location: fields[4] as String,
      rating: fields[5] as double,
      profileImage: fields[6] as String,
      hasAppointment: fields[7] as bool,
      experience: fields[8] as String,
      patientCount: fields[9] as int,
      reviewCount: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AppointmentModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.doctorName)
      ..writeByte(1)
      ..write(obj.specialty)
      ..writeByte(2)
      ..write(obj.appointmentDate)
      ..writeByte(3)
      ..write(obj.timeSlot)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.profileImage)
      ..writeByte(7)
      ..write(obj.hasAppointment)
      ..writeByte(8)
      ..write(obj.experience)
      ..writeByte(9)
      ..write(obj.patientCount)
      ..writeByte(10)
      ..write(obj.reviewCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
