class ChangeCardListData {
    CardAppVos cardAppVos;
    int countdown;

    ChangeCardListData({this.cardAppVos, this.countdown});

    factory ChangeCardListData.fromJson(Map<String, dynamic> json) {
        return ChangeCardListData(
            cardAppVos: json['cardAppVos'] != null ? CardAppVos.fromJson(json['cardAppVos']) : null,
            countdown: json['countdown'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['countdown'] = this.countdown;
        if (this.cardAppVos != null) {
            data['cardAppVos'] = this.cardAppVos.toJson();
        }
        return data;
    }
}

class CardAppVos {
    bool isEnd;
    int pageNum;
    int pageSize;
    List<Result> results;
    int totalCount;
    int totalPageNum;

    CardAppVos({this.isEnd, this.pageNum, this.pageSize, this.results, this.totalCount, this.totalPageNum});

    factory CardAppVos.fromJson(Map<String, dynamic> json) {
        return CardAppVos(
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
    double changePrice;
    int id;
    bool isExchanged;
    String name;
    int score;

    Result({this.changePrice, this.id, this.isExchanged, this.name, this.score});

    factory Result.fromJson(Map<String, dynamic> json) {
        return Result(
            changePrice: json['changePrice'],
            id: json['id'],
            isExchanged: json['isExchanged'],
            name: json['name'],
            score: json['score'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['changePrice'] = this.changePrice;
        data['id'] = this.id;
        data['isExchanged'] = this.isExchanged;
        data['name'] = this.name;
        data['score'] = this.score;
        return data;
    }
}