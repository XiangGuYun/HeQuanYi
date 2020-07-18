class RightClassData {
    int id;
    String name;
    int supId;
    int weight;

    RightClassData({this.id, this.name, this.supId, this.weight});

    factory RightClassData.fromJson(Map<String, dynamic> json) {
        return RightClassData(
            id: json['id'],
            name: json['name'],
            supId: json['supId'],
            weight: json['weight'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['name'] = this.name;
        data['supId'] = this.supId;
        data['weight'] = this.weight;
        return data;
    }
}