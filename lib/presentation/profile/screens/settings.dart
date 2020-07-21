import 'package:auto_size_text/auto_size_text.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/sign_in/screens/password_reset_screen.dart';
import 'package:find_the_treasure/presentation/sign_in/validators.dart';
import 'package:find_the_treasure/services/auth.dart';

import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/widgets_common/platform_exception_alert_dialog.dart';
import 'package:find_the_treasure/widgets_common/sign_in_button.dart';
import 'package:flutter/services.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

bool _editName = false;
bool _updatePassword = false;
bool _editEmail = false;

class SettingsScreen extends StatefulWidget {
  final String version;

  const SettingsScreen({Key key, this.version}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordController2 = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final _nameFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _checkCurrentPasswordValid = true;
  bool _emailUpdated = true;
  bool _obscureText = true;

  String _userName = '';
  String _email = '';

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSingOut = await PlatformAlertDialog(
      title: 'See you soon!',
      image: Image.asset('images/owl_thumbs.png'),
      content: 'Happy Adventures.',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSingOut) {
      _signOut(context);
    }
  }

  bool _validateAndSaveNameForm() {
    final nameForm = _nameFormKey.currentState;

    if (nameForm.validate()) {
      nameForm.save();

      return true;
    }
    return false;
  }

  bool _validateAndSavePasswordForm() {
    final passForm = _passwordFormKey.currentState;

    if (passForm.validate()) {
      passForm.save();

      return true;
    }
    return false;
  }

  bool _validateAndSaveEmailForm() {
    final emailForm = _emailFormKey.currentState;

    if (emailForm.validate()) {
      emailForm.save();

      return true;
    }
    return false;
  }

