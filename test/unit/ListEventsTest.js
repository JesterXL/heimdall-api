// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Test = require("rescript-test/src/Test.js");
var Curry = require("@rescript/std/lib/js/curry.js");
var $$Promise = require("@ryyppy/rescript-promise/src/Promise.js");
var Assertions = require("./services/Assertions.js");
var Belt_Array = require("@rescript/std/lib/js/belt_Array.js");
var ListEvents = require("../../src/ListEvents.js");

function stubDynamo(param) {
  
}

Test.testAsync("should cool async", undefined, (function (cb) {
        $$Promise.$$catch(ListEvents.listEvents(stubDynamo, {
                    start: 100,
                    end: 100,
                    timezone: "utc"
                  }, 3, "token").then(function (events) {
                  var firstEvent = Belt_Array.get(events, 0);
                  if (firstEvent !== undefined) {
                    Assertions.stringEqual(undefined, firstEvent.eventName, "Tst");
                    Curry._2(cb, 1, undefined);
                    return Promise.resolve(true);
                  } else {
                    Test.fail(undefined, undefined);
                    Curry._2(cb, 1, undefined);
                    return Promise.resolve(false);
                  }
                }), (function (param) {
                Test.fail(undefined, undefined);
                Curry._2(cb, 1, undefined);
                return Promise.resolve(false);
              }));
        
      }));

exports.stubDynamo = stubDynamo;
/*  Not a pure module */