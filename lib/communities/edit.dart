import 'package:flutter/material.dart';
import 'package:waltrauds_kitchen/widgets/layout.dart';

class CommunityCreateForm extends StatefulWidget {
  const CommunityCreateForm({Key? key}) : super(key: key);

  @override
  State<CommunityCreateForm> createState() => _CommunityCreateFormState();
}

class _CommunityCreateFormState extends State<CommunityCreateForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BoxWidget(
      width: 500,
      children: [_getForm()],
    );
  }

  _getForm() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter a community name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide a name for your community!';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBoxWidget(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // FIXME implement
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coolio!')));
                  }
                },
                style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.secondary),
                child: const Text('Create community'),
              ),
            ),
          ],
        ));
  }
}
