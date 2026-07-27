class ParcelDeliveryRequest {
  final String pickupAddress;
  final String dropoffAddress;
  final String recipientName;
  final String recipientPhone;
  final String packageDescription;
  final String parcelCategory; // مستندات، طرد، أمانة، مفاتيح، هدية
  final double estimatedFee;
  final String paymentMethod; // نقداً عند الاستلام، نقداً عند الإرسال

  const ParcelDeliveryRequest({
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.recipientName,
    required this.recipientPhone,
    required this.packageDescription,
    required this.parcelCategory,
    required this.estimatedFee,
    required this.paymentMethod,
  });
}
