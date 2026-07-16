class ReaderModel {
  String? id;
  String name;
  String membershipId;
  String phone;

  ReaderModel({
    this.id,
    required this.name,
    required this.membershipId,
    required this.phone,
  });

  factory ReaderModel.fromJson(Map<String, dynamic> json, String documentId) {
    return ReaderModel(
      id: documentId,
      name: json['name'] ?? '',
      membershipId: json['membershipId'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'membershipId': membershipId, 'phone': phone};
  }
}
