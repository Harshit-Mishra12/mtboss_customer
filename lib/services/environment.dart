String apiUrl = "https://mtboss.com/api";
String paymentUrl = "https://mtboss.com/api";

String playstoreUrl =
    "https://play.google.com/store/apps/details?id=com.mtboss.provider";

Map<String, String>? headersToken(token) => {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };

Map<String, String>? get headers =>
    {'Accept': 'application/json', 'Content-Type': 'application/json'};
