 class RightClassData {
    int id;
    String name;
    List<NextLevelVO> nextLevelVO;
    int supId;
    int weight;
    int index = 0;

    RightClassData({this.id, this.name, this.nextLevelVO, this.supId, this.weight});

    factory RightClassData.fromJson(Map<String, dynamic> json) {
        return RightClassData(
            id: json['id'],
            name: json['name'],
            nextLevelVO: json['nextLevelVO'] != null ? (json['nextLevelVO'] as List).map((i) => NextLevelVO.fromJson(i)).toList() : null,
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
        if (this.nextLevelVO != null) {
            data['nextLevelVO'] = this.nextLevelVO.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class NextLevelVO {
    int id;
    String name;
    int supId;
    int weight;
    bool isSelected = false;

    NextLevelVO({this.id, this.name, this.supId, this.weight});

    factory NextLevelVO.fromJson(Map<String, dynamic> json) {
        return NextLevelVO(
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