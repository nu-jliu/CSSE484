const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp();


const FIRESTORE_GRADE_KEY = 'grade';
const FIRESTORE_WEIGHT_KEY = 'weight';

const FIRESTORE_COURSES_COLLECTION_PATH = 'courses'
const FIRESTORE_USERS_COLLECTION_PATH = 'users'

const FIRESTORE_EXAMS_COLLECTION_PATH = 'exams'
const FIRESTORE_ASSIGNMENTS_COLLECTION_PATH = 'assignments'
const FIRESTORE_QUIZZES_COLLECTION_PATH = 'quizzes'
const FIRESTORE_LABS_COLLECTION_PATH = 'labs'

const coursesRef = admin.firestore().collection(FIRESTORE_COURSES_COLLECTION_PATH);
const usersRef = admin.firestore().collection(FIRESTORE_USERS_COLLECTION_PATH);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//

exports.addCourse = functions.https.onRequest(async(req, res) => {
    const courseName = req.query.name;
    const uid = req.query.uid;
    const result = await coursesRef.add({
        name: courseName,
        takenBy: uid
    });

    await result.set({
        participationWeight: 10,
        participationGrade: 99,
        assignmentsWeight: 10,
        examsWeight: 60,
        labsWeight: 20,
        quizzesWeight: 0
    });

    await result.collection(FIRESTORE_ASSIGNMENTS_COLLECTION_PATH).add({
        grade: 100,
        weight: 10
    });

    await result.collection(FIRESTORE_LABS_COLLECTION_PATH).add({
        grade: 100,
        weight: 10
    });

    await result.collection(FIRESTORE_QUIZZES_COLLECTION_PATH).add({
        grade: 100,
        weight: 10
    });

    await result.collection(FIRESTORE_EXAMS_COLLECTION_PATH).add({
        grade: 100,
        weight: 10
    });

    res.json({
        result: `Course with id: ${result.id} successfully added`
    });
});

exports.getTotalGradeForCourse = functions.https.onRequest(async(req, res) => {
    const courseId = req.query.courseId;

    let totalGrade = 0;
    let totalWeight = 0;


    let assignGrade = 0;
    let examGrade = 0;
    let labGrade = 0;
    let quizGrade = 0;
    const courseSnapshot = await coursesRef.doc(courseId).get();

    if (!courseSnapshot.exists) {
        console.error(`ERROR: course ${courseId} not exist`);
        res.json({
            result: 'error'
        })
    }
    const courseRef = courseSnapshot.ref;

    // participation
    const partWeight = courseSnapshot.get('participationWeight');
    const partGrade = courseSnapshot.get('participationGrade');

    totalWeight += partWeight;
    totalGrade += partGrade / 100 * partWeight;

    // assignments
    const assignOverallWeight = courseSnapshot.get('assignmentsWeight');
    totalWeight += assignOverallWeight;

    if (assignOverallWeight != 0) {
        const assignRef = courseRef.collection(FIRESTORE_ASSIGNMENTS_COLLECTION_PATH);
        await assignRef.get().then(querySnapshot => {
            let assignTotalWeight = 0;
            let assignTotalGrade = 0;

            querySnapshot.forEach(docSnapshot => {
                const assignWeight = docSnapshot.get(FIRESTORE_WEIGHT_KEY);
                const assignGrade = docSnapshot.get(FIRESTORE_GRADE_KEY);

                assignTotalWeight += assignWeight;
                assignTotalGrade += assignGrade / 100 * assignWeight;
            });

            assignGrade = assignTotalGrade / assignTotalWeight * assignOverallWeight;
            totalGrade += assignGrade;
        }).catch(err => {
            console.error('ERROR: unable to get assignments');
        });
    }

    // exams
    const examsOverallWeight = courseSnapshot.get('examsWeight');
    totalWeight += examsOverallWeight;

    if (examsOverallWeight > 0) {
        const examsRef = courseRef.collection(FIRESTORE_EXAMS_COLLECTION_PATH);
        await examsRef.get().then(querySnapshot => {
            let examsTotalWeight = 0;
            let examsTotalGrade = 0;

            querySnapshot.forEach(docSnapshot => {
                const examWeight = docSnapshot.get(FIRESTORE_WEIGHT_KEY);
                const examGrade = docSnapshot.get(FIRESTORE_GRADE_KEY);

                examsTotalWeight += examWeight;
                examsTotalGrade += examGrade / 100 * examWeight;
            });

            examGrade = examsTotalGrade / examsTotalWeight * examsOverallWeight;
            totalGrade += examGrade;
        }).catch(err => {
            console.error('ERROR: unable to get exams');
        });
    }

    // labs
    const labsOverallWeight = courseSnapshot.get('labsWeight');
    totalWeight += labsOverallWeight;

    if (labsOverallWeight > 0) {
        const labsRef = courseRef.collection(FIRESTORE_LABS_COLLECTION_PATH);
        await labsRef.get().then(querySnapshot => {
            let labsTotalWeight = 0;
            let labsTotalGrade = 0;

            querySnapshot.forEach(docSnapshot => {
                const labWeight = docSnapshot.get(FIRESTORE_WEIGHT_KEY);
                const labGrade = docSnapshot.get(FIRESTORE_GRADE_KEY);

                labsTotalWeight += labWeight;
                labsTotalGrade += labGrade / 100 * labWeight;
            });

            labGrade = labsTotalGrade / labsTotalWeight * labsOverallWeight;
            totalGrade += labGrade;
        }).catch(err => {
            console.error('ERROR: unable to get labs');
        });
    }

    // quizzes
    const quizzesOverallWeight = courseSnapshot.get('quizzesWeight');
    totalWeight += quizzesOverallWeight;

    if (quizzesOverallWeight > 0) {
        const quizzesRef = courseRef.collection(FIRESTORE_QUIZZES_COLLECTION_PATH);
        await quizzesRef.get().then(querySnapshot => {
            let quizzesTotalWeight = 0;
            let quizzesTotalGrade = 0;

            querySnapshot.forEach(docSnapshot => {
                const quizWeight = docSnapshot.get(FIRESTORE_WEIGHT_KEY);
                const quizGrade = docSnapshot.get(FIRESTORE_GRADE_KEY);

                quizzesTotalWeight += quizWeight;
                quizzesTotalGrade += quizGrade / 100 * labWeight;
            });

            quizGrade = quizzesTotalGrade / quizzesTotalWeight * quizzesOverallWeight;
            totalGrade += quizGrade;
        }).catch(err => {
            console.error('ERROR: unable to get quizzes');
        });
    }

    res.json({
        result: 'success',
        totalGrade: totalGrade,
        totalWeight: totalWeight,
        partGrade: partGrade,
        partWeight: partWeight,
        assignGrade: assignGrade,
        assignWeight: assignOverallWeight,
        examGrade: examGrade,
        examWeight: examsOverallWeight,
        labGrade: labGrade,
        labWeight: labsOverallWeight,
        quizGrade: quizGrade,
        quizWeight: quizzesOverallWeight
    })
});