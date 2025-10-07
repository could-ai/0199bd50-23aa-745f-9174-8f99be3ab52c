import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lung Cancer Detection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const CancerDetectionScreen(),
    );
  }
}

class CancerDetectionScreen extends StatefulWidget {
  const CancerDetectionScreen({super.key});

  @override
  State<CancerDetectionScreen> createState() => _CancerDetectionScreenState();
}

class _CancerDetectionScreenState extends State<CancerDetectionScreen> {
  File? _selectedImage;
  bool _isProcessing = false;
  bool _showProcessedImage = false;
  bool _showCircledImage = false;
  bool _showResult = false;
  final bool _isInfected = true; // Simulation result

  // Placeholder asset paths for processed images
  final String _processedImagePath = 'assets/processed.png';
  final String _circledImagePath = 'assets/circled.png';

  Future<void> _pickImage() async {
    // Reset state when picking a new image
    setState(() {
      _selectedImage = null;
      _isProcessing = false;
      _showProcessedImage = false;
      _showCircledImage = false;
      _showResult = false;
    });

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _startAnalysis() {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
      _showProcessedImage = false;
      _showCircledImage = false;
      _showResult = false;
    });

    // Simulate the multi-step analysis process from MATLAB
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _showProcessedImage = true;
      });
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() {
        _showCircledImage = true;
      });
    });

    Future.delayed(const Duration(seconds: 6), () {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _showResult = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lung Cancer Detection Simulation'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'This is a UI simulation of your MATLAB image processing flow.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 20),
                
                // Step 1: Display Original Image
                _buildStepCard(
                  title: 'Step 1: Select & Display Original Image',
                  content: _selectedImage != null
                      ? Image.file(_selectedImage!)
                      : Container(
                          height: 200,
                          width: 200,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                  isVisible: true,
                ),
                
                // Step 2: Display Processed Image
                _buildStepCard(
                  title: 'Step 2: Identify & Mark Cancer Cells (Red)',
                  content: Image.asset(_processedImagePath),
                  isVisible: _showProcessedImage,
                ),

                // Step 3: Display Circled Image
                _buildStepCard(
                  title: 'Step 3: Circle Infected Spots',
                  content: Image.asset(_circledImagePath),
                  isVisible: _showCircledImage,
                ),

                // Step 4: Show Final Result
                _buildStepCard(
                  title: 'Step 4: Final Result',
                  content: _buildResultWidget(),
                  isVisible: _showResult,
                ),
                
                const SizedBox(height: 20),
                if (_isProcessing)
                  const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('Analyzing Image...'),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _pickImage,
            label: const Text('Select Image'),
            icon: const Icon(Icons.photo_library),
          ),
          const SizedBox(height: 10),
          if (_selectedImage != null && !_isProcessing)
            FloatingActionButton.extended(
              onPressed: _startAnalysis,
              label: const Text('Start Analysis'),
              icon: const Icon(Icons.science),
              backgroundColor: Colors.green,
            ),
        ],
      ),
    );
  }

  Widget _buildStepCard({required String title, required Widget content, required bool isVisible}) {
    return Visibility(
      visible: isVisible,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Center(child: content),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultWidget() {
    if (_isInfected) {
      return Column(
        children: [
          const Text(
            'Result: Infected',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 10),
          Image.asset(_circledImagePath), // Show final image if infected
        ],
      );
    } else {
      return const Text(
        'Result: Not Infected',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
      );
    }
  }
}
