import 'package:cep_app/features/cep/domain/entities/address_entity.dart';
import 'package:cep_app/features/cep/presentation/constants/validation_messages_const.dart';
import 'package:cep_app/features/cep/presentation/mixins/search_cep_local_details_mixin.dart';
import 'package:cep_app/features/cep/presentation/riverpod/cep_app_state.dart';
import 'package:cep_app/features/cep/presentation/riverpod/search_by_local_details_riverpod/local_details_notifier_provider.dart';
import 'package:cep_app/features/cep/presentation/widgets/buttons/cep_button_widget.dart';
import 'package:cep_app/features/cep/presentation/widgets/inputs/cep_text_field_widget.dart';
import 'package:cep_app/features/cep/presentation/widgets/no_result_widget/no_result_widget.dart';
import 'package:cep_app/shared/theme/extensions/theme_extension.dart';
import 'package:cep_app/shared/ui/extensions/snack_bar_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Key searchZipCodeByLocalDetailsButtonKey = Key(
  'searchZipCodeByLocalDetailsButtonKey',
);

class SearchByLocalDetailsTabWidget extends ConsumerStatefulWidget {
  const SearchByLocalDetailsTabWidget({super.key});

  @override
  ConsumerState<SearchByLocalDetailsTabWidget> createState() =>
      _SearchByLocalDetailsTabWidgetState();
}

class _SearchByLocalDetailsTabWidgetState
    extends ConsumerState<SearchByLocalDetailsTabWidget>
    with SearchCepLocalDetailsMixin {
  final formKey = GlobalKey<FormState>();

  void onSearchByLocalDetails() {
    if (formKey.currentState!.validate()) {
      // Clean Code: Evita instanciar classes de domínio diretamente nos widgets da UI.
      ref
          .read(searchByLocalDetailsNotifierProvider.notifier)
          .loadAddressByLocalDetails(
            estado: estadoTEC.text,
            cidade: cidadeTEC.text,
            rua: ruaTEC.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escuta o estado para injetar o aviso visual de contingência offline na UI
    ref.listen<CepAppState>(searchByLocalDetailsNotifierProvider, (
      previous,
      next,
    ) {
      if (next is SearchByLocalDetailsOfflineSuccessState && context.mounted) {
        context.showSnackBar(SnackBarType.warning, next.warningMessage);
      }
    });

    final state = ref.watch(searchByLocalDetailsNotifierProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Text('Insira um local:', style: context.getTextTheme.titleMedium),
              const SizedBox(height: 16),
              CepTextFieldWidget(
                textEC: estadoTEC,
                focusNode: estadoFN,
                placeholder: 'Estado',
                validator: (String? estado) {
                  if (estado == null || estado.isEmpty) {
                    return ValidationMessagesConst.notEmpty('Estado');
                  } else if (estado.length > 2) {
                    return ValidationMessagesConst.length('Estado', 2);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CepTextFieldWidget(
                textEC: cidadeTEC,
                focusNode: cidadeFN,
                placeholder: 'Cidade',
                validator: (String? cidade) {
                  if (cidade == null || cidade.isEmpty) {
                    return ValidationMessagesConst.notEmpty('Cidade');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CepTextFieldWidget(
                textEC: ruaTEC,
                focusNode: ruaFN,
                placeholder: 'Rua',
                validator: (String? rua) {
                  if (rua == null || rua.isEmpty) {
                    return ValidationMessagesConst.notEmpty('Rua');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              CepButtonWidget(
                key: searchZipCodeByLocalDetailsButtonKey,
                label: 'Procurar',
                onPressed: () {
                  if (state is CepStateLoading) return;

                  FocusScope.of(context).requestFocus(FocusNode());
                  onSearchByLocalDetails();
                },
              ),
              const SizedBox(height: 16),
              switch (state) {
                CepStateInitial() => const SizedBox.shrink(),
                CepStateLoading() => const CircularProgressIndicator(),
                CepStateError(:final message) => Text(message),
                CepStateNoResult(:final message) => NoResultWidget(
                  text: message,
                ),
                SearchByLocalDetailsSuccessState(:final addressesList) =>
                  _AddressesListResult(addressesList: addressesList),
                SearchByLocalDetailsOfflineSuccessState(:final addressesList) =>
                  _AddressesListResult(addressesList: addressesList),
                _ => SizedBox.shrink(),
              },
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressesListResult extends StatelessWidget {
  final List<AddressEntity> addressesList;

  const _AddressesListResult({required this.addressesList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        // Text('Resultados:', style: context.getTextTheme.titleLarge),
        Text(
          'Resultados encontrados (${addressesList.length}):',
          style: context.getTextTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        // Flutter Performance: Substituído o map().toList() por um construtor otimizado e sob demanda
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: addressesList.length,
          itemBuilder: (ctx, index) {
            final item = addressesList[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(
                  item.cep,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${item.logradouro}\n${item.bairro} - ${item.localidade}/${item.uf}',
                  style: const TextStyle(
                    color: Colors.black54, // Força o subtítulo a ser escuro
                  ),
                ),
                isThreeLine: true,
              ),
            );
          },
        ),
      ],
    );
  }
}
