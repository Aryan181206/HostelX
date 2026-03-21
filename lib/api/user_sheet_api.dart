import 'dart:convert';

import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSheetsApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "gsheet-490820",
  "private_key_id": "066a6bc2fca11749383ec56c759f950a4512f0ea",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDBT9cgOiGAog/c\nk/x4j/b5XZfaZ4FIOrSjsu7k86hk4jSvswz8dL5vJNjFQinx1ZMcTHh4Y9AdwGV2\nTvP8G3uwwJcFHViUBtycAxcUfFT/nG4YR0OO5t3Xx2+usiHPhe83YPtCVm3uJrTu\nhPNb3TsXP4qNZ8heB6IHQghVAfjsuCvpoI16Ooy0IrzKlagqYwipKci91bYga2MG\nnzzQLI3zfxRtTqIgiIJYyZubyhoTYIUbWgaxdtSN48rrCcKo6CTO/QJTx0HnX0zi\nlaPHSU8SY9Q1lq7BwElClhmZJZKWBX3gMYN/gZ2deu2c/omnyzNu/mZ2VZ5O4/yZ\n4T2ScAMpAgMBAAECggEAFnmVXdpUVdPBu1f7RPsb8D8Y7hwVlFO698NQcg8AF4aT\nMJBFJL7f+yUSDNEV9ldp7KLZaMnWAveA9GHWjQuW9GRXypDwYPlxQbQ8RTX1XeiO\nhkUWzjD6PuGhkvKD6tA8ETi1za8lxcf7RjXv41DT026gSbN0wLXreSOMu3FowwCs\n4rIncbp+3N/SxPL1j1H1VWsaN6U8/tOlPASd6ZMiUKS16YSsyKm8sd9caNdw6uGZ\n9MTQqeX/kp5oPauAxIh3uV2z+qReyIJqBX1ZFJGLGdXmGXoOUjxUVqu/6k/9eKiS\nq5fK6/LOCiQVxtEa4NOUAO+3sacOQrCcX3lT0yHHpwKBgQDhi9YQVwira9ACy2Kp\nWTBlWLhgUqMlmpsNGtt/Mk8KrhpI69qASmHGxvZpZWgzw35oUmxHGk0aa1oFZn/K\nm5ICUkx1j2lheCO5Gd79CqO1qSOZgQhd62jGEEvPmf/mgzjyvPwJGPI80TvZNPtH\nh6X4Kue0l0wdWrvm6rLsRQMVXwKBgQDbac0JnVv1XJfiGo6d6UDcjXWJL22bubfO\nmXimx8b442vMWtAhUjpgIQSPFloLurlp9r9NKlEa3BEo0GUhfnhHSFAUEkkZTZx9\nXFBcHliAwRfHjWRotzVOpi783s/v9AWQqKlS1LQZ5B0U0BHZnwvrzmMtIUAaeLjK\nCRlo2yNsdwKBgFsRuWdznP6KU70tHjM+3fmt7xSFiXZ/jKen9oTPbXbkgZx8DwfK\nANzgLVK1LXPpNbstvKahCgzm17xifKr0Ueo6DMFTHLvMZLAysAUALMYG+2bZ4OT7\nTpzaq6GxjtAmn/HzONj7h6Pi4AV+DQ/+x5cCy/fxNzyLDF/a2E/qNaqFAoGAL7z2\nSng9UMYjmaMzknH0lcgFYaK7E121+zJzCL6AsRgyFRVRIV7VqqKkbklrsA+hVcfE\n2ZIycUieRyYISuBMZR37plJQKzwypyfVqCVGFkVs2hMOXKY35/PKV2RXE5shNtcr\neAUlZli2ZxfaOmIbYuPVujT40Imhkvul1qWPMIMCgYButDPsW51/WVFBF2lS8jTN\ncrcpSe0pXO07zTR5xnjBiBsrVFjxVHV19scsn1l5S3jZlbJTIfJwB0cpFEGPOdZX\neZHWhcpe1Sdv+5HYhdy4Thw6RRJhgPEuQG3/mJw92RrGRHK9dW4lAYcKl4z2JbQ9\nAKCYPOnVLXlj0YqEzXWBDg==\n-----END PRIVATE KEY-----\n",
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
