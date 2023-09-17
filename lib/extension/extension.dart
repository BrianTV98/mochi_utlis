
import 'package:flutter/material.dart';

extension BuilderContextExtension on BuildContext {
   ThemeData get theme => Theme.of(this);
   TextTheme get textTheme => theme.textTheme;
   double get  withScreenUtil => MediaQuery.of(this).size.width;
   double get  heightScreenUtils => MediaQuery.of(this).size.height;
}