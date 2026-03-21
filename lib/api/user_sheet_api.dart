import 'dart:convert';

import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSheetsApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "gsheet-490820",
  "private_key_id": "643abbbc23da4ce0b371de215f97e8b5b2d2e119",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC9S00KXqUAy1CM\nzDvtAiipurAIqjqOqGt5vzyNBmW3uOruR3dQKQyNQZECqI7dRaY1U5K6CLStBOHv\nOgodCnvkvnRNVIipTvyE84E5+8j6r1qk5QBE9a/7+XYUFalmUikvmQrBvU6UVg2N\n2K78vuJBGOiIXypiOlIRX0nmD/xD+d4xKjAv/LjiZK+y8E8dHo2Nrt/T/l0ICYcl\nGO+jTvP2p0DDUpYHPkctLHGChQamo9J5H0D7b+hMrkD9gt2fJj8jOVcGKucPypCq\nT8KisySQgcPu/ae3i9OtGhp3Cm+UV6vnxwo75ss3g+14eavgnK0/PI+J1uusPY/M\nPzg4IlPLAgMBAAECggEAP1jv00SRG47uye+fLlXGneZn+r5dEliyfu/Mp7U4XR95\nH3yzJRRXqv4CNU2LYelpEfeB5tf6/tvfcFuP/t//TjGeYjKj+WUBhMyotmrYe2wr\nfXtVd75wwnZdWaNWKXPdbJxeyS89GM8jghC9nr+SoA5h4yFV4cF6rW2iIWfAGE72\nfnCMOobl3m/QbezTDMYmG7E1n2s1UbR1onSnhzQDy7wef72xFYT9Q1b6tYI4Pcmp\n0MTcNKv+gUSuWoa+Cl+qQ+WKuoJULM+AEEcUuR4kFMtiRSWjCX38N0kbej8BMJPN\nZTSpxW69r7Ewg8bVs0Uim8RXz7qW6IATsiNgtRNHAQKBgQDvTLrpGahF3aYHwTLk\n37RnwT/2GvJJ1KrGp0OzQGO4+BKQOTSDKuz1EBUbtGIkDcqLFxx32QsPaAKvPmvR\nHTWVAJy9x7HsNDCIHVOh+oGImH9F0fX4dmK5dfVMGnZw9lwZKY1EDkW/QOrToO7C\ntoEokdHIRb37R1gA0tBiWzBSawKBgQDKgS70aRMIRSgwKixWqIHJJQL/YSrVvwuO\n92Lqinhulu426hAOnv1jAvEqbLsG1Ad1q7PqUBnTjk26MGSv9JcbLR6BboEGojlI\nMQQZjs7Mua9lUJ+Qcw9bPUqXsgnAthwXzBGKHFkPt3ySMmiTmrCrjziXgGR/vgoR\nTmtM6qwcIQKBgHceW+BS7Eey+MXdbyctEFGhieRJL5h+62+trW6aO8nEewEd6Lzu\nbjvjAI7k8QF/d/Zaz8n82ZuWq9duHB9hCd4dCukRccjhhdMLvijgWQCU4K3xwR4o\nWCZ3yF5UweajS98epvpcnG2CtCIadx+n141JYQLvbI2byvvF9QMw31H3AoGBAK5w\nVYhIsxJesF29FnCXuyUP8uMWSpXReh1vURAEs/Vfolg/jBFsN42AzUnkW79oCfz9\nKYBf+79XR/FpGnLP2RKZ7TtFe3PBbmKXhpaVg+Kq2UIHD0yZMNNBmu3NecU9mjmN\nmlZEURvOzUoKjjcH+8PtHayz9t5rT7TUvm2FgTjBAoGAf1oeOLa643ASxiXSVyIL\nFjAQOrevy0hqXmfP8jIHynHX988oGl1rt81bmH+U8lFP8Q5ylyBaMfgFkXTKVUpX\nFA7jfLNJfPKNCiPrTElYsVT1J61ttU9RvAGWGTFVggG/wsFbsKY6NfBMJrKqI60w\nsMdhu8Q9Y9o6oIUgF4CHQFA=\n-----END PRIVATE KEY-----\n",
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
