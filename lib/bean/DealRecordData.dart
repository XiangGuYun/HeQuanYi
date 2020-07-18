class DealRecordData {
    bool isEnd;
    int pageNum;
    int pageSize;
    List<DealRecordResult> results;
    int totalCount;
    int totalPageNum;

    DealRecordData({this.isEnd, this.pageNum, this.pageSize, this.results, this.totalCount, this.totalPageNum});

    factory DealRecordData.fromJson(Map<String, dynamic> json) {
        return DealRecordData(
            isEnd: json['isEnd'], 
            pageNum: json['pageNum'], 
            pageSize: json['pageSize'], 
            results: json['results'] != null ? (json['results'] as List).map((i) => DealRecordResult.fromJson(i)).toList() : null, 
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

class DealRecordResult {
    String content;
    String dayView;
    int flowType;
    int id;
    String money;
    String monthView;

    DealRecordResult({this.content, this.dayView, this.flowType, this.id, this.money, this.monthView});

    factory DealRecordResult.fromJson(Map<String, dynamic> json) {
        return DealRecordResult(
            content: json['content'], 
            dayView: json['dayView'], 
            flowType: json['flowType'], 
            id: json['id'], 
            money: json['money'], 
            monthView: json['monthView'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['content'] = this.content;
        data['dayView'] = this.dayView;
        data['flowType'] = this.flowType;
        data['id'] = this.id;
        data['money'] = this.money;
        data['monthView'] = this.monthView;
        return data;
    }
}