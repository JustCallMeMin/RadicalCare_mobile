import 'package:radicalcare/common/model/booking.dart';
import 'package:radicalcare/common/model/booking_detail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:radicalcare/common/api/appointment_api.dart';
import '../../../../common/api/motor_service_api.dart';
import '../../../../common/model/appointment_detail.dart';
import '../../../../common/utils/secure_storage.dart';

part 'booking_notifier.g.dart';

@riverpod
class BookingNotifier extends _$BookingNotifier {
  // Bản đồ lưu thông tin chi tiết dịch vụ
  final Map<int, BookingDetail> _serviceDetails = {};
  DateTime? _serviceDate;

  @override
  Booking build() {
    return Booking(
      customerId: '',
      dateCreated: DateTime.now(),
      serviceIds: [],
    );
  }

  // Cập nhật ID khách hàng
  void updateCustomerId(String customerId) {
    state = state.copyWith(customerId: customerId);
  }

  // Cập nhật hoặc thêm mới thông tin dịch vụ
  void addOrUpdateServiceDetail({
    required int serviceId,
    required DateTime serviceDate, // Giữ nguyên DateTime
    String? serviceDescription,
    double? cost,
  }) {
    final updatedDetail = BookingDetail(
      serviceId: serviceId,
      serviceDate: serviceDate,  // Gửi DateTime trực tiếp
      serviceDescription: serviceDescription ?? _serviceDetails[serviceId]?.serviceDescription ?? '',
      cost: cost ?? _serviceDetails[serviceId]?.cost ?? 0.0,
    );

    _serviceDetails[serviceId] = updatedDetail;

    if (!state.serviceIds.contains(serviceId)) {
      final updatedServiceIds = List<int>.from(state.serviceIds)..add(serviceId);
      state = state.copyWith(serviceIds: updatedServiceIds);
    }

    print("Added/Updated service detail: $updatedDetail");
  }

  // Cập nhật ngày thực hiện cho tất cả dịch vụ
  void updateServiceDateForAll(DateTime serviceDate) {
    _serviceDate = serviceDate;
    for (final serviceId in state.serviceIds) {
      addOrUpdateServiceDetail(
        serviceId: serviceId,
        serviceDate: serviceDate,
      );
    }
    print("Updated serviceDate for all services to: $serviceDate");
  }

  // Lấy ngày thực hiện chung
  DateTime? get serviceDate => _serviceDate;

  // Xóa thông tin chi tiết của dịch vụ
  void removeServiceDetail(int serviceId) {
    _serviceDetails.remove(serviceId);
    final updatedServiceIds = List<int>.from(state.serviceIds)..remove(serviceId);
    state = state.copyWith(serviceIds: updatedServiceIds);
    print("Removed service detail for serviceId: $serviceId");
  }

  // Cập nhật ngày tạo booking
  void updateDateCreated(DateTime date) {
    state = state.copyWith(dateCreated: date);
  }

  // Lấy danh sách chi tiết dịch vụ
  List<BookingDetail> get serviceDetails {
    return state.serviceIds
        .map((id) => _serviceDetails[id] ?? BookingDetail(
      serviceId: id,
      serviceDate: _serviceDate ?? DateTime.now(), // Nếu không có ngày, sử dụng ngày hiện tại
      serviceDescription: '',
      cost: 0.0,
    ))
        .toList();
  }

  // Gửi yêu cầu tạo booking
  Future<void> submitBooking() async {
    try {
      final customerId = await SecureStorageManager.getCustomerId();
      if (customerId == null || customerId.isEmpty) {
        throw Exception("Customer ID is missing.");
      }

      state = state.copyWith(customerId: customerId);

      // Kiểm tra nếu không có dịch vụ được chọn
      if (state.serviceIds.isEmpty) {
        throw Exception("No services selected.");
      }

      // Kiểm tra nếu không có ngày dịch vụ (serviceDate)
      if (_serviceDate == null) {
        throw Exception("Service date is missing.");
      }

      // Định dạng lại ngày tạo
      final formattedDateCreated = state.dateCreated.toIso8601String();

      // Đảm bảo serviceDates có giá trị hợp lệ
      final serviceDate = _serviceDate != null
          ? [_serviceDate!.toIso8601String()]  // Chuyển đổi ngày thành ISO8601 và cho vào mảng
          : [];

      if (serviceDate.isEmpty) {
        throw Exception("Service date is missing or invalid.");
      }

      final payload = {
        'customerId': customerId,
        'dateCreated': formattedDateCreated,  // Định dạng ngày tạo
        'serviceIds': state.serviceIds,
        'serviceDates': serviceDate,  // Dữ liệu ngày dịch vụ
      };

      print("Booking API Payload: $payload");

      // Gửi yêu cầu tạo booking
      await AppointmentApi.createAppointment(payload);
      print("Booking successfully submitted!");
    } catch (e) {
      // Hiển thị thông báo lỗi nếu có
      print("Error submitting booking: $e");
      throw Exception("Failed to submit booking. Please try again.");
    }
  }
}

final motorServicesProvider = FutureProvider<List<Map<String, dynamic>>>( (ref) async {
  final response = await MotorServiceApi.fetchAllMotorServices();
  if (response.containsKey('data')) {
    final services = List<Map<String, dynamic>>.from(response['data'].map((service) {
      return {
        'serviceId': service['serviceId'],
        'serviceName': service['serviceName'],
        'serviceDescription': service['serviceDescription'],
        'costTableId': service['costTableId'],
      };
    }));

    print("Fetched services: $services");

    return services;
  } else {
    throw Exception("No data found in response");
  }
});
