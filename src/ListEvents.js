// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Jzon = require("rescript-jzon/src/Jzon.js");
var Curry = require("@rescript/std/lib/js/curry.js");
var Js_option = require("@rescript/std/lib/js/js_option.js");
var Caml_exceptions = require("@rescript/std/lib/js/caml_exceptions.js");
var QueryJs = require("./services/query.js");

var timeRange = Jzon.object2((function (param) {
        return [
                param.start,
                param.end
              ];
      }), (function (param) {
        return {
                TAG: /* Ok */0,
                _0: {
                  start: param[0],
                  end: param[1]
                }
              };
      }), Jzon.field("start", Jzon.$$int), Jzon.field("end", Jzon.$$int));

var $$arguments = Jzon.object3((function (param) {
        return [
                param.timeRange,
                param.first,
                param.after
              ];
      }), (function (param) {
        return {
                TAG: /* Ok */0,
                _0: {
                  timeRange: param[0],
                  first: param[1],
                  after: param[2]
                }
              };
      }), Jzon.field("timeRange", timeRange), Jzon.field("first", Jzon.$$int), Jzon.field("after", Jzon.string));

var inputEvent = Jzon.object1((function (param) {
        return param.arguments;
      }), (function ($$arguments) {
        return {
                TAG: /* Ok */0,
                _0: {
                  arguments: $$arguments
                }
              };
      }), Jzon.field("arguments", $$arguments));

var lastEvaluatedEvent = Jzon.object3((function (param) {
        return [
                param.primaryKey,
                param.start,
                param.end
              ];
      }), (function (param) {
        return {
                TAG: /* Ok */0,
                _0: {
                  primaryKey: param[0],
                  start: param[1],
                  end: param[2]
                }
              };
      }), Jzon.field("PK", Jzon.string), Jzon.field("start", Jzon.$$int), Jzon.field("end", Jzon.$$int));

function permissionToString(permission) {
  switch (permission) {
    case /* Free */0 :
        return "free";
    case /* Blocked */1 :
        return "blocked";
    case /* Request */2 :
        return "request";
    
  }
}

var $$event = Jzon.object6((function (param) {
        return [
                param.eventName,
                param.lastUpdated,
                permissionToString(param.permission),
                param.end,
                param.primaryKey,
                param.start
              ];
      }), (function (param) {
        var start = param[5];
        var primaryKey = param[4];
        var end = param[3];
        var permissionString = param[2];
        var lastUpdated = param[1];
        var eventName = param[0];
        switch (permissionString) {
          case "blocked" :
              return {
                      TAG: /* Ok */0,
                      _0: {
                        eventName: eventName,
                        lastUpdated: lastUpdated,
                        permission: /* Blocked */1,
                        end: end,
                        primaryKey: primaryKey,
                        start: start
                      }
                    };
          case "free" :
              return {
                      TAG: /* Ok */0,
                      _0: {
                        eventName: eventName,
                        lastUpdated: lastUpdated,
                        permission: /* Free */0,
                        end: end,
                        primaryKey: primaryKey,
                        start: start
                      }
                    };
          case "request" :
              return {
                      TAG: /* Ok */0,
                      _0: {
                        eventName: eventName,
                        lastUpdated: lastUpdated,
                        permission: /* Request */2,
                        end: end,
                        primaryKey: primaryKey,
                        start: start
                      }
                    };
          default:
            return {
                    TAG: /* Error */1,
                    _0: {
                      NAME: "UnexpectedJsonValue",
                      VAL: [
                        [{
                            TAG: /* Field */0,
                            _0: "permission"
                          }],
                        permissionString
                      ]
                    }
                  };
        }
      }), Jzon.field("eventName", Jzon.string), Jzon.field("lastUpdated", Jzon.$$int), Jzon.field("permission", Jzon.string), Jzon.field("end", Jzon.$$int), Jzon.field("PK", Jzon.string), Jzon.field("start", Jzon.$$int));

