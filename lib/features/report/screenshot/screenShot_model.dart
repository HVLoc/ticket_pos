// To parse this JSON data, do
//
//     final feedbackRequest = feedbackRequestFromJson(jsonString);

import 'dart:convert';

FeedbackRequest feedbackRequestFromJson(String str) =>
    FeedbackRequest.fromJson(json.decode(str));

String feedbackRequestToJson(FeedbackRequest data) =>
    json.encode(data.toJson());

class FeedbackRequest {
  FeedbackRequest({
    this.taxcode,
    this.customerName,
    this.fileFeedback,
    this.content,
  });

  String? taxcode;
  String? customerName;
  dynamic fileFeedback;
  String? content;

  factory FeedbackRequest.fromJson(Map<String, dynamic> json) =>
      FeedbackRequest(
        taxcode: json["taxcode"],
        customerName: json["customerName"],
        fileFeedback: json["fileFeedback"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "taxcode": taxcode,
        "customerName": customerName,
        "fileFeedback": fileFeedback,
        "content": content,
      };
}
