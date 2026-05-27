class UserModel{
  String? id;
 
  String? email;
  String? accessToken;

  UserModel({this.id,  this.email,this.accessToken});
  UserModel.fromJson(Map<String, dynamic> userMap){
    id = userMap['id']?.toString();
    email= userMap['email'];
    accessToken= userMap['access_token'];
  }
}