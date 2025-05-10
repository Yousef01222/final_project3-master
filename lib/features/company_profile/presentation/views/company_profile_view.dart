// import 'package:flutter/material.dart';
// import 'package:grade3/core/utils/get_responsive_font_size.dart';
// import 'package:grade3/core/widgets/custom_chat_button.dart';
// import 'package:grade3/features/chat/presentation/views/widgets/chat_item_page.dart';
// import 'package:grade3/features/home/data/models/company_model.dart';
// import 'package:grade3/features/home/presentation/views/widgets/custom_rounded_image.dart';

// class CompanyProfileView extends StatelessWidget {
//   const CompanyProfileView({
//     super.key,
//     required this.companyModel,
//   });
//   final CompanyModel companyModel;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF2F2F2),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           'Company Profile',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CustomRoundedImage(
//               imageUrl: companyModel.logo.isNotEmpty
//                   ? companyModel.logo
//                   : 'https://example.com/default-logo.png', // تأكد من أن الـ logo ليس فارغاً
//               width: MediaQuery.sizeOf(context).width * 0.35,
//             ),
//             const SizedBox(height: 10),
//             Text(
//               companyModel.name,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: getResponsiveFontSize(
//                   context,
//                   baseFontSize: 20,
//                 ),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               companyModel.type,
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: getResponsiveFontSize(
//                   context,
//                   baseFontSize: 14,
//                 ),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 30),
//             Row(
//               children: [
//                 Text(
//                   'Company overview',
//                   style: TextStyle(
//                     fontSize: getResponsiveFontSize(
//                       context,
//                       baseFontSize: 20,
//                     ),
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black.withOpacity(0.80),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 15),
//             _buildInfoRow('Email', companyModel.id, isLink: true),
//             _buildInfoRow('Size', '${companyModel.size} Employees'),
//             _buildInfoRow('Location', companyModel.location, isLink: false),
//             const SizedBox(height: 25),
//             Row(
//               children: [
//                 Text(
//                   'About Us:',
//                   style: TextStyle(
//                     fontSize: getResponsiveFontSize(
//                       context,
//                       baseFontSize: 20,
//                     ),
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black.withOpacity(0.80),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               companyModel.descryption,
//               style: TextStyle(
//                 fontSize: getResponsiveFontSize(
//                   context,
//                   baseFontSize: 14,
//                 ),
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 100),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Container(
//         height: 50,
//         width: double.infinity,
//         margin: const EdgeInsets.only(
//           left: 20,
//           right: 20,
//           bottom: 20,
//         ),
//         child: CustomChatButton(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ChatItemPage(
//                   company: companyModel,
//                   imageUrl: companyModel.logo,
//                   name: companyModel.name,
//                   recivedId: companyModel.id, // بعتنا موديل الشركة
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value, {bool isLink = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 80,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(width: 20),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 color: isLink
//                     ? const Color(0xff3797FF)
//                     : Colors.black.withOpacity(0.6),
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//*//  * 1. استخدمنا `CustomRoundedImage` لعرض صورة الشركة.

// import 'package:flutter/material.dart';
// import 'package:grade3/features/company_profile/presentation/views/available_jobs.dart';
// import 'package:grade3/features/home/data/models/jobs_model.dart';
// import 'package:grade3/features/home/data/repos/jobs_repo.dart';
// import 'package:grade3/core/utils/get_responsive_font_size.dart';
// import 'package:grade3/core/widgets/custom_chat_button.dart';
// import 'package:grade3/features/chat/presentation/views/widgets/chat_item_page.dart';
// import 'package:grade3/features/home/data/models/company_model.dart';
// import 'package:grade3/features/home/presentation/views/widgets/custom_rounded_image.dart';

// class CompanyProfileView extends StatelessWidget {
//   const CompanyProfileView({
//     super.key,
//     required this.companyModel,
//   });

//   final CompanyModel companyModel;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF2F2F2),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           'Company Profile',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CustomRoundedImage(
//               imageUrl: companyModel.logo.isNotEmpty
//                   ? companyModel.logo
//                   : 'https://example.com/default-logo.png',
//               width: MediaQuery.sizeOf(context).width * 0.35,
//             ),
//             const SizedBox(height: 10),
//             Text(
//               companyModel.name,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: getResponsiveFontSize(context, baseFontSize: 20),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               companyModel.type,
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: getResponsiveFontSize(context, baseFontSize: 14),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 30),
//             _buildSectionTitle(context, 'Company overview'),
//             const SizedBox(height: 15),
//             _buildInfoRow('Email', companyModel.id, isLink: true),
//             _buildInfoRow('Size', '${companyModel.size} Employees'),
//             _buildInfoRow('Location', companyModel.location),
//             const SizedBox(height: 25),
//             _buildSectionTitle(context, 'About Us:'),
//             const SizedBox(height: 8),
//             Text(
//               companyModel.descryption,
//               style: TextStyle(
//                 fontSize: getResponsiveFontSize(context, baseFontSize: 14),
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 30),

