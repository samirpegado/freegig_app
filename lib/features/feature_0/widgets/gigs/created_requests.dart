import 'package:flutter/material.dart';
import 'package:freegig_app/data/services/user_request.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:iconsax/iconsax.dart';

class RequestsSent extends StatefulWidget {
  final String gigUid;

  const RequestsSent({super.key, required this.gigUid});

  @override
  State<RequestsSent> createState() => _RequestsSentState();
}

class _RequestsSentState extends State<RequestsSent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: UserRequest().listRequestsByGigAndOwner(widget.gigUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Erro ao carregar convites: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container();
          } else {
            List<Map<String, dynamic>> requests = snapshot.data!;
            return ExpansionTile(
              initiallyExpanded: true,
              title: Text('Solicitações recebidas (${requests.length})'),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> requestData =
                        requests[index]['userRequestData'];
                    Map<String, dynamic> userData = requests[index]['userData'];

                    return ListTile(
                      leading: ClipOval(
                        child: Image.network(
                          userData['profileImageUrl'],
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Excluir solicitação',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      Icon(
                                        Iconsax.user_remove,
                                        color: Colors.blue,
                                        size: 30,
                                      )
                                    ],
                                  ),
                                  content: Text(
                                      'Deseja remover a solicitação de ${userData['publicName']} para participar da sua GIG?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Fechar',
                                          style: TextStyle(color: Colors.black),
                                        )),
                                    TextButton(
                                        onPressed: () async {
                                          await UserRequest().refuseRequest(
                                              requestData['requestUid']);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NavigationMenu(
                                                        navPage: 1,
                                                      )));
                                        },
                                        child: Text(
                                          'Remover',
                                          style: TextStyle(color: Colors.blue),
                                        ))
                                  ],
                                ),
                              );
                            },
                            icon: Icon(Icons.delete),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Confirmar',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      Icon(
                                        Iconsax.user_add,
                                        color: Colors.green,
                                        size: 30,
                                      )
                                    ],
                                  ),
                                  content: Text(
                                      'Deseja adicionar ${userData['publicName']} a sua GIG?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Fechar',
                                          style: TextStyle(color: Colors.black),
                                        )),
                                    TextButton(
                                        onPressed: () async {
                                          await UserRequest().acceptRequest(
                                              requestUid:
                                                  requestData['requestUid'],
                                              selectedGigUid:
                                                  requestData['gigUid'],
                                              requesterUid:
                                                  requestData['requesterUid']);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NavigationMenu(
                                                        navPage: 1,
                                                      )));
                                        },
                                        child: Text(
                                          'Adicionar',
                                          style: TextStyle(color: Colors.green),
                                        ))
                                  ],
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      title: Text(userData['publicName']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userData['category']),
                          Text(
                            requestData['requestStatus'],
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
