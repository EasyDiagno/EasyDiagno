import 'package:easydiagno/Constants/constants.dart';
import 'package:easydiagno/Models/HospitalModel/getSpecialisation.dart';
import 'package:easydiagno/Models/HospitalModel/hospitalReg1Model.dart';
import 'package:easydiagno/Services/hospital%20Module/addDoctorApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class DoctorSection2 extends StatefulWidget {
  final List<Specialisation> specialization;

  const DoctorSection2({
    Key? key,
    required this.specialization,
  }) : super(key: key);

  @override
  State<DoctorSection2> createState() => _DoctorSectionState();
}

class _DoctorSectionState extends State<DoctorSection2> {
  Map<String, TextEditingController> doctorControllers =
      {}; // Use this map in the state

  @override
  Widget build(BuildContext context) {
    final item = widget.specialization;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          for (Specialisation specialization in item)          
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  DocSubSectionGroup(
                    selected: specialization,
                    controller: doctorControllers.putIfAbsent(
                      specialization.specialisation,
                      () => TextEditingController(),
                    ),
                  ),
                  if (item.indexOf(specialization) < item.length - 1) h10,
                ],
              ),
            ),
          h15,
          ElevatedButton(onPressed: () async{
            print(widget.specialization);
            print(allAddedDoctors);
            await addDoctorApi(allAddedDoctors, widget.specialization);
          }, child: Text("Submit"))
        ],
      ),
    );
  }
}

class DocSubSectionGroup extends StatefulWidget {
  final Specialisation selected;
  final TextEditingController controller;

  const DocSubSectionGroup({
    Key? key,
    required this.selected,
    required this.controller,
  }) : super(key: key);

  @override
  _DocSubSectionGroupState createState() => _DocSubSectionGroupState();
}

class _DocSubSectionGroupState extends State<DocSubSectionGroup> {
  List<DoctorDetails> doctorDetailsList = [DoctorDetails(title: '')];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black38)),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.selected.specialisation,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black38,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      doctorDetailsList.add(DoctorDetails(title: widget.selected.specialisation));
                    });
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
            for (var docDetails in doctorDetailsList)
              DocSubSection(doctorDetails: docDetails),
          ],
        ),
      ),
    );
  }
}

class DocSubSection extends StatefulWidget {
  final DoctorDetails doctorDetails;

  DocSubSection({Key? key, required this.doctorDetails}) : super(key: key);

  @override
  State<DocSubSection> createState() => _DocSubSectionState();
}

class _DocSubSectionState extends State<DocSubSection> {
  final doctornameController = TextEditingController();
  final qualificationController = TextEditingController();

  Doctors d1 = Doctors(
      specialisation: '',
      hospitalId: '',
      doctorName: '',
      qualification: '',
      availableDays: []);
  ValueNotifier isAdded = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isAdded,
      builder: (BuildContext context, value, Widget? child) {
        return isAdded.value
            ? func(d1)!
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      cursorColor: Colors.amber,
                      decoration: InputDecoration(
                        hintText: 'Doctor Name',
                      ),
                      controller: qualificationController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Qualification'),
                      controller: doctornameController,
                    ),
                    h5,
                    Text(
                      "Add available day",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.red),
                    ),
                    h5,
                    buildDayDropdown(),
                    h10,
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          d1 = await Doctors(
                              specialisation: '1',
                              hospitalId: '1',
                              doctorName: doctornameController.text,
                              qualification: qualificationController.text,
                              availableDays: widget.doctorDetails.selectedDays);
                          allAddedDoctors.add(d1);
                          //await addToList(d1);
                          print("Doctors :$allAddedDoctors");
                          isAdded.value = true;
                          func(d1);
                        },
                        child: Text("Add"),
                      ),
                    ),
                    Divider(thickness: 5, color: Colors.amberAccent),
                  ],
                ),
              );
      },
    );
  }

  Widget buildDayDropdown() {
    final List<String> daysOfWeek = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];

    return FormBuilderCheckboxGroup(
      name: 'days',
      options:
          daysOfWeek.map((day) => FormBuilderFieldOption(value: day)).toList(),
      onChanged: (value) {
        widget.doctorDetails.selectedDays =
            List<String>.from(value!.map((dynamic item) => item.toString()));
        // final selectedDays = widget.doctorDetails.selectedDays = List<String>.from(value!.map((dynamic item) => item.toString()));
      },
    );
  }

  bool addToList(Doctors d) {
    //print(d.isEdited);
    bool isFound = false;
    for (var i = 0; i < allAddedDoctors.length; i++) {
      Doctors doctor = allAddedDoctors[i];
      if (doctor.id == d.id) {
        isFound = true;
        break;
      }
    }
    if (!isFound) {
      allAddedDoctors.add(d);
    }
    return true;
  }

  Widget? func(Doctors submitted) {
    //isAdded.value = true;
    return Container(
      child: Column(
        children: [
          Text(submitted.doctorName),
          Text(submitted.qualification),
          Text(submitted.availableDays.toString()),
          IconButton(
              onPressed: () {
                isAdded.value = false;
                for (var i = 0; i < allAddedDoctors.length; i++) {
                  Doctors doctor = allAddedDoctors[i];
                  if (doctor.id == submitted.id) {
                    allAddedDoctors.remove(doctor);
                  }
                }
              },
              icon: Icon(Icons.edit)),
        ],
      ),
    );
  }
}

class DoctorDetails {
  final String title;
  String doctorName = '';
  String qualification = '';
  List<String> selectedDays = [];

  DoctorDetails({required this.title});
}

List<Doctors> allAddedDoctors = [];
