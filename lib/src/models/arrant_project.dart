class ArrantProject {
  late String id;
  late String name;
  late String description;
  late String slug;
  late String imageUrl;
  late String location;
  late int status;
  late double price;

  ArrantProject();

  ArrantProject.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : '';
      name = jsonMap['name'] ?? '';
      description = jsonMap['description'] ?? '';
      slug = jsonMap['slug'] ?? '';
      imageUrl = jsonMap['image_url'] ?? '';
      location = jsonMap['location'] ?? '';
      status = jsonMap['status'] != null
          ? int.parse(jsonMap['status'].toString())
          : 0;
      price = jsonMap['price'] != null
          ? double.parse(jsonMap['price'].toString())
          : 0.0;
    } catch (e) {
      print("Arrant Project Model Error: $e");
    }
  }
}
