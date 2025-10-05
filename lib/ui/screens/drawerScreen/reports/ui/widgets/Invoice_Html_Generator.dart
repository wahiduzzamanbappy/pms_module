import 'package:flutter/material.dart';

class InvoiceHtmlGenerator {
  static String generateInvoiceHtml(String? selectedStore, String? selectedUser, String fromDate, String toDate, List<Map<String, String>> invoiceData) {
    String htmlContent = """
    <html>
      <head>
        <style>
          body { font-family: Arial, sans-serif; }
          table { width: 100%; border-collapse: collapse; }
          th, td { padding: 8px; text-align: left; border: 1px solid #ddd; }
        </style>
      </head>
      <body>
        <h2>Income Statement</h2>
        <p><strong>Store:</strong> $selectedStore</p>
        <p><strong>User:</strong> $selectedUser</p>
        <p><strong>From:</strong> $fromDate <strong>To:</strong> $toDate</p>
        <table>
          <tr>
            <th>Date</th>
            <th>Item</th>
            <th>Amount</th>
          </tr>
          ${invoiceData.map((item) {
      return "<tr><td>${item['date']}</td><td>${item['item']}</td><td>${item['amount']}</td></tr>";
    }).join()}
        </table>
      </body>
    </html>
    """;
    return htmlContent;
  }
}
