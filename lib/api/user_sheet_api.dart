import 'dart:convert';

import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSheetsApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "gsheet-490820",
  "private_key_id": "6ca6ea04cdcabda74dfa0361861194919ae0e4e5",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC2ZEr0PyW5CiM8\nf3V2tj1YKPotuVRvUkBcP6MaUzOtUSTqXuWdgxvPMvcHtimMv52ma9qvSFqereQR\niKj7JMS935AnNrnr/yAniuN5jQnG6B0yM162jniQjw7ZgalofYTsoF4eoWXl90rX\noq0dK9NjJ6N6kD4LvLNlTwsaFqeZf/Pyj/25uSwjSDbxnZAbvSENnyfG6SpyKO7q\nKURme2JQC9Tmr2NQsctIqLF42bx78s6jXzteiZIDsD4bAIDwgmwsP17BuL+0TWtW\n9TBS4H4Z3Hjd4T8WVQefvSpJ/d+0LAMVYPUTr+QhZ6PQDD4Qglyv3kbr6oqu3oWU\nBqD9P5M/AgMBAAECggEAA/YQUqxUa2e29YdnIQQ64ivxqFs6uY2LFvXNhbLXj89l\nV9m7xDymtqH1ZNYl94fp1UVzuGl/3lZfJP+s0SzZQQPBTmNijPzmJosI/wjQdODG\n/Dd1ZSLu/LoT/nv8a+fd99hRHaUvtgY1j+gD49BMhP4auidhJuwa5qZdfVw57kbP\nE1w1yU2EXiiURSjQ8FKrRd9ItGjL1gEpEqTCLEHJVkOSMNVlpvW0BgMZ0dI2k/Sg\n7DaSruH/uNQUrz0RojRnbPtoptz78BdA1qLg5HcpI2OwZ2R6+Z7CDvAHcTJsktZA\nBn1cI4v9HTkD064pLSULeLGfirNKZx9U1D04RYuW4QKBgQDYv5CBGV9vMJmpLxUz\n2eek8DdV9xot2Ixh05lY/Bf3rGEjVpw7xrv/Hd9NG56EOX3K1+/NjFtOMdSzaC0v\nGBhouck22WMWP1k9Qndl0wwM7Wqg0q5Wi1dijPSsIm6B61qOMIqjaUViptclhtwS\nwLLOAOC/hUXIAhJFxS0dMUpABwKBgQDXa/ZJokZAqdkpzhaNNsDQT8kzHGYGSdCE\nQBSCUJ2k55w5GqQIqKb2TjJXIOmcl0Dv+od9JaH8U6G28kzeJYHSRqphiJhOQS4M\nKprkoxKf9UJHPgAAgZDylmyyNpKGchkBaTRVGYvXO9SH/j+5C8i7VfFgQNfhxr7U\nFueSaFdVCQKBgQC40sEaFNS4L60YAzoFOO66Sswk1czRAzLRyGme43hcjfVW+OfI\nYTK13HcpfT+yaIPHkFK/58uD5iIFyfOdkOJfiuz1hHFl6ybhgefmQAyqiVi/Qme/\nDJq7Qo7wqXup9VMGpIXTylSMRtB3A4RtyTuvRjhfl/llD78dF4HcvscdyQKBgF3I\nN4FY7wKprsv/V1wE0S4e/fWNUHE+Y1Of3g3ZcLfgyOcnTPAkFAO4iTvbLTiptHCE\n/cUixAFom0dc9s/jPkA/2V76q2ut/pD3X1VYFPykNkVznWabAXJKwGlZTrLPK0ms\n9kZyB6oc9up5al5x3eKIiLuhnxpAfsUwb4ISgKqZAoGAYbdbzfZ3BWYLssWM9OyF\nen5vzceolJYeFu0tZS7h6zI0Nq6lHvnps0JVdVQRjoc0uds/+8JhARvVCnPe+gLM\nzvSUFjEMwJHf0vDeIV5y+bq4jp1jUCeCG1DQlmLSjWrPoeYFDX/hCordPl77gAOS\njU7nSZXGKrdAMgXVewdVXwE=\n-----END PRIVATE KEY-----\n",
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
  static Worksheet? _complaintSheet;
  static Worksheet? _feedbackSheet;


  static Future init() async {
    final spreadsheet = await _gsheet.spreadsheet(_spreadsheet);

    // Initialize Sheet1 (users)
    _userSheet = await _getWorkSheet(spreadsheet, title: 'Sheet1');

    // Initialize Announcement sheet
    _announcementSheet = await _getWorkSheet(spreadsheet, title: 'Announcement');

    _complaintSheet = await _getWorkSheet(spreadsheet, title: 'Complaint');

    // Ensure header exists for Announcement
    final header = await _announcementSheet!.values.row(1);
    if (header.isEmpty) {
      await _announcementSheet!.values.insertRow(1, ['Date', 'Announcement']);
    }

    // Complaint header
    final complaintHeader = await _complaintSheet!.values.row(1);
    if (complaintHeader.isEmpty) {
      await _complaintSheet!.values.insertRow(1, [
        'Admission No',
        'Complaint Type',
        'Description',
        'ImageURL',
        'Status'
      ]);
    }

    // Initialize Feedback sheet
    _feedbackSheet = await _getWorkSheet(spreadsheet, title: 'Feedback');

// Ensure header exists
    final feedbackHeader = await _feedbackSheet!.values.row(1);
    if (feedbackHeader.isEmpty) {
      await _feedbackSheet!.values.insertRow(1, [
        'Admission No',
        'Date',
        'Rating',
        'Feedback'
      ]);
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


  /// ✅ ADD USER FEEDBACK
  static Future<bool> addFeedback({
    required int rating,
    required String feedbackText,
  }) async {
    if (_feedbackSheet == null) await init();

    try {
      final prefs = await SharedPreferences.getInstance();

      // 🔹 Get current user
      final userDataString = prefs.getString('user');
      if (userDataString == null) return false;

      final currentUser =
      Map<String, dynamic>.from(jsonDecode(userDataString));

      final admissionNo = currentUser['Admission No'];

      // 🔹 Current Date
      final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // 🔹 Append feedback row
      await _feedbackSheet!.values.appendRow([
        admissionNo,
        currentDate,
        rating.toString(), // store as string
        feedbackText,
      ]);

      return true;
    } catch (e) {
      print("Error adding feedback: $e");
      return false;
    }
  }
  /// ✅ Add new Announcement with current date
  static Future<bool> addAnnouncement(String announcementText , String header) async {
    if (_announcementSheet == null) await init();

    try {
      final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await _announcementSheet!.values.appendRow([currentDate, announcementText , header]);
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
          column: 5, // Password column index
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

  /// ✅ GET ROOMMATE DATA & SAVE IN SHARED PREFERENCES
  static Future<Map<String, String>?> getRoommate() async {
    if (_userSheet == null) await init();

    try {
      final prefs = await SharedPreferences.getInstance();

      // 🔹 Get current user data from SharedPreferences
      final userDataString = prefs.getString('user');
      if (userDataString == null) return null;

      final currentUser = Map<String, dynamic>.from(jsonDecode(userDataString));

      final hostelBlock = currentUser['Hostel Block'];
      final roomNumber = currentUser['Room Number'];
      final admissionNo = currentUser['Admission No'];

      // 🔹 Fetch all rows from sheet
      final rows = await _userSheet!.values.map.allRows();
      if (rows == null) return null;

      // 🔹 Find roommate
      for (var row in rows) {
        if (row['Hostel Block'] == hostelBlock &&
            row['Room Number'] == roomNumber &&
            row['Admission No'] != admissionNo) {

          // ✅ Save roommate data in SharedPreferences
          await prefs.setString('roommate', jsonEncode(row));

          return row;
        }
      }

      return null; // No roommate found
    } catch (e) {
      print("Error fetching roommate: $e");
      return null;
    }
  }

  static Future<bool> addComplaint({
    required String complaintType,
    required String description,
    required String imageUrl,
  }) async {
    if (_complaintSheet == null) await init();

    try {
      final prefs = await SharedPreferences.getInstance();

      // 🔹 Get current user data
      final userDataString = prefs.getString('user');
      if (userDataString == null) return false;

      final currentUser =
      Map<String, dynamic>.from(jsonDecode(userDataString));

      final admissionNo = currentUser['Admission No'];

      // 🔹 Default status
      const status = "Pending";

      // 🔹 Insert into sheet
      await _complaintSheet!.values.appendRow([
        admissionNo,
        complaintType,
        description,
        imageUrl,
        status,
      ]);

      return true;
    } catch (e) {
      print("Error adding complaint: $e");
      return false;
    }
  }

  /// ✅ GET ALL COMPLAINTS OF CURRENT USER
  static Future<List<Map<String, String>>> getMyComplaints() async {
    if (_complaintSheet == null) await init();

    try {
      final prefs = await SharedPreferences.getInstance();

      // 🔹 Get current user
      final userDataString = prefs.getString('user');
      if (userDataString == null) return [];

      final currentUser =
      Map<String, dynamic>.from(jsonDecode(userDataString));

      final admissionNo = currentUser['Admission No'];

      // 🔹 Fetch all complaints
      final rows = await _complaintSheet!.values.map.allRows();
      if (rows == null) return [];

      List<Map<String, String>> myComplaints = [];

      for (var row in rows) {
        if (row['Admission No'] == admissionNo) {
          myComplaints.add(row);
        }
      }

      print(myComplaints);
      return myComplaints;
    } catch (e) {
      print("Error fetching complaints: $e");
      return [];
    }
  }

  /// ✅ GET ALL ANNOUNCEMENTS
  static Future<List<Map<String, String>>> getAnnouncements() async {
    if (_announcementSheet == null) await init();

    try {
      final rows = await _announcementSheet!.values.map.allRows();
      if (rows == null) return [];

      List<Map<String, String>> announcements = [];

      for (var row in rows) {
        announcements.add({
          'date': row['Date'] ?? '',
          'announcement': row['Announcement'] ?? '',
          'header': row['Header'] ?? ''
        });
      }

      return announcements;
    } catch (e) {
      print("Error fetching announcements: $e");
      return [];
    }
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
