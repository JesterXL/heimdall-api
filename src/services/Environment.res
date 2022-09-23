type environment
    = QA
    | Staging
    | Production

let environmentToString = environment =>
    switch environment {
    | QA => "qa"
    | Staging => "stage"
    | Production => "prod"
    }

let stringToEnvironment = str =>
    switch str {
    | "dev" => Some(QA)
    | "qa" => Some(QA)
    | "staging" => Some(Staging)
    | "prod" => Some(Production)
    | _ => None
    }

let getEnvironment = () =>
    switch Node.Process.process["env"] -> Js.Dict.get("NODE_ENV") {
    | None => QA
    | Some(envString) => switch envString {
        | "prod" => Production
        | "staging" => Staging
        | "qa" => QA
        | _ => QA
    }
    }

