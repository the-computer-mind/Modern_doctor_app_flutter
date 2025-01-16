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
    // Make the app full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductProvider>(
            create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        // title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:
            TaskScreen(), //here we have two task so this is the gateway of two different task
      ),
    );
  }
}
