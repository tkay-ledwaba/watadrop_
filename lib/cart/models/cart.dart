class Cart {

  late int _id;
  late String _name;
  late String _image;
  late String _price;
  late int _qty;

  Cart(this._id, this._name, this._image, this._price, this._qty);

  //Note.withId(this._id, this._title, this._date, this._priority, [this._description]);

  int get id => _id;

  String get name => _name;

  String get image => _image!;

  int get qty => _qty;

  String get price => _price;

  set name(String newName) {
    if (newName.length <= 255) {
      this._name = newName;
    }
  }

  set image(String newImage) {
    if (newImage.length <= 255) {
      this._image = newImage;
    }
  }

  set qty(int newQty) {
    if (newQty >= 1 && newQty <= 2) {
      this._qty = newQty;
    }
  }

  set price(String newDate) {
    this._price = newDate;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['image'] = _image;
    map['qty'] = _qty;
    map['price'] = _price;

    return map;
  }

  // Extract a Note object from a Map object
  Cart.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._image = map['image'];
    this._price = map['price'];
    this._qty = map['qty'];

  }
}