import 'package:flutter/material.dart';

class TermsAndPrivacyDialog extends StatelessWidget {
  const TermsAndPrivacyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Termos de Uso e Política de Privacidade\n\n"
                "Última Atualização: 18 de dezembro de 2023\n\n"
                "Bem-vindo ao FreeGIG!\n\n"
                "Ao utilizar nosso aplicativo, você concorda com os seguintes Termos de Uso e Política de Privacidade. Recomendamos que leia cuidadosamente este documento antes de prosseguir.\n\n"
                "Termos de Uso\n\n"
                "Responsabilidades dos Usuários:\nO usuário é totalmente responsável pelas gigs que agenda, participa ou cria. O não cumprimento de compromissos, faltas em gigs ou desistências sem aviso prévio são de responsabilidade exclusiva dos usuários envolvidos.\n\n"
                "Conversas e Comunicação:\nTodas as conversas, mensagens e interações no aplicativo são de responsabilidade dos usuários envolvidos. Reservamo-nos o direito de monitorar o conteúdo do chat para garantir a conformidade com estes Termos de Uso.\n\n"
                "Arquivamento de Gigs:\nApós a data de um show, as gigs são automaticamente arquivadas. Os usuários podem arquivar ou excluir suas próprias gigs a qualquer momento. Não nos responsabilizamos por eventos ocorridos após o arquivamento ou exclusão da gig.\n\n"
                "Avaliações:\nApós o arquivamento de uma gig, os usuários podem receber notificações para avaliarem uns aos outros. A responsabilidade pela precisão e justiça das avaliações é dos usuários.\n\n"
                "Exibição de Anúncios e Propagandas:\nAo utilizar o aplicativo, o usuário autoriza o FreeGIG a exibir anúncios e propagandas dentro da aplicação.\n\n"
                "Política de Privacidade\n\n"
                "Armazenamento de Dados:\nOs dados dos usuários, incluindo números de telefone, são armazenados no Firebase, uma plataforma segura. Não tratamos informações sigilosas dos usuários.\n\n"
                "Coleta de Informações:\nColetamos informações necessárias para o funcionamento do aplicativo, como nome de usuário, e-mail, informações relacionadas à gigs e números de telefone. O número de telefone é coletado para permitir ações corretivas em casos de mau comportamento.\n\n"
                "Uso de Números de Telefone:\nOs números de telefone coletados serão utilizados exclusivamente para: Em casos de mau comportamento, insultos ou violações dos Termos de Uso, reservamo-nos o direito de entrar em contato com os usuários por meio de seus números de telefone para esclarecimentos.\n\n"
                "Comportamento Adequado:\nO FreeGIG preza pelo bem-estar e pelo respeito mútuo de todos os usuários, portanto não é permitido insultos, mau comportamento, falsidade ideológica, falsificação de gigs e dados. Reservamo-nos o direito de, a qualquer momento, excluir a conta de usuários que violarem essas diretrizes.\n\n"
                "Segurança:\nEmpregamos medidas de segurança para proteger as informações dos usuários, incluindo números de telefone. No entanto, não podemos garantir segurança absoluta em todas as situações.\n\n"
                "Responsabilidade dos Usuários:\nOs usuários são inteiramente responsáveis pela veracidade dos dados cadastrais fornecidos e dos dados compartilhados nas funcionalidades do aplicativo. Recomendamos que os usuários forneçam informações precisas e atualizadas para garantir uma experiência eficiente e confiável.\n\n"
                "Alterações na Política de Privacidade:\nReservamo-nos o direito de fazer alterações nesta Política de Privacidade. Aconselhamos que os usuários revisem periodicamente este documento.\n\n"
                "Ao utilizar nosso aplicativo, você concorda com estes termos. Agradecemos por escolher FreeGIG! Se tiver dúvidas ou preocupações, entre em contato conosco em freegigbr@gmail.com.\n\n"
                "FreeGIG",
                textAlign: TextAlign.justify,
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Fechar'))
          ],
        ),
      ),
    );
  }
}
