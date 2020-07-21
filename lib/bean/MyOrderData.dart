class MyOrderData {
    bool isEnd;
    int pageNum;
    int pageSize;
    List<Result> results;
    int totalCount;
    int totalPageNum;

    MyOrderData({this.isEnd, this.pageNum, this.pageSize, this.results, this.totalCount, this.totalPageNum});

    factory MyOrderData.fromJson(Map<String, dynamic> json) {
        return MyOrderData(
            isEnd: json['isEnd'],
            pageNum: json['pageNum'],
            pageSize: json['pageSize'],
            results: json['results'] != null ? (json['results'] as List).map((i) => Result.fromJson(i)).toList() : null,
            totalCount: json['totalCount'],
            totalPageNum: json['totalPageNum'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['isEnd'] = this.isEnd;
        data['pageNum'] = this.pageNum;
        data['pageSize'] = this.pageSize;
        data['totalCount'] = this.totalCount;
        data['totalPageNum'] = this.totalPageNum;
        if (this.results != null) {
            data['results'] = this.results.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Result {
    String applyDesc;
    String createTime;
    String goodsLogo;
    String goodsName;
    int id;
    String logisticsCompany;
    String logisticsNumber;
    int payTime;
    double price;
    String refuseDesc;
    int status;

    Result({this.applyDesc, this.createTime, this.goodsLogo, this.goodsName, this.id, this.logisticsCompany, this.logisticsNumber, this.payTime, this.price, this.refuseDesc, this.status});

    factory Result.fromJson(Map<String, dynamic> json) {
        return Result(
            applyDesc: json['applyDesc'],
            createTime: json['createTime'],
            goodsLogo: json['goodsLogo'],
            goodsName: json['goodsName'],
            id: json['id'],
            logisticsCompany: json['logisticsCompany'],
            logisticsNumber: json['logisticsNumber'],
            payTime: json['payTime'],
            price: json['price'],
            refuseDesc: json['refuseDesc'],
            status: json['status'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['applyDesc'] = this.applyDesc;
        data['createTime'] = this.createTime;
        data['goodsLogo'] = this.goodsLogo;
        data['goodsName'] = this.goodsName;
        data['id'] = this.id;
        data['logisticsCompany'] = this.logisticsCompany;
        data['logisticsNumber'] = this.logisticsNumber;
        data['payTime'] = this.payTime;
        data['price'] = this.price;
        data['refuseDesc'] = this.refuseDesc;
        data['status'] = this.status;
        return data;
    }
}