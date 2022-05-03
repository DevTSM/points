class CategoryModel {
  String name;
  String id;
  String img;
  List<Map<String, dynamic>> subCategorias;
  CategoryModel(
      {required this.id,
      required this.name,
      required this.img,
      required this.subCategorias});
  factory CategoryModel.setInit(String name, String id, String image) {
    return CategoryModel(subCategorias: [], img: image, name: name, id: id);
  }
  factory CategoryModel.fromData(Map<String, dynamic> data) {
    List<Map<String, dynamic>> cat = [];
    if (data["subCategorias"] != null) {
      data["subCategorias"].forEach((element) {
        cat.add({"value": element, "isCurrent": false});
      });
    }
    return CategoryModel(
        id: data["id"] ?? "",
        name: data["nombre"] ?? "Categoria sin nombre",
        img: data["imagen"] ?? "",
        subCategorias: cat);
  }

  addSubcategoria(String subCat) {
    var valueChange =
        subCategorias.where((element) => element["value"] == subCat);
    if (valueChange.isNotEmpty) {
      valueChange.first["isCurrent"] = true;
    }
  }

  deleteCategoria(String subCat) {
    var valueDelete =
        subCategorias.where((element) => element["value"] == subCat);
    if (valueDelete.isNotEmpty) {
      valueDelete.first["isCurrent"] = false;
    }
  }

  getMap() {
    return {
      "id": id,
      "nombre": name,
      "subCategorias": subCategorias.map((e) {
        if (e["isCurrent"]) {
          return e["value"];
        }
      }).toList()
    };
  }
}
