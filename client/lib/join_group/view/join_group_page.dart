import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:survival_list/join_group/join_group.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class JoinGroupPage extends StatelessWidget {
  const JoinGroupPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => JoinGroupBloc(
          survivalListRepository: context.read<SurvivalListRepository>(),
        ),
        child: const JoinGroupPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JoinGroupBloc, JoinGroupState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == JoinGroupStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const JoinGroupView(),
    );
  }
}

class JoinGroupView extends StatelessWidget {
  const JoinGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((JoinGroupBloc bloc) => bloc.state.status);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.joinGroupAppBarTitle),
      ),
      body: status.isLoadingOrSuccess
          ? const Center(child: CupertinoActivityIndicator())
          : Stack(
              children: [
                MobileScanner(
                  onDetect: (capture) {
                    for (final barcode in capture.barcodes) {
                      if (barcode.rawValue != null) {
                        final res = RegExp(r'^survival-list:(.*)$')
                            .firstMatch(barcode.rawValue!);
                        if (res != null) {
                          context
                              .read<JoinGroupBloc>()
                              .add(JoinGroupQrCodeScanned(res[1]!));
                        }
                      }
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            backgroundBlendMode: BlendMode.overlay,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              l10n.joinGroupHelpText,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
