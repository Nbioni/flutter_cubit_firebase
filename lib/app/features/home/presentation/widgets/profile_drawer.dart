import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/data/models/user_model.dart';

class ProfileDrawer extends StatefulWidget {
  final UserModel? userModel;
  final Function() logout;
  final Function(XFile file) uploadProfileImage;

  const ProfileDrawer({super.key, required this.userModel, required this.logout, required this.uploadProfileImage});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  @override
  Widget build(BuildContext context) {
    final profileImageUrl = widget.userModel?.profileImageUrl;
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 40),
          TextButton(
            onPressed: () async {
              final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
              if(image != null) {
                widget.uploadProfileImage(image);
              }
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl) : null,
                  child: profileImageUrl != null ? null : const Icon(Icons.camera_alt, size: 45),
                ),
                if(profileImageUrl != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: const Icon(Icons.camera_alt, size: 25, color: Colors.white),
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              widget.userModel?.email ?? "",
              style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                )
              ),
            ),
          ),
          const SizedBox(height: 40),
          TextButton.icon(
            onPressed: () {
              widget.logout.call();
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red), // Definindo a cor da borda como vermelha
            ),
            icon: const Icon(Icons.logout, color: Colors.red,),
            label: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}