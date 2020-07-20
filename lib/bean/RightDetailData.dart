class RightDetailData {
    String exchangeDesc;
    List<String> exchangeImgs;
    String exchangeWay;
    int exclusivePrice;
    int id;
    bool isNeedCheckPhone;
    String itemDesc;
    int itemType;
    int jumpType;
    String jumpUrl;
    int leftStock;
    String logo;
    String name;
    int orderId;
    int payWay;
    double price;
    int scoreExchange;
    StoreAppVO storeAppVO;
    int storeCount;
    int tag;
    int useStock;
    int vipId;
    String vipName;
    double vipPrice;
    int vipType;

    RightDetailData({this.exchangeDesc, this.exchangeImgs, this.exchangeWay, this.exclusivePrice, this.id, this.isNeedCheckPhone, this.itemDesc, this.itemType, this.jumpType, this.jumpUrl, this.leftStock, this.logo, this.name, this.orderId, this.payWay, this.price, this.scoreExchange, this.storeAppVO, this.storeCount, this.tag, this.useStock, this.vipId, this.vipName, this.vipPrice, this.vipType});

    factory RightDetailData.fromJson(Map<String, dynamic> json) {
        return RightDetailData(
            exchangeDesc: json['exchangeDesc'],
            exchangeImgs: json['exchangeImgs'] != null ? new List<String>.from(json['exchangeImgs']) : null,
            exchangeWay: json['exchangeWay'],
            exclusivePrice: json['exclusivePrice'],
            id: json['id'],
            isNeedCheckPhone: json['isNeedCheckPhone'],
            itemDesc: json['itemDesc'],
            itemType: json['itemType'],
            jumpType: json['jumpType'],
            jumpUrl: json['jumpUrl'],
            leftStock: json['leftStock'],
            logo: json['logo'],
            name: json['name'],
            orderId: json['orderId'],
            payWay: json['payWay'],
            price: json['price'],
            scoreExchange: json['scoreExchange'],
            storeAppVO: json['storeAppVO'] != null ? StoreAppVO.fromJson(json['storeAppVO']) : null,
            storeCount: json['storeCount'],
            tag: json['tag'],
            useStock: json['useStock'],
            vipId: json['vipId'],
            vipName: json['vipName'],
            vipPrice: json['vipPrice'],
            vipType: json['vipType'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['exchangeDesc'] = this.exchangeDesc;
        data['exchangeWay'] = this.exchangeWay;
        data['exclusivePrice'] = this.exclusivePrice;
        data['id'] = this.id;
        data['isNeedCheckPhone'] = this.isNeedCheckPhone;
        data['itemDesc'] = this.itemDesc;
        data['itemType'] = this.itemType;
        data['jumpType'] = this.jumpType;
        data['jumpUrl'] = this.jumpUrl;
        data['leftStock'] = this.leftStock;
        data['logo'] = this.logo;
        data['name'] = this.name;
        data['orderId'] = this.orderId;
        data['payWay'] = this.payWay;
        data['price'] = this.price;
        data['scoreExchange'] = this.scoreExchange;
        data['storeCount'] = this.storeCount;
        data['tag'] = this.tag;
        data['useStock'] = this.useStock;
        data['vipId'] = this.vipId;
        data['vipName'] = this.vipName;
        data['vipPrice'] = this.vipPrice;
        data['vipType'] = this.vipType;
        if (this.exchangeImgs != null) {
            data['exchangeImgs'] = this.exchangeImgs;
        }
        if (this.storeAppVO != null) {
            data['storeAppVO'] = this.storeAppVO.toJson();
        }
        return data;
    }
}

class StoreAppVO {
    String address;
    String distance;
    double latitude;
    double longitude;
    String name;
    int storeId;

    StoreAppVO({this.address, this.distance, this.latitude, this.longitude, this.name, this.storeId});

    factory StoreAppVO.fromJson(Map<String, dynamic> json) {
        return StoreAppVO(
            address: json['address'],
            distance: json['distance'],
            latitude: json['latitude'],
            longitude: json['longitude'],
            name: json['name'],
            storeId: json['storeId'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['address'] = this.address;
        data['distance'] = this.distance;
        data['latitude'] = this.latitude;
        data['longitude'] = this.longitude;
        data['name'] = this.name;
        data['storeId'] = this.storeId;
        return data;
    }
}