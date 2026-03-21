import 'dart:convert';

import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSheetsApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "gsheet-490820",
  "private_key_id": "f1af0fd886ee7c91d5f514b99798d7102a8a61d6",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCtFS5PNg3tvlg+\nFmZrhIbMwj29bmd0mSmbBXYENQuN72GcmA08lfT5MS0w9R94NLDm2k1anh5ekR/C\nkkvQ0+pUCdkcMsBOjvfZSQEjztgAAahRW6bYfE+Q0p276qlFz6ZegV2hEppYuEXK\nKGpprBbH5opLEjWHDfXZ/OY2LPaL0cthHTxXUZ4WBbjUt1NC+241xc3qShineyB+\nifh5Zgbn7+/2x6ByuZ7nxNE9M99sElcXWUWGcm3yey6jeZ033iCU2X1NqUQzW8od\n1MUl2E2j3JNvag20lqY+iZq/9gWQgl+AiAlwJz1yd4Q/ncX1aNPvFft9WnMp/M+U\nPHph2GO1AgMBAAECggEAG3gOFnIsubuIw6nIbW3l+t8k70hzUNTx/nFaboaAo/EG\n29Rh3WirLVU5p9hvOyOZo7mnpycLCNUdZkLTl3vaZ6X8d/YyAQW9nhVxAd7U9wNM\nVEUocJkiA4j5kZZHcRXogH0lf+e06TmtkcziPo0aPHWBIzLrndiAWS1C1/xA0KWj\nQGjJpI0LP/Kp2/cfRgZfOsCgC2s9TYlcVTt6G559fW9gk3NAi094XOAOIcNoESSd\nnHlX/TaFV4H5Gnayp934mIL/vRI2KkKkothWRNBrfS2Z6q6N1zsuQ3tWsdQve+zC\nbphC7W3BusAnkTLCfVtBcMlXhSSi4Ug/TDzEc6jbAQKBgQDVRpayE5bXxLFGqz1a\nkt7C7wRPw3e5ez/fCWUqAn3y9X9421MaAEbyrP3gL4fZYSDfcznApCd6JQoqEWE2\nj+fGRkelXdPLmXdlWA3EPhYsammA7iwMMksx4T7bUXFunArbqbN1og5RP2Xi6RgC\n86huBJLhv+Pj8tdRQgPQvnBi9QKBgQDPwWBQloLI85S9acQf5JIwoGy0t7YsDpsN\ngnCB/U2zz3etNf4DffEeLes4lVNfJyhV9+HgbkEkiRulFgam7nBGNfd26R2hcneC\nGWm99ET3Enwgpn6mxBwDWYk2FkIzXjLJYwie/KxG4s8FAxOKWEXH8tx8y6k2Y5gt\nAy/1ERMFwQKBgQDF8DV8IGIm7w34oITYwuar1FkUDj3Xj2PABGA3lQh/rQkZibSe\ntRMjtxoILxTN0y9HMxGukKty2V2NnYOzt+tMQX3NJD+k/lGpZQeh0l2R61DvsByB\nVUwkhwBnXDcCiSAqrl04F6diEIznA56dXrY7JVOM4SMINCFR8QrJeXWk4QKBgQCl\n10ymJ++Qr/hs1zAK8W/NR1JfVEMkmigluZlL+sL7JUL4TqBNc0x1ddxN182sqFpn\nfa+ecwSnQJeDybhXqwCO22eGUYIorXI+tUCWtJYU0HmrqpxxTRy7g86nEU+ZJ7nM\nzrREDZkMION2scT4a4yQlwpwyDZ0Rz5juCahLxcLQQKBgALICcKEwd00ENP2vDZ3\nYcFa/XXItwt+tBlx509Sv0wabVD6NDnobzZW+JFn1n9vqsHf9UWZqTbZEfMgWg9D\nBFe9MNaT3ib19ogepGqeBPrGuCzTtnm3Ur+D069iiT0tc0g0mQtyIMOLrQq406j8\nEBm2jF5UOq1R82bRap+Eh2ld\n-----END PRIVATE KEY-----\n",
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
