class CommentModel {
  String userId, productId,comment;
  bool status;


  CommentModel(
      {required this.userId, required this.productId, required this.comment,this.status=false});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'productId': productId,
      'comment': comment,
      'status':status
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) => CommentModel(
      userId: map['userId'],
      productId: map['productId'],
      comment: map['comment'],
    status: map['status'],
  );
}
