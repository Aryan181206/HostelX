import 'dart:convert';

import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSheetsApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "gsheet-490820",
  "private_key_id": "a492880210b38e4837a7df4504d1088e30da04fa",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCVeRBMT64HJ2lX\nw0U31Rc4CI/J7uObiu/cPO0wh8Gmm22+oVncsIl9nyxywlLRguvPiwOxssrj218s\n3wiZFkT0Z22cUlGHhfFrmtv7mmq5L//3xfnTT1q5mHgeZg/vHSrE2tzqcASajIe5\nj/BubPHRABW5CQec1cyF65/jBnCe9tQ6EJk5va0OorrnOPxTG7DQBIEApp7SDJTp\nHdDjaz79c6oebr2B5dbUPXosOpBhtws+cLowq9YXWmDO7hW2WA8oCLjQLDlYL/Gs\nkaKnaibx+4b8ZpWb91qd9IOQ9LguSt50UHLwWnNPwFkvXj8gFrLVnqKKhgqRVQK4\n87rqkd8ZAgMBAAECggEAAZ1ISkgKsqQVKgVUuuN6d+NLyPFjaZt+DLcRvsDwm//j\nbGLUvs1J/DPbEzWQbG00ESPzZcNvF+KXgWYP8zX/h6joUP8TR1nwf2oxmbg+EoL3\nX5yL9AwliDSiiNLZtYpEmydb/yI3l9hlt4uGRsMMIjw/KnueUUN+jSxm0oO6yqoO\nle4oE3RbNGx5iRapFVgd/uL4E/V1rzhyLFK3qG7dwNukKhgUR/FsHdqWZ8umU3jX\noWeSav30NxUwynAieFzZhrCljQaf1b/n342T1fUGeiH7m3CUA0Yh1qD/iATl9rxt\nQ7S/cw9WBD4gyS7+Cq2KalRtQMlDdZboekJU5jefcwKBgQDF8hyjvQFv9D8ieMU8\n+fu11gmeclrNB2IDq2jEy/MR9768BjPaKSoEsjslKDmCSZPa7zM+6/uIwCo+KxhT\nsFZjO0er+rsc1p5qwL1GznUTwRvXBr38Bc9Z631iplznPHE7Aw621R/OvQPVU2Me\n3AI/SQD7sDSqAGB5dPXkGf4TfwKBgQDBT5S3uPo0/B/6ewojhzmoCGYxPphhfTjr\n+4BfCjMXHuF3n7Tvg8I/vRcnm8OHFpHSXh2oomgih69848GohuKrL+bB2JK8h3Lr\n9jcS5hZ+IH4hnIA7H9a1IoVL0/Q6cVErUiYhrwwzhhYEcJX1aDd/1SB8KMsrkyxU\nR/qG3l95ZwKBgQDEEGZRwNp1m8YVTO6A0VOC7rikWryZrKBm5hdmJmVi/LPN5Y7i\nnjdiY2+2BDvCU0LCbn+h6XhCIaU14tW7v0QyEfuR204O6H4NW0+fnMvWf0YmHCV+\nRfr2JA0T85i96d52BzdB3aQd0JbFbE0Xue/340W4BvaDFNB6PWF5SE2j3QKBgQCj\nyPCBRVnBIMlbaXoqpf0E0LD9EkL7fqSG1J1saPDmqwRvXUJpGOKxLF388i2VPFsq\nuRE5+vhuITZfg31mc3qDfl9uaDfTQpPtNrxs58Ow84jKo5XGAnDhIbF8kMXB6pbS\nNJUYPv8AfKAU/OshdT5oscQHTmztq5GIiz/Jm4mbCwKBgG4jknxt/WMbLNlPai5D\n0Tq/u713WhOKrrivlZqhWNXhO/A9qSyYi/L6+r34nmvsh/5TZdXiSQ/JqgZga0QO\nuEmtm872VPKqKqhaqzYNU18nFJG1VpI0sMAaAAv7Zhs2mGB22uBpRmnHpy92gS7e\n+xF1+Yc6doe7YFmV91orXgW6\n-----END PRIVATE KEY-----\n",
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

  /// ✅ Initialize all sheets
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
