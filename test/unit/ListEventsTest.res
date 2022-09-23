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
				ok: true,
				error: None
			},
			ListEvents.Codecs.listEventsDynamoResponse
		)
	)


testAsync("should cool async", cb => {
	let _ = listEvents(stubDynamo, { start: 90, end: 400, firstIndex: 1, afterToken: None })
	->then(
		result => {
			switch result {
			| Error(reason) => {
				fail(())
				cb(~planned=1, ())
				resolve(false)
			}
			| Ok({ items }) => {
				switch Belt.Array.get(items, 0) {
				| None => {
					fail(())
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
		_ => {
			fail(())
			cb(~planned=1, ())
			resolve(false)
		}
	)
	
})