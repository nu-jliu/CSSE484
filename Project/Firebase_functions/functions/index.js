const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
    functions.logger.info("Hello logs!", { structuredData: true });
    response.send("Hello from Firebase!");
});

exports.addCourse = functions.https.onRequest(async(req, res) => {
    const courseName = req.query.name;
    const result = await admin.firestore().collection('courses').add({
        name: courseName
    });

    res.json({
        result: `Course with id: ${result.id} successfully added`
    });
});