  void _submitName() async {
    UserData _userData = Provider.of<UserData>(context, listen: false);
    DatabaseService _databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    if (_validateAndSaveNameForm()) {
      try {
        _isLoading = true;
        _editName = false;
        setState(() {});
        final UserData _updatedUserData = UserData(
            displayName: _userName,
            email: _userData.email,
            locationsExplored: _userData.locationsExplored,
            photoURL: _userData.photoURL,
            points: _userData.points,
            uid: _userData.uid,
            userDiamondCount: _userData.userDiamondCount,
            userKeyCount: _userData.userKeyCount,
            isAdmin: _userData.isAdmin);
        await _databaseService.updateUserData(userData: _updatedUserData);
        _isLoading = false;
        final snackBar = SnackBar(
            content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Text('Username updated'),
              Icon(
                Icons.done,
                color: Colors.greenAccent,
              )
            ]));
        _scaffoldkey.currentState.showSnackBar(snackBar);
        setState(() {});
      } catch (e) {
        print(e.toString());
        _isLoading = false;
      }
    }
  }

  void _submitEmail() async {
    UserData _userData = Provider.of<UserData>(context, listen: false);
    DatabaseService _databaseService =
        Provider.of<DatabaseService>(context, listen: false);

    if (_validateAndSaveEmailForm()) {
      print(_email);
      setState(() {
        _isLoading = true;
      });
      try {
        _checkCurrentPasswordValid =
            await validateCurrentPassword(_currentPasswordController.text);

        setState(() {});
        if (_checkCurrentPasswordValid) {
          final UserData _updatedUserData = UserData(
              displayName: _userData.displayName,
              email: _email,
              locationsExplored: _userData.locationsExplored,
              photoURL: _userData.photoURL,
              points: _userData.points,
              uid: _userData.uid,
              userDiamondCount: _userData.userDiamondCount,
              userKeyCount: _userData.userKeyCount,
              isAdmin: _userData.isAdmin);

          _emailUpdated = await updateUserEmail(_email);

          if (_emailUpdated) {
            _editEmail = false;

            await _databaseService.updateUserData(userData: _updatedUserData);
            final snackBar = SnackBar(
                content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Text('Email updated'),
                  Icon(
                    Icons.done,
                    color: Colors.greenAccent,
                  )
                ]));

            _emailController.clear();
            _currentPasswordController.clear();
            _scaffoldkey.currentState.showSnackBar(snackBar);
            _isLoading = false;
            setState(() {});
          } else {
            _isLoading = false;
          }
        } else {
          _isLoading = !_isLoading;
        }
      } on PlatformException catch (e) {
        print('platform');
        PlatformExceptionAlertDialog(
          title: 'Error',
          exception: e,
        ).show(context);
        _isLoading = false;
      } catch (e) {
        print('catch');
        _isLoading = false;
        print(e.toString());
      }
    }
  }

  void _submitPass() async {
    if (_validateAndSavePasswordForm()) {
      try {
        _isLoading = true;
        setState(() {});
        _checkCurrentPasswordValid =
            await validateCurrentPassword(_currentPasswordController.text);
        setState(() {});
        if (_checkCurrentPasswordValid) {
          updateUserPassword(_newPasswordController2.text);
          _updatePassword = false;
          _isLoading = false;
          setState(() {});
          final snackBar = SnackBar(
              content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Text('Password updated'),
                Icon(
                  Icons.done,
                  color: Colors.greenAccent,
                )
              ]));
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _newPasswordController2.clear();
          setState(() {});
          _scaffoldkey.currentState.showSnackBar(snackBar);
        } else {
          _isLoading = false;
          setState(() {});
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Error!',
          exception: e,
        ).show(context);
        _isLoading = false;
      }
    }
  }

  Future<bool> validateCurrentPassword(String password) {
    AuthBase _auth = Provider.of<AuthBase>(context, listen: false);
    return _auth.validateCurrentPassword(password: password);
  }

  void updateUserPassword(String password) {
    AuthBase _auth = Provider.of<AuthBase>(context, listen: false);
    try {
      _auth.updatePassword(password);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(title: 'Error', exception: e).show(context);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> updateUserEmail(String email) async {
    AuthBase _auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await _auth.updateEmail(email);
      return true;
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(title: 'Error', exception: e).show(context);
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  void dispose() {
    _editName = false;
    _isLoading = false;
    _updatePassword = false;
    _editEmail = false;
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordController2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    final UserData _userData = Provider.of<UserData>(context);
    final User _userEmail = Provider.of<User>(
      context,
    );
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor: MaterialTheme.orange,
      ),
      body: ListView(children: <Widget>[
        Container(
          height: _size.height - kToolbarHeight - 75,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildSettings(_userData, context, _userEmail),
              _buildLogOut(_userData, context, _userEmail),
            ],
          ),
        ),
      ]),
    );
  }

  Container _buildSettings(
      UserData _userData, BuildContext context, User userEmail) {
    User user = Provider.of<User>(context);

    // bool loginFacebook = user.loginCredential == 'facebook.com';
    bool loginGoogle = user.loginCredential == 'google.com';
    bool login = loginGoogle;
    print(user.loginCredential);
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          // EDIT USERNAME
          _editName
              ? _buildUserNameTextField(_userData)
              : _buildListTile(
                  title: _userData.displayName,
                  leading: Icon(
                    Icons.edit,
                    color: Colors.blueAccent,
                  ),
                  onTap: () {
                    setState(() {
                      _editName = true;
                      _editEmail = false;
                      _updatePassword = false;
                    });
                  },
                  leadingContainerColor: Colors.blue.shade100),
          // EDIT EMAIL
          login
              ? Container()
              : _editEmail
                  ? _buildEmailTextField(_userData, userEmail)
                  : _buildListTile(
                      title: _userData.email,
                      leading: Icon(
                        Icons.edit,
                        color: MaterialTheme.orange,
                      ),
                      onTap: () {
                        setState(() {
                          _editEmail = true;
                          _updatePassword = false;
                          _editName = false;
                        });
                      },
                      leadingContainerColor: Colors.orange.shade100),
          // EDIT PASSWORD
          login
              ? Container()
              : _updatePassword
                  ? _buildPasswordTextFields()
                  : _buildListTile(
                      title: 'Password',
                      leading: Icon(
                        Icons.edit,
                        color: Colors.redAccent,
                      ),
                      onTap: () {
                        setState(() {
                          _updatePassword = true;
                          _editName = false;
                          _editEmail = false;
                        });
                      },
                      leadingContainerColor: Colors.red.shade100),
        ],
      ),
    );
  }

  Container _buildLogOut(
      UserData _userData, BuildContext context, User userEmail) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Text(
                  'Logged in as',
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  _userData.email,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Find the Treasure version: ' + widget.version,
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _confirmSignOut(context),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: MaterialTheme.orange,
                  borderRadius: BorderRadius.circular(15)),
              height: 60,
              width: double.infinity,
              child: Center(
                child: Text(
                  'LOGOUT',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Build Update Name Text Field
  Widget _buildUserNameTextField(UserData userData) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Form(
            autovalidate: true,
            key: _nameFormKey,
            child: TextFormField(
              autofocus: true,
              controller: _nameController
                ..text = userData.displayName
                ..selection = TextSelection.collapsed(
                    offset: userData.displayName.length),
              enabled: !_updatePassword,
              style: TextStyle(fontSize: 20),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (ProfanityFilter().checkStringForProfanity(value)) {
                  return 'Oh my! Please avoid language like that';
                }
                if (value.isEmpty || value == null) {
                  return 'Please enter your name.';
                }
                return null;
              },
              maxLines: 1,
              maxLength: 20,
              maxLengthEnforced: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(5),
                hintText: 'Enter your name',
                enabled: !_isLoading,
                suffixIcon: IconButton(
                    enableFeedback: true,
                    icon: _isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                MaterialTheme.orange),
                          )
                        : Icon(
                            Icons.clear,
                            color: MaterialTheme.orange,
                          ),
                    onPressed: () {
                      Future.delayed(Duration(milliseconds: 50)).then((_) {
                        _nameController.clear();
                      });
                    }),
              ),
              onSaved: (value) => _userName = value,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: SignInButton(
                    padding: 0,
                    text: 'Update',
                    isLoading: _isLoading,
                    onPressed: !_isLoading ? _submitName : null,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: SignInButton(
                    color: Colors.grey,
                    text: 'Cancel',
                    onPressed: () {
                      _editName = !_editName;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Build Update Email Text Field
  Widget _buildEmailTextField(UserData userData, User userEmail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Form(
            key: _emailFormKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  onSaved: (value) => _email = value,
                  controller: _emailController,
                  enabled: _editEmail,
                  textCapitalization: TextCapitalization.none,
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (!EmailStringValidator().isValid(value)) {
                      return 'Hmm, try double-checking your email.';
                    } else {
                      return null;
                    }
                  },
                  maxLines: 1,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      labelText: userData.email,
                      enabled: !_isLoading,
                      suffixIcon: IconButton(
                          enableFeedback: true,
                          icon: Icon(
                            Icons.clear,
                            color: MaterialTheme.orange,
                          ),
                          onPressed: () {
                            Future.delayed(Duration(milliseconds: 50))
                                .then((_) {
                              _emailController.clear();
                            });
                          })),
                ),
                SizedBox(height: 15),
                Container(
                    child: TextFormField(
                  enabled: !_editName,
                  controller: _currentPasswordController,
                  obscureText: _obscureText,
                  style: TextStyle(fontSize: 16),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your password';
                    }

                    if (!(value.length >= 6)) {
                      return "Whoops, looks like your password is too short";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    errorText: _checkCurrentPasswordValid
                        ? ''
                        : 'Password incorrect, please try again.',
                    contentPadding: EdgeInsets.all(5),
                    labelText: 'Current password',
                    enabled: !_isLoading,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: MaterialTheme.orange,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                )),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: SignInButton(
                    padding: 0,
                    text: 'Update',
                    isLoading: _isLoading,
                    onPressed: !_isLoading ? _submitEmail : null,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: SignInButton(
                    color: Colors.grey,
                    text: 'Cancel',
                    onPressed: () {
                      _emailController.clear();
                      _currentPasswordController.clear();
                      _editEmail = !_editEmail;

                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => PasswordResetScreen(),
                    ));
              },
              child: Container(child: Text('Forgotten password?'))),
        ],
      ),
    );
  }

  Widget _buildPasswordTextFields() {
    return Container(
        height: 350,
        child: Form(
          key: _passwordFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    enabled: !_editName,
                    controller: _currentPasswordController,
                    obscureText: _obscureText,
                    style: TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      errorText: _checkCurrentPasswordValid
                          ? ''
                          : 'Password incorrect, please try again.',
                      contentPadding: EdgeInsets.all(5),
                      labelText: 'Current password',
                      enabled: !_isLoading,
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: MaterialTheme.orange,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  )),
              //New Password 1
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    enabled: !_editName,
                    controller: _newPasswordController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your new password';
                      }
                      if (!(value.length >= 6)) {
                        return "Whoops, looks like your password is too short";
                      }

                      return null;
                    },
                    obscureText: _obscureText,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      labelText: 'New password (6+ characters)',
                      enabled: !_isLoading,
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: MaterialTheme.orange,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  )),
              //New password 2
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    enabled: !_editName,
                    controller: _newPasswordController2,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your  new password';
                      }
                      if (!(value.length >= 6)) {
                        return "Whoops, looks like your password is too short";
                      }

                      if (_newPasswordController.text != value) {
                        return 'Passwords do not match, try again.';
                      }
                      return null;
                    },
                    obscureText: _obscureText,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      labelText: 'Confirm password (6+ characters)',
                      enabled: !_isLoading,
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: MaterialTheme.orange,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                  )),

              SizedBox(
                height: 20,
              ),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: SignInButton(
                        padding: 0,
                        text: 'Update',
                        isLoading: _isLoading,
                        onPressed:
                            !_isLoading || !_editName ? _submitPass : null,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: SignInButton(
                        color: Colors.grey,
                        text: 'Cancel',
                        onPressed: () {
                          _currentPasswordController.clear();
                          _updatePassword = false;

                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => PasswordResetScreen(),
                        ));
                  },
                  child: Container(child: Text('Forgotten password?'))),
            ],
          ),
        ));
  }

  ListTile _buildListTile({
    @required String title,
    @required Icon leading,
    @required Function onTap,
    @required Color leadingContainerColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      title: AutoSizeText(
        title,
        maxLines: 1,
        style: TextStyle(
            color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      trailing: Icon(
        Icons.keyboard_arrow_right,
        size: 30,
      ),
      leading: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: leadingContainerColor),
          padding: EdgeInsets.all(10),
          child: leading),
      onTap: onTap,
    );
  }
}
