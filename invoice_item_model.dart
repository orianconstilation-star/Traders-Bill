class InvoiceItem {
  final int? id;
  final int? invoiceId;
  final String productName;
  final double price;
  final int quantity;
  final double total;

  InvoiceItem({
    this.id,
    this.invoiceId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'product_name': productName,
      'price': price,
      'quantity': quantity,
      'total': total,
    };
  }

  factory InvoiceItem.fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      id: map['id'],
      invoiceId: map['invoice_id'],
      productName: map['product_name'],
      price: map['price'],
      quantity: map['quantity'],
      total: map['total'],
    );
  }
}
