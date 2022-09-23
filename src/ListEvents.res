open Promise

type permission
    = Free
    | Blocked
    | Request

type event = {
    eventName: string,
    lastUpdated: int,
    permission: permission,
    end: int,
    primaryKey: string,
    start: int
}

type listEventOptions = {
    start: int,
    end: int,
    timezone: string
}

let listEvents = (dynamoFunc, options, firstIndex, afterToken) => {
    resolve(
        [
            { 
                eventName: "Test",
                lastUpdated: 123,
                permission: Blocked,
                end: 456,
                primaryKey: "event-123",
                start: 123
            }
        ]
    )
}