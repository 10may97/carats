import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurantapp/services/image_upload_service.dart';

class UploadBillPage extends StatefulWidget {
  const UploadBillPage({super.key});

  @override
  State<UploadBillPage> createState() => _UploadBillPageState();
}

class _UploadBillPageState extends State<UploadBillPage> {
  final ImageUploadService _imageUploadService = ImageUploadService();
  final TextEditingController _reviewController = TextEditingController();
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isUploading = true;
    });

    await _imageUploadService.pickImage(context, source);

    setState(() {
      _isUploading = false;
    });
  }

  Future<void> _submitReview() async {
    if (_reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a review')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    await _imageUploadService.submitReview(_reviewController.text);

    setState(() {
      _isUploading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review submitted successfully!')),
    );

    _reviewController.clear();
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_album),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Bill Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isUploading ? null : () => _showImageSourceActionSheet(context),
              child: _isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Pick Image'),
            ),
            if (_imageUploadService.selectedImage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(
                  _imageUploadService.selectedImage!,
                  height: 200,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _reviewController,
                decoration: const InputDecoration(labelText: "Enter your Review"),
              ),
            ),
            ElevatedButton(
              onPressed: _isUploading ? null : _submitReview,
              child: _isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}
