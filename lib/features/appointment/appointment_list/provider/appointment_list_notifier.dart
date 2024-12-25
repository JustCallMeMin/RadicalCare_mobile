import 'package:radicalcare/common/model/appointment_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../common/api/appointment_api.dart';
import '../../../../common/model/appointment_detail.dart';

part 'appointment_list_notifier.g.dart';

@riverpod
class AppointmentListNotifier extends _$AppointmentListNotifier {
  @override
  Future<List<Appointment>> build() async {
    return await _fetchAllAppointments();
  }

  Future<List<Appointment>> _fetchAllAppointments() async {
    final response = await AppointmentApi.fetchAllAppointments();

    if (response['status'] == 200) {
      final List<dynamic> data = response['data'] ?? [];
      return data.map((json) => Appointment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch appointments');
    }
  }
}
