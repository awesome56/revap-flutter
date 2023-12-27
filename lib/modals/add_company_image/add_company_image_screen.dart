import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:revap/models/Company.dart';
import 'package:revap/models/User.dart';
import 'package:revap/components/loadingDialog.dart';
import 'package:revap/components/messageDialog.dart';
import 'package:revap/constants.dart';

class AddCompanyImageScreen extends StatefulWidget {
  final Map<String, dynamic>? formData;
  const AddCompanyImageScreen({Key? key, this.formData}) : super(key: key);

  @override
  State<AddCompanyImageScreen> createState() => _AddCompanyImageScreenState();
}

class _AddCompanyImageScreenState extends State<AddCompanyImageScreen> {
  File? imageFile;
  User user = User();

  // Function to handle the "Next" button click
  void _handleSaveButtonClick() async {
    if (imageFile != null) {
      // Check if an image is selected
      LoadingDialog.show(context);

      // Replace the following line with your actual access token and company ID
      String? accessToken = await user.getAccessToken();

      int companyId;

      if (widget.formData!['id'] is int) {
        companyId = widget.formData!['id'];
      } else {
        companyId = int.tryParse(widget.formData!['id']) ?? 0;
      }

      // Call the addCompanyImage function from the Company model
      Map<String, dynamic> result = await Company().addCompanyImage(
        accessToken!,
        companyId,
        imageFile!,
      );

      // ignore: use_build_context_synchronously
      LoadingDialog.hide(context);

      if (result['success']) {
        // Image uploaded successfully
        // ignore: use_build_context_synchronously
        showCustomDialog(context, "Image uploaded successfully!",
            const Color.fromARGB(206, 0, 0, 0));
      } else if (result['success'] == 401) {
        String? newAccessToken = await user.getRefreshToken();
        if (newAccessToken != null) {
          // Call the addCompanyImage function from the Company model
          Map<String, dynamic> result = await Company().addCompanyImage(
            newAccessToken,
            companyId,
            imageFile!,
          );
          if (result['success']) {
            // Image uploaded successfully
            // ignore: use_build_context_synchronously
            showCustomDialog(context, "Image uploaded successfully!",
                const Color.fromARGB(206, 0, 0, 0));
          } else {
            // ignore: use_build_context_synchronously
            showCustomDialog(
                context,
                result['error'] ?? 'An error occurred. Please try again.',
                const Color.fromARGB(206, 250, 1, 1));
            // Handle the error here, e.g., show an error message
            print(result['error']);
          }
        } else {
          // ignore: use_build_context_synchronously
          showCustomDialog(context, 'An error occurred. Please try again.',
              const Color.fromARGB(206, 250, 1, 1));

          // Handle the error here, e.g., show an error message
        }
      } else {
        // ignore: use_build_context_synchronously
        showCustomDialog(
            context,
            result['error'] ?? 'An error occurred. Please try again.',
            const Color.fromARGB(206, 250, 1, 1));
        // Handle the error here, e.g., show an error message
        print(result['error']);
      }
    } else {
      showCustomDialog(context, "Please select an image to upload.",
          const Color.fromARGB(206, 250, 1, 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: _handleSaveButtonClick,
              child: const Text(
                'Skip',
              ),
            ),
            const Text(
              'Add company image',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: _handleSaveButtonClick,
              child: const Text(
                'Save',
                style: TextStyle(color: kPrimaryColor),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            imageFile == null
                ? Image.asset(
                    'assets/images/company-logo.png',
                    height: 300.0,
                    width: 300.0,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(150.0),
                    child: Image.file(
                      imageFile!,
                      height: 300.0,
                      width: 300.0,
                      fit: BoxFit.fill,
                    )),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () async {
                Map<Permission, PermissionStatus> statuses = await [
                  Permission.storage,
                  Permission.camera,
                ].request();
                if (statuses[Permission.storage]!.isGranted &&
                    statuses[Permission.camera]!.isGranted) {
                  // ignore: use_build_context_synchronously
                  showImagePicker(context);
                } else {
                  // ignore: use_build_context_synchronously
                  showCustomDialog(context, 'No permission provided.',
                      const Color.fromARGB(206, 250, 1, 1));
                }
              },
              child: const Text('Select Image'),
            ),
          ],
        ),
      ),
    );
  }

  final picker = ImagePicker();

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5.2,
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                      child: const Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 60.0,
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "Gallery",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.pop(context);
                      },
                    )),
                    Expanded(
                        child: InkWell(
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 60.0,
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              "Camera",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.pop(context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  _imgFromGallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _imgFromCamera() async {
    await picker
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square, // Enforce 1:1 aspect ratio
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Image Cropper",
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio:
              CropAspectRatioPreset.square, // Set initial aspect ratio to 1:1
          lockAspectRatio: true, // Lock aspect ratio to 1:1
        ),
        IOSUiSettings(
          title: "Image Cropper",
        ),
      ],
    );

    if (croppedFile != null) {
      imageCache.clear();
      setState(() {
        imageFile = File(croppedFile.path);
      });
      // reload();
    }
  }
}
