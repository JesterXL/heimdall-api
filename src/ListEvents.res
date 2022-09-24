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
    firstIndex: int,
    afterToken: Js.Option.t<string>
}

module Codecs = {

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
        hasNextPage: bool,
        ok: bool,
        error: Js.Option.t<string>
    }

    let permissionToString = permission =>
        switch permission {
        | Free => "Free"
        | Blocked => "Blocked"
        | Request => "Request"
        }

    let event = Jzon.object6(
        ({ eventName, lastUpdated, permission, end, primaryKey, start }) => ( eventName, lastUpdated, permissionToString(permission), end, primaryKey, start ),
        (( eventName, lastUpdated, permissionString, end, primaryKey, start )) =>
            switch permissionString {
            | "Free" => { eventName, lastUpdated, permission: Free , end, primaryKey, start } -> Ok
            | "Blocked" => { eventName, lastUpdated, permission: Blocked , end, primaryKey, start } -> Ok
            | "Request" => { eventName, lastUpdated, permission: Request , end, primaryKey, start } -> Ok
            | x => Error(#UnexpectedJsonValue([Field("permission")], x))
            },
        Jzon.field("eventName", Jzon.string),
        Jzon.field("lastUpdated", Jzon.int),
        Jzon.field("permission", Jzon.string),
        Jzon.field("end", Jzon.int),
        Jzon.field("PK", Jzon.string),
        Jzon.field("start", Jzon.int)
    )

    let listEventsDynamoResponse = Jzon.object5(
        ({ items, lastEvaluatedKey, hasNextPage, ok, error }) => ( items, lastEvaluatedKey, hasNextPage, ok, error ),
        (( items, lastEvaluatedKey, hasNextPage, ok, error )) => { items, lastEvaluatedKey, hasNextPage, ok, error } -> Ok,
        Jzon.field("items", Jzon.array(event)),
        Jzon.field("lastEvaluatedKey", lastEvaluatedEvent)->Jzon.optional,
        Jzon.field("hasNextPage", Jzon.bool),
        Jzon.field("ok", Jzon.bool),
        Jzon.field("error", Jzon.string) -> Jzon.optional
    )

    type eventNode = {
        id: string,
        name: string,
        timeRange: timeRange,
        permission: permission
    }

    let eventNode = Jzon.object4(
        ({ id, name, timeRange, permission }) => ( id, name, timeRange, permissionToString(permission) ),
        (( id, name, timeRange, permissionString )) =>
            switch permissionString {
            | "Free" => { id, name, timeRange, permission: Free } -> Ok
            | "Blocked" => { id, name, timeRange, permission: Blocked } -> Ok
            | "Request" => { id, name, timeRange, permission: Request } -> Ok
            | x => Error(#UnexpectedJsonValue([Field("permission")], x))
            },
        Jzon.field("id", Jzon.string),
        Jzon.field("name", Jzon.string),
        Jzon.field("timeRange", timeRange),
        Jzon.field("permission", Jzon.string)
    )

    type eventsEdge = {
        node: eventNode,
        cursor: string
    }

    let eventsEdge = Jzon.object2(
        ({ node, cursor }) => ( node, cursor ),
        (( node, cursor )) => { node, cursor } -> Ok,
        Jzon.field("node", eventNode),
        Jzon.field("cursor", Jzon.string)
    )

    type pageInfo = {
        endCursor: string,
        hasNextPage: bool
    }

    let pageInfo = Jzon.object2(
        ({ endCursor, hasNextPage }) => ( endCursor, hasNextPage ),
        (( endCursor, hasNextPage )) => { endCursor, hasNextPage } -> Ok,
        Jzon.field("endCursor", Jzon.string),
        Jzon.field("hasNextPage", Jzon.bool)
    )

    type eventsResponse = {
        totalCount: int,
        edges: Js.Array.t<eventsEdge>,
        pageInfo: pageInfo
    }

    let eventsResponse = Jzon.object3(
        ({ totalCount, edges, pageInfo }) => ( totalCount, edges, pageInfo ),
        (( totalCount, edges, pageInfo )) => { totalCount, edges, pageInfo } -> Ok,
        Jzon.field("totalCount", Jzon.int),
        Jzon.field("edges", Jzon.array(eventsEdge)),
        Jzon.field("pageInfo", pageInfo) 
    )

    let mapEventToEventNode = (event:event) =>
    {
        id: event.primaryKey,
        name: event.eventName,
        timeRange: { start: event.start, end: event.end },
        permission: event.permission
    }

    let encodeLastEvaluatedEvent = lastEvaluatedEventMaybe =>
        switch lastEvaluatedEventMaybe {
        | None => ""
        | Some(event) => Jzon.encodeWith(event, lastEvaluatedEvent) -> Js.Json.stringify(_)
        }

    let mapEventNodeToEventsEdge = (eventNode:eventNode) =>
    {
        node: eventNode,
        cursor: {
            primaryKey: eventNode.id, 
            start: eventNode.timeRange.start, 
            end: eventNode.timeRange.end
        } -> Some -> encodeLastEvaluatedEvent
    }
        
}


@module("./services/query.js") external getTotalItemsJS: (()) => Promise.t<int> = "getTotalItems"

let getTotalItems = getTotalItemsFunc =>
    getTotalItemsFunc()

let getTotalItemsPartial = getTotalItems(getTotalItemsJS)


@module("./services/query.js") external listEventsJS: (int, int, int, string) => Promise.t<Js.Json.t> = "listEvents"

exception ListEventsException(string)

let getEndCursor = (data:Codecs.listEventsDynamoResponse) => {
    if(data.hasNextPage === true) {
        Codecs.encodeLastEvaluatedEvent(data.lastEvaluatedKey)
    } else {
        ""
    }
}
let listEvents = (listEventsFromDynamoFunc, getTotalItemsFunc, event) => {
    switch Jzon.decodeWith(event, Codecs.inputEvent) {
    | Error(reason) => reject(ListEventsException(Jzon.DecodingError.toString(reason)))
    | Ok(options) => resolve(options)
    }
    ->then(
        event =>
            Promise.all2((
                listEventsFromDynamoFunc(event.arguments.timeRange.start, event.arguments.timeRange.end, event.arguments.first, event.arguments.after),
                getTotalItems(getTotalItemsFunc)
            ))
    )
    ->then(
        (( listEventsResponse, totalItems )) => {
            Js.log2("listEvents response:", listEventsResponse)
            switch Jzon.decodeWith(listEventsResponse, Codecs.listEventsDynamoResponse) {
            | Error(reason) => reject(ListEventsException("listEvents failed to decode the dy response: " ++ Jzon.DecodingError.toString(reason)))
            | Ok(data) => {
                if(data.ok === true) {
                    resolve((data, totalItems))
                } else {
                    reject(ListEventsException(Js.Option.getWithDefault("Unknown JS error", data.error)))
                }
            }
            }
        }
    )
    ->then(
        (( data, totalItems )) => {
            let edges =
                Js.Array.map(Codecs.mapEventToEventNode, data.items)
                -> Js.Array.map(Codecs.mapEventNodeToEventsEdge, _)

            { 
                Codecs.totalCount: totalItems,
                edges: edges,
                pageInfo: {
                    endCursor: getEndCursor(data),
                    hasNextPage: data.hasNextPage
                }
            }
            -> Jzon.encodeWith(_, Codecs.eventsResponse)
            -> resolve
        }
    )
}

let listEventsPartial = listEvents(listEventsJS, getTotalItemsJS)

let handler = event => {
    Js.log2("event:", event)
    listEventsPartial(event)
    ->then(
        response => {
            Js.log2("response:", response)
            resolve(response)
        }
    )
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