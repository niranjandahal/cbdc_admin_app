import 'package:cbdc_admin/screens/bank_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For parsing JSON

class BankProvider with ChangeNotifier {
  List<Map<String, dynamic>> _pendingKYC = [];
  List<Map<String, dynamic>> _allBanks = [];
  Map<String, dynamic>? _singleBank;
  Map<String, dynamic>? _bankdetailafterlogin;
  int _bankbalance = 0;
  int _banktransaction = 0;
  int _totaluser = 0;
  int _kycpending = 0;
  String _bankid = "";
  List<Map<String, dynamic>> _users = [];

  List<Map<String, dynamic>> get users => _users;

  bool _isLoading = false;

  List<Map<String, dynamic>> get pendingKYC => _pendingKYC;
  List<Map<String, dynamic>> get allBanks => _allBanks;
  Map<String, dynamic>? get singleBank => _singleBank;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get bankdetailafterlogin => _bankdetailafterlogin;
  int get bankbalance => _bankbalance;
  int get banktransaction => _banktransaction;
  int get totaluser => _totaluser;
  int get kycpending => _kycpending;
  String get bankid => _bankid;

  // ...existing code...

  List<Map<String, dynamic>> _banks = [];
  List<Map<String, dynamic>> get banks => _banks;

// NRB Stats
  int _nrbTotalMinted = 0;
  int _nrbBalance = 0;
  int _nrbTotalTransfer = 0;
  int _nrbTotalBanks = 0;

  int get nrbTotalMinted => _nrbTotalMinted;
  int get nrbBalance => _nrbBalance;
  int get nrbTotalTransfer => _nrbTotalTransfer;
  int get nrbTotalBanks => _nrbTotalBanks;

  final String baseurl = "http://192.168.1.7:5000/api/v1/";

// Fetch all banks
  Future<void> fetchAllBanks() async {
    try {
      final response = await http.get(Uri.parse(baseurl + "banks/"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // If API returns {banks: [...]}
        _banks = data['banks'] != null
            ? List<Map<String, dynamic>>.from(data['banks'])
            : List<Map<String, dynamic>>.from(data);
        notifyListeners();
      } else {
        print("Failed to fetch banks");
      }
    } catch (e) {
      print("Error fetching banks: $e");
    }
  }

// Send money to bank
  Future<bool> sendMoneyToBank({
    required String bankId,
    required int amount,
    required BuildContext context,
  }) async {
    try {
      print("selected bankid printing" + bankId);
      print("amount " + amount.toString());
      final response = await http.post(
        Uri.parse(baseurl + "mint/transfer-to-cb"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "bankId": bankId,
          "amount": amount,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Money sent to bank successfully!")),
        );
        await getNRBStats();
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send money to bank.")),
        );
        return false;
      }
    } catch (e) {
      print("Error sending money to bank: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending money to bank.")),
      );
      return false;
    }
  }

// Get NRB stats
  Future<void> getNRBStats() async {
    try {
      final response = await http.get(Uri.parse(baseurl + "mint/stats/"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _nrbTotalMinted = data['totalMinted'] ?? 0;
        _nrbBalance = data['balance'] ?? 0;
        _nrbTotalTransfer = data['totalTransfers'] ?? 0;
        _nrbTotalBanks = data['totalBanks'] ?? 0;
        notifyListeners();
      } else {
        print("Failed to fetch NRB stats");
      }
    } catch (e) {
      print("Error fetching NRB stats: $e");
    }
  }

  Future<void> fetchStats(String bankId) async {
    try {
      final response =
          await http.get(Uri.parse(baseurl + "banks/$bankId/stats"));
      print("Response: ${response.body}");
      print("bank id is" + bankId);
      print(bankId);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _bankbalance = data['bankBalance'] ?? 0;
        _banktransaction = data['bankToUserTransactions'] ?? 0;
        _totaluser = data['totalUsers'] ?? 0;
        _kycpending = data['kycPendingCount'] ?? 0;
        notifyListeners();
      } else {
        print("Failed to fetch stats");
      }
    } catch (e) {
      print("Error fetching stats: $e");
    }
  }

  Future<bool> sendMoneyToUser({
    required String bankId,
    required String userId,
    required int amount,
    String description = "",
    required BuildContext context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseurl + "transactions/bank-to-user"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "bankId": bankId,
          "userId": userId,
          "amount": amount,
          "description": description,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Money sent successfully!")),
        );
        await fetchStats(bankId); // Refresh balance
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send money.")),
        );
        return false;
      }
    } catch (e) {
      print("Error sending money: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending money.")),
      );
      return false;
    }
  }

// ...existing code...

  Future<bool> mintCBDC(BuildContext context, int amount) async {
    try {
      final response = await http.post(
        Uri.parse(baseurl + "mint/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"amount": amount}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("CBDC minted successfully!")),
        );
        // Optionally refresh stats or balances here
        notifyListeners();
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to mint CBDC.")),
        );
        return false;
      }
    } catch (e) {
      print("Error minting CBDC: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error minting CBDC.")),
      );
      return false;
    }
  }

