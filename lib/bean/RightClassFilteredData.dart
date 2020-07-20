class RightClassFilteredData {
    bool isEnd;
    int pageNum;
    int pageSize;
    List<Result> results;
    int totalCount;
    int totalPageNum;

    RightClassFilteredData({this.isEnd, this.pageNum, this.pageSize, this.results, this.totalCount, this.totalPageNum});

    factory RightClassFilteredData.fromJson(Map<String, dynamic> json) {
        return RightClassFilteredData(
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
    String distance;
    int id;
    String logo;
    String name;
    int payWay;
    double price;
    int tag;
    String vipId;
    String vipName;
    double vipPrice;
    int vipType;

    Result({this.distance, this.id, this.logo, this.name, this.payWay, this.price, this.tag, this.vipId, this.vipName, this.vipPrice, this.vipType});

    factory Result.fromJson(Map<String, dynamic> json) {
        return Result(
            distance: json['distance'],
            id: json['id'],
            logo: json['logo'],
            name: json['name'],
            payWay: json['payWay'],
            price: json['price'],
            tag: json['tag'],
            vipId: json['vipId'],
            vipName: json['vipName'],
            vipPrice: json['vipPrice'],
            vipType: json['vipType'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['distance'] = this.distance;
        data['id'] = this.id;
        data['logo'] = this.logo;
        data['name'] = this.name;
        data['payWay'] = this.payWay;
        data['price'] = this.price;
        data['tag'] = this.tag;
        data['vipId'] = this.vipId;
        data['vipName'] = this.vipName;
        data['vipPrice'] = this.vipPrice;
        data['vipType'] = this.vipType;
        return data;
    }
}