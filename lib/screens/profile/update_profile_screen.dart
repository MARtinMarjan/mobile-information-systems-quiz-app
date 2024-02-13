import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/viewmodels/user.viewmodel.dart';

import '../../widgets/ui/rounded_button.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  Uint8List? _image;
  String previousImage = "";
  String previousUsername = "";
  final TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    previousImage = userViewModel.userData?.imageLink ?? '';
    previousUsername = userViewModel.userData?.username ?? '';
    if (previousUsername.isNotEmpty) {
      usernameController.text = previousUsername;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      Uint8List img = await file.readAsBytes();
      setState(() {
        _image = img;
      });
    } else {
      print("No Images Selected");
    }
  }

  void saveProfile() async {
    String username = usernameController.text;
    UserViewModel userViewModel =
        Provider.of<UserViewModel>(context, listen: false);
    if (_image == null) {
      Get.snackbar("Error", "Please select an image");
      return;
    }
    if (username.isEmpty) {
      Get.snackbar("Error", "Please enter a username");
      return;
    }
    userViewModel.saveProfile(username, _image!).then((value) {
      Get.back();
    });
  }

  @override
  Widget build(BuildContext context) {
    var zolta = Colors.yellow;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 50.0),
        child: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left),
          ),
          title: Text(
            "Edit Profile",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : SizedBox(
                          width: 150,
                          height: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: previousImage != ""
                                ? Image(
                                    image: NetworkImage(previousImage),
                                    fit: BoxFit.cover,
                                  )
                                : const Image(
                                    image: AssetImage(
                                        "assets/level_map/BoyGraduation.png")),
                          ),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.circle,
                      ),
                      child: PopupMenuButton<ImageSource>(
                        offset: const Offset(0, 40),
                        onSelected: pickImage,
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: ImageSource.camera,
                            child: Text('Choose from Camera'),
                          ),
                          const PopupMenuItem(
                            value: ImageSource.gallery,
                            child: Text('Choose from Gallery'),
                          ),
                        ],
                        child: IconButton(
                          icon: const Icon(Icons.add_a_photo),
                          color: Theme.of(context).primaryColor,
                          onPressed: null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        hintText: 'Change your username',
                      ),
                    ),
                    const SizedBox(height: 50),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: zolta,
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
