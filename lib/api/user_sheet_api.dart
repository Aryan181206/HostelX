import 'dart:convert';

import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSheetsApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "gsheet-490820",
  "private_key_id": "5ebf62dbde4d66be82a9b49d2c2ed04a23a2e95d",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDMjvoPmSFhi823\n7PNHDF3jhdRp/HsusK1ualpdZ3jmP3IdvEs8HbATveQaT8xqxJO0DkFAqWDEeJMt\n6POY+xbBe0pDNkTFT00B4PkGHrQq6sv38J5csNNzchViPWkKdL09windNE6W7mL6\nlQ5Bsncw4hFLvGXV+NNw1W4z4ytlq/2T2zoeyG66jybiIFWKl/f0n59Ip0A/6xUt\n/TOhPrK1xpMKGqIGyaJFL43HDw60ZPLYkBprZ90TjwrVV34Umdnp/mu16DnRatl8\njwlEgmo31kKSVVk2JxOlDCL8ntI0MYxUfrsxjrFrbvHkAP/vX0TnLu76JRWKfNM+\nL6F2x2UpAgMBAAECggEABXgxNtI5B/BYBiSfdfUzsXi2REXho/mfZDC9zSTjdldD\nSDOXrg970htQCmVl1C5WELNs3+YSK06vXhk4zOIHKryO23CLstw69TjnD63UfW1H\nxOUPJu/8x2fJK0D0b7jNXTsK1C+o25+bepMaYtFQdI3RjpKGr+D2WQcBP6vsUMyV\n5xOeIczC4CUUMUDG9TM4HpINZ4YbxPZe0/W2TOJKCsZh2fXb+AURXgqhlbdRnuZ6\ni5f7Yu9bu2rowrDLCLlaXy69buub8AvzopNWlOzjkFkPjInImKCE9eQCcFQ9sWez\nFGvxZWumutDDlFw3OysuIet62fs0sha4qU25ZEdUgQKBgQDu9jfXUWvK53uWUOWm\nTFIQBehWciIiY8FTqzi6026Z7v0u2MmO/I5yaMPTKKMyIizCdce63g6Um2BgGfti\nA+3c6WnOhYNuZTRTtQSaHUjRxvAat4FZikcQWdxcsMpOwBSwzMdxSmB74bRKGJlo\nzDa7Mr9McH0wDOaDS0lo2oX0mQKBgQDbJMswiNxe7pjMj+s6ngi+npWXAoQNGRAG\nnL3PpBdA/aemd8ZY1ySI9eO5Zj01mx3T2d3/Y0Nej9pMOIcNSHiAZ+YwWitm0Pux\nxfAKs5kqNIVcdRmqGXmdXBa+st766QaIPZiJ72dCkb2d8Iqpx+OJ+34uFaa56ZW3\nO0FgsAS/EQKBgQDFeaYWA0xQJtIEG6BcuG+MnEUvwywgPU3TpgjAo9+fyFdksnSG\n/IF/XMKPquKKmKFiplDDRaTI/Eo9wNr0Wgjk6eOtbrp5rZr7nflKnu7BpWRgv8te\nQp6NjaVE2DinsaanoOMk5XEsjw4duYx1hWWpd7uNINzjq5WHZN0qkIPo6QKBgHiJ\ntHntzckp1EIwp2KGqqiu8fkuGRRbRMVeUcl0qJXG8ABQwXj8Xcw39Bp2chSaTb3J\niKKBJv1MgvaJ4T8dLarze1n9PwI+0TLnfTFluEnOucwxXPyDJrG3hYs/OAcrRbyK\npOy6EkI7h+Dn/l2E5VNwUednYV3BbehrX3qfVv0BAoGAUFykOlvKFbGhowInMGOr\ndGTA2Guury8XguHnDwWGiWdcZYQ06N3AH8Z1Wo7PdCWT2ilM42BFa9zP0kdn4JF3\nbT4lXJ21HR0gVK1QdAMKE1POtImoV6ZZYf/WHL0anrW1YaLvaWTHX5tSpTzOsRSB\nbTV/ZLnMG8tQEznQHkdW4IQ=\n-----END PRIVATE KEY-----\n",
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


  /// ✅ UPDATE COMPLAINT STATUS (Admin Action)
  static Future<bool> updateComplaintStatus({
    required String admissionNo,
    required String description,
    required String newStatus,
  }) async {
    if (_complaintSheet == null) await init();

    try {
      final rows = await _complaintSheet!.values.map.allRows();
      if (rows == null) return false;

      // Loop through rows to find the exact complaint
      for (int i = 0; i < rows.length; i++) {
        if (rows[i]['Admission No'] == admissionNo && rows[i]['Description'] == description) {
          // Status is the 5th column.
          // Row index is i + 2 (because i starts at 0, and row 1 is the header)
          await _complaintSheet!.values.insertValue(
            newStatus,
            column: 5,
            row: i + 2,
          );
          return true;
        }
      }
      return false; // Complaint not found
    } catch (e) {
      print("Error updating complaint status: $e");
      return false;
    }
  }



  /// ✅ GET ALL COMPLAINTS (ADMIN / FULL LIST)
  static Future<List<Map<String, String>>> getAllComplaints() async {
    if (_complaintSheet == null) await init();

    try {
      final rows = await _complaintSheet!.values.map.allRows();
      if (rows == null) return [];

      List<Map<String, String>> complaints = [];

      for (var row in rows) {
        complaints.add({
          'admissionNo': row['Admission No'] ?? '',
          'complaintType': row['Complaint Type'] ?? '',
          'description': row['Description'] ?? '',
          'imageUrl': row['ImageURL'] ?? '',
          'status': row['Status'] ?? 'Pending',
          'date': row['Date'] ?? '', // ✅ FIX ADDED
        });
      }

      return complaints.reversed.toList(); // latest first 🚀
    } catch (e) {
      print("Error fetching all complaints: $e");
      return [];
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




  /// ✅ GET ALL FEEDBACK
  static Future<List<Map<String, String>>> getAllFeedback() async {
    if (_feedbackSheet == null) await init();

    try {
      final rows = await _feedbackSheet!.values.map.allRows();
      if (rows == null) return [];

      List<Map<String, String>> feedbackList = [];

      for (var row in rows) {
        feedbackList.add({
          'admissionNo': row['Admission No'] ?? '',
          'date': row['Date'] ?? '',
          'rating': row['Rating'] ?? '',
          'feedback': row['Feedback'] ?? '',
        });
      }

      return feedbackList;
    } catch (e) {
      print("Error fetching feedback: $e");
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
