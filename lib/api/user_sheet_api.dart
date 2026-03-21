import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';

class UserSheetsApi {
  static const _credentials = r'''
 {
  "type": "service_account",
  "project_id": "gsheet-490820",
  "private_key_id": "5f11e0d3aeeab14bdd8e8d903c4b68089e9d44df",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDAuoRqDfw4OGOf\n6l5ne4TmKfoXEteWevLaxZLjIqlwj3kLosJUfY6HQRqzFoX/H4ZWsMeBA7tm2fcD\n2DMzUdbNtmPu1Myy22wSaUFetOyQFtUwXVncjRsMdZXwIPuk+OwSbmuS9f2gv/TL\nGZiF243VWKa2qvPPhvaeF9PbvNG8FG8+rgh3J8VAxJtpFRAeHpuLsI1AR9ng9KE7\n9mNazaAxbupgR6IybUUbT+ueO5DpzT6r8CTs3dIm0HwlqroYrdr1er4QQ3tiwCjw\nVs3S7mJRkr/GiadbAIhnxADHEszTeqhovHofusYwomG8+hq3SgNKSArGNQrISXua\nPnfbPIORAgMBAAECggEAKghDmrGkIUrDB3xgzGbW7C+ZeHDGje4Qiv/t8hV8KK1R\ns+TyRuT/MaZUQVyXKrXgYYW6bPu4Yk0FH1SGjhm6JDE0CEFmx1ctcbJ87D+/HAmu\nwxaI453umUAHzFAVMbyMF9T3Jxz5DJbwt17EseTZQP9NlKch90+y93Ww4cqDX2Yg\nkShdyQZHQQzilZKMkpZqC158/JkHmWl0Cw+SIenffsXnowEtvd4Ohe8wB0VjGeaQ\ng6YCVfC94CqIgZaEG3CGeIf3UqOT3WNPzuSND8KLu33TF2qCfMFdB+UmLmEAryy8\nxtBsDMceeMQ7Ybd+U7HId4BVqG7ckO3ibNS7TbHGtQKBgQDlUeuMq6VMN9A8sKO1\nHb5GfcFDs07Pbj2M30NFRXhseM29mhKVIx0QfuueqBr8MTa099LIf3SnbELxnHYo\n4uRxnISgbdr4xna1OdqxotWn/buKLhqrIc99kQJA0lQ/bVG3cAmr9bDiMOS9hNbQ\nFJMbvfFLu0uDRRxq5q/cvVo6pwKBgQDXJsGbYfpKnz39ffq2F/upb7fvtU7LZNno\ndA/2xzkzNUg0TGYT3XiR0be2UqW5QQn74aupxHTLWuI2MQedzV98/qWgf440G5gc\n7lek97PKkm3deDyoTmaU7VJA2d/v40KAP582mVDZWBUdkPpdS5yphI0aVqXhSRCr\nkFdrjkXvBwKBgQCEMhlr2ndL3ND6a4m0GxVZZZ1H/dHs2kw5LWuGP2oQfgN8zZjw\nyHE01TXXHGmSAHzdDhBA7Ni+uzZMOjoTj9jJdcUvBqU4zJAaIOPli01HromyOqm9\nBZyrcjCuVZGjjs2QxdGNg/EYM79pUW7UPUggsfqsAaiiX/Dl3156Dd45+QKBgBly\n9CO1Cy4Yd/SsGiO/4nzAQjmQcKmOXFgqoljGZ/Wur8O/5bMj10coT1q5m/C1yMCK\niQujuUz0ix1t30DDMjBOzriVXfS77to9NxDEW/fyKhywRDyESY4EJF6XZu2xLASP\ngf2rVOzghl7g7zxp3TYP/8DFzwk+40Hn6O9H/O2xAoGBALirIw1048aJOCyCK5EH\nBYmVl+2ib825o25UnEZ0S/oM9X0fxpRv8Kxp5lkRG3OCJ9QP+mYEFstTV+BpUFSe\nmlvLWo4vijn7LAZ5gD+XfRqf/KnwrztLtuDp01YGh/J1njY0nVKkl5kMOAbd5SZD\ndYKuxftPhxw4PBPI378Qg70l\n-----END PRIVATE KEY-----\n",
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
  static final _gsheet = GSheets(_credentials);

  static Worksheet? _userSheet;
  static Worksheet? _announcementSheet;

  /// ✅ Initialize all sheets
  static Future init() async {
    final spreadsheet = await _gsheet.spreadsheet(_spreadsheet);

    // Initialize Sheet1 (users)
    _userSheet = await _getWorkSheet(spreadsheet, title: 'Sheet1');

    // Initialize Announcement sheet
    _announcementSheet = await _getWorkSheet(spreadsheet, title: 'Announcement');

    // Ensure header exists for Announcement
    final header = await _announcementSheet!.values.row(1);
    if (header.isEmpty) {
      await _announcementSheet!.values.insertRow(1, ['Date', 'Announcement']);
    }
  }

  /// ✅ Helper to get or create worksheet
  static Future<Worksheet> _getWorkSheet(Spreadsheet spreadsheet,
      {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  /// ✅ Add new Announcement with current date
  static Future<bool> addAnnouncement(String announcementText) async {
    if (_announcementSheet == null) await init();

    try {
      final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await _announcementSheet!.values.appendRow([currentDate, announcementText]);
      return true;
    } catch (e) {
      print('Error adding announcement: $e');
      return false;
    }
  }

  //Login only no create account
  static Future<Map<String, String>?> login(
      String admissionNo, String password) async {
    if (_userSheet == null) return null;

    final rows = await _userSheet!.values.map.allRows();
    if (rows == null) return null;

    for (var row in rows) {
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
    if (rows == null) return null;

    for (var row in rows) {
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
    if (rows == null) return false;

    for (int i = 0; i < rows.length; i++) {
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
    if (rows == null) return false;

    for (int i = 0; i < rows.length; i++) {
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

  

  /// ✅ Initialize Announcement Sheet
  static Future initAnnouncementSheet() async {
    final spreadsheet = await _gsheet.spreadsheet(_spreadsheet);
    _announcementSheet = await _getWorkSheet(spreadsheet, title: 'Announcement');

    // Check if header exists, if not, set header
    final header = await _announcementSheet!.values.row(1);
    if (header.isEmpty) {
      await _announcementSheet!.values.insertRow(1, ['Date', 'Announcement']);
    }
  }


}
