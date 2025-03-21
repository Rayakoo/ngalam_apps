class UserEntity {
  final String nomer_induk_kependudukan;
  final String name;
  final String email;
  final String password;
  final String photoProfile;
  final String address;
  final String role; 

  UserEntity({
    required this.nomer_induk_kependudukan,
    required this.name,
    required this.email,
    required this.password,
    this.photoProfile =
        'https://th.bing.com/th/id/OIP.hGSCbXlcOjL_9mmzerqAbQHaHa?w=182&h=182&c=7&r=0&o=5&dpr=1.3&pid=1.7', // Default photo profile URL
    this.address = '-', // Default address
    this.role = 'user', // Default role
  });
}
