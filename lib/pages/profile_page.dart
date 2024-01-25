import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: _FormBody(),
                ),
              ),
            ),
            _FormAction(formKey),
          ],
        ),
      ),
    );
  }
}

class _FormBody extends StatefulWidget {
  const _FormBody();

  @override
  State<_FormBody> createState() => _FormBodyState();
}

class _FormBodyState extends State<_FormBody> {
  final usernameController = TextEditingController();
  final birtDateController = TextEditingController();

  final initialDate = DateTime.now().subtract(const Duration(days: 60 * 365));

  int calculateAge(String birthDate) {
    final currentDate = DateTime.now();
    final parsedBirthDate = DateTime.parse(birthDate);
    int age = currentDate.year - parsedBirthDate.year;
    if (currentDate.month < parsedBirthDate.month ||
        (currentDate.month == parsedBirthDate.month &&
            currentDate.day < parsedBirthDate.day)) {
      age--;
    }
    return age;
  }

  String profileRecap() {
    String result = '';
    if (usernameController.text.isEmpty) {
      result += usernameController.text;
      final birthDate = birtDateController.text;
      if (birthDate.isNotEmpty) {
        final age = calculateAge(birthDate);
        result += '($age y.o)';
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 80,
          child: Text(
            usernameController.text.isEmpty
                ? '?'
                : usernameController.text[0].toUpperCase(),
            style: const TextStyle(fontSize: 60),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Agus (20 y.o)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 35),
        TextFormField(
          controller: usernameController,
          decoration: const InputDecoration(
            labelText: 'username',
            hintText: 'e.g jhondoe',
          ),
          onChanged: (value) {
            setState(() {});
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            } else if (value.length < 6) {
              return 'Min 6';
            } else if (value.length > 16) {
              return 'max 16';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'e.g jhondoe@gmail.com',
          ),
          validator: (value) {
            if (value == null) {
              return 'Required';
            } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[azA-Z]+",
            ).hasMatch(value)) {
              return 'Invalid Format';
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: TextFormField(
                controller: birtDateController,
                decoration: const InputDecoration(
                  labelText: 'Birth Date',
                  hintText: 'Chose',
                ),
                readOnly: true,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(
                      const Duration(days: 365 * 20),
                    ),
                    firstDate: DateTime(1000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    birtDateController.text =
                        pickedDate.toLocal().toString().split(' ')[0];
                    setState(() {});
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  hintText: 'Chose',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  return null;
                },
                items: const [
                  DropdownMenuItem(
                    value: "male",
                    child: Text('Male'),
                  ),
                  DropdownMenuItem(
                    value: 'famale',
                    child: Text('Famale'),
                  )
                ],
                onChanged: (value) {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Hobby',
            hintText: 'Write your hobies or thing you likes',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            return null;
          },
          maxLength: 40,
          minLines: 2,
          maxLines: 4,
        ),
      ],
    );
  }
}

class _FormAction extends StatelessWidget {
  const _FormAction(this.formKey);

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 15.0,
      ),
      child: ElevatedButton(
        child: const Text(
          'Submit',
          style: TextStyle(fontSize: 16),
        ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Profile Submitted'),
                action: SnackBarAction(
                  label: 'ok',
                  onPressed: () {},
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
