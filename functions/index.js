const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.archiveOldGigs = functions.pubsub
  .schedule('0 2 * * *') // Executa todos os dias às 2h da madrugada
  .timeZone('America/Sao_Paulo')
  .onRun(async (context) => {
    const currentDate = new Date();
    currentDate.setDate(currentDate.getDate() - 1); // Subtrai 1 dia da data atual

    const gigsSnapshot = await admin.firestore().collection('gigs').get();

    const batch = admin.firestore().batch();
    const notificationsBatch = admin.firestore().batch();  
    const chatRoomsBatch = admin.firestore().batch(); // Batch para chat_rooms

    gigsSnapshot.forEach(async (gigDoc) => {
      const gigData = gigDoc.data();
      const gigDate = parseDate(gigData.gigDate);

      if (gigDate <= currentDate && gigData.gigArchived === false) {
        const gigRef = admin.firestore().collection('gigs').doc(gigDoc.id);
        batch.update(gigRef, { gigArchived: true });

        // Obtém os documentos da query chat_rooms
        const chatRoomQuery = admin.firestore().collection('chat_rooms').where('gigSubjectUid', '==', gigDoc.id);
        const chatRoomDocs = await chatRoomQuery.get();

        // Itera sobre os documentos para criar batch de atualização
        chatRoomDocs.forEach((chatRoomDoc) => {
          const chatRoomRef = admin.firestore().collection('chat_rooms').doc(chatRoomDoc.id);
          chatRoomsBatch.delete(chatRoomRef); // Alteração aqui: use delete() em vez de update()
        });

        // Criação de notificações apenas quando há mais de um participante na GIG recém-arquivada
        const gigParticipants = gigData.gigParticipants || [];
        if (gigParticipants.length > 1) {
          gigParticipants.forEach((participantUid) => {
            const notificationRef = admin.firestore().collection('notifications').doc();
            notificationsBatch.set(notificationRef, {
              body: 'Compartilhe suas avaliações sobre os participantes envolvidos nesta GIG',
              notificationUid: notificationRef.id,
              recipientID: participantUid,
              gigUid: gigDoc.id,
              title: gigData.gigDescription,
              type: 'rate'
            });
          });
        }
      }
    });

    // Executa as operações em lote
    await batch.commit();
    await notificationsBatch.commit();
    await chatRoomsBatch.commit();

    return null; // Retornamos null, pois não precisamos de um valor específico ao concluir a função.
  });

// Função para converter a string de data em um objeto Date
function parseDate(dateString) {
  const [day, month, year] = dateString.split('-');
  return new Date(`${year}-${month}-${day}`);
}
