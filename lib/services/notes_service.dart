import 'dart:convert';

import '/models/api_response.dart';
import '/models/note_for_listing.dart';
import 'package:http/http.dart' as http;

class NotesService {
  static const API = 'http://api.notes.programmingaddict.com';
  static const headers = {'apiKey': '08d771e2-7c49-1789-0eaa-32aff09f1471'};

  Future<ApiResponse<List<NoteForListing>>> getNotesList() {
    return http.get(API + '/notes', headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final notes = <NoteForListing>[];
        for (var item in jsonData) {
          final note = NoteForListing(
            noteID: item['noteID'],
            noteTitle: item['noteTitle'],
            createDateTime: DateTime.parse(item['createDateTime']),
            latestEditDateTime: item['latestEditTime'] != null
                ? DateTime.parse(item['latestEditTime'])
                : null,
          );
          notes.add(note);
        }
        return ApiResponse<List<NoteForListing>>(data: notes);
      }
      return ApiResponse<List<NoteForListing>>(
          error: true, errorMessage: 'An error occured');
    }).catchError((_) => ApiResponse<List<NoteForListing>>(
        error: true, errorMessage: 'An error occured!'));
  }
}
