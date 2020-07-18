class BannerData1 {
    int goodsId;
    int id;
    int itemId;
    String jumpType;
    String jumpUrl;
    String name;
    int port;
    String position;
    int state;
    String status;
    String url;
    int weight;

    BannerData1({this.goodsId, this.id, this.itemId, this.jumpType, this.jumpUrl, this.name, this.port, this.position, this.state, this.status, this.url, this.weight});

    factory BannerData1.fromJson(Map<String, dynamic> json) {
        return BannerData1(
            goodsId: json['goodsId'],
            id: json['id'],
            itemId: json['itemId'],
            jumpType: json['jumpType'],
            jumpUrl: json['jumpUrl'],
            name: json['name'],
            port: json['port'],
            position: json['position'],
            state: json['state'],
            status: json['status'],
            url: json['url'],
            weight: json['weight'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['goodsId'] = this.goodsId;
        data['id'] = this.id;
        data['itemId'] = this.itemId;
        data['jumpType'] = this.jumpType;
        data['jumpUrl'] = this.jumpUrl;
        data['name'] = this.name;
        data['port'] = this.port;
        data['position'] = this.position;
        data['state'] = this.state;
        data['status'] = this.status;
        data['url'] = this.url;
        data['weight'] = this.weight;
        return data;
    }
}