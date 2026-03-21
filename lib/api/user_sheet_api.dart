import 'dart:convert';

import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSheetsApi {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "gsheet-490820",
  "private_key_id": "5956ca4e7123a179944e1511f3bf00a9cbb4ae68",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCfmWaqBdkdIN1R\nYgEZHyuAzTzuuwsZw0hJ0AxqceKTxKM6YgvT76GXmvEsjs+BjWCHQ7QrgwiuIJrB\nw7eAi/WKXRA7eq8IOIggvwV6fVMTqr5zFFkAphyaEdZE69KOK1E6tdPm07DD6aJb\nYEcBzHeWnT10xzrQUBBJQmY8jqW+NMSMTaTiNj90TOfm1xwrT9TMdwyoWobhhb9p\n4wumMLfM92+o2/jKg/T+rQVNC2+nLKRScpp5LB9IXNL5o5n0prX3G7XEzrl5z2Ea\noez1+I1gyeaDbtd5QeyMWdUwwBFFSmTPj9stkW84cli/yBJn8likbP9jjXjQG0pM\nLCVCKGPFAgMBAAECggEAJMLBaCuhKumpOIfVn2rzyv7bCFTqVWSK17+VQIZbTTR3\ncWjodwhExOYCI4SAbMN65qUUUIpluy/U3YkeUPxL0fMmHEEhpEfbKQm+sgxAULEd\nHWYkKvdX8q/llenojWkSVG7RsGL1neaISDpImLQ3Hmi44VdLZ3Rtj+Y8pLmpmQHy\n3XCxTk+Gk/soY9YXaX9YKnBVkc22XAI+6bQ1B1n5OK+4J5jINboBaKwRbSfEwQOT\ntG0PLce7AI4bdeuOaFlPJMTSgnAQsw5B8qv+qcwD749y0mFbvIyoOhiCz5bZbb4d\nDswJ3rVJj+alDOsGG6BjQbO6fOCwKLMr3u9e+aOqWQKBgQDMYImZS99qJyVx/8ut\naJEawA+kAv01Lf4+Fy6ezmeS9lPD+JPm5J4uurT0TO+Fok3nFA62gzyqLSHImqOl\neJhsIKbzXj0FuFRAt0fVhH4MDG90RmZlmS+ElqTtZgVjjTt0VpCmzDW7qoPReqT6\nBGQAd7X7k4yRo+IO68+psLzSiQKBgQDH6W4GcK4uq7wOq0kovFAvdHOVziz++ul/\n7L/nBvCreAN0EyLv8RhmIoA4SmPqPkDup1UFGNWRqz6RVZvG6tyyPo0F4ELiDCkZ\noZI2LS1uYXxafYIJ6Or1hUO9YUrjkhYkThbLw8F54dmItM5z29vdq4NgNjIB0knr\nGoDNRraoXQKBgGcs8SoXmJEhdBDp/qvrVx23Ce5Vp/h54Jj94QZA0x7pBf6v9hKh\nJY4XqZSPZngDKOrYQFk5RZ3vrNd14dl+WQx1K3M/BvVlSftly3jqKyvv9zAu/jCa\nNdfsqRRD5cKNIQ+pR9s8yn+UJHnTPYgOQWHPDWsU4OkBX/UCbNKQq7JpAoGAYPfU\nW6Fai97XaFIjOXQmfO5Chp6sar3wdxGyf/B42uNq4WnK35IVoK0JfsRutJefzWMz\nNTa3mWH0BnD9D76qcHcw1nHSX21AnmMl1cuSJuF4fTg11HK7TX5nvjusJLiertuF\n6S658VHgv5PcNIynmF1yaz++f+2t1zFS2r97KC0CgYAJXBwg0hOXX0HU8i1gbT2P\n42yMTPxPw0hubhmFIpxFYu1gGGsS7pUlQVZPUzdy11aC43zynkX+SKFa9iJUsylf\n6cAmapCnm7aEJtiN2a8HjRhWn6LlJ+9troCOlBD5N2oAfO0UnP5wJCPJFRXjm/bN\nBvEFc0gKi3eOgFNGtZXSdQ==\n-----END PRIVATE KEY-----\n",
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
