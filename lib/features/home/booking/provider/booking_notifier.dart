import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:radicalcare/common/api/appointment_api.dart';
import '../../../../common/api/motor_service_api.dart';
import '../../../../common/model/booking.dart';
import '../../../../common/utils/secure_storage.dart';

part 'booking_notifier.g.dart';

@riverpod
class BookingNotifier extends _$BookingNotifier {
  @override
  Booking build() {
    // Khởi tạo trạng thái mặc định
    return Booking(
      customerId: '', // ID khách hàng
      date: DateTime.now(), // Ngày đặt lịch mặc định
      serviceIds: [], // Danh sách dịch vụ mặc định (trống)
    );
  }

  // Cập nhật ID khách hàng
  void updateCustomerId(String customerId) {
    state = state.copyWith(customerId: customerId);
  }

  // Cập nhật ngày đặt lịch
  void updateDate(DateTime date) {
    state = state.copyWith(date: date);
  }

  // Cập nhật danh sách ID dịch vụ
  void updateServiceIds(List<int> serviceIds) {
    state = state.copyWith(serviceIds: serviceIds);
  }

  // Thêm một dịch vụ vào danh sách
  void addServiceId(int serviceId) {
    final updatedServiceIds = List<int>.from(state.serviceIds)..add(serviceId);
    state = state.copyWith(serviceIds: updatedServiceIds);
  }

  // Xóa một dịch vụ khỏi danh sách
  void removeServiceId(int serviceId) {
    final updatedServiceIds = List<int>.from(state.serviceIds)
      ..remove(serviceId);
    state = state.copyWith(serviceIds: updatedServiceIds);
  }

  // Gửi yêu cầu đặt lịch lên API
  Future<void> submitBooking() async {
    try {
      // Lấy customerId từ token
      final customerId = await SecureStorageManager.getCustomerId();
      if (customerId == null || customerId.isEmpty) {
        throw Exception("Customer ID is missing.");
      }

      // Cập nhật customerId vào state
      state = state.copyWith(customerId: customerId);

      // Kiểm tra thông tin trước khi gửi
      if (state.serviceIds.isEmpty) {
        throw Exception("No services selected.");
      }

      if (state.date == null) {
        throw Exception("Date is missing.");
      }
      print("Booking JSON: ${state.toJson()}");
      // Gửi yêu cầu tạo booking
      await AppointmentApi.createAppointment(state.toJson());
      print("Booking successfully submitted!");
    } catch (e) {
      print("Error submitting booking: $e");
      throw Exception("Failed to submit booking. Please try again.");
    }
  }
}

final motorServicesProvider = FutureProvider<List<Map<String, dynamic>>>(
      (ref) async {
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

      // Gắn print để kiểm tra dữ liệu fetch được
      print("Fetched services: $services");

      return services;
    } else {
      throw Exception("No data found in response");
    }
  },
);

