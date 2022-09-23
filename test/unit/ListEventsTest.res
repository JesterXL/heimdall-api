open Test
open ListEvents
open Promise
open Assertions

// test("should cool sync", () => {
//   pass(())
// })

let stubDynamo = () => { () }


testAsync("should cool async", cb => {
  let _ = listEvents(stubDynamo, { start: 100, end: 100, timezone: "utc" }, 3, "token")
  ->then(
    events => {
      switch Belt.Array.get(events, 0) {
      | None => {
        fail(())
        cb(~planned=1, ())
        resolve(false)
      }
      | Some(firstEvent) => {
        stringEqual(firstEvent.eventName, "Tst")
        cb(~planned=1, ())
        resolve(true)
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