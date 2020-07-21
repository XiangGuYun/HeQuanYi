class RechargeData {
    int id;
    double priceDiscount;
    double priceView;

    RechargeData({this.id, this.priceDiscount, this.priceView});

    factory RechargeData.fromJson(Map<String, dynamic> json) {
        return RechargeData(
            id: json['id'],
            priceDiscount: json['priceDiscount'],
            priceView: json['priceView'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['priceDiscount'] = this.priceDiscount;
        data['priceView'] = this.priceView;
        return data;
    }
}