//             FutureBuilder<List<JobModel>>(
//               future: JobService.fetchJobsByCompanyId(companyModel.id),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return const Text('Error loading jobs');
//                 } else if (!snapshot.hasData ||
//                     snapshot.data == null ||
//                     snapshot.data!.isEmpty) {
//                   return const Text('No jobs available for this company.');
//                 } else {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildSectionTitle(context, 'Available Jobs'),
//                       const SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AvailableJobs(
//                                 companyId: companyModel.id,
//                               ),
//                             ),
//                           );
//                         },
//                         child: const Text('Available Jobs'),
//                       ),
//                     ],
//                   );
//                 }
//               },
//             ),

//             const SizedBox(height: 50),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Container(
//         height: 50,
//         width: double.infinity,
//         margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
//         child: CustomChatButton(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ChatItemPage(
//                   company: companyModel,
//                   imageUrl: companyModel.logo,
//                   name: companyModel.name,
//                   recivedId: companyModel.id,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(BuildContext context, String title) {
//     return Row(
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: getResponsiveFontSize(context, baseFontSize: 20),
//             fontWeight: FontWeight.w600,
//             color: Colors.black.withOpacity(0.80),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoRow(String label, String value, {bool isLink = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 80,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(width: 20),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 color: isLink
//                     ? const Color(0xff3797FF)
//                     : Colors.black.withOpacity(0.6),
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:grade3/features/company_profile/presentation/views/available_jobs.dart';
import 'package:grade3/features/home/data/models/jobs_model.dart';
import 'package:grade3/features/home/data/repos/jobs_repo.dart';
import 'package:grade3/core/utils/get_responsive_font_size.dart';
import 'package:grade3/core/widgets/custom_chat_button.dart';
import 'package:grade3/features/chat/presentation/views/widgets/chat_item_page.dart';
import 'package:grade3/features/home/data/models/company_model.dart';
import 'package:grade3/features/home/presentation/views/widgets/custom_rounded_image.dart';

class CompanyProfileView extends StatelessWidget {
  const CompanyProfileView({
    super.key,
    required this.companyModel,
  });

  final CompanyModel companyModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Company Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomRoundedImage(
              imageUrl: companyModel.logo.isNotEmpty
                  ? companyModel.logo
                  : 'https://example.com/default-logo.png',
              width: MediaQuery.sizeOf(context).width * 0.35,
            ),
            const SizedBox(height: 10),
            Text(
              companyModel.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: getResponsiveFontSize(context, baseFontSize: 20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              companyModel.type,
              style: TextStyle(
                color: Colors.grey,
                fontSize: getResponsiveFontSize(context, baseFontSize: 14),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionTitle(context, 'Company overview'),
            const SizedBox(height: 15),
            _buildInfoRow('Email', companyModel.id, isLink: true),
            _buildInfoRow('Size', '${companyModel.size} Employees'),
            _buildInfoRow('Location', companyModel.location),
            const SizedBox(height: 25),
            _buildSectionTitle(context, 'About Us:'),
            const SizedBox(height: 8),
            Text(
              companyModel.descryption,
              style: TextStyle(
                fontSize: getResponsiveFontSize(context, baseFontSize: 14),
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: FutureBuilder<List<JobModel>>(
                future: JobService.fetchJobsByCompanyId(companyModel.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Error loading jobs');
                  } else {
                    final jobs = snapshot.data;
                    print('Fetched Jobs: $jobs');

                    if (jobs == null || jobs.isEmpty) {
                      return const Text(
                        'No jobs available for this company.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(context, 'Available Jobs'),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AvailableJobs(
                                    companyId: companyModel.id,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Available Jobs'),
                          ),
                        ],
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 50,
        width: double.infinity,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: CustomChatButton(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatItemPage(
                  company: companyModel,
                  imageUrl: companyModel.logo,
                  name: companyModel.name,
                  recivedId: companyModel.id,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: getResponsiveFontSize(context, baseFontSize: 20),
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.80),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isLink
                    ? const Color(0xff3797FF)
                    : Colors.black.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
