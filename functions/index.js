const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.archiveOldGigs = functions.pubsub.schedule('59 23 * * *').timeZone('America/Sao_Paulo').onRun(async (context) => {
  const currentDate = new Date();

  const gigsSnapshot = await admin.firestore().collection('gigs').get();

  const batch = admin.firestore().batch();

  gigsSnapshot.forEach((gigDoc) => {
    const gigData = gigDoc.data();
    const gigDate = parseDate(gigData.gigDate);

    if (gigDate < currentDate) {
      const gigRef = admin.firestore().collection('gigs').doc(gigDoc.id);
      batch.update(gigRef, { gigArchived: true });
    }
  });

  return batch.commit();
});

// Passa a string que vem do 'gigDate' e transfoma no objeto Date
function parseDate(dateString) {
  const [day, month, year] = dateString.split('-');
  return new Date(`${year}-${month}-${day}`);
}
