class DepartmentModel {
  final int id;
  final String name;

  DepartmentModel({this.id = 0, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}