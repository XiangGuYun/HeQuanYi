class CategoryData {
    int id;
    String name;

    CategoryData({this.id, this.name});

    factory CategoryData.fromJson(Map<String, dynamic> json) {
        return CategoryData(
            id: json['id'],
            name: json['name'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['name'] = this.name;
        return data;
    }
}