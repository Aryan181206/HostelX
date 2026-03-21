import 'dart:convert';

import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSheetsApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "gsheet-490820",
  "private_key_id": "5f1f1ab71a26e64d3f276c699c2db10475eb5768",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDgjxjI7RpJl50R\nvjDDan35uZGh4Y+26Zrqewh9yO8Z/T5YbE/kQj/v1iJ0X+y5sEJCKnjh/EAMltGW\nX6v4O3YwDXJHWdlN/SElJoXNYS6kXsOIMOS+BBrQQztatdjkO2OAGGbUwXUpdR6V\nUFgZVKl2/bGBYDnbC5FaaGMURewXFHfhaHC2BZVVanEetdIBSt3bqQXP25+/Q+pf\n+mLkD5b8+HBU4UwNI2UVrl9orT8rq4rfisGrhNmCUdvhlvTtvubYdT8L2vfN54G0\nNi2t/+y+l7crMC3Hx1vzFGz5lFQVKTw18XhoKneOb/6xyd4WvIfDrdMXXwDq6vQl\nX5ZMzglnAgMBAAECggEAAWHwKaCIFmboESlmHHXl46k4U9JTM7GZghMS2M9pZXQR\nM7MrBMFBqoTbfnLuvq/uoICpcN7AODOfg7kAEo2vKxmSGA1eEKRb1WI41axhAKMS\nuh5u8hqNXbXkQik3diRFdw7vZyTvxzsQ3qN5f2Jtjq1+L8k7YfVexjs5TPEnRHcZ\nVrj8HjE9bMz9uWahhBlH87V0sg3+VoVgc/CybQ1Zw1JnnkQYyDgdGRZpuuBrrt/L\n/tRCLGFJmDGpULo09zRyRS9JHPjOvn9m3HESTTKQm7dWqFzNlcdDYrhgn9ajVB2h\nJNiGLTmADchP+nngNLrjPm9xEjDCbRDNml5DDzFKRQKBgQD+TZRyygTrqxlqzHDI\nHr8cRT+z122AqllvMx49UUfy6gnd8VrohP6jX1qNaHSCxlzJ2kgMy93fLUAAEY3K\np2yuGHb6dqgZvFNpgMiZGxxiZZuWyNEjCR3eRYXBY87NYO/FubNXftooTDQpxGiw\n6qN3xC8+rtnsuY9UPequ7QdbswKBgQDiDrSwFusEXZn4bpg0P03dgnwY3QdoqyTd\n8rZ7YhGr5SUsIluIclI8WbDh/ttvH4fv48p6GWlz10ld8fb1/RkjGHafx7AIs0Ux\n/s/D/Jv4kDc10/ZkJn2cJFl5pNT21yVQHeui0MZ1JXN/aTCGj/bRnf0l7i3ErjLp\ntWvAETMxfQKBgQCyoiRpDeeu9B2Cm+GNcaulXC+HUQimnQL9zdasE/CKfkQ4F1ZY\nhzOn509gjcNqKZT8Zcy+0GYmY07VvX7wn/MDyEOrZLZofZXKQqCmjBjANce5f48J\nIVpNzGBMnKOkOTe0mOGV0JHGROFPhZxUyj3R34mgaorCcwZvkp7MCcxlaQKBgEaX\nEwNd1LvDQt5aIrtF/VmrcncNJlAgCV4peaRjxmLoJkh23iBompdv5pVb0UgND5Tw\ni/y+zLg4xRdKBLVh+KSF8h0I7UZ6PKRVDqoDyuy+lA8CBpHVlynYC/y5ZStDmco/\n3aI1EZPpQvzJazbJ4+gnLrLWgoJFZ26lkWUjudm9AoGBAOpd9JtyCB/GeTh+LlYT\nFOrNEU7Q3TZZSLsPIAqzmgaKjnW4tMYXbFWwdFs8xwBkSJVceBDb/LVLhkgwxxkK\nmspzWyph93R9I2KYNj3j/iNHMcJomOWm09f86k2OWeROvtQ57Xv//iXZ+L2xzdHB\njDVvyBwioVrqiSNKLtCt0ser\n-----END PRIVATE KEY-----\n",
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
