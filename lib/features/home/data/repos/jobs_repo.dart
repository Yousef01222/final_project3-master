import 'dart:convert';

import 'package:grade3/features/home/data/models/jobs_model.dart';
import 'package:http/http.dart' as http;

class JobService {
  static Future<List<JobModel>> fetchJobsByCompanyId(String companyId) async {
    final url =
        'https://translator-project-seven.vercel.app/company/job/$companyId/list-job';

    final response = await http.get(Uri.parse(url));

    print('URL: $url');
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      final jobsList = decoded['jobs'] as List;

      if (jobsList.isNotEmpty) {
        return jobsList.map((json) => JobModel.fromJson(json)).toList();
      } else {
        return []; // Return an empty list if no jobs are available
      }
    } else {
      throw Exception('Failed to load jobs');
    }
  }
}
