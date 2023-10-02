const { initializeApp, applicationDefault, cert } = require('firebase-admin/app');
const { getFirestore, Timestamp, FieldValue, Filter, QueryDocumentSnapshot } = require('firebase-admin/firestore');
const { databaseError, flightExistsError, writeMatchesError, noFlightError} = require('./utils/error'); // Adjust the file path accordingly
const {isoToCustomFormat, timestampToISO} = require('./utils/timeUtils');
const { v1: uuidv1, v4: uuidv4,} = require('uuid');
const moment = require('moment');
const serviceAccount = require('../lion-pool-f5755-firebase-adminsdk-zzm20-5b403629fd.json');
const admin = require('firebase-admin');
const { request } = require('express');


async function changeFlightStatus (recieverFlightId, recieverUserId, senderFlightId, senderUserId){
	try{
		await db.collection('users').doc(recieverUserId).collection('userFlights').doc(recieverFlightId).update({foundMatch: true})
		await db.collection('users').doc(senderUserId).collection('userFlights').doc(senderFlightId).update({foundMatch: true})
		console.log("Updated user flights for "+recieverUserId+" and "+senderUserId);
		return
	}catch(error){
		console.error("Error updating flight status, ",error);
	}
}

async function fetchFlights(userId){
	return new Promise(async(resolve, reject) => {
		const flights = []
		try{
			const userFlights = await db.collection('users').doc(userId).collection('userFlights').get();
			if (userFlights.empty) {
				resolve(flights) 
			} else{
				userFlights.forEach	(flight => {
					flights.push({
						id: flight.data()['id'],
						userId: flight.data()['userId'],
						airport: flight.data()['airport'],
						date: (flight.data()['date']).toDate().toISOString(),
						foundMatch: flight.data()['foundMatch']
					});
				});
				resolve(flights);
		}
		}catch(error){
			reject(error)
		}
	});
}

async function addFlight(userId, date, airport){
	return new Promise(async(resolve, reject) => {
		const formattedDate = new Date(date);
		const startOfDay = new Date(date);
		startOfDay.setHours(0,0,0,0);
		const endOfDay = new Date(date);
		endOfDay.setHours(23,59,59,999);

		// Range
		const start = Timestamp.fromDate(startOfDay)
		const end =Timestamp.fromDate(endOfDay)

		const checkExistingQuery =  db.collection('users')
										.doc(userId)
										.collection('userFlights')
										.where("date", ">=",start)
										.where("date", "<=", end);
		
	
		try {
			//Runs the query to ensure there is not already a flight there
			let checkExistSnapshot = await checkExistingQuery.get();

			// TODO: Existing flight already, make custom error 
			if (!checkExistSnapshot.empty){
				throw new flightExistsError();
			} else {
				// Generate an Id for this flight 
				const flightId = uuidv1();

				// Storing data in user collection 
				const flightDataForUser = {
					id: flightId,
					userId: userId,
					airport: airport,
					date: formattedDate,
					foundMatch: false
				};
				await db.collection('users')
									.doc(userId)
									.collection('userFlights')
									.doc(flightId)
									.set(flightDataForUser);

				// Storing data in flight collection
				const flightDataForAirport = {
					id: flightId,
					userId: userId,
					date: formattedDate, 
					foundMatch: false
				};

				const document_name = `${flightId}-${userId}`
				await db.collection('flights')
							.doc(airport)
							.collection('userFlights')
							.doc(document_name)
							.set(flightDataForAirport);

				resolve(flightDataForUser)
			}
		} catch (error) {
			if (error instanceof flightExistsError){
				reject(error)
			} else {
				reject(new databaseError());
			}
		}
	})
}

async function deleteFlight (flightId, userId, airport){
	return new Promise(async(resolve, reject) => {
		const document_name = `${flightId}-${userId}`

		try{		
			await cleanUpFromDelete(flightId, userId, airport);

			await db.collection('users')
				.doc(userId)
				.collection('userFlights')
				.doc(flightId)
				.delete();

			await db.collection('flights')
				.doc(airport)
				.collection('userFlights')
				.doc(document_name)
				.delete();
			resolve(null);

		}catch(error){
			reject(error);
		}
	});
}

async function cleanUpFromDelete (flightId, userId, airport){
	const outRequestsQuery = db.collection('users')
								.doc(userId)
								.collection('outRequests')

	var recieverUserIdFromOut;
	var requestIDFromOut;
	var senderUserId;
	var requestId;

	//This works
	const outRequestsSnapshot = await outRequestsQuery.where('senderFlightId', '==', flightId).get()
	
	if (!outRequestsSnapshot.empty){
		outRequestsSnapshot.forEach(doc => {
			recieverUserIdFromOut = doc.data()['recieverUserId'];
			requestIDFromOut = doc.data()['id'];
			doc.ref.delete();
		});

		const inRequestsQuery = await db.collection('users')
								.doc(recieverUserIdFromOut)
								.collection('inRequests')
								.doc(requestIDFromOut).get();

		if (!inRequestsQuery.empty){
			inRequestsQuery.forEach(doc => {
				doc.ref.delete()
		})
	}
	}
}

module.exports ={
	fetchFlights,
	addFlight,
	changeFlightStatus,
	deleteFlight
}