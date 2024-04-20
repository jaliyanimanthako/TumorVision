import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../model/file_data_model.dart';
import '../screens/result_screen.dart';
import 'package:http/http.dart' as http;

class DroppedFileWidget extends StatefulWidget {
  final File_Data_Model? file;
  final VoidCallback? onReSelect;

  const DroppedFileWidget({Key? key, required this.file, this.onReSelect}) : super(key: key);

  @override
  _DroppedFileWidgetState createState() => _DroppedFileWidgetState();
}

class _DroppedFileWidgetState extends State<DroppedFileWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.file != null)
            SizedBox(
              height: 200,
              child: Image.network(
                widget.file!.url,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fitHeight,
                errorBuilder: (context, error, _) => buildEmptyFile('No Preview'),
              ),
            ),
          const SizedBox(height: 10),
          if (widget.file != null) buildFileDetail(widget.file),
        ],
      ),
    );
  }

  Widget buildEmptyFile(String text) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Center(child: Text(text)),
    );
  }

  Widget buildFileDetail(File_Data_Model? file) {
    return Container(
      margin: const EdgeInsets.only(left: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: widget.onReSelect,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  surfaceTintColor: Colors.white,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFF14967F)),
                  ),
                ),
                child: const Text('Re-Select', style: TextStyle(color: Color(0xFF14967F))),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () async {
                  if (widget.file != null) {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      String base64Image = base64Encode(widget.file!.bytes);

                      final response = await http.post(
                        Uri.parse('https://58c4-2402-4000-21c2-df0e-b542-b93f-3dc1-8646.ngrok-free.app/predict'),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({'base64Image': base64Image}),

                      );
                      setState(() {
                        _isLoading = false;
                      });

                      if (response.statusCode == 200) {
                        final responseData = jsonDecode(response.body);
                        String predictedClass = responseData['predicted_class'];

                        // Navigate to result screen with the predicted class
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(predictedClass: predictedClass, url: widget.file!.url,),
                          ),
                        );
                      } else {
                        debugPrint('Failed to predict: ${response.statusCode}');
                        debugPrint('Response body: ${response.body}');
                      }
                    } catch (e) {
                      setState(() {
                        _isLoading = false;
                      });
                      debugPrint('Error sending image bytes: $e');
                    }
                  } else {
                    debugPrint('No file selected');
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  backgroundColor: const Color(0xFF14967F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Check', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
          const SizedBox(height: 10),
          _isLoading?
          const SizedBox(
            width: 80,
            height: 80,
            child: LoadingIndicator(
              indicatorType: Indicator.ballSpinFadeLoader,
              colors: [Color(0xFF14967F)],
              strokeWidth: 2,
              pathBackgroundColor: Colors.black,
            ),
          ):
              Container(),
        ],
      ),
    );
  }
}
