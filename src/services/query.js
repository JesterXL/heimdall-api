const aws = require('aws-sdk')
const dynamo = new aws.DynamoDB.DocumentClient()

dynamo.query({
    TableName: 'eventsAndApps',
    IndexName: 'listApps',
    KeyConditionExpression: 'PK = :PK',
    ExpressionAttributeValues: {
        ':PK': 'event-22'
    }
})
.promise()
.then(console.log)


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