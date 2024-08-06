class ApiServices {
  /*
    DAFTAR API
      - Base
      - Master
      - Authentification
      - Home
      - Destinasi
      - Berita
      - Pengaturan
      - Tambahan
  */

  // ! BASE
  static const String baseJepin = 'https://jepin.pontianak.go.id';
  static const String baseJepin2 = 'https://jepin.pontianak.go.id/';
  static const String baseJepinApi = 'https://jepin.pontianak.go.id/api/';
  static const String basePemkot = 'https://pontianak.go.id/';
  static const String basePemkotApi = 'https://pontianak.go.id/api/';
  // ! TUTUP BASE

  // ! MASTER
  static const String setting = baseJepinApi + "pengaturan";
  // ! TUTUP MASTER

  // ! AUTHENTIFICATION
  static const String kebijakanPrivasi = baseJepinApi + "/p/5-kebijakan-privasi"; //? Method GET 
  static const String register = baseJepinApi + "register"; //? Method POST, Param body=name, username, email, password, confirmation_password
  static const String login = baseJepinApi + "login"; //? Method POST, Param body=email, password
  static const String sendEmail = baseJepinApi + "user/kirim-email"; //? Method POST, Param body=email
  static const String getCode = baseJepinApi + "user/ambil-kode"; //? Method GET, Param=email => Endpoint/{email}
  static const String sendCode = baseJepinApi + "user/kirim-kode"; //? Method POST, Param body=email,code
  static const String updatePassword = baseJepinApi + "user/update-password"; //? Method POST, Param body=email,code
  // ! TUTUP AUTHENTIFICATION

  // ! HOME
  static const String carousel = baseJepinApi + "slider"; //? Method GET
  static const String menuSmartcity = baseJepinApi + "menu-smartcity"; //? Method GET
    // ! MORE
    static const String hargaPangan = baseJepinApi + "pangan"; //? Method GET
    static const String teleponPenting = baseJepinApi + "telepon-penting"; //? Method GET

  // ! TUTUP HOME

  // ! DESTINASI
    // ! EVENT
    static const String daftarEvent = baseJepinApi + "event"; //? Method GET
    static const String detailEvent = baseJepinApi + "event/"; //? Method GET, Param=id => Endpoint/{id}
    // ! WISATA
    static const String daftartWisata = baseJepinApi + "wisata"; //? Method GET, Param=page/search => Endpoint/{page/search}
    static const String kategoriWisata = baseJepinApi + "wisata/kategori"; //? Method GET
    static const String detailWisata = baseJepinApi + "wisata"; //? Method GET, Param=id => Endpoint/{id}
    static const String gambarWisata = "/uploads/infoWisata/"; //? Method GET, Param=nama-gambar => Endpoint/{nama-gambar}
    static const String penilaianWisata = baseJepinApi + "wisata/nilai"; //? Method GET, Param=id => Endpoint/{id}
    static const String tambahPenilaianWisata = baseJepinApi + "wisata/tambah-nilai"; //? Method POST, Param body=rating, komentar, wisata_id, user_id
    static const String hapusPenilaianWisata = baseJepinApi + "wisata/hapus-nilai"; //? Method POST, Param body= id
    // ! PENGINAPAN
    static const String daftarPenginapan = baseJepinApi + "penginapan"; //? Method GET, Param=page/search => Endpoint/{page/search}
    static const String kategoriPenginapan = baseJepinApi + "kategori-penginapan"; //? Method GET
    static const String detailPenginapan = baseJepinApi + "penginapan"; //? Method GET, Param=id => Endpoint/{id}
    static const String gambarPenginapan = "/uploads/infoHotelRestoran/"; //? Method GET, Param=nama-gambar => Endpoint/{nama-gambar}
    static const String penilaianPenginapan = baseJepinApi + "penginapan/nilai"; //? Method GET, Param=id => Endpoint/{id}
    static const String tambahPenilaianPenginapan = baseJepinApi + "penginapan/tambah-nilai"; //? Method POST, Param body=rating, komentar, wisata_id, user_id
    static const String hapusPenilaianPenginapan = baseJepinApi + "penginapan/hapus-nilai"; //? Method POST, Param body= id
    // ! RESTORAN
    static const String daftarRestoran = baseJepinApi + "restoran"; //? Method GET, Param=page/search => Endpoint/{page/search}
    static const String kategoriRestoran = baseJepinApi + "kategori-restoran"; //? Method GET
    static const String detailRestoran = baseJepinApi + "restoran"; //? Method GET, Param=id => Endpoint/{id}
    static const String gambarRestoran = "/uploads/infoHotelRestoran/"; //? Method GET, Param=nama-gambar => Endpoint/{nama-gambar}
    static const String penilaianRestoran = baseJepinApi + "nilai-restoran"; //? Method GET, Param=id => Endpoint/{id}
    static const String tambahPenilaianRestoran = baseJepinApi + "tambah-nilai-restoran"; //? Method POST, Param body=rating, komentar, wisata_id, user_id
    static const String hapusPenilaianRestoran = baseJepinApi + "hapus-nilai-restoran"; //? Method POST, Param body=id
  // ! TUTUP DESTINASI

  // ! BERITA
  static const String berita = basePemkotApi + "berita"; //? Method GET
  static const String beritaTerbaru = basePemkotApi + "berita/latest"; //? Method GET
  static const String daftarBerita = baseJepinApi + "berita"; //? Method GET, Param=page,q
  static const String detailBerita = baseJepinApi + "berita"; //? Method GET, Param=id => Endpoint/{id}
  static const String gambarDetailBerita = basePemkot + "/file/berita/"; //? Method GET, Param=id => Endpoint/{id}
  static const String pencarianBerita = baseJepinApi + "cari"; //? Method GET, Param=page,q
  // ! TUTUP BERITA

  // ! PENGATURAN
    // ! PROFILE
    static const String userProfile = baseJepinApi + "user/profil"; //? Method POST, Param body=bearer_token
    static const String userUpdateProfile = baseJepinApi + "user/update";//? Method POST, Param body=bearer_token, name, username, email
    static const String userDeleteProfile = baseJepinApi + "user/delete"; //? Method POST, Param body=bearer_token, id
    // ! FEEDBACK
    static const String feedback = baseJepinApi + 'feedback'; //? Method GET
    static const String sendFeedback = baseJepinApi + 'feedback/send'; //? Method POST, Param body=user_id,pesan
  // ! TUTUP PENGATURAN

  // ! TAMBAHAN
  static const String imagePlaceholder = "https://www.logistec.com/wp-content/uploads/2017/12/placeholder.png";
  static const String aplikasi = baseJepinApi + "aplikasi"; //? Method GET
  static const String map = 'http://alpha3.pontive.web.id/api/map'; //? Method GET
  // ! TUTUP TAMBAHAN
}
