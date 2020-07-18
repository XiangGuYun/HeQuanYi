class RedPacketData {
    bool isEnd;
    int pageNum;
    int pageSize;
    List<Result> results;
    int totalCount;
    int totalPageNum;

    RedPacketData({this.isEnd, this.pageNum, this.pageSize, this.results, this.totalCount, this.totalPageNum});

    factory RedPacketData.fromJson(Map<String, dynamic> json) {
        return RedPacketData(
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
    String dueTime;
    int id;
    String name;
    double price;
    int state;
    String welfareDesc;

    Result({this.dueTime, this.id, this.name, this.price, this.state, this.welfareDesc});

    factory Result.fromJson(Map<String, dynamic> json) {
        return Result(
            dueTime: json['dueTime'],
            id: json['id'],
            name: json['name'],
            price: json['price'],
            state: json['state'],
            welfareDesc: json['welfareDesc'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['dueTime'] = this.dueTime;
        data['id'] = this.id;
        data['name'] = this.name;
        data['price'] = this.price;
        data['state'] = this.state;
        data['welfareDesc'] = this.welfareDesc;
        return data;
    }
}