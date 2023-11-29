const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.archiveOldGigs = functions.pubsub
  .schedule('59 23 * * *')
  .timeZone('America/Sao_Paulo')
  .onRun(async (context) => {
    const currentDate = new Date();

    const gigsSnapshot = await admin.firestore().collection('gigs').get();

    const batch = admin.firestore().batch();
    const notificationsBatch = admin.firestore().batch();

    gigsSnapshot.forEach((gigDoc) => {
      const gigData = gigDoc.data();
      const gigDate = parseDate(gigData.gigDate);

      if (gigDate < currentDate && gigData.gigArchived === false) {
        const gigRef = admin.firestore().collection('gigs').doc(gigDoc.id);
        batch.update(gigRef, { gigArchived: true });

        // Criação de notificações apenas quando há mais de um participante na GIG recém-arquivada
        const gigParticipants = gigData.gigParticipants || [];
        if (gigParticipants.length > 1) {
          gigParticipants.forEach((participantUid) => {
            const notificationRef = admin.firestore().collection('rateNotification').doc();
            notificationsBatch.set(notificationRef, {
              rateNotificationUid: notificationRef.id,
              participantUid,
              gigUid: gigDoc.id,
              gigDescription: gigData.gigDescription,
            });
          });
        }
      }
    });

    // Executa as operações em lote
    await batch.commit();
    await notificationsBatch.commit();

    return null; // Retornamos null, pois não precisamos de um valor específico ao concluir a função.
  });

// Função para converter a string de data em um objeto Date
function parseDate(dateString) {
  const [day, month, year] = dateString.split('-');
  return new Date(`${year}-${month}-${day}`);
}
