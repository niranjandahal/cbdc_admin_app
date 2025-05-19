import 'package:cbdc_admin/widgets/KYC_detail_page.dart';
import 'package:provider/provider.dart';
import '../provider/bankprovider.dart';
import 'package:flutter/material.dart';

class KYCVerification extends StatefulWidget {
  @override
  _KYCVerificationState createState() => _KYCVerificationState();
}

class _KYCVerificationState extends State<KYCVerification> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BankProvider>(context, listen: false).fetchPendingKYC();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BankProvider>(
      builder: (context, bankProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "KYC Verification",
            ),
            SizedBox(height: 10),
            bankProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : bankProvider.pendingKYC.isEmpty
                    ? Text("No pending KYC requests")
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: bankProvider.pendingKYC.length,
                        itemBuilder: (context, index) {
                          final kycRequest = bankProvider.pendingKYC[index];
                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text("User: ${kycRequest['name']}"),
                              subtitle: Text("Email: ${kycRequest['email']}"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        KYCDetailPage(userData: kycRequest),
                                  ),
                                );
                              },
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.check_circle,
                                        color: Colors.green),
                                    onPressed: () => bankProvider.approveKYC(
                                        context, kycRequest['_id']),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.cancel, color: Colors.red),
                                    onPressed: () => bankProvider.rejectKYC(
                                      context,
                                      kycRequest['_id'],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
