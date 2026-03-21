import 'dart:convert';

import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSheetsApi {
  static const _credentials = r'''YOUR_CREDENTIALS
''';
  static final _spreadsheet = 'YOUR_SPREADSHEET_ID';
  static final _gsheet = GSheets(_credentials);

  static Worksheet? _userSheet;
  static Worksheet? _announcementSheet;
  static Worksheet? _complaintSheet;
  static Worksheet? _feedbackSheet;


  static Future init() async {
    final spreadsheet = await _gsheet.spreadsheet(_spreadsheet);


    _userSheet = await _getWorkSheet(spreadsheet, title: 'Sheet1');


    _announcementSheet = await _getWorkSheet(spreadsheet, title: 'Announcement');

    _complaintSheet = await _getWorkSheet(spreadsheet, title: 'Complaint');


    final header = await _announcementSheet!.values.row(1);
    if (header.isEmpty) {
      await _announcementSheet!.values.insertRow(1, ['Date', 'Announcement']);
    }


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


    _feedbackSheet = await _getWorkSheet(spreadsheet, title: 'Feedback');


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


  static Future<Worksheet> _getWorkSheet(Spreadsheet spreadsheet,
      {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }



  static Future<bool> addFeedback({
    required int rating,
    required String feedbackText,
  }) async {
    if (_feedbackSheet == null) await init();

    try {
      final prefs = await SharedPreferences.getInstance();


      final userDataString = prefs.getString('user');
      if (userDataString == null) return false;

      final currentUser =
      Map<String, dynamic>.from(jsonDecode(userDataString));

      final admissionNo = currentUser['Admission No'];


      final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());


      await _feedbackSheet!.values.appendRow([
        admissionNo,
        currentDate,
        rating.toString(),
        feedbackText,
      ]);

      return true;
    } catch (e) {
      print("Error adding feedback: $e");
      return false;
    }
  }

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


  static Future<Map<String, String>?> login(
      String admissionNo, String password) async {
    if (_userSheet == null) return null;

    final rows = await _userSheet!.values.map.allRows();
    if (rows == null) return null;

    for (var row in rows) {
      if (row['Admission No'] == admissionNo &&
          row['Password'] == password) {
        return row;
      }
    }

    return null;
  }


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





  static Future<bool> updatePassword(
      String admissionNo, String newPassword) async {
    final rows = await _userSheet!.values.map.allRows();
    if (rows == null) return false;

    for (int i = 0; i < rows.length; i++) {
      if (rows[i]['Admission No'] == admissionNo) {

        await _userSheet!.values.insertValue(
          newPassword,
          column: 5,
          row: i + 2,
        );
        return true;
      }
    }
    return false;
  }


  static Future<bool> updateRoom(
      String admissionNo, String newRoom) async {
    final rows = await _userSheet!.values.map.allRows();
    if (rows == null) return false;

    for (int i = 0; i < rows.length; i++) {
      if (rows[i]['Admission No'] == admissionNo) {
        await _userSheet!.values.insertValue(
          newRoom,
          column: 5,
          row: i + 2,
        );
        return true;
      }
    }
    return false;
  }


  static Future<Map<String, String>?> getRoommate() async {
    if (_userSheet == null) await init();

    try {
      final prefs = await SharedPreferences.getInstance();


      final userDataString = prefs.getString('user');
      if (userDataString == null) return null;

      final currentUser = Map<String, dynamic>.from(jsonDecode(userDataString));

      final hostelBlock = currentUser['Hostel Block'];
      final roomNumber = currentUser['Room Number'];
      final admissionNo = currentUser['Admission No'];


      final rows = await _userSheet!.values.map.allRows();
      if (rows == null) return null;


      for (var row in rows) {
        if (row['Hostel Block'] == hostelBlock &&
            row['Room Number'] == roomNumber &&
            row['Admission No'] != admissionNo) {


          await prefs.setString('roommate', jsonEncode(row));

          return row;
        }
      }

      return null;
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


      final userDataString = prefs.getString('user');
      if (userDataString == null) return false;

      final currentUser =
      Map<String, dynamic>.from(jsonDecode(userDataString));

      final admissionNo = currentUser['Admission No'];


      const status = "Pending";


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



  static Future<bool> updateComplaintStatus({
    required String admissionNo,
    required String description,
    required String newStatus,
  }) async {
    if (_complaintSheet == null) await init();

    try {
      final rows = await _complaintSheet!.values.map.allRows();
      if (rows == null) return false;


      for (int i = 0; i < rows.length; i++) {
        if (rows[i]['Admission No'] == admissionNo && rows[i]['Description'] == description) {

          await _complaintSheet!.values.insertValue(
            newStatus,
            column: 5,
            row: i + 2,
          );
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Error updating complaint status: $e");
      return false;
    }
  }




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
          'date': row['Date'] ?? '',
        });
      }

      return complaints.reversed.toList();
    } catch (e) {
      print("Error fetching all complaints: $e");
      return [];
    }
  }


  static Future<List<Map<String, String>>> getMyComplaints() async {
    if (_complaintSheet == null) await init();

    try {
      final prefs = await SharedPreferences.getInstance();


      final userDataString = prefs.getString('user');
      if (userDataString == null) return [];

      final currentUser =
      Map<String, dynamic>.from(jsonDecode(userDataString));

      final admissionNo = currentUser['Admission No'];


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






  static Future initAnnouncementSheet() async {
    final spreadsheet = await _gsheet.spreadsheet(_spreadsheet);
    _announcementSheet = await _getWorkSheet(spreadsheet, title: 'Announcement');


    final header = await _announcementSheet!.values.row(1);
    if (header.isEmpty) {
      await _announcementSheet!.values.insertRow(1, ['Date', 'Announcement']);
    }
  }


}
