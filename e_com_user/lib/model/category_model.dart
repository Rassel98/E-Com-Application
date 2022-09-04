
const categoryModelId='id';
const categoryModelName='name';
const categoryModelAvailable='available';
const categoryModelProductCount='productCount';

class CategoryModel{
  String? catId;
  String ? catName;
  bool available;
  num productCount;

  CategoryModel({this.catId, this.catName, this.productCount=0,this.available=true});

  Map<String,dynamic>toMap(){
    return <String,dynamic>{
      categoryModelId:catId,
      categoryModelName:catName,
      categoryModelAvailable:available,
      categoryModelProductCount:productCount,


    };
  }
  factory CategoryModel.fromMap(Map<String, dynamic>map) => CategoryModel(
    catId: map[categoryModelId],
    catName: map[categoryModelName],
    available: map[categoryModelAvailable],
    productCount: map[categoryModelProductCount]


  );
}
