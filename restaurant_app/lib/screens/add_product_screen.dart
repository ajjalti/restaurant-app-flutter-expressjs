import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_app/dtos/product_request_dto.dart';
import 'package:restaurant_app/models/product.dart';
import 'package:restaurant_app/services/message_service.dart';
import 'package:restaurant_app/services/product_service.dart';

class AddProduct extends StatefulWidget {
  final MessageService messageService;
  const AddProduct({super.key, required this.messageService});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;
  final picker = ImagePicker();

  void _submitProduct() async {
    final ProductService _productService = ProductService();
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final price = double.tryParse(_priceController.text.trim()) ?? 0;
      final description = _descriptionController.text.trim();

      if (_imageFile == null) {
        widget.messageService.showError("You should add an image");
        return;
      } else {
        setState(() {
          _isLoading = true;
        });
        final ProductRequestDto product = ProductRequestDto(
          name: name,
          description: description,
          price: price,
        );
        final response = await _productService.createProduct(
          product,
          _imageFile as File,
        );
        if (response != null) {
          setState(() {
            _isLoading = false;
          });
          widget.messageService.showSuccess("Product was created !");
          Navigator.pushReplacementNamed(context, '/home', arguments: 1);
        } else {
          setState(() {
            _isLoading = false;
          });
          widget.messageService.showError("operation failed !");
        }
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery, // ou ImageSource.camera
      imageQuality: 75,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemYellow,
      // appBar: AppBar(
      //   title: Text("Add Item to shop"),
      //   backgroundColor: Colors.yellow,
      //   leading: IconButton(icon: Icon(Icons.plus_one), onPressed: () {}),
      // ),
      body: SingleChildScrollView(
        child:
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child:
                                _imageFile != null
                                    ? Image.file(_imageFile!, height: 150)
                                    : Image.asset(
                                      'assets/images/addproduct.png',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _pickImage,
                            child: Text("Add Product Picture"),
                          ),
                          SizedBox(height: 20),
                          Divider(height: 20, thickness: 2, color: Colors.grey),
                          SizedBox(height: 20),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    hintText: "product name",
                                    labelText: 'Enter product name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  controller: _priceController,
                                  decoration: InputDecoration(
                                    hintText: "Product price",
                                    labelText: "Enter product price",
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  controller: _descriptionController,
                                  decoration: InputDecoration(
                                    hintText: "Product description",
                                    labelText: "Enter product description",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 25),
                                Center(
                                  child: TextButton(
                                    onPressed: _submitProduct,
                                    child: Text("ADD Product +"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
      ),

      // bottomNavigationBar: AdminNavigationBar(
      //   selectedIndex: _selectedIndex,
      //   onItemTapped: _onItemTapped,
      // ),
    );
  }
}
