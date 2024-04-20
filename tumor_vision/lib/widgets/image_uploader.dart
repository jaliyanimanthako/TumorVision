import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:dotted_border/dotted_border.dart';
import '../model/file_data_model.dart';

class ImageUploader extends StatefulWidget {

  final ValueChanged<File_Data_Model> onDroppedFile;

  const ImageUploader({Key? key,required this.onDroppedFile}):super(key: key);
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  late DropzoneViewController controller;
  bool highlight = false;

  @override
  Widget build(BuildContext context) {

    return buildDecoration(

        child: Stack(
          children: [
            DropzoneView(
              onCreated: (controller) => this.controller = controller,
              onDrop: uploadedFile,
              onHover:() => setState(()=> highlight = true),
              onLeave: ()=> setState(()=>highlight = false),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cloud_upload_outlined,
                    size: 80,
                    color: Colors.white,
                  ),
                  const Text(
                    'Drop Files Here',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const Text('Add png/jpg file of your MRI scan', style: TextStyle(color: Colors.white, fontSize: 12),),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final events = await controller.pickFiles();
                      if (events.isEmpty) return;
                      uploadedFile(events.first);
                    },
                    icon: const Icon(Icons.search, color: Color(0xFF14967F)),
                    label: const Text(
                      'Choose File',
                      style: TextStyle(color: Color(0xFF14967F), fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: highlight? const Color(0xFF095E7D): const Color(0xFFE2FCD6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Adjust the radius here
                      ),
                    ),
                  )

                ],
              ),
            ),
          ],
        ));
  }

  Future uploadedFile(dynamic event) async {
    final name = event.name;
    final mime = await controller.getFileMIME(event);
    final byte = await controller.getFileData(event);
    final url = await controller.createFileUrl(event);
    final file = event;

    final droppedFile = File_Data_Model
      (name: name, mime: mime, bytes: byte, url: url,);

    widget.onDroppedFile(droppedFile);


    setState(() {
      highlight = false;
    });
  }


  Widget buildDecoration({required Widget child}){
    final colorBackground =  highlight? const Color(0xFF095E7D): const Color(0xFF14967F);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: colorBackground,
        child: DottedBorder(
            borderType: BorderType.RRect,
            color: Colors.white,
            strokeWidth: 3,
            dashPattern: const [8,4],
            radius: const Radius.circular(10),
            padding: EdgeInsets.zero,
            child: child
        ),
      ),
    );
  }
}
