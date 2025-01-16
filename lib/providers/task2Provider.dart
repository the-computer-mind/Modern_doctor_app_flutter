import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/apiModel.dart';

class ProductProvider with ChangeNotifier {
  final Dio _dio = Dio(); // Instance of Dio for making API calls
  List<Product> _products = []; // Private variable to store the products
  bool _isloading = false;
  bool get isloading => _isloading;
  // Getter to access the list of products
  List<Product> get products => _products;

  // Setter to update the products list
  set products(List<Product> products) {
    _products = products;
    notifyListeners(); // Notify listeners that the data has been updated
  }

  // Method to fetch products from the API
  Future<void> fetchProducts() async {
    _isloading = true;
    notifyListeners();
    try {
      final response =
          await _dio.get('https://api.restful-api.dev/objects'); // API endpoint

      if (response.statusCode == 200) {
        // If the API call is successful, parse the data
        List<dynamic> data = response.data;
        //  debugPrint("Here is the api data >>>>>>>>>> " + response.data[0]);
        _products = data.map((json) => Product.fromJson(json)).toList();
        _isloading = false;
        notifyListeners(); // Notify listeners after data is fetched
      } else {
        _isloading = false;
        notifyListeners();
        throw Exception('Failed to load products');
      }
    } catch (e) {
      _isloading = false;
      notifyListeners();
      print('Error fetching products: $e');
      // Handle error gracefully
    }
  }
}
