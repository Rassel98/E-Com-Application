class ProductModel{
  String? id;
  String? name;
  String?category;
  String? description;
  num salePrice,stock,ratingCount;
  double rating;
  bool featured;
  bool available;
  String? imageUrl;

  ProductModel(
      {this.id,
      this.name,
      this.category,
      this.description,
      this.stock=0,
      this.ratingCount=0,
      this.rating=0,
      required this.salePrice,
        this.featured = true,
        this.available = true,
      this.imageUrl});
Map<String,dynamic>toMap(){
  return <String,dynamic>{
    'id': id,
    'name': name,
    'category': category,
    'description': description,
    'salePrice': salePrice,
    'ratingCount': ratingCount,
    'stock': stock,
    'rating': rating,
    'feature': featured,
    'available': available,
    'imageUrl': imageUrl,

  };
}
  factory ProductModel.fromMap(Map<String, dynamic>map) => ProductModel(
    id: map['id'],
    name: map['name'],
    category: map['category'],
    description: map['description'],
    salePrice: map['salePrice'],
    stock: map['stock'],
    rating: map['rating'] ?? 0.0,
    ratingCount: map['ratingCount'] ?? 0,
    featured: map['feature'],
    available: map['available'],
    imageUrl: map['imageUrl'],
  );
}