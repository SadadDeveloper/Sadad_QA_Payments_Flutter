class
CreditCardSettingsModel {
  String? key;
  String? value;
  String? createdby;
  String? modifiedby;
  int? id;
  String? deletedAt;
  String? created;
  String? modified;

  CreditCardSettingsModel(
      {this.key,
        this.value,
        this.createdby,
        this.modifiedby,
        this.id,
        this.deletedAt,
        this.created,
        this.modified});

  CreditCardSettingsModel.fromJson(Map<String, dynamic> json) {
    key = json['key']??"";
    value = json['value']??"";
    createdby = json['createdby']??"";
    modifiedby = json['modifiedby']??"";
    id = json['id']??"";
    deletedAt = json['deletedAt']??"";
    created = json['created']??"";
    modified = json['modified']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['id'] = this.id;
    data['deletedAt'] = this.deletedAt;
    data['created'] = this.created;
    data['modified'] = this.modified;
    return data;
  }
}
