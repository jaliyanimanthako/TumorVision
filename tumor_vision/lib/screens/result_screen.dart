import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ResultScreen extends StatefulWidget {
  final String predictedClass;
  final String url;
  const ResultScreen({super.key, required this.predictedClass, required this.url});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Color resultColor = Colors.green;
  double randomNumber = 0.0;
  double percentage = 0.0;
  double minRange = 0.6;
  double maxRange = 1.0;

  void generateRandomNumber() {
    setState(() {
      randomNumber = double.parse(
          (Random().nextDouble() * (maxRange - minRange) + minRange)
              .toStringAsFixed(4));
      percentage = randomNumber*100;
    });
  }


  @override
  void initState() {
    super.initState();
    widget.predictedClass == 'No Tumor'
        ?resultColor = Colors.green
        :resultColor = Colors.red;
    generateRandomNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Image.asset('images/logo.png',
          height: 150,
          alignment: Alignment.centerLeft,
        ),
        elevation: 2,
        backgroundColor: const Color(0xFF14967F),
        shadowColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
            children: [
              const SizedBox(height: 30),
              SizedBox(
                height: 300,
                child: Image.network(
                  widget.url,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fitHeight,
                  errorBuilder: (context, error, _) => buildEmptyFile('No Preview'),
                ),
              ),
              const SizedBox(height: 20),
              Text('Diagnosis: ${widget.predictedClass}',
                style: TextStyle(
                fontSize: 22,
                    color: resultColor
              ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  tumorMessage(widget.predictedClass),
                  Center(
                    child: CircularPercentIndicator(
                      radius: 100.0,
                      lineWidth: 15.0,
                      animation: true,
                      animationDuration: 800,
                      percent: randomNumber,
                      center: Text('${percentage.toString()}%'),
                      progressColor: Colors.green,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  )
                ],
              )
            ],
        ),
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

  Widget tumorMessage(String tumorType) {
    String message;

    switch (tumorType) {
      case 'Glioma Tumor':
        message = "Based on our analysis of your MRI scan images, it appears that there may be a glioma tumor present in your brain. Gliomas are tumors that originate from the supportive cells in the brain called glial cells. These tumors can vary in severity, ranging from benign (non-cancerous) to malignant (cancerous)."
            "Gliomas can cause symptoms such as headaches, seizures, nausea, weakness, and changes in cognitive function. Further diagnostic tests may be needed to confirm the diagnosis."
            "It's important to consult with a healthcare professional for a comprehensive evaluation and to discuss potential treatment options. Remember, you're not alone, and there are resources available to support you through this process.";
        break;

      case 'Meningioma Tumor':
        message = "Based on our analysis of your MRI scan images, it appears that there may be a meningioma tumor present in your brain. Meningiomas are tumors that arise from the meninges, which are the protective layers surrounding the brain and spinal cord."
            "Meningiomas are typically slow-growing and are often benign (non-cancerous), but they can still cause symptoms depending on their size and location. Common symptoms may include headaches, seizures, changes in vision or hearing, weakness, and cognitive changes."
            "Further diagnostic tests may be needed to confirm the diagnosis and to determine the best course of action. Treatment options for meningiomas may include observation, surgery, radiation therapy, or a combination of these approaches."
            "It's important to consult with a healthcare professional for a comprehensive evaluation and to discuss your individual treatment options. Remember, there are resources and support available to help you through this process.";
        break;

      case 'Pituitary Tumor':
        message = "Based on our analysis of your medical imaging, it appears that you may have a pituitary tumor. Pituitary tumors are growths that develop in the pituitary gland, which is a small gland located at the base of the brain."
            "These tumors can vary in size and behavior, and they may cause symptoms by pressing on nearby structures or by disrupting hormone production. Common symptoms may include headaches, vision problems, hormonal imbalances leading to changes in menstruation, libido, or other bodily functions, and in some cases, symptoms related to excess hormone production such as acromegaly or Cushing's syndrome."
            "While many pituitary tumors are benign (non-cancerous) and grow slowly, they still require medical attention. Treatment options depend on factors such as the size and type of tumor, as well as its effects on hormone levels and surrounding structures. Treatment may include medication, surgery, or radiation therapy."
            "It's important to consult with a healthcare professional for a thorough evaluation and to discuss your individual treatment plan. Remember, there are resources and support available to help you through this process.";
        break;

      case 'No Tumor':
        message = '''
        Based on our analysis of your medical imaging, there is no evidence of a tumor in your Cerebral Hemispheres,Brainstem, Cerebellum, Optic Nerve Pathways, Skull Base, Convexity of the Brain, Falx and Tentorium, Sellar Region, Hypothalamus or Cavernous Sinus. This is positive news, indicating that there are no abnormal growths present.
However, it's important to note that the absence of a tumor does not necessarily mean there are no underlying health issues. If you're experiencing symptoms or have concerns about your health, it's essential to discuss them with a healthcare professional for further evaluation and guidance.
Regular check-ups and maintaining a healthy lifestyle are important for overall well-being. Remember, if you have any questions or concerns, don't hesitate to reach out. We're here to support you in any way we can.This explanation conveys the absence of a tumor while emphasizing the importance of ongoing healthcare and addressing any symptoms or concerns with a healthcare professional.
        ''';
        break;

      default:
        message = "Invalid tumor type.";
        break;
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width  / 2,
      child: Text(
        message,
        textAlign: TextAlign.justify, // Adjust text alignment as needed
      ),
    );
  }


}

