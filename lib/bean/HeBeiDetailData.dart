class HeBeiDetailData {
    bool isEnd;
    int pageNum;
    int pageSize;
    List<HebeiDetailResult> results;
    int totalCount;
    int totalPageNum;

    HeBeiDetailData({this.isEnd, this.pageNum, this.pageSize, this.results, this.totalCount, this.totalPageNum});

    factory HeBeiDetailData.fromJson(Map<String, dynamic> json) {
        return HeBeiDetailData(
            isEnd: json['isEnd'],
            pageNum: json['pageNum'],
            pageSize: json['pageSize'],
            results: json['results'] != null ? (json['results'] as List).map((i) => HebeiDetailResult.fromJson(i)).toList() : null,
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

class HebeiDetailResult {
    String content;
    String dayView;
    int flowType;
    String monthView;
    int score;
    String unit;

    HebeiDetailResult({this.content, this.dayView, this.flowType, this.monthView, this.score, this.unit});

    factory HebeiDetailResult.fromJson(Map<String, dynamic> json) {
        return HebeiDetailResult(
            content: json['content'],
            dayView: json['dayView'],
            flowType: json['flowType'],
            monthView: json['monthView'],
            score: json['score'],
            unit: json['unit'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['content'] = this.content;
        data['dayView'] = this.dayView;
        data['flowType'] = this.flowType;
        data['monthView'] = this.monthView;
        data['score'] = this.score;
        data['unit'] = this.unit;
        return data;
    }
}