class ResponseModel {
  dynamic json;

  ResponseModel({this.json});

  Map<String, dynamic> toJson() => {
        'isError': json['isError'],
        'message': json['message'],
        'data': json['data']
      };

  bool get isError {
    return json['isError'] is bool
        ? json['isError']
        : json['isError'] == "true"
            ? true
            : false;
  }

  dynamic get message {
    return json['message'];
  }

  dynamic get data {
    return json['data'];
  }
}