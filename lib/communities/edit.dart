import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:waltrauds_kitchen/db/community.dart';
import 'package:waltrauds_kitchen/widgets/layout.dart';

import '../widgets/auth.dart';

class CommunityCreateForm extends StatefulWidget {
  const CommunityCreateForm({Key? key}) : super(key: key);

  @override
  State<CommunityCreateForm> createState() => _CommunityCreateFormState();
}

class _CommunityCreateFormState extends State<CommunityCreateForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return BoxWidget(
      width: 500,
      children: [_getForm()],
    );
  }

  _getForm() {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var userId = snapshot.data?.uid;
            return FormBuilder(
              key: _formKey,
              onChanged: () {
                _formKey.currentState!.save();
                // debugPrint(_formKey.currentState!.value.toString());
              },
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter a community name',
                    ),
                    name: 'name',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: 'Please provide a name for your community',
                      ),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  SizedBoxWidget(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final formData = _formKey.currentState?.value;
                          // FIXME how to handle async request correctly here?
                          createCommunity(
                            Community(name: formData!['name']),
                            userId!,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(formData['name'])));
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.secondary),
                      child: const Text('Create community'),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox(height: 0);
        });
  }
}
