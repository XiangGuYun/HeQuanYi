class EnterprisePrefectureHomePageData {
    int customerId;
    List<Label> labelList;
    String name;

    EnterprisePrefectureHomePageData({this.customerId, this.labelList, this.name});

    factory EnterprisePrefectureHomePageData.fromJson(Map<String, dynamic> json) {
        return EnterprisePrefectureHomePageData(
            customerId: json['customerId'], 
            labelList: json['labelList'] != null ? (json['labelList'] as List).map((i) => Label.fromJson(i)).toList() : null, 
            name: json['name'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['customerId'] = this.customerId;
        data['name'] = this.name;
        if (this.labelList != null) {
            data['labelList'] = this.labelList.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Label {
    int labelId;
    String labelName;

    Label({this.labelId, this.labelName});

    factory Label.fromJson(Map<String, dynamic> json) {
        return Label(
            labelId: json['labelId'], 
            labelName: json['labelName'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['labelId'] = this.labelId;
        data['labelName'] = this.labelName;
        return data;
    }
}