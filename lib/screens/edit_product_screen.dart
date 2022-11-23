import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';
  const EditProductScreen({Key key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    description: '',
    id: null,
    title: '',
    imageUrl: '',
    price: 0,
  );

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  void updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      // this setstate is used to tell flutter that when focus is out of the image url box rebuilt the page so that the we can have the picture in the container
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Provide a value';
                  } else {
                    return null;
                  }
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                    description: _editedProduct.description,
                    id: _editedProduct.id,
                    title: newValue,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter a value';
                  }

                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }

                  if (double.parse(value) <= 0) {
                    return 'Please Enter a number greater than 0';
                  }

                  return null;
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                    description: _editedProduct.description,
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    imageUrl: _editedProduct.imageUrl,
                    price: double.parse(newValue),
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (newValue) {
                  _editedProduct = Product(
                    description: newValue,
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some description';
                  }

                  if (value.length < 10) {
                    return 'Should be atleast 10 characters long';
                  }

                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              left: 10,
                            ),
                            child: Text('Enter a Url'))
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          description: _editedProduct.description,
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          imageUrl: newValue,
                          price: _editedProduct.price,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an image url';
                        }

                        if (!value.startsWith('http') &&
                            !value.startsWith('http')) {
                          return 'Please Enter a valid url';
                        }

                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('jpeg')) {
                          return 'Please enter a valid image Url';
                        }

                        return null;
                      },
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
