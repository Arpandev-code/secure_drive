import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class UploadOptions extends StatelessWidget {
  const UploadOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        coloredContainer(
            bgColor: Colors.lightBlue.withOpacity(0.3),
            title: 'Images',
            option: 'Image',
            iconColor: Colors.blue,
            icon: EvaIcons.image),
        coloredContainer(
            bgColor: Colors.redAccent.withOpacity(0.3),
            title: 'Videos',
            option: 'Video',
            iconColor: Colors.red,
            icon: Icons.play_arrow_rounded),
        coloredContainer(
            bgColor: Colors.indigoAccent.withOpacity(0.3),
            title: 'Documents',
            option: 'Document',
            iconColor: Colors.indigoAccent,
            icon: EvaIcons.fileText),
        coloredContainer(
            bgColor: Colors.purple.withOpacity(0.3),
            title: 'Audios',
            option: 'Audio',
            iconColor: Colors.purple,
            icon: EvaIcons.music)
      ],
    );
  }

  Widget coloredContainer({
    required Color bgColor,
    required IconData icon,
    required String title,
    required String option,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