// ...existing code...
  Future<void> fetchAllUsers() async {
    try {
      final response =
          await http.get(Uri.parse(baseurl + "user/userManagement"));
      if (response.statusCode == 200) {
        print("calling user fetch function");
        print("Response: ${response.body}");
        final data = jsonDecode(response.body);
        // Extract the users list from the 'users' key
        _users = List<Map<String, dynamic>>.from(data['users']);
        print(_users);
        notifyListeners();
      } else {
        print("Failed to fetch users");
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  Future<void> blockUser(BuildContext context, String userId) async {
    try {
      final response = await http.patch(
        Uri.parse(baseurl + "user/$userId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": "Blocked"}),
      );
      if (response.statusCode == 200) {
        await fetchAllUsers();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User blocked successfully.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to block user.")),
        );
      }
    } catch (e) {
      print("Error blocking user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error blocking user.")),
      );
    }
  }

  Future<void> banklogin(
      BuildContext context, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseurl + "user/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "type": "bank",
        }),
      );

      print("POST request sent");

      if (response.statusCode == 200) {
        final responsedata = jsonDecode(response.body);
        debugPrint("Full response: ${jsonEncode(responsedata)}");

        if (responsedata["bank"] != null) {
          _bankdetailafterlogin = responsedata["bank"];
          _bankid = responsedata["bank"]["_id"];

          print(_bankid);

          print("Bank login successful. Navigating to dashboard...");

          // Optional: Notify listeners if using Provider
          notifyListeners();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BankDashboard(), // Make sure this widget exists
            ),
          );
        } else {
          print("Expected 'bank' object not found in response.");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text("Unexpected response from server. Please try again.")),
          );
        }
      } else {
        print("Login failed with status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Login failed. Please check your credentials.")),
        );
      }
    } catch (e) {
      print("An error occurred during login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Something went wrong. Please try again later.")),
      );
    }
  }

  // Fetch pending KYC data with get request
  Future<void> fetchPendingKYC() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.get(Uri.parse(baseurl + "kyc/pending"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print('Response data: $data');
        List<dynamic> pendingUsers = data['pendingUsers'];

        // print("Pending KYC data: $pendingUsers");

        _pendingKYC = pendingUsers
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
        WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
      } else {
        print("Failed to load KYC data");
      }
    } catch (e) {
      print("Error fetching pending KYC: $e");
    } finally {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

// ...existing code...
// Approve KYC
  Future<void> approveKYC(BuildContext context, String id) async {
    try {
      final response = await http.post(
        Uri.parse(baseurl + "kyc/approve/$id"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print(response.body);
        if (data["status"] == "success") {
          await fetchPendingKYC();
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("KYC approved successfully.")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BankDashboard()),
          );
        }
      } else {
        print("Failed to approve KYC");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to approve KYC.")),
        );
      }
    } catch (e) {
      print("Error approving KYC: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error approving KYC.")),
      );
    }
  }

// Reject KYC
  Future<void> rejectKYC(BuildContext context, String id) async {
    try {
      final response = await http.post(
        Uri.parse(baseurl + "kyc/reject/$id"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(response.body);

        if (data["status"] == "success") {
          await fetchPendingKYC();
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("KYC rejected successfully.")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BankDashboard()),
          );
        }
      } else {
        print("Failed to reject KYC");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to reject KYC.")),
        );
      }
    } catch (e) {
      print("Error rejecting KYC: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error rejecting KYC.")),
      );
    }
  }
// ...existing code...

  // Register a new bank
  Future<bool> registerBank(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseurl + "banks/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );
      return response.statusCode == 201;
    } catch (e) {
      print("Error registering bank: $e");
      return false;
    }
  }

  // Get all banks
  // Future<void> fetchAllBanks(String token) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse(baseurl + "banks/"),
  //       headers: {"Authorization": "Bearer $token"},
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       _allBanks = List<Map<String, dynamic>>.from(data);
  //       notifyListeners();
  //     } else {
  //       print("Failed to fetch banks");
  //     }
  //   } catch (e) {
  //     print("Error fetching banks: $e");
  //   }
  // }

  // Get single bank details
  Future<void> fetchSingleBank(String id, String token) async {
    try {
      final response = await http.get(
        Uri.parse(baseurl + "banks/$id"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        _singleBank = jsonDecode(response.body);
        notifyListeners();
      } else {
        print("Failed to fetch single bank");
      }
    } catch (e) {
      print("Error fetching single bank: $e");
    }
  }

  // Update bank profile
  Future<bool> updateBankProfile(
      String id, String name, String email, String token) async {
    try {
      final response = await http.patch(
        Uri.parse(baseurl + "banks/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({"name": name, "email": email}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error updating profile: $e");
      return false;
    }
  }

  // Update bank password
  Future<bool> updateBankPassword(
      String id, String oldPassword, String newPassword, String token) async {
    try {
      final response = await http.patch(
        Uri.parse(baseurl + "banks/$id/password"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(
            {"oldPassword": oldPassword, "newPassword": newPassword}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error updating password: $e");
      return false;
    }
  }

  // Update bank status
  Future<bool> updateBankStatus(String id, String status, String token) async {
    try {
      final response = await http.patch(
        Uri.parse(baseurl + "banks/$id/status"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({"status": status}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error updating status: $e");
      return false;
    }
  }

  // Get bank balance
  Future<double?> fetchBankBalance(String id, String token) async {
    try {
      final response = await http.get(
        Uri.parse(baseurl + "banks/$id/balance"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["balance"];
      } else {
        print("Failed to fetch bank balance");
        return null;
      }
    } catch (e) {
      print("Error fetching balance: $e");
      return null;
    }
  }
}