var listEventsDynamoResponse = Jzon.object5((function (param) {
        return [
                param.items,
                param.lastEvaluatedKey,
                param.hasNextPage,
                param.ok,
                param.error
              ];
      }), (function (param) {
        return {
                TAG: /* Ok */0,
                _0: {
                  items: param[0],
                  lastEvaluatedKey: param[1],
                  hasNextPage: param[2],
                  ok: param[3],
                  error: param[4]
                }
              };
      }), Jzon.field("items", Jzon.array($$event)), Jzon.optional(Jzon.field("lastEvaluatedKey", lastEvaluatedEvent)), Jzon.field("hasNextPage", Jzon.bool), Jzon.field("ok", Jzon.bool), Jzon.optional(Jzon.field("error", Jzon.string)));

var eventNode = Jzon.object4((function (param) {
        return [
                param.id,
                param.name,
                param.timeRange,
                permissionToString(param.permission)
              ];
      }), (function (param) {
        var permissionString = param[3];
        var timeRange = param[2];
        var name = param[1];
        var id = param[0];
        switch (permissionString) {
          case "blocked" :
              return {
                      TAG: /* Ok */0,
                      _0: {
                        id: id,
                        name: name,
                        timeRange: timeRange,
                        permission: /* Blocked */1
                      }
                    };
          case "free" :
              return {
                      TAG: /* Ok */0,
                      _0: {
                        id: id,
                        name: name,
                        timeRange: timeRange,
                        permission: /* Free */0
                      }
                    };
          case "request" :
              return {
                      TAG: /* Ok */0,
                      _0: {
                        id: id,
                        name: name,
                        timeRange: timeRange,
                        permission: /* Request */2
                      }
                    };
          default:
            return {
                    TAG: /* Error */1,
                    _0: {
                      NAME: "UnexpectedJsonValue",
                      VAL: [
                        [{
                            TAG: /* Field */0,
                            _0: "permission"
                          }],
                        permissionString
                      ]
                    }
                  };
        }
      }), Jzon.field("id", Jzon.string), Jzon.field("name", Jzon.string), Jzon.field("timeRange", timeRange), Jzon.field("permission", Jzon.string));

var eventsEdge = Jzon.object2((function (param) {
        return [
                param.node,
                param.cursor
              ];
      }), (function (param) {
        return {
                TAG: /* Ok */0,
                _0: {
                  node: param[0],
                  cursor: param[1]
                }
              };
      }), Jzon.field("node", eventNode), Jzon.field("cursor", Jzon.string));

var pageInfo = Jzon.object2((function (param) {
        return [
                param.endCursor,
                param.hasNextPage
              ];
      }), (function (param) {
        return {
                TAG: /* Ok */0,
                _0: {
                  endCursor: param[0],
                  hasNextPage: param[1]
                }
              };
      }), Jzon.field("endCursor", Jzon.string), Jzon.field("hasNextPage", Jzon.bool));

var eventsResponse = Jzon.object3((function (param) {
        return [
                param.totalCount,
                param.edges,
                param.pageInfo
              ];
      }), (function (param) {
        return {
                TAG: /* Ok */0,
                _0: {
                  totalCount: param[0],
                  edges: param[1],
                  pageInfo: param[2]
                }
              };
      }), Jzon.field("totalCount", Jzon.$$int), Jzon.field("edges", Jzon.array(eventsEdge)), Jzon.field("pageInfo", pageInfo));

function mapEventToEventNode($$event) {
  return {
          id: $$event.primaryKey,
          name: $$event.eventName,
          timeRange: {
            start: $$event.start,
            end: $$event.end
          },
          permission: $$event.permission
        };
}

function encodeLastEvaluatedEvent(lastEvaluatedEventMaybe) {
  if (lastEvaluatedEventMaybe !== undefined) {
    return JSON.stringify(Jzon.encodeWith(lastEvaluatedEventMaybe, lastEvaluatedEvent));
  } else {
    return "";
  }
}

function mapEventNodeToEventsEdge(eventNode) {
  return {
          node: eventNode,
          cursor: encodeLastEvaluatedEvent({
                primaryKey: eventNode.id,
                start: eventNode.timeRange.start,
                end: eventNode.timeRange.end
              })
        };
}

var Codecs = {
  timeRange: timeRange,
  $$arguments: $$arguments,
  inputEvent: inputEvent,
  lastEvaluatedEvent: lastEvaluatedEvent,
  permissionToString: permissionToString,
  $$event: $$event,
  listEventsDynamoResponse: listEventsDynamoResponse,
  eventNode: eventNode,
  eventsEdge: eventsEdge,
  pageInfo: pageInfo,
  eventsResponse: eventsResponse,
  mapEventToEventNode: mapEventToEventNode,
  encodeLastEvaluatedEvent: encodeLastEvaluatedEvent,
  mapEventNodeToEventsEdge: mapEventNodeToEventsEdge
};

