import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_06/model/category_model.dart';
import 'package:e_com_06/model/order_constant_model.dart';
import 'package:e_com_06/model/product_model.dart';

import '../model/purches_model.dart';

class DBHelper {
  static const String collectionAdmin = 'Admins';
  static const String collectionCategory = 'Categories';
  static const String collectionProduct = 'Products';
  static const String collectionPurchase = 'Purchase';
  static const String collectionOrderSettings = 'Settings';
  static const String documentOrderConstant = 'OrderConstant';
  static const String collectionRateProduct = 'Rating';
  static const String collectionComments = 'Comments';
  static const String collectionUser = 'Users';
  static const String collectionCart = 'Cart';
  static const String collectionOrder = 'Orders';
  static const String collectionOrderDetails = 'OrderDetails';
  static const String collectionCities = 'Cities';

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<bool> isAdmin(String uid) async {
    final snapshot = await _db.collection(collectionAdmin).doc(uid).get();
    return snapshot.exists;
  }

//all Add function

  static Future<void> addProduct(String uid, num count,
      ProductModel productModel, PurchaseModel purchaseModel) async {
    final wb = _db.batch();
    final proDoc = _db.collection(collectionProduct).doc();
    final purcDoc = _db.collection(collectionPurchase).doc();
    final catDoc = _db.collection(collectionCategory).doc(uid);
    productModel.id = proDoc.id;
    purchaseModel.id = purcDoc.id;
    purchaseModel.productId = proDoc.id;

    wb.set(proDoc, productModel.toMap());
    wb.set(purcDoc, purchaseModel.toMap());
    wb.update(catDoc, {'productCount': count});

    return wb.commit();
  }

  static Future<void> addCategory(CategoryModel categoryModel) async {
    final doc = _db.collection(collectionCategory).doc();
    categoryModel.catId = doc.id;
    return doc.set(categoryModel.toMap());
  }

  static Future<void> addPurchase(PurchaseModel purchaseModel, CategoryModel catModel, num newStock) async {
    final doc = _db.collection(collectionPurchase).doc();
    final catDoc = _db.collection(collectionPurchase).doc(catModel.catId);
    final wb=_db.batch();
    purchaseModel.id = doc.id;
    wb.set(doc, purchaseModel.toMap());
    wb.update(catDoc, {categoryModelProductCount:catModel.productCount });
    final proDoc=_db.collection(collectionProduct).doc(purchaseModel.productId);
    wb.update(proDoc, {'stock':newStock});

    return wb.commit();

    //return doc.set(purchaseModel.toMap());
  }

  static Future<void> addOrderConstant(
      OrderConstantModel orderConstantModel) async {
  return  _db
        .collection(collectionOrderSettings)
        .doc(documentOrderConstant)
        .set(orderConstantModel.toMap());
  }

//all Get function

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getAllOrderConstant() =>
      _db
          .collection(collectionOrderSettings)
          .doc(documentOrderConstant)
          .snapshots();

  static Future<DocumentSnapshot<Map<String, dynamic>>> getAllOrderConstant2() =>
      _db
          .collection(collectionOrderSettings)
          .doc(documentOrderConstant)
          .get();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(collectionProduct).snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrders() =>
      _db.collection(collectionOrder).snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() =>
      _db.collection(collectionUser).snapshots();


  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllPurchase(
          String id) =>
      _db
          .collection(collectionPurchase)
          .where('productId', isEqualTo: id)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(
          String pid) =>
      _db.collection(collectionProduct).doc(pid).snapshots();

  //all update function

  static Future<void> updateProduct(String id, Map<String, dynamic> map) =>
      _db.collection(collectionProduct).doc(id).update(map);

//all delete function
  static Future<void> deleteCategoryById(String id) =>
      _db.collection(collectionCategory).doc(id).delete();

  static Future<void> deleteProductById(String id) async {
    //_db.collection(collectionProduct).doc(id).delete()
    //final wb=_db.batch();
    //  var removedProductRef = _db.collection(collectionProduct).doc(id);
    //  var removedPurchaseRef = _db.collection(collectionPurchase).doc(id);
    // wb.delete(removedProductRef);
    // wb.delete(removedPurchaseRef);
    //  wb.commit();
    // _db.collection(collectionCategory).doc(id).delete();
  }
}
