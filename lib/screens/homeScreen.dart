import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../customLibraries/dotNavBar/src/DotNavigationBarItem.dart';
import '../customLibraries/dotNavBar/src/NavBars.dart';
import '../fakeData.dart';
import '../models/appointment_model.dart';
import '../utils/hextoColor.dart';
import 'appointmentBooking.dart';
import 'chatScreen.dart';
import 'showAppoitments.dart';
import 'taskScreen.dart';
import 'topDoctors.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    HomeScreen(),
    AppointmentsScreen(),
    HomeScreen(),
  ];

  void _handleIndexChanged(int i) {
    setState(() {
      _currentIndex = i;
    });
  }

  //lets create the search functionality
  List<AppointmentModel> filteredDoctors = [];
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    filteredDoctors = doctorData; // Initialize with all doctors
  }

  void _filterDoctors(String query) {
    final List<AppointmentModel> results = doctorData
        .where((doctor) =>
            doctor.specialty.toLowerCase().contains(query.toLowerCase()) ||
            doctor.location.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredDoctors = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //used to remove default back arrow still giving back option
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TaskScreen()),
        ); // Goes back to the previous screen
        return Future.value(false); // Prevents the default back action
      },
      child: Scaffold(
          extendBody: false,
          backgroundColor: Colors.white,

          //drawer: ,
          // appBar: AppBar(
          //   automaticallyImplyLeading: false,
          // ), // Disables the default back button
          body: _currentIndex == 0
              ? CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: MediaQuery.of(context).size.height <
                              740 //app responsibness
                          ? MediaQuery.of(context).size.height * 0.5
                          : MediaQuery.of(context).size.height * 0.4,
                      // pinned: true,
                      floating: true,

                      // shape: BeveledRectangleBorder(
                      //     borderRadius: BorderRadius.circular(10)),
                      flexibleSpace: FlexibleSpaceBar(
                        // title: Text(
                        //   "Let's find your top doctor!",
                        //   style: TextStyle(color: Colors.white, fontSize: 16),
                        // ),
                        background: Container(
                          // margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF6A5AE0),
                                Color(0xFF968CEB),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Symbols.sort,
                                      color: Colors.white,
                                    ),
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage: AssetImage(
                                          'assets/images/doctor1.png'), // Replace with your profile image
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Welcome Back',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Let's find",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 34,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "your top doctor!",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 34,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 30),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (value) => _filterDoctors(value),
                                    decoration: InputDecoration(
                                      suffixIcon:
                                          _searchController.text.isNotEmpty
                                              ? IconButton(
                                                  icon: Icon(Icons.clear,
                                                      color: Colors.grey),
                                                  onPressed: () {
                                                    _searchController.clear();
                                                    _filterDoctors(
                                                        ""); // Reset the filtered list
                                                    setState(
                                                        () {}); // Rebuild to hide the clear button
                                                  },
                                                )
                                              : null,
                                      hintText: 'Search health issue...',
                                      prefixIcon: Icon(Icons.search,
                                          color: Colors.grey),
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                _searchController.text.isNotEmpty
                                    ? SizedBox()
                                    : const Text(
                                        "Categories",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                _searchController.text.isNotEmpty
                                    ? SizedBox()
                                    : SizedBox(height: 5),
                                // Categories Section
                                _searchController.text.isNotEmpty
                                    ? SizedBox()
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            CategoryItem(
                                                icon: Icons.all_inbox,
                                                label: 'All'),
                                            CategoryItem(
                                                icon: Icons.favorite,
                                                label: 'Cardiology'),
                                            CategoryItem(
                                                icon: Icons.medical_services,
                                                label: 'Medicine'),
                                            CategoryItem(
                                                icon: Icons.local_hospital,
                                                label: 'General'),
                                          ],
                                        ),
                                      ),
                                _searchController.text.isNotEmpty
                                    ? SizedBox()
                                    : SizedBox(height: 20),

                                // Doctor Cards
                                filteredDoctors.isEmpty
                                    ? const Center(
                                        child:
                                            Text("No matching doctors found"))
                                    : Column(
                                        children: filteredDoctors.map((doctor) {
                                          return DoctorCard(
                                            name: doctor.doctorName,
                                            specialty:
                                                '${doctor.specialty}, ${doctor.location}',
                                            rating: doctor.rating,
                                            index: doctorData.indexOf(doctor),
                                            image: doctor.profileImage,
                                          );
                                        }).toList(),
                                      ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : _currentIndex == 1
                  ? AppointmentsScreen()
                  : _currentIndex == 2
                      ? ChatWIthDoctor()
                      : TopDoctorsScreen(),
          floatingActionButton: DotNavigationBar(
            //our custom modified library
            backgroundColor: Colors.white,
            boxShadow: [
              BoxShadow(
                color: hexToColor("#b28cff"),
                blurRadius: 2,
                spreadRadius: 1,
                offset: Offset(0, 3),
              ),
            ],
            marginR: const EdgeInsets.only(bottom: 0, right: 0, left: 25),
            paddingR: const EdgeInsets.only(bottom: 1, top: 0),
            itemPadding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            currentIndex: _currentIndex,
            dotIndicatorColor: hexToColor("#b28cff"),
            unselectedItemColor: Colors.grey[300],
            splashBorderRadius: 10,
            borderRadius: 15,
            enableFloatingNavBar: true,
            onTap: _handleIndexChanged,
            items: [
              /// Home
              DotNavigationBarItem(
                icon: Icon(
                  Symbols.home,
                  fill: 1,
                ),
                selectedColor: hexToColor("#b28cff"),
              ),

              /// Likes
              DotNavigationBarItem(
                icon: Icon(Symbols.calendar_add_on),
                selectedColor: hexToColor("#b28cff"),
              ),

              /// Search
              DotNavigationBarItem(
                icon: Icon(Symbols.message),
                selectedColor: hexToColor("#b28cff"),
              ),

              /// Profile
              DotNavigationBarItem(
                icon: Icon(Symbols.add),
                selectedColor: hexToColor("#b28cff"),
              ),
            ],
          )),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  CategoryItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 90,
          height: 80,
          margin: EdgeInsets.only(right: 15),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black12,
            //     blurRadius: 6,
            //     offset: Offset(0, 3),
            //   ),
            // ],
            border: Border.all(
                width: 2, color: hexToColor("#dfe1eb").withOpacity(0.7)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.purple, size: 30),
            ],
          ),
        ),
        SizedBox(height: 5),
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final double rating;
  final int index;
  final String image;

  DoctorCard({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.index,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AppointmentBookingPage(
                      appointmentModel: doctorData[index],
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black12,
          //     blurRadius: 6,
          //     offset: Offset(0, 3),
          //   ),
          // ],
          border: Border.all(
              width: 2, color: hexToColor("#dfe1eb").withOpacity(0.7)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? hexToColor("#dfe1eb")
                            : hexToColor(
                                "#b28cff"), // Background color for the avatar,
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    SizedBox(width: 5),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    specialty,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    //   softWrap: false, // Prevent wrapping
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                doctorData[index].hasAppointment
                    ? Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          // border: Border.all(width: 1, color: Colors.grey),
                          color: hexToColor(
                              "#e8e9f0"), // Background color for the avatar
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Appointment",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          // border: Border.all(width: 1, color: Colors.grey),
                          color: hexToColor(
                              "#e8e9f0"), // Background color for the avatar
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Appointment",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.4),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
