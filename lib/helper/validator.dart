Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

class Validator {
  static String name(String value) {
    if (value.isEmpty) return 'Nama barang harus diisi'; 
    else if (value.length < 2 ) return 'Nama terlalu pendek';
    return null;
  }
  static String role(String value) {
    if (value.isEmpty) return 'Role harus dimasukkan'; 
    return null;
  }
  static String fullname(String value) {
    if (value.isEmpty) return 'Nama karyawan harus diisi'; 
    else if (value.length < 2 ) return 'Nama karyawan terlalu pendek';
    return null;
  }
  static String supplier(String value) {
    if (value.isEmpty) return 'Nama pemasok harus diisi'; 
    else if (value.length < 2 ) return 'Nama pemasok terlalu pendek';
    return null;
  }
  static String email(String value) {
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return 'Harap masukkan surel / email anda';
    else if (!regex.hasMatch(value)) return 'surel / email tidak valid';
    return null;
  }
  static String password(String value) {
    if (value.isEmpty) return 'Kata sandi harus diisi';
    else if (value.length < 5) return 'Kata sandi minimal 5 karakter';
    return null;
  }
  static String passwordLogin(String value) {
    if (value.isEmpty) return 'Harap masukkan kata sandi';
    return null;
  }
  static String telephone(String value) {
    if (value.isEmpty) return 'Nomor telepon harus diisi';
    else if (value.length < 10) return 'Nomor telepon minimal 10 digit';
    else if (value.length > 13) return 'Nomor telepon maksimal 13 digit';
    return null;
  }
  static String date(String value) {
    if (value.isEmpty) return 'Tanggal harus dimasukkan';
    return null;
  }

  static String payDate(String value) {
    if (value.isEmpty) return 'Tanggal pembayaran harus dipilih';
    return null;
  }
  static String address(String value) {
    if (value.isEmpty) return 'Alamat lengkap harus diisi';
    else if (value.length < 10) return 'Alamat kurang lengkap';
    return null;
  }
  static String textPayment(String value) {
    if (value.isEmpty) return 'Bukti pembayaran harus diisi';
    else if (value.length < 20) return 'Bukti pembayaran tidak lengkap';
    return null;
  }
  static String noRekening(String value) {
    if (value.isEmpty) return 'Nomor rekening harus diisi';
    else if (value.length < 10) return 'Nomor rekening tidak lengkap';
    return null;
  }
  static String quantity(String value) {
    if (value.isEmpty) return 'Jumlah barang harus dimasukkan';
    else if (value.length == 0) return 'Jumlah barang tidak valid';
    return null;
  }
}
