class BuyVipData {
    List<Detail> details;
    double price;
    List<PriceConfigAppVo> priceConfigAppVos;
    String renewDesc;
    double renewPrice;
    double saveMoneyCount;
    int vipId;

    BuyVipData({this.details, this.price, this.priceConfigAppVos, this.renewDesc, this.renewPrice, this.saveMoneyCount, this.vipId});

    factory BuyVipData.fromJson(Map<String, dynamic> json) {
        return BuyVipData(
            details: json['details'] != null ? (json['details'] as List).map((i) => Detail.fromJson(i)).toList() : null,
            price: json['price'],
            priceConfigAppVos: json['priceConfigAppVos'] != null ? (json['priceConfigAppVos'] as List).map((i) => PriceConfigAppVo.fromJson(i)).toList() : null,
            renewDesc: json['renewDesc'],
            renewPrice: json['renewPrice'],
            saveMoneyCount: json['saveMoneyCount'],
            vipId: json['vipId'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['price'] = this.price;
        data['renewDesc'] = this.renewDesc;
        data['renewPrice'] = this.renewPrice;
        data['saveMoneyCount'] = this.saveMoneyCount;
        data['vipId'] = this.vipId;
        if (this.details != null) {
            data['details'] = this.details.map((v) => v.toJson()).toList();
        }
        if (this.priceConfigAppVos != null) {
            data['priceConfigAppVos'] = this.priceConfigAppVos.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class PriceConfigAppVo {
    int id;
    String name;
    double originalPrice;
    double realPrice;
    int vipCardId;

    PriceConfigAppVo({this.id, this.name, this.originalPrice, this.realPrice, this.vipCardId});

    factory PriceConfigAppVo.fromJson(Map<String, dynamic> json) {
        return PriceConfigAppVo(
            id: json['id'],
            name: json['name'],
            originalPrice: json['originalPrice'],
            realPrice: json['realPrice'],
            vipCardId: json['vipCardId'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['name'] = this.name;
        data['originalPrice'] = this.originalPrice;
        data['realPrice'] = this.realPrice;
        data['vipCardId'] = this.vipCardId;
        return data;
    }
}

class Detail {
    int id;
    String itemDesc;
    String name;
    double saveMoney;
    int vipCardId;
    int vipCardType;

    Detail({this.id = -1, this.itemDesc, this.name, this.saveMoney, this.vipCardId, this.vipCardType});

    factory Detail.fromJson(Map<String, dynamic> json) {
        return Detail(
            id: json['id'],
            itemDesc: json['itemDesc'],
            name: json['name'],
            saveMoney: json['saveMoney'],
            vipCardId: json['vipCardId'],
            vipCardType: json['vipCardType'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['itemDesc'] = this.itemDesc;
        data['name'] = this.name;
        data['saveMoney'] = this.saveMoney;
        data['vipCardId'] = this.vipCardId;
        data['vipCardType'] = this.vipCardType;
        return data;
    }
}