class ApiService {
  static var imagePlaceholder =
      "https://www.logistec.com/wp-content/uploads/2017/12/placeholder.png";

  static var baseUrl = "https://jepin.pontianak.go.id";
  static var baseUrl2 = "https://jepin.pontianak.go.id/";
  static var baseApi = "https://jepin.pontianak.go.id/api/";
  static var basePemkot = 'https://pontianak.go.id/';
  static var basePemkotApi = 'https://pontianak.go.id/api/';

  static var setting = baseApi + "pengaturan"; //method get
  static var kebijakanPrivasi = baseUrl + "/p/5-kebijakan-privasi"; //method get
  static var carousel = baseApi + "slider"; //method get
  static var homeMenu = baseApi + "menu"; //method get

  static var event = baseApi + "event"; //method get
  static var eventDetail = baseApi + "event"; //method get, .../{id}

  static var foodInfo = baseApi + "info_pangan"; //method get

  static var tourismCategory = baseApi + "kategori_info_wisata"; //method get
  static var tourismList =
      baseApi + "info_wisata"; //method get, param : page, search
  static var tourismDetail = baseApi + "info_wisata"; //method get, .../{id}
  static var tourismReviewList =
      baseApi + "detail_tourism_review"; //method get, .../{id}
  static var tourismReviewCreate = baseApi +
      "create_tourism_review"; //method POST, param : rating, komentar, wisata_id, user_id
  static var tourismReviewDelete =
      baseApi + "delete_tourism_review"; //method POST, param : id
  static var urlImageTourism = "/uploads/infoWisata/";

  static var hotelCategory = baseApi + "kategori_info_hotel"; //method get
  static var hotelList =
      baseApi + "info_hotel"; //method get, param : page, search
  static var hotelDetail = baseApi + "info_hotel"; //method get, .../{id}
  static var hotelReviewList =
      baseApi + "detail_hotel_review"; //method get, .../{id}
  static var hotelReviewCreate = baseApi +
      "create_hotel_review"; //method POST, param : rating, komentar, wisata_id, user_id
  static var hotelReviewDelete =
      baseApi + "delete_hotel_review"; //method POST, param : id
  static var urlImageHotel = "/uploads/infoHotelRestoran/";

  static var restaurantCategory =
      baseApi + "kategori_info_restoran"; //method get
  static var restaurantList =
      baseApi + "info_restoran"; //method get, param : page, search
  static var restaurantDetail =
      baseApi + "info_restoran"; //method get, .../{id}
  static var restaurantReviewList =
      baseApi + "detail_restaurant_review"; //method get, .../{id}
  static var restaurantReviewCreate = baseApi +
      "create_restaurant_review"; //method POST, param : rating, komentar, wisata_id, user_id
  static var restaurantReviewDelete =
      baseApi + "delete_restaurant_review"; //method POST, param : id
  static var urlImageRestaurant = "/uploads/infoHotelRestoran/";
  static String teleponPenting = baseApi + "teleponpenting";
  // static var feedback = baseApi + "feedback/send";

  static var berita = basePemkotApi + "berita"; //method get
  static var latest = basePemkotApi + "berita/latest"; //method get
  static var newsList = baseApi + "berita"; //method get, param : page, q
  static var newsDetail = baseApi + "berita"; //method get, param : .../{id}
  static var newsDetailImage = basePemkot + "/file/berita/"; //method get, param : .../{id}

  static var search = baseApi + "cari"; //method get, param : page, q

  static var application = baseApi + "aplikasi"; //method get

  static var userRegister = baseApi +
      "register"; //method post, param : name, username, email, password, c_password
  static var userLogin =
      baseApi + "login"; //method post, param : email, password
  static var userProfile =
      baseApi + "details"; //method post, param : bearer token
  static var userUpdateProfile = baseApi +
      "user/update"; //method post, param : bearer token, name, username, email
  static var userDeleteProfile =
      baseApi + "user/delete"; //method post, param: bearer token, id
  static var feedback = baseApi + 'feedback';
  static var sendFeedback = baseApi + 'feedback/send';
  static var sendEmail = baseApi + "user/kirim-email"; //method post, param : email
  static var getCode = baseApi + "user/ambil-kode"; //method get, param : email
  static var sendCode = baseApi + "user/send-kode"; //method post, param : email,code
  static var updatePassword = baseApi + "user/update-password"; //method post, param : email,code
      

  static var map = 'http://alpha3.pontive.web.id/api/map';
}
