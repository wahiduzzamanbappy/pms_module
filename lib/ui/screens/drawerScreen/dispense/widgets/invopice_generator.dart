/*
// ═════════════════════════════════════════════════════════════════════════════
// PDF GENERATOR
// ═════════════════════════════════════════════════════════════════════════════

class InvoicePdfGenerator {
  // Palette
  static const _dark = PdfColor.fromInt(0xFF111111);
  static const _muted = PdfColor.fromInt(0xFF888888);
  static const _lightGrey = PdfColor.fromInt(0xFFF5F5F5);
  static const _border = PdfColor.fromInt(0xFFDDDDDD);

  static Future<pw.Document> generate(InvoiceData data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular();
    final bold = await PdfGoogleFonts.robotoBold();

    final dateFmt = DateFormat('MMM dd, yyyy');
    final moneyFmt = NumberFormat('#,##0.00');

    String money(double v) => 'BDT ${moneyFmt.format(v)}';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 36),
        build: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // ── HEADER ──────────────────────────────────────────────────────
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('INVOICE',
                        style: pw.TextStyle(
                            font: bold,
                            fontSize: 28,
                            letterSpacing: 1.5,
                            color: _dark)),
                    pw.SizedBox(height: 4),
                    pw.Text('#${data.invoiceNumber}',
                        style: pw.TextStyle(
                            font: font, fontSize: 11, color: _muted)),
                  ],
                ),
                pw.Container(
                  width: 120,
                  height: 48,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: _border),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  alignment: pw.Alignment.center,
                  child: pw.Text('YOUR LOGO',
                      style: pw.TextStyle(
                          font: bold, fontSize: 10, color: _muted)),
                ),
              ],
            ),

            pw.SizedBox(height: 20),
            pw.Divider(color: _border, thickness: 1),
            pw.SizedBox(height: 14),

            // ── BILL FROM / BILL TO / DATES ──────────────────────────────
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Bill From
                pw.Expanded(
                  child: _addressBlock(
                    label: 'BILL FROM',
                    name: data.fromName,
                    lines: [data.fromAddress, data.fromCity, data.fromPhone],
                    font: font,
                    bold: bold,
                  ),
                ),
                pw.SizedBox(width: 16),
                // Bill To
                pw.Expanded(
                  child: _addressBlock(
                    label: 'BILL TO',
                    name: data.toName,
                    lines: [data.toAddress, data.toCity],
                    font: font,
                    bold: bold,
                  ),
                ),
                pw.SizedBox(width: 16),
                // Dates
                pw.SizedBox(
                  width: 130,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _dateBlock('ISSUE DATE', dateFmt.format(data.issueDate),
                          font, bold),
                      pw.SizedBox(height: 10),
                      _dateBlock(
                          'DUE DATE', dateFmt.format(data.dueDate), font, bold),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 24),

            // ── LINE ITEMS TABLE ─────────────────────────────────────────
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(1.6), // Date
                1: const pw.FlexColumnWidth(3.2), // Description
                2: const pw.FlexColumnWidth(1.6), // Price
                3: const pw.FlexColumnWidth(0.8), // QTY
                4: const pw.FlexColumnWidth(1.6), // Total
              },
              children: [
                // Header row
                pw.TableRow(
                  decoration:
                  const pw.BoxDecoration(color: _lightGrey),
                  children: [
                    _th('Date', bold),
                    _th('Description', bold),
                    _th('Price', bold),
                    _th('QTY', bold),
                    _th('Total', bold, right: true),
                  ],
                ),
                // Data rows
                ...data.items.asMap().entries.map((entry) {
                  final item = entry.value;
                  final isEven = entry.key.isEven;
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color:
                      isEven ? PdfColors.white : const PdfColor.fromInt(0xFFFAFAFA),
                      border: const pw.Border(
                        bottom: pw.BorderSide(color: _border, width: 0.5),
                      ),
                    ),
                    children: [
                      _td(dateFmt.format(item.date), font),
                      _td('${item.name} (${item.category})', font),
                      _td(money(item.price), font),
                      _td('${item.quantity}', font),
                      _td(money(item.total), font, right: true),
                    ],
                  );
                }),
              ],
            ),

            pw.SizedBox(height: 16),

            // ── SUBTOTAL / TAX / TOTAL ───────────────────────────────────
            pw.Row(
              children: [
                pw.Spacer(),
                pw.Container(
                  width: 230,
                  child: pw.Column(
                    children: [
                      _summaryRow('Subtotal', money(data.subtotal), font, bold),
                      pw.Divider(color: _border, thickness: 0.5),
                      _summaryRow(
                          'Tax (${(data.taxRate * 100).toStringAsFixed(0)}%)',
                          money(data.tax),
                          font,
                          bold),
                      pw.Divider(color: _border, thickness: 1),
                      _summaryRow(
                          'Total Due', money(data.totalDue), bold, bold,
                          isTotal: true),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 28),

            // ── PAYMENT INFO ─────────────────────────────────────────────
            if (data.paymentInfo.isNotEmpty) ...[
              pw.Text('Payment Information:',
                  style:
                  pw.TextStyle(font: bold, fontSize: 10, color: _dark)),
              pw.SizedBox(height: 5),
              pw.Text(data.paymentInfo,
                  style:
                  pw.TextStyle(font: font, fontSize: 9, color: _muted)),
              pw.SizedBox(height: 20),
            ],

            pw.Spacer(),

            // ── FOOTER ───────────────────────────────────────────────────
            pw.Divider(color: _border, thickness: 1),
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.Text(
                'Thank you for your business!',
                style: pw.TextStyle(font: bold, fontSize: 11, color: _muted),
              ),
            ),
          ],
        ),
      ),
    );

    return pdf;
  }

  // ── Widget helpers ──────────────────────────────────────────────────────

  static pw.Widget _addressBlock({
    required String label,
    required String name,
    required List<String> lines,
    required pw.Font font,
    required pw.Font bold,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label,
            style: pw.TextStyle(
                font: bold, fontSize: 8, color: _muted, letterSpacing: 1)),
        pw.SizedBox(height: 4),
        pw.Text(name,
            style: pw.TextStyle(font: bold, fontSize: 12, color: _dark)),
        pw.SizedBox(height: 2),
        ...lines
            .where((l) => l.isNotEmpty)
            .map((l) => pw.Text(l,
            style: pw.TextStyle(font: font, fontSize: 10, color: _muted))),
      ],
    );
  }

  static pw.Widget _dateBlock(
      String label, String value, pw.Font font, pw.Font bold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label,
            style: pw.TextStyle(
                font: bold, fontSize: 8, color: _muted, letterSpacing: 1)),
        pw.SizedBox(height: 2),
        pw.Text(value,
            style: pw.TextStyle(font: bold, fontSize: 11, color: _dark)),
      ],
    );
  }

  static pw.Widget _th(String text, pw.Font bold, {bool right = false}) =>
      pw.Padding(
        padding:
        const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        child: pw.Text(text,
            textAlign: right ? pw.TextAlign.right : pw.TextAlign.left,
            style: pw.TextStyle(font: bold, fontSize: 10, color: _dark)),
      );

  static pw.Widget _td(String text, pw.Font font, {bool right = false}) =>
      pw.Padding(
        padding:
        const pw.EdgeInsets.symmetric(vertical: 7, horizontal: 6),
        child: pw.Text(text,
            textAlign: right ? pw.TextAlign.right : pw.TextAlign.left,
            style: pw.TextStyle(font: font, fontSize: 10, color: _dark)),
      );

  static pw.Widget _summaryRow(
      String label,
      String value,
      pw.Font labelFont,
      pw.Font valueFont, {
        bool isTotal = false,
      }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: pw.TextStyle(
                  font: labelFont,
                  fontSize: isTotal ? 12 : 10,
                  color: isTotal ? _dark : _muted)),
          pw.Text(value,
              style: pw.TextStyle(
                  font: valueFont, fontSize: isTotal ? 13 : 10, color: _dark)),
        ],
      ),
    );
  }
}*/
