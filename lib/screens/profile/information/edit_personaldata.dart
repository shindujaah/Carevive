import 'package:carevive/common%20widgets/new_roundtextfield.dart';
import 'package:carevive/common%20widgets/round_gradient_button.dart';
import 'package:carevive/common%20widgets/round_textfield.dart';
import 'package:carevive/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditPersonalData extends StatefulWidget {
  static String routeName = "/EditPersonalData";

  const EditPersonalData({Key? key}) : super(key: key);

  @override
  State<EditPersonalData> createState() => _EditPersonalDataState();
}

class _EditPersonalDataState extends State<EditPersonalData> {
  bool isCheck = false;

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  String? _selectedGender;
  String? _selectedBlood;
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _caretakerNameController =
      TextEditingController();
  final TextEditingController _caretakerAgeController = TextEditingController();
  final TextEditingController _caretakerRelationshipController =
      TextEditingController();
  final TextEditingController _caretakerContactController =
      TextEditingController();
  final TextEditingController _caretakerAddressController =
      TextEditingController();
  final TextEditingController _medicalHistoryController =
      TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();

  String _selectedStage = "None";
  String _selectedStageType = "None";
  int cyclesDone = 0;
  int cyclesRemaining = 0;
  int timeOfIllness = 0;

  CollectionReference _users = FirebaseFirestore.instance.collection("users");

  DateTime? _selectedDate;
  bool buttonClicked = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> getUserData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userSnapshot = await _users.doc(userId).get();

    Map<String, dynamic>? userData =
        userSnapshot.data() as Map<String, dynamic>?;

