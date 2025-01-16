import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:doctor_app_webarts/screens/homeScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'fakeData.dart';
import 'models/appointment_model.dart';
import 'providers/task2Provider.dart';
import 'screens/taskScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AppointmentModelAdapter());
  await Hive.openBox<AppointmentModel>('appointments');
  loadAppointmentsFromStorage(); // Load appointments from local storage

  runApp(
    DevicePreview(
      enabled:
          false, //!kReleaseMode,   //enable krelease to see multi mobile preview
      tools: const [
        ...DevicePreview.defaultTools,
      ],
      builder: (context) => const MyApp(),
    ),
  );
}

void loadAppointmentsFromStorage() async {
  final box = Hive.box<AppointmentModel>('appointments');
  final savedAppointments = box.values.toList();

  for (var doctor in doctorData) {
    debugPrint(
        "The values saved is --->>>>>>>>>>>> ${savedAppointments.any((appointment) => appointment.doctorName == doctor.doctorName)}");
    // Check if the doctor has a saved appointment
    doctor.hasAppointment = savedAppointments
        .any((appointment) => appointment.doctorName == doctor.doctorName);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Make the app full screen using this
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return MultiProvider(
      providers: [
        //Provider to handle the api data dynamic
        ChangeNotifierProvider<ProductProvider>(
            create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:
            TaskScreen(), //here we have two task so this is the gateway of two different task
      ),
    );
  }
}
