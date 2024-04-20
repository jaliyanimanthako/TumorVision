import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../model/file_data_model.dart';
import '../widgets/dropped_file_widget.dart';
import '../widgets/image_uploader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File_Data_Model? file;



      @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('images/logo.png',
          height: 150,
          alignment: Alignment.centerLeft,
        ),
        elevation: 2,
        backgroundColor: const Color(0xFF14967F),
        shadowColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          // Increased padding for better spacing
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Brain Tumor Detector",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // Center-align the text
              ),
              const SizedBox(height: 20), // Added spacing below the title
              const Text(
                "Welcome to TumorVision!",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center, // Center-align the text
              ),
              const Text(
                "Brain tumor detection app powered by deep learning",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center, // Center-align the text
              ),
              const SizedBox(height: 10),
              const Text(
                "TumorVision uses advanced algorithms to analyze medical images and identify potential tumors with high accuracy.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center, // Center-align the text
              ),
              const Text(
                " Simply upload your scans and receive instant insights. Take control of your health today with our intuitive tumor finder.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center, // Center-align the text
              ),
              const SizedBox(height: 20),
              const Text('Please upload clear MRI scan photos for accurate analysis.', style: TextStyle(fontSize: 12),),
              const SizedBox(height: 20),
              file == null ?
              SizedBox(
                height: 300,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 3 / 5,
                child: ImageUploader(
                  onDroppedFile: (file) {
                    setState(() {
                      this.file = file;
                    });
                  },
                ),
              )
                  : DroppedFileWidget(
                file: file,
                onReSelect: () {
                  setState(() {
                    file = null; // Reset file state to trigger re-selection
                  });
                },
              ),
            ],
          ),
        ),

      ),
      bottomNavigationBar: Container(
        height: 50,
        width: MediaQuery
            .of(context)
            .size
            .width,
        color: Colors.grey.shade100,
        // Example background color
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: '  © ${DateTime
                    .now()
                    .year} ',
              ),
              TextSpan(
                text: 'Chathura Devinda',
                style: const TextStyle(
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                  debugPrint('tapped chathura');
                    launchUrlString(
                        'https://www.linkedin.com/in/chathura-devinda-73ab25229/',
                      mode: LaunchMode.platformDefault
                    );
                  },
              ),
              const TextSpan(
                text: ' & ',
              ),
              TextSpan(
                text: 'Jaliya Nimantha',
                style: const TextStyle(
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrlString(
                        'https://www.linkedin.com/in/jaliya-nimantha-8924b7219/',
                        mode: LaunchMode.platformDefault
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
