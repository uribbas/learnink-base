import 'dart:async';
import 'phone_signin_model.dart';
class PhoneSignInBloc {
  final StreamController<PhoneSignInModel> _modelController = StreamController<
      PhoneSignInModel>();

  Stream<PhoneSignInModel> get modelStream => _modelController.stream;
  PhoneSignInModel _model = PhoneSignInModel();
  bool _isDisposed=false;

  void dispose() {
    print('dispose called from PhoneSignInBloc');
    _modelController.close();
    _isDisposed=true;
  }

  void continued(){
    updateWith(continued: true);
  }

  void updateWith({
    String phoneNumber,
    bool isLoading,
    bool continued
  }) {
    _model = _model.copyWith(
      phoneNumber: phoneNumber,
      isLoading: isLoading,
      continued: continued,
    );

    if(!_isDisposed) {
      _modelController.add(_model);
    }
  }
}