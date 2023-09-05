// To parse this JSON data, do
//
//     final clientsModel = clientsModelFromJson(jsonString);

import 'dart:convert';

ClientsModel clientsModelFromJson(String str) => ClientsModel.fromJson(json.decode(str));

String clientsModelToJson(ClientsModel data) => json.encode(data.toJson());

class ClientsModel {
    List<Datum> data;

    ClientsModel({
        required this.data,
    });

    factory ClientsModel.fromJson(Map<String, dynamic> json) => ClientsModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String id;
    String name;
    String email;
    String phone;
    String country;
    String image;

    Datum({
        required this.id,
        required this.name,
        required this.email,
        required this.phone,
        required this.country,
        required this.image,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        country: json["country"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "country": country,
        "image": image,
    };
}
