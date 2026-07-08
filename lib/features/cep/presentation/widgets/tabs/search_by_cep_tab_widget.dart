import 'package:cep_app/features/cep/domain/entities/address_entity.dart';
import 'package:cep_app/features/cep/presentation/constants/validation_messages_const.dart';
import 'package:cep_app/features/cep/presentation/mixins/cep_tec_mixin.dart';
import 'package:cep_app/features/cep/presentation/riverpod/cep_app_state.dart';
import 'package:cep_app/features/cep/presentation/riverpod/search_by_cep_riverpod.dart/cep_notifier_provider.dart';
import 'package:cep_app/features/cep/presentation/widgets/buttons/cep_button_widget.dart';
import 'package:cep_app/features/cep/presentation/widgets/inputs/cep_text_field_widget.dart';
import 'package:cep_app/features/cep/presentation/widgets/no_result_widget/no_result_widget.dart';
import 'package:cep_app/shared/theme/extensions/theme_extension.dart';
import 'package:cep_app/shared/ui/extensions/snack_bar_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const searchByZipCodeButtonKey = Key('searchByZipCodeButtonKey');

class SearchByCepTabWidget extends ConsumerStatefulWidget {
  const SearchByCepTabWidget({super.key});

  @override
  ConsumerState<SearchByCepTabWidget> createState() =>
      _SearchByCepTabWidgetState();
}

class _SearchByCepTabWidgetState extends ConsumerState<SearchByCepTabWidget>
    with CepTECMixin {
  final cepInputFN = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    onDispose();
    cepInputFN.dispose();
    super.dispose();
  }

  void onSearchCep() {
    if (formKey.currentState!.validate()) {
      ref
          .read(searchByCepNotifierProvider.notifier)
          .loadAddressByCep(cepTEC.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escuta o estado para disparar efeitos colaterais visuais (Ex: SnackBars)
    ref.listen<CepAppState>(searchByCepNotifierProvider, (previous, next) {
      if (next is SearchByCepOfflineSuccessState && context.mounted) {
        context.showSnackBar(SnackBarType.warning, next.warningMessage);
      }
    });

    final state = ref.watch(searchByCepNotifierProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Text('Insira um CEP', style: context.getTextTheme.titleMedium),
              SizedBox(height: 16),
              CepTextFieldWidget(
                textEC: cepTEC,
                placeholder: 'CEP',
                validator: (String? cep) {
                  if (cep == null || cep.isEmpty) {
                    return ValidationMessagesConst.notEmpty('CEP');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              CepButtonWidget(
                key: searchByZipCodeButtonKey,
                label: 'Procurar',
                onPressed: state is CepStateLoading
                    ? null
                    : () {
                        cepInputFN.unfocus();
                        onSearchCep();
                      },
              ),
              const SizedBox(height: 32),
              switch (state) {
                CepStateInitial() => const SizedBox.shrink(),
                CepStateLoading() => CircularProgressIndicator(),
                CepStateError(:final message) => Text(message),
                CepStateNoResult(:final message) => NoResultWidget(
                  text: message,
                ),
                SearchByCepSuccessState(:final address) => _AddressResult(
                  address: address,
                ),
                SearchByCepOfflineSuccessState(:final lastAddress) =>
                  _AddressResult(address: lastAddress),
                _ => const SizedBox.shrink(),
              },
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressResult extends StatelessWidget {
  final AddressEntity address;

  const _AddressResult({required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Resultado:', style: context.getTextTheme.titleLarge),
        // const SizedBox(height: 32),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CEP: ${address.cep}',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold // Força o subtítulo a ser escuro
                  ),
                ),
                const Divider(),
                Text(
                  'Cidade: ${address.localidade} - ${address.uf}',
                  style: const TextStyle(
                    color: Colors.black87, // Força o subtítulo a ser escuro
                  ),
                ),
                if (address.bairro.isNotEmpty)
                  Text(
                    'Bairro: ${address.bairro}',
                    style: const TextStyle(
                      color: Colors.black54, // Força o subtítulo a ser escuro
                    ),
                  ),
                if (address.logradouro.isNotEmpty)
                  Text(
                    'Logradouro: ${address.logradouro}',
                    style: const TextStyle(
                      color: Colors.black54, // Força o subtítulo a ser escuro
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
