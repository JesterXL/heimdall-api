open Promise

let handler = event => {
    Js.log2("auth lambda event:", event)
    resolve({ "isAuthorized": true })
}
