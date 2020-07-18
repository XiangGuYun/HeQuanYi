class HomeIconData {
    String iconImg;
    String name;
    int resourceId;
    int type;
    String unusableTip;
    bool usable;

    HomeIconData({this.iconImg, this.name, this.resourceId, this.type, this.unusableTip, this.usable});

    factory HomeIconData.fromJson(Map<String, dynamic> json) {
        return HomeIconData(
            iconImg: json['iconImg'],
            name: json['name'],
            resourceId: json['resourceId'],
            type: json['type'],
            unusableTip: json['unusableTip'],
            usable: json['usable'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['iconImg'] = this.iconImg;
        data['name'] = this.name;
        data['resourceId'] = this.resourceId;
        data['type'] = this.type;
        data['unusableTip'] = this.unusableTip;
        data['usable'] = this.usable;
        return data;
    }
}