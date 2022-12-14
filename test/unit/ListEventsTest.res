open Test
open ListEvents
open Promise
open Assertions

// test("should cool sync", () => {
//   pass(())
// })

let stubDynamo = (_, _, _, _) =>
	resolve(
		Jzon.encodeWith(
			{ 
				ListEvents.Codecs.items: [{ eventName: "Test", lastUpdated: 100, permission: Free, end: 200, primaryKey: "event", start: 100 }], 
				lastEvaluatedKey: None,
				hasNextPage: false,
				ok: true,
				error: None
			},
			ListEvents.Codecs.listEventsDynamoResponse
		)
	)

testAsync("should list some items", cb => {
	let stubEvent = Js.Json.parseExn(`
	{
		"arguments": {
			"timeRange": {
				"start": 90,
				"end": 400
			},
			"first": 1,
			"after": ""
		}
	}`)
	let _ = listEvents(stubDynamo, stubEvent)
	->then(
		json => {
			switch Jzon.decodeWith(json, Codecs.eventsResponse) {
			| Error(reason) => {
				Js.log2("error decoding:", reason)
				fail(~message="Failed decoding", ())
				cb(~planned=1, ())
				resolve(false)
			}
			| Ok(eventsResponse) => {
				switch Belt.Array.get(eventsResponse.events, 0) {
				| None => {
					fail(~message="Failed to find a first item", ())
					cb(~planned=1, ())
					resolve(false)
				}
				| Some(firstEvent) => {
					stringEqual(firstEvent.eventName, "Test")
					cb(~planned=1, ())
					resolve(true)
				}
			}
			}
			}
			
		}
	)
	->catch(
		error => {
			Js.log2("error:", error)
			fail(~message=`listEvents exception`, ())
			cb(~planned=1, ())
			resolve(false)
		}
	)
})
