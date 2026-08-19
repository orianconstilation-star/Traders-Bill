import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/invoice_model.dart';
import '../models/invoice_item_model.dart';

class PdfService {
  static Future<void> generateInvoicePdf(Invoice invoice, List<InvoiceItem> items) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            cross: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('TRADER BILL', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Customer: ${invoice.customerName}'),
              pw.Text('Date: ${invoice.date}'),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ['Product', 'Price', 'Qty', 'Total'],
                data: items.map((item) => [item.productName, item.price.toStringAsFixed(2), item.quantity.toString(), item.total.toStringAsFixed(2)]).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    cross: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Total: ${invoice.totalAmount.toStringAsFixed(2)}'),
                      pw.Text('CGST (${(invoice.gstRate / 2).toStringAsFixed(1)}%): ${invoice.cgst.toStringAsFixed(2)}'),
                      pw.Text('SGST (${(invoice.gstRate / 2).toStringAsFixed(1)}%): ${invoice.sgst.toStringAsFixed(2)}'),
                      pw.Divider(),
                      pw.Text('Grand Total: ${invoice.grandTotal.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
