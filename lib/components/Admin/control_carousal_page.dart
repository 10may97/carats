import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ControlCarousalPage extends StatefulWidget {
  @override
  _ControlCarousalPageState createState() => _ControlCarousalPageState();
}

class _ControlCarousalPageState extends State<ControlCarousalPage> {
  final TextEditingController _imageUrlController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addImage() {
    String imageUrl = _imageUrlController.text.trim();
    if (imageUrl.isNotEmpty) {
      _firestore.collection('carousal').add({
        'imageUrl': imageUrl,
        // Add additional fields if needed, such as timestamp, etc.
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image added successfully')),
        );
        _imageUrlController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add image: $error')),
        );
      });
    }
  }

  void _deleteImage(String docId) {
    _firestore.collection('carousel_images').doc(docId).delete().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image deleted successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete image: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control Carousel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addImage,
              child: Text('Add Image'),
            ),
            SizedBox(height: 32.0),
            Text(
              'Current Images:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('carousel_images').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No images available');
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: snapshot.data!.docs.map((doc) {
                    String imageUrl = doc['imageUrl'] as String;
                    String docId = doc.id;
                    return ListTile(
                      title: Text(imageUrl),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteImage(docId),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
