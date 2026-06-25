class AddReportModel {
  final String text;
  AddReportModel({required this.text});

  Map<String, dynamic> toJson() => {
    "reportText": text, 
  };
}