class ExchangeTicketData {
    List<Ticket> ticket;
    String vipcardTip;

    ExchangeTicketData({this.ticket, this.vipcardTip});

    factory ExchangeTicketData.fromJson(Map<String, dynamic> json) {
        return ExchangeTicketData(
            ticket: json['ticket'] != null ? (json['ticket'] as List).map((i) => Ticket.fromJson(i)).toList() : null,
            vipcardTip: json['vipcardTip'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['vipcardTip'] = this.vipcardTip;
        if (this.ticket != null) {
            data['ticket'] = this.ticket.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Ticket {
    String expiry;
    int id;
    String name;
    int status;
    int type;

    Ticket({this.expiry, this.id, this.name, this.status, this.type});

    factory Ticket.fromJson(Map<String, dynamic> json) {
        return Ticket(
            expiry: json['expiry'],
            id: json['id'],
            name: json['name'],
            status: json['status'],
            type: json['type'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['expiry'] = this.expiry;
        data['id'] = this.id;
        data['name'] = this.name;
        data['status'] = this.status;
        data['type'] = this.type;
        return data;
    }
}