    if (userData != null) {
      setState(() {
        _firstnameController.text = userData['firstName'] ?? '';
        _lastnameController.text = userData['lastName'] ?? '';
        _idNumberController.text = userData['ID Number'] ?? '';
        _ageController.text = userData['age'] ?? '';
        _numberController.text = userData['number'] ?? '';
        _dateOfBirthController.text = userData['dateOfBirth'] ?? '';
        _caretakerNameController.text = userData['caretakerName'] ?? '';
        _caretakerAgeController.text =
            userData['caretakerAge'].toString() ?? "0";
        _caretakerRelationshipController.text =
            userData['caretakerRelationship'] ?? '';
        _caretakerContactController.text = userData['caretakerContact'] ?? '';
        _caretakerAddressController.text = userData['caretakerAddress'] ?? '';
        _weightController.text = userData['weight'] ?? '';
        _heightController.text = userData['height'] ?? '';
        _medicalHistoryController.text = userData['medicalHistory'] ?? '';
        _allergiesController.text = userData['allergies'] ?? '';
        _selectedGender = userData['gender'];
        _selectedBlood = userData['blood'];
        _selectedStage = userData['cancerStage'] ?? "None";
        _selectedStageType = userData['cancerType'] ?? "None";
        cyclesDone = userData['cyclesDone'];
        cyclesRemaining = userData['cyclesRemaining'];
        timeOfIllness = userData['timeOfIllness'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> updateUserProfile() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      await _users.doc(userId).update({
        'firstName': _firstnameController.text,
        'lastName': _lastnameController.text,
        'ID Number': _idNumberController.text,
        'number': _numberController.text,
        'blood': _selectedBlood,
        'age': _ageController.text,
        'gender': _selectedGender,
        'dateOfBirth': _dateOfBirthController.text,
        'weight': _weightController.text,
        'height': _heightController.text,
        'caretakerName': _caretakerNameController.text,
        'caretakerAge': int.parse(_caretakerAgeController.text),
        'caretakerRelationship': _caretakerRelationshipController.text,
        'caretakerContact': _caretakerContactController.text,
        'caretakerAddress': _caretakerAddressController.text,
        'medicalHistory': _medicalHistoryController.text,
        'allergies': _allergiesController.text,
        'cancerStage': _selectedStage,
        'cancerType': _selectedStageType,
        'cyclesDone': cyclesDone,
        'cyclesRemaining': cyclesRemaining,
        'timeOfIllness': timeOfIllness,
      });
    } catch (error) {
      Fluttertoast.showToast(msg: "Somethin Went Wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: Text(
          "Update Your Profile",
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Personal Information",
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  NewRoundTextField(
                    textEditingController: _firstnameController,
                    hintText: "First Name",
                    textInputType: TextInputType.name,
                    // onChanged: (value) {
                    //   _formKey.currentState!.validate();
                    // },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  NewRoundTextField(
                    textEditingController: _lastnameController,
                    hintText: "Last Name",
                    textInputType: TextInputType.name,
                    // onChanged: (value) {
                    //   _formKey.currentState!.validate();
                    // },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: media.height * 0.02,
                  ),

                  NewRoundTextField(
                    textEditingController: _idNumberController,
                    hintText: "Identification Card Number",
                    textInputType: TextInputType.name,
                    // onChanged: (value) {
                    //   _formKey.currentState!.validate();
                    // },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your ID Number';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  NewRoundTextField(
                    textEditingController: _numberController,
                    hintText: "Phone Number",
                    textInputType: TextInputType.number,
                    // onChanged: (value) {
                    //   _formKey.currentState!.validate();
                    // },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Phone Number';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightGrayColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Image.asset(
                                "assets/icons/gender_icon.png",
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                                color: AppColors.grayColor,
                              ),
                            ),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Text("Choose Gender",
                                      style: const TextStyle(
                                          color: AppColors.grayColor,
                                          fontSize: 12)),
                                  value: _selectedGender,
                                  isDense: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedGender = newValue;
                                    });
                                  },
                                  items: ["Male", "Female"].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          color: AppColors.grayColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                        if (buttonClicked &&
                            (_selectedGender == null ||
                                _selectedGender!.isEmpty))
                          Column(
                            children: [
                              Divider(
                                color: Color(0xFFB01B13),
                                height: 3,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 15, top: 4),
                                  child: Text(
                                    'Please choose a gender',
                                    style: TextStyle(
                                      color: Color(0xFFB01B13),
                                      fontSize: 12.2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  // Gender Dropdown
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightGrayColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Image.asset(
                                "assets/icons/blood_icon.png",
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                                color: AppColors.grayColor,
                              ),
                            ),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Text("Choose Blood Type",
                                      style: const TextStyle(
                                          color: AppColors.grayColor,
                                          fontSize: 12)),
                                  value: _selectedBlood,
                                  isDense: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedBlood = newValue;
                                    });
                                  },
                                  items: [
                                    "O+",
                                    "O-",
                                    "A+",
                                    "A-",
                                    "B+",
                                    "B-",
                                    "AB+",
                                    "AB-",
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          color: AppColors.grayColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                        if (buttonClicked &&
                            (_selectedBlood == null || _selectedBlood!.isEmpty))
                          Column(
                            children: [
                              Divider(
                                color: Color(0xFFB01B13),
                                height: 3,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 15, top: 4),
                                  child: Text(
                                    'Please choose Blood Type',
                                    style: TextStyle(
                                      color: Color(0xFFB01B13),
                                      fontSize: 12.2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  // Date of Birth
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: NewRoundTextField(
                        textEditingController: _dateOfBirthController,
                        hintText: "Date of Birth",
                        textInputType: TextInputType.text,
                        // onChanged: (value) {
                        //   _formKey.currentState!.validate();
                        // },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your date of birth';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  SizedBox(height: 15),
                  NewRoundTextField(
                    textEditingController: _weightController,
                    hintText: "Your Weight",
                    textInputType: TextInputType.text,
                    // onChanged: (value) {
                    //   _formKey.currentState!.validate();
                    // },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your weight';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  NewRoundTextField(
                    textEditingController: _heightController,
                    hintText: "Your Height",
                    textInputType: TextInputType.text,
                    // onChanged: (value) {
                    //   _formKey.currentState!.validate();
                    // },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your height';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  NewRoundTextField(
                    textEditingController: _ageController,
                    hintText: "Your Age",
                    textInputType: TextInputType.text,
                    // onChanged: (value) {
                    //   _formKey.currentState!.validate();
                    // },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Age';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: media.height * 0.03,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Caretaker Information",
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),

                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  NewRoundTextField(
                    textEditingController: _caretakerNameController,
                    hintText: "Caretaker Name",
                    textInputType: TextInputType.text,
                    // onChanged: (value) {
                    //   _formKey.currentState!.validate();
                    // },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Caretaker Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  NewRoundTextField(
                    textEditingController: _caretakerAgeController,
                    hintText: "Caretaker Age",
                    textInputType: TextInputType.number,
                    // onChanged: (value) {
                    //   _formKey.currentState!.validate();
                    // },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Caretaker Age';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  NewRoundTextField(
                    textEditingController: _caretakerContactController,
                    hintText: "Caretaker Contact",
                    textInputType: TextInputType.text,
                    // onChanged: (value) {
                    //   _formKey.currentState!.validate();
                    // },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Caretaker Contact';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.lightGrayColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextFormField(
                      maxLines: 2,
                      controller: _caretakerAddressController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: "Caretaker Address",
                          hintStyle: TextStyle(
                              fontSize: 12, color: AppColors.grayColor)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Caretaker Address';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: media.height * 0.03,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Other Information",
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.lightGrayColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextFormField(
                      maxLines: 2,
                      controller: _medicalHistoryController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: "Medical History",
                          hintStyle: TextStyle(
                              fontSize: 12, color: AppColors.grayColor)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Medical History';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.lightGrayColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextFormField(
                      maxLines: 2,
                      controller: _allergiesController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: "Allergies",
                          hintStyle: TextStyle(
                              fontSize: 12, color: AppColors.grayColor)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Allergies';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  // Gender Dropdown

                  Container(
                    height: 55,
                    padding: EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrayColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Text("Choose Cancer Stage",
                                      style: const TextStyle(
                                          color: AppColors.grayColor,
                                          fontSize: 12)),
                                  value: _selectedStage,
                                  isDense: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedStage = newValue!;
                                    });
                                  },
                                  items: [
                                    "None",
                                    "0",
                                    "I",
                                    "II",
                                    "III",
                                    "IV",
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          color: AppColors.grayColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                        if (buttonClicked &&
                            (_selectedStage == null || _selectedStage!.isEmpty))
                          Column(
                            children: [
                              Divider(
                                color: Color(0xFFB01B13),
                                height: 3,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 15, top: 4),
                                  child: Text(
                                    'Choose Cancer Stage',
                                    style: TextStyle(
                                      color: Color(0xFFB01B13),
                                      fontSize: 12.2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  // Gender Dropdown
                  Container(
                    height: 55,
                    padding: EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrayColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Text("Choose Cancer Type",
                                      style: const TextStyle(
                                          color: AppColors.grayColor,
                                          fontSize: 12)),
                                  value: _selectedStageType,
                                  isDense: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedStageType = newValue!;
                                    });
                                  },
                                  items: [
                                    "None",
                                    "Bladder Cancer",
                                    "Breast Cancer",
                                    "Colorectal Cancer",
                                    "Kidney Cancer",
                                    "Lung Cancer",
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          color: AppColors.grayColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                        if (buttonClicked &&
                            (_selectedStageType == null ||
                                _selectedStageType!.isEmpty))
                          Column(
                            children: [
                              Divider(
                                color: Color(0xFFB01B13),
                                height: 3,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 15, top: 4),
                                  child: Text(
                                    'Choose Cancer Type',
                                    style: TextStyle(
                                      color: Color(0xFFB01B13),
                                      fontSize: 12.2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: media.height * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                    decoration: BoxDecoration(
                        color: AppColors.lightGrayColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Cycles Done",
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (cyclesDone > 0) cyclesDone--;
                                });
                              },
                            ),
                            Text(cyclesDone.toString()),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  cyclesDone++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.height * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                    decoration: BoxDecoration(
                        color: AppColors.lightGrayColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Cycles Remaining",
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (cyclesRemaining > 0) cyclesRemaining--;
                                });
                              },
                            ),
                            Text(cyclesRemaining.toString()),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  cyclesRemaining++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.height * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                    decoration: BoxDecoration(
                        color: AppColors.lightGrayColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Time of Illness (years)",
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (timeOfIllness > 0) timeOfIllness--;
                                });
                              },
                            ),
                            Text(timeOfIllness.toString()),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  timeOfIllness++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.height * 0.05),
                  RoundGradientButton(
                    title: "Update Profile",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        updateUserProfile();
                        Navigator.pop(context);
                      }
                    },
                  ),
                  SizedBox(
                    height: media.height * 0.015,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
