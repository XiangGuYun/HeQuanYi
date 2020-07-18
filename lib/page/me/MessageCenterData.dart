class MessageCenterData {
    bool isEnd;
    int pageNum;
    int pageSize;
    List<Result> results;
    int totalCount;
    int totalPageNum;

    MessageCenterData({this.isEnd, this.pageNum, this.pageSize, this.results, this.totalCount, this.totalPageNum});

    factory MessageCenterData.fromJson(Map<String, dynamic> json) {
        return MessageCenterData(
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
    int isRead;
    int itemId;
    int jumpType;
    String path;
    String pushTime;
    String title;

    Result({this.id, this.isRead, this.itemId, this.jumpType, this.path, this.pushTime, this.title});

    factory Result.fromJson(Map<String, dynamic> json) {
        return Result(
            id: json['id'],
            isRead: json['isRead'],
            itemId: json['itemId'],
            jumpType: json['jumpType'],
            path: json['path'],
            pushTime: json['pushTime'],
            title: json['title'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['isRead'] = this.isRead;
        data['itemId'] = this.itemId;
        data['jumpType'] = this.jumpType;
        data['path'] = this.path;
        data['pushTime'] = this.pushTime;
        data['title'] = this.title;
        return data;
    }
}