import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radicalcare/features/appointment_list/view/widgets/widgets/appointment_card.dart';
import '../provider/appointment_list_notifier.dart';

class AppointmentListPage extends ConsumerWidget {
  const AppointmentListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAppointments = ref.watch(appointmentListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment List'),
      ),
      body: asyncAppointments.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Failed to load appointments: $error'),
        ),
        data: (appointments) => appointments.isEmpty
            ? const Center(child: Text('No appointments available'))
            : ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];

            // Fetch details for each appointment if needed
            final asyncDetails = ref.watch(appointmentDetailsProvider(appointment.id));

            return asyncDetails.when(
              loading: () => const ListTile(
                title: Text('Loading details...'),
              ),
              error: (error, stack) => ListTile(
                title: Text('Failed to load details: $error'),
              ),
              data: (details) => AppointmentCard(
                appointment: appointment,
                details: details,
              ),
            );
          },
        ),
      ),
    );
  }
}
