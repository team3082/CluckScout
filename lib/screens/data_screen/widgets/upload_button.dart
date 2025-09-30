import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/providers/upload_provider.dart';

class UploadToRoostButton extends StatelessWidget {
  const UploadToRoostButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UploadProvider>(
      builder: (context, provider, _) {
        if (!provider.canUpload) return const SizedBox.shrink();
        
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 243, 243, 243),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => provider.uploadDatabase(context),
            child: const SizedBox(
              width: 150,
              child: Center(
                child: Text(
                  "Upload to Roost",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(28, 27, 31, 1),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}