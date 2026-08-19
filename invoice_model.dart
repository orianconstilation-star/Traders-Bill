class Invoice {
  final int? id;
  final String customerName;
  final String date;
  final double totalAmount;
  final double gstRate;
  final double cgst;
  final double sgst;
  final double grandTotal;

  Invoice({
    this.id,
    required this.customerName,
    required this.date,
    required this.totalAmount,
    required this.gstRate,
    required this.cgst,
    required this.sgst,
    required this.grandTotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_name': customerName,
      'date': date,
      'total_amount': totalAmount,
      'gst_rate': gstRate,
      'cgst': cgst,
      'sgst': sgst,
      'grand_total': grandTotal,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      customerName: map['customer_name'],
      date: map['date'],
      totalAmount: map['total_amount'],
      gstRate: map['gst_rate'],
      cgst: map['cgst'],
      sgst: map['sgst'],
      grandTotal: map['grand_total'],
    );
  }
}
