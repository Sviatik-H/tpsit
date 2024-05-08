import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
        ).copyWith(
          secondary: Colors.orange,
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black87),
          bodyText2: TextStyle(color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal, // Colore di sfondo del pulsante
            foregroundColor: Colors.white, // Colore del testo sul pulsante
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      home: ProductManagementPage(),
    );
  }
}




class ProductManagementPage extends StatefulWidget {
  @override
  _ProductManagementPageState createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController manufacturerIdController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();
  TextEditingController newNameController = TextEditingController();
  TextEditingController newDescriptionController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController newManufacturerIdController = TextEditingController();
  TextEditingController newCategoryIdController = TextEditingController();

  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final response =
        await http.get(Uri.parse('http://localhost/Rest/Server.php'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData is List) {
        setState(() {
          products = jsonData.map((data) => Product.fromJson(data)).toList();
        });
      } else {
        throw Exception('Invalid JSON format received');
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> deleteProduct(int productId) async {
    final response = await http.delete(
      Uri.parse('http://localhost/Rest/Server.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'ProductId': productId}),
    );

    if (response.statusCode == 200) {
      loadProducts();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Product deleted')));
    } else {
      throw Exception('Failed to delete product');
    }
  }

  Future<void> addProduct(
      String name, String description, double price, int manufacturerId, int categoryId) async {
    final response = await http.post(
      Uri.parse('http://localhost/Rest/Server.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'Name': name,
        'Description': description,
        'Price': price,
        'ManufacturerId': manufacturerId,
        'CategoryId': categoryId
      }),
    );

    if (response.statusCode == 200) {
      loadProducts();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Product added')));
    } else {
      throw Exception('Failed to add product');
    }
  }

  Future<void> modifyProduct(int productId, String newName, String newDescription, double newPrice,
      int newManufacturerId, int newCategoryId) async {
    final response = await http.put(
      Uri.parse('http://localhost/Rest/Server.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'ProductId': productId,
        'Name': newName,
        'Description': newDescription,
        'Price': newPrice,
        'ManufacturerId': newManufacturerId,
        'CategoryId': newCategoryId
      }),
    );

    if (response.statusCode == 200) {
      loadProducts();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Product updated')));
    } else {
      throw Exception('Failed to update product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Enter Product Name',
                labelStyle: TextStyle(color: Colors.teal), // Colore dell'etichetta
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Enter Product Description',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Enter Product Price',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 10),
            TextField(
              controller: manufacturerIdController,
              decoration: InputDecoration(
                labelText: 'Enter Manufacturer ID',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: categoryIdController,
              decoration: InputDecoration(
                labelText: 'Enter Category ID',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                addProduct(
                    nameController.text,
                    descriptionController.text,
                    double.tryParse(priceController.text) ?? 0.0,
                    int.tryParse(manufacturerIdController.text) ?? 0,
                    int.tryParse(categoryIdController.text) ?? 0);
                nameController.clear();
                descriptionController.clear();
                priceController.clear();
                manufacturerIdController.clear();
                categoryIdController.clear();
              },
              child: Text('Add Product'),
            ),
            SizedBox(height: 20),
            Text(
              'All Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.orange.shade50,
                    child: ListTile(
                      title: Text(products[index].name),
                      subtitle: Text(
                          '${products[index].description}\nPrice: \$${products[index].price}\nManufacturer ID: ${products[index].manufacturerId}\nCategory ID: ${products[index].categoryId}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.teal),
                            onPressed: () {
                              newNameController.text = '';
                              newDescriptionController.text = '';
                              newPriceController.text = '';
                              newManufacturerIdController.text = '';
                              newCategoryIdController.text = '';
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Modify Product'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: newNameController,
                                          decoration: InputDecoration(
                                            labelText: 'Enter New Product Name',
                                            labelStyle: TextStyle(
                                                color: Colors.teal),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.teal),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        TextField(
                                          controller: newDescriptionController,
                                          decoration: InputDecoration(
                                            labelText:
                                                'Enter New Product Description',
                                            labelStyle: TextStyle(
                                                color: Colors.teal),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.teal),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        TextField(
                                          controller: newPriceController,
                                          decoration: InputDecoration(
                                            labelText: 'Enter New Product Price',
                                            labelStyle: TextStyle(
                                                color: Colors.teal),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.teal),
                                            ),
                                          ),
                                          keyboardType: TextInputType.numberWithOptions(
                                              decimal: true),
                                        ),
                                        SizedBox(height: 10),
                                        TextField(
                                          controller:
                                              newManufacturerIdController,
                                          decoration: InputDecoration(
                                            labelText:
                                                'Enter New Manufacturer ID',
                                            labelStyle: TextStyle(
                                                color: Colors.teal),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.teal),
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                        SizedBox(height: 10),
                                        TextField(
                                          controller: newCategoryIdController,
                                          decoration: InputDecoration(
                                            labelText: 'Enter New Category ID',
                                            labelStyle: TextStyle(
                                                color: Colors.teal),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.teal),
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          modifyProduct(
                                              products[index].id,
                                              newNameController.text,
                                              newDescriptionController.text,
                                              double.tryParse(
                                                      newPriceController.text) ??
                                                  0.0,
                                              int.tryParse(
                                                      newManufacturerIdController
                                                          .text) ??
                                                  0,
                                              int.tryParse(
                                                      newCategoryIdController
                                                          .text) ??
                                                  0);

                                          Navigator.pop(context);
                                        },
                                        child: Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              deleteProduct(products[index].id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int manufacturerId;
  final int categoryId;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.manufacturerId,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    if (json['ProductId'] == null ||
        json['Name'] == null ||
        json['Description'] == null ||
        json['Price'] == null ||
        json['ManufacturerId'] == null ||
        json['CategoryId'] == null) {
      throw ArgumentError("Invalid JSON provided to Product.fromJson");
    }
    return Product(
      id: json['ProductId'] as int,
      name: json['Name'] as String,
      description: json['Description'] as String,
      price: (json['Price'] as num).toDouble(),
      manufacturerId: json['ManufacturerId'] as int,
      categoryId: json['CategoryId'] as int,
    );
  }
}
