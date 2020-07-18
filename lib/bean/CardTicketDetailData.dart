class CardTicketDetailData {
    String couponCode;
    String couponUrl;
    int exchangEndTime;
    String exchangeDesc;
    List<String> exchangeImgs;
    String exchangeWay;
    int id;
    int itemId;
    String itemLogo;
    String itemName;
    int itemType;
    int status;
    int storeCount;
    int tag;

    CardTicketDetailData({this.couponCode, this.couponUrl, this.exchangEndTime, this.exchangeDesc, this.exchangeImgs, this.exchangeWay, this.id, this.itemId, this.itemLogo, this.itemName, this.itemType, this.status, this.storeCount, this.tag});

    factory CardTicketDetailData.fromJson(Map<String, dynamic> json) {
        return CardTicketDetailData(
            couponCode: json['couponCode'],
            couponUrl: json['couponUrl'],
            exchangEndTime: json['exchangEndTime'],
            exchangeDesc: json['exchangeDesc'],
            exchangeImgs: json['exchangeImgs'] != null ? new List<String>.from(json['exchangeImgs']) : null,
            exchangeWay: json['exchangeWay'],
            id: json['id'],
            itemId: json['itemId'],
            itemLogo: json['itemLogo'],
            itemName: json['itemName'],
            itemType: json['itemType'],
            status: json['status'],
            storeCount: json['storeCount'],
            tag: json['tag'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['couponCode'] = this.couponCode;
        data['couponUrl'] = this.couponUrl;
        data['exchangEndTime'] = this.exchangEndTime;
        data['exchangeDesc'] = this.exchangeDesc;
        data['exchangeWay'] = this.exchangeWay;
        data['id'] = this.id;
        data['itemId'] = this.itemId;
        data['itemLogo'] = this.itemLogo;
        data['itemName'] = this.itemName;
        data['itemType'] = this.itemType;
        data['status'] = this.status;
        data['storeCount'] = this.storeCount;
        data['tag'] = this.tag;
        if (this.exchangeImgs != null) {
            data['exchangeImgs'] = this.exchangeImgs;
        }
        return data;
    }
}