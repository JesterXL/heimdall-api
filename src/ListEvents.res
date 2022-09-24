open Promise

module RequestCodecs = {

    type timeRange = {
        start: int,
        end: int
    }

    let timeRange = Jzon.object2(
        ({ start, end }) => ( start, end ),
        (( start, end )) => { start, end } -> Ok,
        Jzon.field("start", Jzon.int),
        Jzon.field("end", Jzon.int)
    )

    type arguments = {
        timeRange: timeRange,
        first: int,
        after: string
    }

    let arguments = Jzon.object3(
        ({ timeRange, first, after }) => ( timeRange, first, after ),
        (( timeRange, first, after )) => { timeRange, first, after } -> Ok,
        Jzon.field("timeRange", timeRange),
        Jzon.field("first", Jzon.int),
        Jzon.field("after", Jzon.string)
    )

    type inputEvent = {
        arguments: arguments
    }

    let inputEvent = Jzon.object1(
        ({ arguments }) => ( arguments ),
        (( arguments )) => { arguments: arguments } -> Ok,
        Jzon.field("arguments", arguments)
    )
}

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
    firstIndex: int,
    afterToken: Js.Option.t<string>
}

module Codecs = {

    type lastEvaluatedEvent = {
        primaryKey: string,
        start: int,
        end: int
    }

    let lastEvaluatedEvent = Jzon.object3(
        ({ primaryKey, start, end }) => ( primaryKey, start, end ),
        (( primaryKey, start, end )) => { primaryKey, start, end } -> Ok,
        Jzon.field("PK", Jzon.string),
        Jzon.field("start", Jzon.int),
        Jzon.field("end", Jzon.int)
    )

    type listEventsDynamoResponse = {
        items: Js.Array.t<event>,
        lastEvaluatedKey: Js.Option.t<lastEvaluatedEvent>,
        ok: bool,
        error: Js.Option.t<string>
    }

    let permissionToString = permission =>
        switch permission {
        | Free => "free"
        | Blocked => "blocked"
        | Request => "request"
        }

    let event = Jzon.object6(
        ({ eventName, lastUpdated, permission, end, primaryKey, start }) => ( eventName, lastUpdated, permissionToString(permission), end, primaryKey, start ),
        (( eventName, lastUpdated, permissionString, end, primaryKey, start )) =>
            switch permissionString {
            | "free" => { eventName, lastUpdated, permission: Free , end, primaryKey, start } -> Ok
            | "blocked" => { eventName, lastUpdated, permission: Blocked , end, primaryKey, start } -> Ok
            | "request" => { eventName, lastUpdated, permission: Request , end, primaryKey, start } -> Ok
            | x => Error(#UnexpectedJsonValue([Field("permission")], x))
            },
        Jzon.field("eventName", Jzon.string),
        Jzon.field("lastUpdated", Jzon.int),
        Jzon.field("permission", Jzon.string),
        Jzon.field("end", Jzon.int),
        Jzon.field("PK", Jzon.string),
        Jzon.field("start", Jzon.int)
    )

    let listEventsDynamoResponse = Jzon.object4(
        ({ items, lastEvaluatedKey, ok, error }) => ( items, lastEvaluatedKey, ok, error ),
        (( items, lastEvaluatedKey, ok, error )) => { items, lastEvaluatedKey, ok, error } -> Ok,
        Jzon.field("items", Jzon.array(event)),
        Jzon.field("lastEvaluatedKey", lastEvaluatedEvent)->Jzon.optional,
        Jzon.field("ok", Jzon.bool),
        Jzon.field("error", Jzon.string) -> Jzon.optional
    )
}


@module("./services/query.js") external listEventsJS: (int, int, int, string) => Promise.t<Js.Json.t> = "listEvents"

exception ListEventsException(string)

let listEvents = (listEventsFromDynamoFunc, event) => {
    switch Jzon.decodeWith(event, RequestCodecs.inputEvent) {
    | Error(reason) => reject(ListEventsException(Jzon.DecodingError.toString(reason)))
    | Ok(options) => resolve(options)
    }
    ->then(
        event =>
            listEventsFromDynamoFunc(event.arguments.timeRange.start, event.arguments.timeRange.end, event.arguments.first, event.arguments.after)
    )
    ->then(
        response => {
            Js.log2("listEvents response:", response)
            switch Jzon.decodeWith(response, Codecs.listEventsDynamoResponse) {
            | Error(reason) => reject(ListEventsException("listEvents failed to decode the dy response: " ++ Jzon.DecodingError.toString(reason)))
            | Ok(data) => {
                if(data.ok === true) {
                    resolve(data)
                } else {
                    reject(ListEventsException(Js.Option.getWithDefault("Unknown JS error", data.error)))
                }
            }
            }
        }
    )
}

let listEventsPartial = listEvents(listEventsJS)

let handler = event => {
    Js.log2("event:", event)
    resolve(event)
}

if %raw(`require.main === module`) {
    let _ = listEventsPartial(Js.Json.parseExn(`{
        arguments: {
            timeRange: {
                start: 90,
                end: 400,
            },
            firstIndex: 0,
            afterToken: None
        }
    }`))
    ->then(
        result => {
            Js.log2("result:", result)
            resolve(true)
        }
    )
}