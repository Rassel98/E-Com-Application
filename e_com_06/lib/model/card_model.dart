const String cardProductId = 'productId';
const String cardProductName = 'productName';
const String cardProductImage = 'imageUrl';
const String cardProductSalePrice = 'salePrice';
const String cardProductQuantity = 'quantity';
const String cardProductStock = 'stock';
const String cardProductCategory = 'category';

class CartModel {
  String? productId, productName, imageUrl,category;
  num salePrice, quantity,stock;

  CartModel(
      {this.productId,
      this.productName,
      this.imageUrl,
      this.category,
      required this.salePrice,
      required this.stock,
      this.quantity=1});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      cardProductId: productId,
      cardProductName: productName,
      cardProductImage: imageUrl,
      cardProductCategory: category,
      cardProductSalePrice: salePrice,
      cardProductStock: stock,
      cardProductQuantity: quantity
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) => CartModel(
      productId: map[cardProductId],
      productName: map[cardProductName],
      imageUrl: map[cardProductImage],
      category: map[cardProductCategory],
      salePrice: map[cardProductSalePrice],
      stock: map[cardProductStock],
      quantity: map[cardProductQuantity]);
}
