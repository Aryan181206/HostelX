import 'package:gsheets/gsheets.dart';

class UserSheetsApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "gsheet-490820",
  "private_key_id": "a08d22687420e1ec18008ef793adeb0464e35465",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDN3X0T/ece+1bi\nC6Q7nVjReuDYP1KmchKDhSGSSIjFllMAQfUs7TvnY9WRBabG88WJ537bcx7VlvSV\nCszx1RXesVEAtTW2ndpVqWSTgoJpGvXfDB8QpoUq/ZvCji+vvuY3WIxGJwcuP6jW\nScBKwQy1rVXKb1RQolBM73OnaL98QRUX+Rutltaib06Dz5eEJlKom0XZzmaHNSh+\nab/uAryN/aXUk2nhawiNOMo0fHKZw4V/kycp6xrWg+rbuEahvlg800dcl2C4u0Op\nSJIddnVKXUBmaBTtjcl8pV3M5Yd1AlRzPOzxSbrg44nnoc4fVbztE6Me/WIRi2t4\nMxMD/jcrAgMBAAECggEATojsAffvN1UIAKUTSsDMlOGtLCIAHEpRQMZFl+I+9y3R\nTTxcVX7NRwlBfJks1iJCHklnjj1dKntzo/YiWDGDrdh0P/JhYuDWXa6JFXMI4CLu\nYGBl63qzO8LTLIYEsCWB+uQ3Yz3ZUe3sMY+iIYKDID3XiCovfrFlM+x3cQqXXkVg\npvIdho0xaIXVCb431m+vt3oEO+W7lhEnYjxRW7liRWU+jLJZ1IIzRAwooqqK6iF0\neOHnqfYnZUACDi/xoJ+kMo2m+rHzwi06VfcSTGBuC/tMCST0UydMloq7LOb0QYd4\nLX3eVRoD7lI60wKXPA0l2r0XBdDB3DO/5E8UEVyLrQKBgQDnIIPXE2BA0iwwP5RN\nnK4yg0SHlOJh9utkQLBsbjvnE3FhVNT2jpDYHASUZSNJYloW5qAFykpTlyKZOdor\nsBaPtgcOO/Gw2Fq29ZbyxaGcRfU2nkYt8MtiD/xHQshafMMlyKdTJc1uu8UQm5iG\nqZHC6QuqUIeKwX4S0VsJA+I+rQKBgQDkBQR0sfDVvazcF/6tAnXDigfTfcGI55Ti\nGayScgCS54vIIcxxPHqbW/0cNUovYPg/+qz5iJEk7G/e/CnjiwdFxIHHAYpo5p5B\n1F5g7z/HRfSWxgngOm4QmJl8chSvgwYllExCAf8YUzxPVWQLLebP3dF9ljEomTYf\nqfEOHgXANwKBgButYRxYTaZ1hKUid/fzU0jpP0OdKJ7imr2eoYHakYHSajlllzsP\nR3kZodLDab5X8MHdTDxlRRFNf+8pZl7k7062VZH2y7KJthNCxZi84eV82yh3O6A0\nvaY4k9VUwflUB2p25NKoLDmecrLSbylxFOtqTONQUWrkUNygBW7G8EjhAoGAH6TO\nnH9BQ/hhr92om0v3Gd7i/Se7nws8bzBO8bfeeoSlsm12WNSi00Kt2qdOl0qmyQI5\n1RttwSkK0XA/Q/O8W6NMu1hsY+h1V/9n5Z3uRPJhYjczkamqMqVqz4lpc34EcVym\nRJbQVwjeGshn7OE+4eQPuZUJV3ADwdsst9/UvnsCgYEAyK1TYgQ52DdTUsfCZ/V0\nmtECpeQ3rHGfqIGNIJfjyl9r3yt72IYyYrSOrISPdvGPX6DmrHnWCUJTk6UlPWxJ\nozMSK+Scbw2JZNYhrOcI9CPKDdxiYElpTzffg+CeU3HuiIMA02FBBRiUdKlqwZ83\nokt3NSpY68FLJ+y2+02c5MY=\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheet@gsheet-490820.iam.gserviceaccount.com",
  "client_id": "111531553876168319365",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheet%40gsheet-490820.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';
  static final _spreadsheet = '1NE-UpmkgvxAnUpYRuDi_IUMmx976M4q6jjjxlj4UuKM';
  static final _gsheet = GSheets(_credentials) ;
  static Worksheet? _userSheet ;


  static Future init() async{
    final spreadsheet = await _gsheet.spreadsheet(_spreadsheet) ;
    _userSheet = await _getWorkSheet(spreadsheet , title : 'Sheet1') ;
  }

  static Future<Worksheet> _getWorkSheet(
      Spreadsheet spreadsheet ,
      {required String title}) async {
    try{
      return await spreadsheet.addWorksheet(title) ;
    }catch (e) {
      return spreadsheet.worksheetByTitle(title)! ;
    }

  }

  //Login only no create account
  static Future<Map<String, String>?> login(
      String admissionNo, String password) async {
    if (_userSheet == null) return null;

    final rows = await _userSheet!.values.map.allRows();

    for (var row in rows!) {
      if (row['Admission No'] == admissionNo &&
          row['Password'] == password) {
        return row; // user found
      }
    }

    return null; // invalid login
  }

  /// ✅ GET SINGLE STUDENT DATA
  static Future<Map<String, String>?> getStudent(
      String admissionNo) async {
    final rows = await _userSheet!.values.map.allRows();

    for (var row in rows!) {
      if (row['Admission No'] == admissionNo) {
        return row;
      }
    }
    return null;
  }


  /// ✅ UPDATE PASSWORD
  static Future<bool> updatePassword(
      String admissionNo, String newPassword) async {
    final rows = await _userSheet!.values.map.allRows();

    for (int i = 0; i < rows!.length; i++) {
      if (rows[i]['Admission No'] == admissionNo) {
        // +2 because row index starts after header
        await _userSheet!.values.insertValue(
          newPassword,
          column: 4, // Password column index
          row: i + 2,
        );
        return true;
      }
    }
    return false;
  }

  /// ✅ UPDATE ROOM NUMBER
  static Future<bool> updateRoom(
      String admissionNo, String newRoom) async {
    final rows = await _userSheet!.values.map.allRows();

    for (int i = 0; i < rows!.length; i++) {
      if (rows[i]['Admission No'] == admissionNo) {
        await _userSheet!.values.insertValue(
          newRoom,
          column: 5, // Room Number column
          row: i + 2,
        );
        return true;
      }
    }
    return false;
  }

}