const aws = require('aws-sdk')
const dynamo = new aws.DynamoDB.DocumentClient({ region: 'us-east-1'})

// dynamo.query({
//     TableName: 'eventsAndApps',
//     IndexName: 'listEvents',
//     KeyConditionExpression: 'PK = :PK',
//     ExpressionAttributeValues: {
//         ':PK': 'event'
//     },
//     Limit: 1,
//     ExclusiveStartKey: undefined
// })
// .promise()
// .then(
//     ({ Items, LastEvaluatedKey }) =>
//         ({ items: Items, lastEvaluatedKey: LastEvaluatedKey })
// )
// .then(console.log)

// naive implementation that doesn't really allow efficient
// paging right now.
const listEvents = (startTime, endTime, first, lastEvaluatedKey) =>
    dynamo.query({
        TableName: 'eventsAndApps',
        IndexName: 'listEvents',
        KeyConditionExpression: 'PK = :PK AND #start BETWEEN :startTime AND :endTime',
        ExpressionAttributeNames: {
            '#start': 'start',
        },
        ExpressionAttributeValues: {
            ':PK': 'event',
            ':startTime': startTime,
            ':endTime': endTime
        },
        // Limit: limit,
        LastEvaluatedKey: lastEvaluatedKey
    })
    .promise()
    .then(
        ({ Items, LastEvaluatedKey }) =>
            LastEvaluatedKey
            ? ({ items: Items, lastEvaluatedKey: LastEvaluatedKey, ok: true })
            : ({ items: Items, ok: true })
    )
    .catch(
        error =>
            Promise.resolve({ ok: false, error: `DynamoDB error: ${error?.message}`, items: [] })
    )

// listEvents(90, 200, 1, undefined).then(console.log)

// KeyConditionExpression: "Id = :id AND #DocTimestamp BETWEEN :start AND :end",
//    ExpressionAttributeNames: {
//      '#DocTimestamp': 'Timestamp'
//    },
//    ExpressionAttributeValues: {
//      ":id": "SOME VALUE",
//      ":start": 1,
//      ":end": 10
//    }


// ExpressionAttributeValues: {
//     ':s': {N: '2'},
//     ':e' : {N: '09'},
//     ':topic' : {S: 'PHRASE'}
//   },
//   KeyConditionExpression: 'Season = :s and Episode > :e',
//   ProjectionExpression: 'Episode, Title, Subtitle',
//   FilterExpression: 'contains (Subtitle, :topic)',
//   TableName: 'EPISODES_TABLE'

// var params = {
//   TableName: 'Table',
//   IndexName: 'Index',
//   KeyConditionExpression: 'HashKey = :hkey and RangeKey > :rkey',
//   ExpressionAttributeValues: {
//     ':hkey': 'key',
//     ':rkey': 2015
//   }
// };

// var documentClient = new AWS.DynamoDB.DocumentClient();

// documentClient.query(params, function(err, data) {
//    if (err) console.log(err);
//    else console.log(data);
// });


// create event
// edit event
// deleteEvent
// PK      | start | end | eventName | permission
// event-22  1334    1355  test        blocked

// create app
// delete app
// update app
// PK     | name | owner | lead | appType
// app-72   Calc   Jesse   Mark   store customer

// list events
// PK      | start | end | eventName | permission
// event-22  1334    1355  test        blocked

// list apps
// PK     | name | owner | lead | appType
// app-72   Calc   Jesse   Mark   store customer

// needs creation date and last updated date


module.exports = {
    listEvents
}