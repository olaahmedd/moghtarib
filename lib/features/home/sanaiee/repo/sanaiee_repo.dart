import 'package:dartz/dartz.dart';
import '../../../../core/network/api_helper.dart';
import '../../../../core/network/end_points.dart';
import '../model/department_model.dart';

class SanaieeRepo {

Future<Either<String, bool>> addDepartment(String deptName) async {
  final result = await ApiHelper.post(
    endPoint: EndPoints.postDepartment, 
    data: DepartmentModel(name: deptName).toJson(),
    isProtected: true,
  );
  return result.fold(
    (error) => Left(error),
    (response) => const Right(true),
  );
}

}