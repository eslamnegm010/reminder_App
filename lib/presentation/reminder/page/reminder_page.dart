import 'package:eslam_s_application/core/app_export.dart';
import 'package:eslam_s_application/presentation/reminder/cubit/reminder_cubit.dart';
import 'package:eslam_s_application/presentation/reminder/cubit/reminder_state.dart';
import 'package:eslam_s_application/presentation/reminder/model/reminder_model.dart';
import 'package:eslam_s_application/presentation/reminder/widgets/custom_reminder_card.dart';
import 'package:eslam_s_application/widgets/default_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hive_flutter/hive_flutter.dart';

class ReminderPage extends StatelessWidget {
  const ReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox<ReminderModel>('remindersBox'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final box = Hive.box<ReminderModel>('remindersBox');
          return BlocProvider(
            create: (_) => ReminderCubit(box),
            child: ReminderPageBody(),
          );
        }
        return const Center(
            child: CircularProgressIndicator(
          color: AppColors.blueColor,
        ));
      },
    );
  }
}

class ReminderPageBody extends StatefulWidget {
  const ReminderPageBody({Key? key}) : super(key: key);

  @override
  State<ReminderPageBody> createState() => _ReminderPageBodyState();
}

class _ReminderPageBodyState extends State<ReminderPageBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  late final FocusNode _focus;

  @override
  void initState() {
    _controller = TextEditingController();
    _focus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('REMINDER',
            style: TextStyle(
                color: AppColors.blueColor, fontWeight: FontWeight.w500)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: DefaultTextFormField(
                autovalidateMode: AutovalidateMode.disabled,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a reminder";
                  }
                  return null;
                },
                currentFocusNode: _focus,
                hint: 'add your reminder',
                currentController: _controller,
                borderRadius: 20,
                contentPadding: const EdgeInsets.all(10),
                textColor: const Color.fromARGB(255, 60, 59, 59),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context
                            .read<ReminderCubit>()
                            .addReminder(text: _controller.text);
                        _controller.clear();
                        _focus.unfocus();
                      }
                    },
                    child: const Text("ADD",
                        style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(AppColors.blueColor)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(
              height: 1,
              thickness: .7,
              color: AppColors.greyColor,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<ReminderCubit, ReminderState>(
                builder: (context, state) {
                  final reminder = state.reminder;
                  if (reminder.isEmpty) {
                    return Center(
                      child: Text("No reminder yet.."),
                    );
                  }
                  return ListView.builder(
                    itemCount: reminder.length,
                    itemBuilder: (context, index) {
                      final item = reminder[index];
                      return RadioCard(
                        title: item.title,
                        value: item.isCompleted,
                        onChanged: () => context
                            .read<ReminderCubit>()
                            .toggleReminder(item.id),
                        onDelete: () => context
                            .read<ReminderCubit>()
                            .removeReminder(item.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
