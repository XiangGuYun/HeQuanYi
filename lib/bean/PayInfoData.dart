class PayInfoData {
    String itemName;
    int orderId;
    int payTime;
    List<Payway> payways;
    double price;

    PayInfoData({this.itemName, this.orderId, this.payTime, this.payways, this.price});

    factory PayInfoData.fromJson(Map<String, dynamic> json) {
        return PayInfoData(
            itemName: json['itemName'],
            orderId: json['orderId'],
            payTime: json['payTime'],
            payways: json['payways'] != null ? (json['payways'] as List).map((i) => Payway.fromJson(i)).toList() : null,
            price: json['price'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['itemName'] = this.itemName;
        data['orderId'] = this.orderId;
        data['payTime'] = this.payTime;
        data['price'] = this.price;
        if (this.payways != null) {
            data['payways'] = this.payways.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Payway {
    bool chosen;
    String content;
    String logo;
    int paywayId;
    bool selectable;
    int index = 0;

    Payway({this.chosen, this.content, this.logo, this.paywayId, this.selectable});

    factory Payway.fromJson(Map<String, dynamic> json) {
        return Payway(
            chosen: json['chosen'],
            content: json['content'],
            logo: json['logo'],
            paywayId: json['paywayId'],
            selectable: json['selectable'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['chosen'] = this.chosen;
        data['content'] = this.content;
        data['logo'] = this.logo;
        data['paywayId'] = this.paywayId;
        data['selectable'] = this.selectable;
        return data;
    }
}