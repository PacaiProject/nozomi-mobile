import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mikhuy/app/app.dart';
import 'package:mikhuy/home/cubit/establishment_list_cubit.dart';
import 'package:mikhuy/outstanding_reservations/view/outstanding_reservations_page.dart';
import 'package:mikhuy/theme/theme.dart';

class EstablishmentsSearchBar extends StatelessWidget {
  const EstablishmentsSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.shade700.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(2, 4), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Establecimiento, producto...',
                contentPadding: EdgeInsets.all(4),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  context.read<EstablishmentListCubit>().getEstablisments();
                }
              },
              onSubmitted: (value) => context
                  .read<EstablishmentListCubit>()
                  .searchEstablishments(value),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<bool>(
                builder: (_) => const OutstandingReservationsPage(),
              ),
            ),
            icon: Icon(
              MdiIcons.shopping,
              color: AppColors.grey.shade800,
              size: 24,
            ),
          ),
          PopupMenuButton(
            position: PopupMenuPosition.under,
            icon: Icon(
              MdiIcons.dotsVertical,
              color: AppColors.grey.shade800,
              size: 24,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: const Text('Cerrar sesión'),
                onTap: () async {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        title: const Icon(MdiIcons.exclamation),
                        content: const Text('¿Está seguro/a de cerrar sesión?'),
                        actionsPadding: const EdgeInsets.only(
                          bottom: 16,
                          left: 16,
                          right: 16,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              context.read<AppBloc>().add(AppLogoutRequested());
                            },
                            style: AppTheme.secondaryButton,
                            child: const Text('Confirmar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Volver atrás'),
                          ),
                        ],
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}