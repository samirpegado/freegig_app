import 'package:flutter/material.dart';
import 'package:freegig_app/services/gigs/gigs_service.dart';
import 'package:freegig_app/common/widgets/gig_more_info.dart';
import 'package:iconsax/iconsax.dart';

class HomeAgenda extends StatefulWidget {
  const HomeAgenda({Key? key}) : super(key: key);

  @override
  State<HomeAgenda> createState() => _HomeAgendaState();
}

class _HomeAgendaState extends State<HomeAgenda> {
  late Stream<List<Map<String, dynamic>>> gigsDataList;

  @override
  void initState() {
    super.initState();
    gigsDataList = GigsDataService().getMyAllGigsStream();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: gigsDataList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Text('Erro: ${snapshot.error}');
            } else {
              List<Map<String, dynamic>> gigs = snapshot.data ?? [];

              if (gigs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Center(
                    child: Text(
                      'Suas próximas GIGs aparecerão aqui',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }

              return Column(
                children: gigs.map((gig) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => MoreInfo(gig: gig));
                      },
                      leading: Container(
                        height: double
                            .infinity, // Define a altura desejada para o ícone
                        child: Icon(Iconsax.category_2),
                      ),
                      title: Text(gig['gigDescription']),
                      subtitle: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(gig['gigDate']),
                            Expanded(
                                child: Text(' - ' + gig['gigInitHour'] + 'h')),
                          ]),
                      trailing: Icon(Iconsax.arrow_right_3),
                    ),
                  );
                }).toList(),
              );
            }
          }),
    );
  }
}