function getTotalItemsJS(prim) {
  return QueryJs.getTotalItems();
}

function getTotalItems(getTotalItemsFunc) {
  return Curry._1(getTotalItemsFunc, undefined);
}

var getTotalItemsPartial = QueryJs.getTotalItems();

function listEventsJS(prim0, prim1, prim2, prim3) {
  return QueryJs.listEvents(prim0, prim1, prim2, prim3);
}

var ListEventsException = /* @__PURE__ */Caml_exceptions.create("ListEvents.ListEventsException");

function getEndCursor(data) {
  if (data.hasNextPage === true) {
    return encodeLastEvaluatedEvent(data.lastEvaluatedKey);
  } else {
    return "";
  }
}

function listEvents(listEventsFromDynamoFunc, getTotalItemsFunc, $$event) {
  var reason = Jzon.decodeWith($$event, inputEvent);
  var tmp;
  tmp = reason.TAG === /* Ok */0 ? Promise.resolve(reason._0) : Promise.reject({
          RE_EXN_ID: ListEventsException,
          _1: Jzon.DecodingError.toString(reason._0)
        });
  return tmp.then(function ($$event) {
                  return Promise.all([
                              Curry._4(listEventsFromDynamoFunc, $$event.arguments.timeRange.start, $$event.arguments.timeRange.end, $$event.arguments.first, $$event.arguments.after),
                              Curry._1(getTotalItemsFunc, undefined)
                            ]);
                }).then(function (param) {
                var listEventsResponse = param[0];
                console.log("listEvents response:", listEventsResponse);
                var reason = Jzon.decodeWith(listEventsResponse, listEventsDynamoResponse);
                if (reason.TAG !== /* Ok */0) {
                  return Promise.reject({
                              RE_EXN_ID: ListEventsException,
                              _1: "listEvents failed to decode the dy response: " + Jzon.DecodingError.toString(reason._0)
                            });
                }
                var data = reason._0;
                if (data.ok === true) {
                  return Promise.resolve([
                              data,
                              param[1]
                            ]);
                } else {
                  return Promise.reject({
                              RE_EXN_ID: ListEventsException,
                              _1: Js_option.getWithDefault("Unknown JS error", data.error)
                            });
                }
              }).then(function (param) {
              var data = param[0];
              var __x = data.items.map(mapEventToEventNode);
              var edges = __x.map(mapEventNodeToEventsEdge);
              var __x_totalCount = param[1];
              var __x_pageInfo = {
                endCursor: getEndCursor(data),
                hasNextPage: data.hasNextPage
              };
              var __x$1 = {
                totalCount: __x_totalCount,
                edges: edges,
                pageInfo: __x_pageInfo
              };
              return Promise.resolve(Jzon.encodeWith(__x$1, eventsResponse));
            });
}

function listEventsPartial(param) {
  return listEvents(listEventsJS, getTotalItemsJS, param);
}

function handler($$event) {
  console.log("event:", $$event);
  listEvents(listEventsJS, getTotalItemsJS, $$event).then(function (response) {
        console.log("response:", response);
        return Promise.resolve(response);
      });
  
}

if ((require.main === module)) {
  listEvents(listEventsJS, getTotalItemsJS, JSON.parse("{\n        arguments: {\n            timeRange: {\n                start: 90,\n                end: 400,\n            },\n            firstIndex: 0,\n            afterToken: None\n        }\n    }")).then(function (result) {
        console.log("result:", result);
        return Promise.resolve(true);
      });
}

exports.Codecs = Codecs;
exports.getTotalItemsJS = getTotalItemsJS;
exports.getTotalItems = getTotalItems;
exports.getTotalItemsPartial = getTotalItemsPartial;
exports.listEventsJS = listEventsJS;
exports.ListEventsException = ListEventsException;
exports.getEndCursor = getEndCursor;
exports.listEvents = listEvents;
exports.listEventsPartial = listEventsPartial;
exports.handler = handler;
/* timeRange Not a pure module */
