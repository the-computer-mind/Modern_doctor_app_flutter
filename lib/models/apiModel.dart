//as data isn't same for all list iteam and sometimes data is null
//so i created model in a way to handle both also
//sometimes datatypes are different like price sometimes in int sometimes in string

class Product {
  final String id;
  final String name;
  final ProductData data;

  Product({
    required this.id,
    required this.name,
    required this.data,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 'No Data',
      name: json['name'] ?? 'No Data',
      data: json['data'] != null
          ? ProductData.fromJson(json['data'])
          : ProductData.defaultData(),
    );
  }
}

class ProductData {
  final String color;
  final String capacity;
  final String price;
  final String generation;
  final String year;
  final String cpuModel;
  final String hardDiskSize;
  final String description;
  final double screenSize;

  ProductData({
    required this.color,
    required this.capacity,
    required this.price,
    required this.generation,
    required this.year,
    required this.cpuModel,
    required this.hardDiskSize,
    required this.description,
    required this.screenSize,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      color: json['color'] ?? json['Color'] ?? 'No Data',
      capacity: json['capacity']?.toString() ??
          json['capacity GB']?.toString() ??
          json['Capacity']?.toString() ??
          'No Data',
      price: json['price'] != null
          ? json['price'].toString()
          : json['Price']?.toString() ?? 'No Data',
      generation: json['generation'] ?? json['Generation'] ?? 'No Data',
      year: json['year'] != null
          ? json['year'].toString()
          : 'No Data', // Convert int/double to String
      cpuModel: json['CPU model'] ?? 'No Data',
      hardDiskSize: json['Hard disk size'] ?? 'No Data',
      description: json['Description'] ?? 'No Data',
      screenSize: (json['Screen size'] != null && json['Screen size'] is num)
          ? (json['Screen size'] as num).toDouble()
          : 0.0, // Default to 0.0 if screen size is absent or invalid
    );
  }

  /// Default values for missing data
  factory ProductData.defaultData() {
    return ProductData(
      color: 'No Data',
      capacity: 'No Data',
      price: 'No Data',
      generation: 'No Data',
      year: 'No Data',
      cpuModel: 'No Data',
      hardDiskSize: 'No Data',
      description: 'No Data',
      screenSize: 0.0,
    );
  }
}
