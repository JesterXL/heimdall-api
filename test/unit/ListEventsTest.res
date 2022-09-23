open Test
open ListEvents
open Promise
open Assertions

// test("should cool sync", () => {
//   pass(())
// })

let stubDynamo = () => { () }


testAsync("should cool async", cb => {
  let _ = listEvents(stubDynamo, { start: 90, end: 400, firstIndex: 1, afterToken: None })
  ->then(
    events => {
      switch Belt.Array.get(events, 0) {
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
  )
  ->catch(
    _ => {
      fail(())
      cb(~planned=1, ())
      resolve(false)
    }
  )
  
})