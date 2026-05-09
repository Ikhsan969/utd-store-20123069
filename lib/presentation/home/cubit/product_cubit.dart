// lib/presentation/home/cubit/product_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase getProductsUseCase;

  ProductCubit(this.getProductsUseCase) : super(const ProductInitial());

  Future<void> loadProducts() async {
    emit(const ProductLoading());
    try {
      final products = await getProductsUseCase.execute();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Gagal memuat produk: ${e.toString()}'));
    }
  }
}
