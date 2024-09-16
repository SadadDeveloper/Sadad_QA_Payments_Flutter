class CheckedAllowedCountryModel {
  bool? isAllowed;
  bool? isDebitCard;

  CheckedAllowedCountryModel({this.isAllowed, this.isDebitCard});

  CheckedAllowedCountryModel.fromJson(Map<String, dynamic> json) {
    isAllowed = json['isAllowed'];
    isDebitCard = json['isDebitCard'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isAllowed'] = this.isAllowed;
    data['isDebitCard'] = this.isDebitCard;
    return data;
  }
}