class DealDetailData {
    String content;
    int flowType;
    int id;
    String money;
    String orderId;
    String result;
    String timeView;

    DealDetailData({this.content, this.flowType, this.id, this.money, this.orderId, this.result, this.timeView});

    factory DealDetailData.fromJson(Map<String, dynamic> json) {
        return DealDetailData(
            content: json['content'],
            flowType: json['flowType'],
            id: json['id'],
            money: json['money'],
            orderId: json['orderId'],
            result: json['result'],
            timeView: json['timeView'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['content'] = this.content;
        data['flowType'] = this.flowType;
        data['id'] = this.id;
        data['money'] = this.money;
        data['orderId'] = this.orderId;
        data['result'] = this.result;
        data['timeView'] = this.timeView;
        return data;
    }
}