class ProductDetailData {
    List<String> egImgs;
    String goodsDesc;
    int id;
    bool isMiguGoods;
    String limitCities;
    String logo;
    String name;
    double price;
    bool split;
    List<SplitGood> splitGoods;
    double vipPrice;

    ProductDetailData({this.egImgs, this.goodsDesc, this.id, this.isMiguGoods, this.limitCities, this.logo, this.name, this.price, this.split, this.splitGoods, this.vipPrice});

    factory ProductDetailData.fromJson(Map<String, dynamic> json) {
        return ProductDetailData(
            egImgs: json['egImgs'] != null ? new List<String>.from(json['egImgs']) : null,
            goodsDesc: json['goodsDesc'],
            id: json['id'],
            isMiguGoods: json['isMiguGoods'],
            limitCities: json['limitCities'],
            logo: json['logo'],
            name: json['name'],
            price: json['price'],
            split: json['split'],
            splitGoods: json['splitGoods'] != null ? (json['splitGoods'] as List).map((i) => SplitGood.fromJson(i)).toList() : null,
            vipPrice: json['vipPrice'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['goodsDesc'] = this.goodsDesc;
        data['id'] = this.id;
        data['isMiguGoods'] = this.isMiguGoods;
        data['limitCities'] = this.limitCities;
        data['logo'] = this.logo;
        data['name'] = this.name;
        data['price'] = this.price;
        data['split'] = this.split;
        data['vipPrice'] = this.vipPrice;
        if (this.egImgs != null) {
            data['egImgs'] = this.egImgs;
        }
        if (this.splitGoods != null) {
            data['splitGoods'] = this.splitGoods.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class SplitGood {
    int id;
    int leftStock;
    String name;
    double price;
    int stock;
    int useStock;
    double vipPrice;

    SplitGood({this.id, this.leftStock, this.name, this.price, this.stock, this.useStock, this.vipPrice});

    factory SplitGood.fromJson(Map<String, dynamic> json) {
        return SplitGood(
            id: json['id'],
            leftStock: json['leftStock'],
            name: json['name'],
            price: json['price'],
            stock: json['stock'],
            useStock: json['useStock'],
            vipPrice: json['vipPrice'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['leftStock'] = this.leftStock;
        data['name'] = this.name;
        data['price'] = this.price;
        data['stock'] = this.stock;
        data['useStock'] = this.useStock;
        data['vipPrice'] = this.vipPrice;
        return data;
    }
}