import 'package:doctor_app_webarts/utils/hextoColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../fakeData.dart';
import '../models/appointment_model.dart';
import 'homeScreen.dart';

class AppointmentBookingPage extends StatefulWidget {
  final AppointmentModel appointmentModel;

  const AppointmentBookingPage({super.key, required this.appointmentModel});
  @override
  _AppointmentBookingPageState createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  String selectedTime = "11:00 AM";
  final List<String> dates = ["7", "8", "9", "10", "11"];
  final List<String> timeSlots = [
    "11:00 AM",
    "12:00 AM",
    "03:00 PM",
    "04:00 PM"
  ];
  DateTime _selectedMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  List<DateTime> _datesInMonth = [];

  @override
  void initState() {
    super.initState();
    _generateDatesForMonth(_selectedMonth);
  }

//Genrating only remainibg days of a month from today to last day of month
  void _generateDatesForMonth(DateTime month) {
    DateTime today = DateTime.now();
    int startDay = (today.year == month.year && today.month == month.month)
        ? today.day
        : 1;

    _datesInMonth = List.generate(
      DateTime(month.year, month.month + 1, 0).day - startDay + 1,
      (index) => DateTime(month.year, month.month, startDay + index),
    );
  }

//showing a calender to pick the month
  Future<void> _showMonthPicker() async {
    DateTime now = DateTime.now();
    DateTime initialDate =
        DateTime(_selectedMonth.year, _selectedMonth.month, 1);

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year, now.month),
      lastDate: DateTime(now.year + 1),
      selectableDayPredicate: (date) =>
          date.day == 1, // Allow only the first day
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(), // Customize the theme if needed
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedMonth) {
      setState(() {
        _selectedMonth = picked;
        _generateDatesForMonth(_selectedMonth);
        _selectedDate = _datesInMonth.first; // Reset selection
      });
    }
  }

  String selectedTimeSlot = "";

  bool isTimeslotValid(String selectedTime, DateTime selectedDate) {
    final now = DateTime.now();

    // Adjust the formatter to match the "hh:mm a" format
    final timeFormatter = DateFormat("hh:mm a"); // Example: "11:00 AM"
    final selectedTimeParsed = timeFormatter.parse(selectedTime);

    // Combine the selected date and parsed time into a DateTime object
    final selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTimeParsed.hour,
      selectedTimeParsed.minute,
    );
    debugPrint(
        "here is the datetime >>>>>>>>>>>>>>>>> ${selectedDateTime}  and now is >${DateTime.now()}");
    // Check if the selected date and time are in the future
    return selectedDateTime.isAfter(now);
  }

  void saveAppointment() async {
    DateTime now = DateTime.now();
    print(now.day);

    if (_selectedDate.isBefore(now) && now.day != _selectedDate.day) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Invalid Selection"),
          content: Text("Please select a future date and time."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }
    print("the selectedtimeslot is ${selectedTime}");

    if (selectedTime.isEmpty || !isTimeslotValid(selectedTime, _selectedDate)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Time Slot Wrong"),
          content: Text("Please select a valid time slot."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }
    if (widget.appointmentModel.hasAppointment) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Already Appointed"),
          content: Text(
              "You Already have a Appointment With - ${widget.appointmentModel.doctorName}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Update hasAppointment in doctorData
    final index = doctorData.indexWhere(
        (doctor) => doctor.doctorName == widget.appointmentModel.doctorName);
    if (index != -1) {
      setState(() {
        doctorData[index].hasAppointment = true;
        doctorData[index].timeSlot = selectedTime;
        doctorData[index].appointmentDate = _selectedDate;
      }); //saving the model in local hive storage
      final box = Hive.box<AppointmentModel>('appointments');
      box.add(doctorData[index]);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text("Appointment saved successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen(), // Replace with your target page
                ),
                (route) => false,
              ); // Removes all the previous routes
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  ///
  ///
  ///

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar Section
        title: Text(
          "Appointment",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) =>
            //         HomeScreen(), // Replace with your target page
            //   ),
            //   (route) => false, // Removes all the previous routes
            // );
          },
        ),
      ),
      backgroundColor: Color(0xFFF8F9FD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),

                SizedBox(height: 20),

                // Profile Section
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Color(0xFFE0E7FF),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage(widget.appointmentModel
                                    .profileImage), // Replace with your image asset
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.appointmentModel.doctorName,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.appointmentModel.specialty,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Info Cards Section
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: hexToColor("#b28cff"),
                    borderRadius: BorderRadius.circular(20),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black12,
                    //     blurRadius: 6,
                    //     offset: Offset(0, 3),
                    //   ),
                    // ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoCard(
                          widget.appointmentModel.patientCount.toString(),
                          "Patients",
                          hexToColor("#b28cff")),
                      _buildInfoCard(widget.appointmentModel.experience,
                          "Exp. Years", hexToColor("#9eeac0")),
                      _buildInfoCard(
                          widget.appointmentModel.reviewCount.toString(),
                          "Reviews",
                          hexToColor("#ff9d9d")),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // About Doctor Section
                Text(
                  "About Doctor",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Dr. Maria Watson is the top most Cardiologist specialist in Nanyang Hospital at London. She is available for private consultation.",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: 20),

                // Schedule Section

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Schedules",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _showMonthPicker();
                      },
                      child: Row(
                        children: [
                          Text(
                            "${DateFormat.MMMM().format(_selectedMonth)}",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Icon(Symbols.arrow_forward_ios,
                              size: 18, color: Colors.black),
                        ],
                      ),
                    ),
                  ],
                ),
                // Display Selected Date

                Container(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _datesInMonth.length,
                    itemBuilder: (context, index) {
                      final date = _datesInMonth[index];
                      final isSelected = date.day == _selectedDate.day;
                      return GestureDetector(
                        onTap: () {
                          debugPrint(
                              "checking of selection >>>>>>> $isSelected >>  $_selectedDate   and the current date $date");
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xFF6C63FF)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${date.day}", // Day of the month
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                DateFormat.E().format(date), // Day of the week
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 20),

                // Visiting Hour Section
                Text(
                  "Visit Hour",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: timeSlots.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTime = timeSlots[index];
                          });
                        },
                        child: Container(
                          width: 100,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: selectedTime == timeSlots[index]
                                ? Color(0xFF6C63FF)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Center(
                            child: Text(
                              timeSlots[index],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: selectedTime == timeSlots[index]
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 20),

                // Book Appointment Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Save appointment to local storage or database
                      saveAppointment();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6C63FF),
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Book Appointment",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String value, String label, Color color) {
    return Container(
      width: 95,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value + "+",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: hexToColor("#afb7d1"),
            ),
          ),
        ],
      ),
    );
  }
}
