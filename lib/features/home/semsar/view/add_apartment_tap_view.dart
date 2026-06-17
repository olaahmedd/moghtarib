import 'dart:io';
import 'package:moghtarib/features/home/semsar/cubit/semsar/add_apartment_state.dart';
import 'package:moghtarib/features/home/semsar/cubit/semsar/add_apartment_cubit.dart';

import '../model/add_apartment_model.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart'; 




class AddApartmentTabView extends StatefulWidget {
  const AddApartmentTabView({super.key});

  @override
  State<AddApartmentTabView> createState() => _AddApartmentTabViewState();
}

class _AddApartmentTabViewState extends State<AddApartmentTabView> {
  final _formKey = GlobalKey<FormState>();

  final _cityController = TextEditingController();
  final _villageController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController(text: '0');
  final _roomsController = TextEditingController();
  final _typeController = TextEditingController(text: '1');
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  bool _isRent = true;

  
  File? _baseImage; 
  List<File> _additionalImages = []; 

  final ImagePicker _picker = ImagePicker();

  
  Future<void> _pickBaseImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _baseImage = File(pickedFile.path);
      });
    }
  }

  
  Future<void> _pickAdditionalImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _additionalImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    _villageController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _roomsController.dispose();
    _typeController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  void _submitForm() {
    
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    
    if (_baseImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text('Please select the required base image first!'),
        ),
      );
      return;
    }

    
    if (_formKey.currentState!.validate()) {
      debugPrint("Form is valid! Calling addApartment...");
      
      final apartment = AddApartmentModel(
        city: _cityController.text.trim(),
        village: _villageController.text.trim(),
        location: _locationController.text.trim(),
        price: double.tryParse(_priceController.text) ?? 0.0,
        numOfRooms: int.tryParse(_roomsController.text) ?? 0,
        type: int.tryParse(_typeController.text) ?? 1,
        addressLat: double.tryParse(_latController.text) ?? 0.0,
        addressLon: double.tryParse(_lonController.text) ?? 0.0,
        isRent: _isRent,
      );

      
      context.read<ApartmentCubit>().addApartment(
        apartment: apartment,
        baseImage: _baseImage,
        additionalImages: _additionalImages,
      );
    } else {
      debugPrint("Form validation failed. Please check your fields.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Please fill all required fields correctly.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1011),
      body: Column(
        children: [
          // 1. الـ Gradient Header
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Apartment ',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                
              ],
            ),
          ),

          
          Expanded(
            child: BlocConsumer<ApartmentCubit, ApartmentState>(
              listener: (context, state) {
                
                ScaffoldMessenger.of(context).hideCurrentSnackBar();

                if (state is ApartmentAddSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Apartment Added Successfully!'),
                    ),
                  );
                  
                  _cityController.clear();
                  _villageController.clear();
                  _locationController.clear();
                  _roomsController.clear();
                  _priceController.text = '0';
                  _typeController.text = '1';
                  _latController.clear();
                  _lonController.clear();
                  setState(() {
                    _baseImage = null;
                    _additionalImages.clear();
                  });
                }
                
                
                if (state is ApartmentError) { 
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(state.message), 
                      duration: const Duration(seconds: 4),
                    ),
                  );
                }
              },
              builder: (context, state) {
                bool isLoading = state is ApartmentLoading;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 750),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            

                            _buildFieldLabel('City'),
                            _buildCustomTextField(_cityController, 'Enter City'),

                            _buildFieldLabel('Village'),
                            _buildCustomTextField(_villageController, 'Enter Village'),

                            _buildFieldLabel('Location'),
                            _buildCustomTextField(_locationController, 'Enter Location'),

                            _buildFieldLabel('Price'),
                            _buildCustomTextField(_priceController, '0', isNumber: true),

                            _buildFieldLabel('NumOfRooms'),
                            _buildCustomTextField(_roomsController, 'Enter total rooms', isNumber: true),

                            _buildFieldLabel('Type'),
                            _buildCustomTextField(_typeController, '1', isNumber: true),

                            _buildFieldLabel('address_Lat'),
                            _buildCustomTextField(_latController, 'Enter latitude', isNumber: true),

                            _buildFieldLabel('address_Lon'),
                            _buildCustomTextField(_lonController, 'Enter longitude', isNumber: true),

                            _buildFieldLabel('IsRent'),
                            _buildRentDropdown(),

                            const SizedBox(height: 20),
                            _buildFieldLabel('Base Image (required)'),
                            
                            _buildImagePlaceholder(
                              text: 'Click to upload base image',
                              imageFile: _baseImage,
                              onTap: _pickBaseImage,
                            ),

                            const SizedBox(height: 20),
                            _buildFieldLabel('Images (optional, multiple)'),
                            
                            GestureDetector(
                              onTap: _pickAdditionalImages,
                              child: Container(
                                width: double.infinity,
                                height: _additionalImages.isEmpty ? 90 : 120,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF161719),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: _additionalImages.isEmpty
                                    ? const Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.collections, color: Colors.white38, size: 20),
                                            const SizedBox(width: 8),
                                            Text('Click to upload multiple images', style: TextStyle(color: Colors.white38, fontSize: 13)),
                                          ],
                                        ),
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.all(8),
                                        itemCount: _additionalImages.length + 1,
                                        itemBuilder: (context, index) {
                                          if (index == _additionalImages.length) {
                                            return Container(
                                              width: 100,
                                              margin: const EdgeInsets.only(left: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.02),
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: Colors.white10),
                                              ),
                                              child: const Icon(Icons.add_a_photo, color: Colors.white38),
                                            );
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 8),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Image.file(
                                                    _additionalImages[index],
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 4,
                                                  right: 4,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _additionalImages.removeAt(index);
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(2),
                                                      decoration: const BoxDecoration(
                                                        color: Colors.black54,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(Icons.close, color: Colors.white, size: 14),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ),

                            const SizedBox(height: 35),

                            Container(
                               width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2575FC).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                              child: SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:Colors.transparent,
                                    disabledBackgroundColor: const Color(0xFF6F32E4).withOpacity(0.5),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                        )
                                      : const Text('Upload', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildCustomTextField(TextEditingController controller, String hint, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      validator: (val) => (val == null || val.trim().isEmpty) ? 'Required field' : null,
      decoration: InputDecoration(
        fillColor: const Color(0xFF161719),
        filled: true,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white10)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF6F32E4))),
      ),
    );
  }

  Widget _buildRentDropdown() {
    return DropdownButtonFormField<bool>(
      value: _isRent,
      dropdownColor: const Color(0xFF161719),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        fillColor: const Color(0xFF161719),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white10)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF6F32E4))),
      ),
      items: const [
        DropdownMenuItem(value: true, child: Text('true')),
        DropdownMenuItem(value: false, child: Text('false')),
      ],
      onChanged: (val) {
        if (val != null) setState(() => _isRent = val);
      },
    );
  }

  Widget _buildImagePlaceholder({
    required String text, 
    required VoidCallback onTap, 
    File? imageFile, 
    bool isMultiple = false
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: imageFile != null ? 180 : 90,
        decoration: BoxDecoration(
          color: const Color(0xFF161719),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white12),
        ),
        child: imageFile != null 
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(imageFile, fit: BoxFit.cover, width: double.infinity),
              )
            : Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(isMultiple ? Icons.collections : Icons.add_photo_alternate, color: Colors.white38, size: 20),
                    const SizedBox(width: 8),
                    Text(text, style: const TextStyle(color: Colors.white38, fontSize: 13)),
                  ],
                ),
              ),
      ),
    );
  }
}