import 'package:flutter/material.dart';
import 'package:giveitashot/api_service.dart';
import 'package:giveitashot/models/customer.dart';
import 'package:giveitashot/utils/form_helper.dart';
import 'package:giveitashot/utils/progressHUD.dart';
import 'package:giveitashot/utils/validator_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late APIService apiService;
  late CustomerModel model;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool isApiCallProcess = false;

  @override
  void initState() {
    apiService = APIService();
    model = CustomerModel(firstName: '', lastName: '', email: '', password: '');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: true,
        title: Text('Sign Up'),
      ),
      body: ProgressHUD(
        child: Form(
          key: globalKey,
          child: _formUI(),
        ),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      ),
    );
  }

  Widget _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormHelper.fieldLabel("First Name"),
                FormHelper.textInput(
                  context,
                  model.firstName,
                  (value) => {
                    model.firstName = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return "Please  enter First Name.";
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("Last Name"),
                FormHelper.textInput(
                  context,
                  model.lastName,
                  (value) => {
                    model.lastName = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return "Please  enter Last Name.";
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("Email Id"),
                FormHelper.textInput(
                  context,
                  model.email,
                  (value) => {
                    model.email = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return "Please  enter email id.";
                    }
                    if (value.isNotEmpty && value.toString().isValidEmail()) {
                      return " Please enter valid email id";
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("Password"),
                FormHelper.textInput(
                  context,
                  model.password,
                  (value) => {
                    model.password = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return "Please  enter Password.";
                    }
                    return null;
                  },
                  obscureText: hidePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: FormHelper.saveButton(
                    "Register",
                    () {
                      if (validateAndSave()) {
                        print(model.toJson());
                        setState(() {
                          isApiCallProcess = true;
                        });

                        apiService.createCustomer(model).then((ret) {
                          setState(() {
                            isApiCallProcess = false;
                          });

                          if (ret) {
                            FormHelper.showMessage(
                              context,
                              "Give it a shot",
                              "registration Successful",
                              "Ok",
                              () {
                                Navigator.of(context).pop();
                              },
                            );
                          } else {
                            FormHelper.showMessage(context, "Give it a shot",
                                "Email Id already registered.", "Ok", () {
                              Navigator.of(context).pop();
                            });
                          }
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
