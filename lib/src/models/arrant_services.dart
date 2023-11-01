class ArrantServices {
  late String id;
  late String name;
  late String slug;
  late String description;
  late String imageUrl;
  late double averagePrice;
  late int status;

  ArrantServices();

  ArrantServices.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : '';
      name = jsonMap["name"] ?? '';
      slug = jsonMap['slug'] ?? '';
      description = jsonMap['description'] ?? '';
      imageUrl = jsonMap['image_url'] ?? '';
      averagePrice = jsonMap['avg_price'] != null
          ? double.parse(jsonMap['avg_price'].toString())
          : 0.0;
      status = jsonMap['status'] != null
          ? int.parse(jsonMap['status'].toString())
          : 0;
    } catch (e) {
      print("Arrant Services Model Error: $e");
    }
  }
}
