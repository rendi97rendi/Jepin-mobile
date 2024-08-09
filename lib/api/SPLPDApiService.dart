class SPLPDApiService {
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
  static const String baseAPI = 'https://splp.pontianak.go.id/api/v3/';
  static const String apiKey = '88A85B213645AE4B5F0A1207A7D3A3A9';
  // ! TUTUP BASE

  // ! MASTER
  static const String setting = baseAPI + "jepin-pengaturan-66989c3a2f8d9";
  // ! TUTUP MASTER

  // ! AUTHENTIFICATION
  static const String kebijakanPrivasi = baseAPI + "/p/5-kebijakan-privasi"; //? Method GET 
  static const String register = baseAPI + "register"; //? Method POST, Param body=name, username, email, password, confirmation_password
  static const String login = baseAPI + "jepin-login-66986a266396f"; //? Method POST, Param body=email, password
  static const String sendEmail = baseAPI + "user/kirim-email"; //? Method POST, Param body=email
  static const String getCode = baseAPI + "user/ambil-kode"; //? Method GET, Param=email => Endpoint/{email}
  static const String sendCode = baseAPI + "user/kirim-kode"; //? Method POST, Param body=email,code
  static const String updatePassword = baseAPI + "user/update-password"; //? Method POST, Param body=email,code
  // ! TUTUP AUTHENTIFICATION

  // ! HOME
  static const String carousel = baseAPI + "jepin-slider-6698b3f22f4b0"; //? Method GET
  static const String menuSmartcity = baseAPI + "jepin-menu-smartcity-6698b7734945f"; //? Method GET
    // ! MORE
    static const String hargaPangan = baseAPI + "jepin-pangan-66a73d2620d73"; //? Method GET
    static const String teleponPenting = baseAPI + "telepon-penting"; //? Method GET

  // ! TUTUP HOME

  // ! DESTINASI
    // ! EVENT
    static const String daftarEvent = baseAPI + "jepin-event-6698b8008300a"; //? Method GET
    static const String detailEvent = baseAPI + "jepin-detail-event-6698b9932880f/"; //? Method GET, Param=id => Endpoint/{id}
    // ! WISATA
    static const String daftartWisata = baseAPI + "jepin-wisata-6698bdf42584e"; //? Method GET, Param=page/search => Endpoint/{page/search}
    static const String kategoriWisata = baseAPI + "jepin-kategori-wisata-6698be4bcbe89"; //? Method GET
    static const String detailWisata = baseAPI + "wisata"; //? Method GET, Param=id => Endpoint/{id}
    static const String gambarWisata = "/uploads/infoWisata/"; //? Method GET, Param=nama-gambar => Endpoint/{nama-gambar}
    static const String penilaianWisata = baseAPI + "wisata/nilai"; //? Method GET, Param=id => Endpoint/{id}
    static const String tambahPenilaianWisata = baseAPI + "wisata/tambah-nilai"; //? Method POST, Param body=rating, komentar, wisata_id, user_id
    static const String hapusPenilaianWisata = baseAPI + "wisata/hapus-nilai"; //? Method POST, Param body= id
    // ! PENGINAPAN
    static const String daftarPenginapan = baseAPI + "jepin-penginapan-6698cbd86eaa8"; //? Method GET, Param=page/search => Endpoint/{page/search}
    static const String kategoriPenginapan = baseAPI + "jepin-kategori-penginapan-6698cc183dee2"; //? Method GET
    static const String detailPenginapan = baseAPI + "jepin-detail-penginapan-6698cc52ec7a4"; //? Method GET, Param=id => Endpoint/{id}
    static const String gambarPenginapan = "/uploads/infoHotelRestoran/"; //? Method GET, Param=nama-gambar => Endpoint/{nama-gambar}
    static const String penilaianPenginapan = baseAPI + "jepin-nilai-penginapan-6698ccd718ebe"; //? Method GET, Param=id => Endpoint/{id}
    static const String tambahPenilaianPenginapan = baseAPI + "jepin-tambah-nilai-penginapan-6698cd2f5e8d0"; //? Method POST, Param body=rating, komentar, wisata_id, user_id
    static const String hapusPenilaianPenginapan = baseAPI + "penginapan/hapus-nilai"; //? Method POST, Param body= id
    // ! RESTORAN
    static const String daftarRestoran = baseAPI + "jepin-restoran-669ef89bbed2e"; //? Method GET, Param=page/search => Endpoint/{page/search}
    static const String kategoriRestoran = baseAPI + "jepin-kategori-restoran-669ef9501d16e"; //? Method GET
    static const String detailRestoran = baseAPI + "restoran"; //? Method GET, Param=id => Endpoint/{id}
    static const String gambarRestoran = "/uploads/infoHotelRestoran/"; //? Method GET, Param=nama-gambar => Endpoint/{nama-gambar}
    static const String penilaianRestoran = baseAPI + "nilai-restoran"; //? Method GET, Param=id => Endpoint/{id}
    static const String tambahPenilaianRestoran = baseAPI + "tambah-nilai-restoran"; //? Method POST, Param body=rating, komentar, wisata_id, user_id
    static const String hapusPenilaianRestoran = baseAPI + "hapus-nilai-restoran"; //? Method POST, Param body=id
    // ! Oleh-Oleh
    static const String daftartOlehOleh = baseAPI + "jepin-oleh-oleh-66b41897cb3bc"; //? Method GET, Param=page/search => Endpoint/{page/search}
    static const String kategoriOlehOleh = baseAPI + "jepin-kategori-oleh-oleh-66b418cedde3a"; //? Method GET
    static const String detailOlehOleh = baseAPI + "jepin-detail-oleh-oleh-66b4190fd8399"; //? Method GET, Param=id => Endpoint/{id}
    static const String gambarOlehOleh = "jepin-gambar-oleh-oleh-66b41a68561cc"; //? Method GET, Param=nama-gambar => Endpoint/{nama-gambar}
    static const String penilaianOlehOleh = baseAPI + "jepin-nilai-oleh-oleh-66b41aa59e638"; //? Method GET, Param=id => Endpoint/{id}
    static const String tambahPenilaianOlehOleh = baseAPI + "jepin-tambah-nilai-oleh-oleh-66b41b028b2dd"; //? Method POST, Param body=rating, komentar, wisata_id, user_id
    static const String hapusPenilaianOlehOleh = baseAPI + "jepin-hapus-nilai-oleh-oleh-66b41b3a1e667"; //? Method POST, Param body= id
  // ! TUTUP DESTINASI

  // ! BERITA
  static const String berita = baseAPI + "jepin-berita-pemkot-669efd26a9383"; //? Method GET
  static const String beritaTerbaru = baseAPI + "berita-pemkot-terkini-659b5a6cf2d33"; //? Method GET
  static const String daftarBerita = baseAPI + "berita"; //? Method GET, Param=page,q
  static const String detailBerita = baseAPI + "jepin-detail-berita-kota-66b48674f1edb"; //? Method GET, Param=id => Endpoint/{id}
  static const String gambarDetailBerita = baseAPI + "/file/berita/"; //? Method GET, Param=id => Endpoint/{id}
  static const String pencarianBerita = baseAPI + "cari"; //? Method GET, Param=page,q
  // ! TUTUP BERITA

  // ! PENGATURAN
    // ! PROFILE
    static const String userProfile = baseAPI + "user/profil"; //? Method POST, Param body=bearer_token
    static const String userUpdateProfile = baseAPI + "user/update";//? Method POST, Param body=bearer_token, name, username, email
    static const String userDeleteProfile = baseAPI + "user/delete"; //? Method POST, Param body=bearer_token, id
    // ! FEEDBACK
    static const String feedback = baseAPI + 'feedback'; //? Method GET
    static const String sendFeedback = baseAPI + 'feedback/send'; //? Method POST, Param body=user_id,pesan
  // ! TUTUP PENGATURAN

  // ! TAMBAHAN
  static const String imagePlaceholder = "https://www.logistec.com/wp-content/uploads/2017/12/placeholder.png";
  // static const String imagePlaceholder = baseAPI + "jepin-image-placeholder-669f04669efbe"; // ! Tidak digunakan
  static const String aplikasi = baseAPI + "aplikasi"; //? Method GET
  static const String map = 'http://alpha3.pontive.web.id/api/map'; //? Method GET
  // ! TUTUP TAMBAHAN
}
