import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:sitaram_mandir/Utils/colors.dart';


class CustomLoadingAPI extends StatelessWidget {
  const  CustomLoadingAPI({
    super.key,
    this.color,
  });
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWaveSpinner(
        color: black,
        waveColor: Colors.teal,
      ),
    );
  }
}

class CustomLoadingAPI1 extends StatelessWidget {
  const CustomLoadingAPI1({
    super.key,
    this.color,
  });
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitHourGlass(
        color: Colors.white,
      ),
    );
  }
}

class CustomLoadingAPI2 extends StatelessWidget {
  const  CustomLoadingAPI2({
    super.key,
    this.color,
  });
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWaveSpinner(
        color: Colors.grey,
        waveColor: Colors.white,
      ),
    );
  }
}