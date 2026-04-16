import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/domain/entities/get_ceps_details_by_local_details_body.dart';
import 'package:cep_app/features/cep/domain/use_cases/get_ceps_details_by_local_details.dart';
import 'package:cep_app/features/cep/presentation/riverpod/base_cep_app_state.dart';
import 'package:cep_app/features/cep/presentation/riverpod/search_by_local_details_riverpod/search_by_local_details_state.dart';
import 'package:cep_app/shared/data/async/either.dart';
import 'package:cep_app/shared/ui/extensions/snack_bar_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SearchByLocalDetailsNotifier
    extends StateNotifier<SearchByLocalDetailsState> {
  final GetCepsDetailsByLocalDetails _getCepsDetailsByLocalDetails;

  SearchByLocalDetailsNotifier(this._getCepsDetailsByLocalDetails)
    : super(const SearchByLocalDetailsState.initial());

  bool get isLoading => state.isLoading;

  Future<void> loadAddressByLocalDetails(
    GetCepsDetailsByLocalDetailsBody localDetailsBody,
    BuildContext context,
  ) async {

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      state: CepStateEnum.loading,
    );

    final cepEither = await _getCepsDetailsByLocalDetails(localDetailsBody);

    switch(cepEither) {
      case Left(value: final l): {
        final noInternetError = l is LocalDetailsInternetConnectionException;

        if (noInternetError && context.mounted) {
          context.showSnackBar(SnackBarType.error, l.message);
        }

        state = state.copyWith(
          isLoading: false,
          state: noInternetError ? CepStateEnum.loaded : CepStateEnum.error,
          errorMessage: noInternetError ? null : l.message, 
          localDetailsList: noInternetError ? l.cepList : null,
        );
      }

      case Right(value: final r): {
        state = state.copyWith(
          isLoading: false,
          state: r.isEmpty ? CepStateEnum.noResult : CepStateEnum.loaded,
          localDetailsList: r,
        );
      } 
    }
  }
}
