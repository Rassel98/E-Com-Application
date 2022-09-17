class RatingModel {
  String userId, productId;
  double rating;

  RatingModel(
      {required this.userId, required this.productId, required this.rating});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'productId': productId,
      'rating': rating
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) => RatingModel(
      userId: map['userId'],
      productId: map['productId'],
      rating: map['rating']);
}
