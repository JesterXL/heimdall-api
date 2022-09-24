const aws = require('aws-sdk')
const dynamo = new aws.DynamoDB.DocumentClient({ region: 'us-east-1'})
const dynamoRoot = new aws.DynamoDB({ region: 'us-east-1' })

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
            ? ({ items: Items, lastEvaluatedKey: LastEvaluatedKey, hasNextPage: true, ok: true })
            : ({ items: Items, hasNextPage: false, ok: true })
    )
    .catch(
        error =>
            Promise.resolve({ ok: false, error: `DynamoDB error: ${error?.message}`, items: [] })
    )

const getTotalItems = () =>
    dynamoRoot.describeTable({
        TableName: 'eventsAndApps',
    })
    .promise()
    .then(
        ({ Table }) =>
            Table
    )
    .then(
        ({ ItemCount }) =>
            ItemCount
    )

getTotalItems().then(console.log)

module.exports = {
    listEvents,
    getTotalItems
}