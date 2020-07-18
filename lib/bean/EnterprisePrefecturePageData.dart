class EnterprisePrefecturePageData {
    bool isEnd;
    int pageNum;
    int pageSize;
    List<Result> results;
    int totalCount;
    int totalPageNum;

    EnterprisePrefecturePageData({this.isEnd, this.pageNum, this.pageSize, this.results, this.totalCount, this.totalPageNum});

    factory EnterprisePrefecturePageData.fromJson(Map<String, dynamic> json) {
        return EnterprisePrefecturePageData(
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
    double exclusivePrice;
    int itemId;
    String itemName;
    String logo;
    int tag;

    Result({this.distance, this.exclusivePrice, this.itemId, this.itemName, this.logo, this.tag});

    factory Result.fromJson(Map<String, dynamic> json) {
        return Result(
            distance: json['distance'], 
            exclusivePrice: json['exclusivePrice'], 
            itemId: json['itemId'], 
            itemName: json['itemName'], 
            logo: json['logo'], 
            tag: json['tag'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['distance'] = this.distance;
        data['exclusivePrice'] = this.exclusivePrice;
        data['itemId'] = this.itemId;
        data['itemName'] = this.itemName;
        data['logo'] = this.logo;
        data['tag'] = this.tag;
        return data;
    }
}