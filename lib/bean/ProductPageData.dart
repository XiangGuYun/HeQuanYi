class ProductPageData {
    bool isEnd;
    int pageNum;
    int pageSize;
    List<Result> results;
    int totalCount;
    int totalPageNum;

    ProductPageData({this.isEnd, this.pageNum, this.pageSize, this.results, this.totalCount, this.totalPageNum});

    factory ProductPageData.fromJson(Map<String, dynamic> json) {
        return ProductPageData(
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
    int id;
    String logo;
    String name;
    double price;
    List<String> tagDescArr;
    double vipPrice;

    Result({this.id, this.logo, this.name, this.price, this.tagDescArr, this.vipPrice});

    factory Result.fromJson(Map<String, dynamic> json) {
        return Result(
            id: json['id'],
            logo: json['logo'],
            name: json['name'],
            price: json['price'],
            tagDescArr: json['tagDescArr'] != null ? new List<String>.from(json['tagDescArr']) : null,
            vipPrice: json['vipPrice'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['logo'] = this.logo;
        data['name'] = this.name;
        data['price'] = this.price;
        data['vipPrice'] = this.vipPrice;
        if (this.tagDescArr != null) {
            data['tagDescArr'] = this.tagDescArr;
        }
        return data;
    }
}