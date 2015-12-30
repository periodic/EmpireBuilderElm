module Test where

import Debug
import List
import String

type TestResult = Success
                | Failure String

type alias Test =
  { name : String
  , result : TestResult
  }

(?) : Bool -> String -> TestResult
(?) result msg =
  if result
     then Success
     else Failure msg

-- Let everything to the left group first.
infixl 0 ?

isSuccess : Test -> Bool
isSuccess test =
  case test.result of
    Success -> True
    Failure _ -> False

isFailure : Test -> Bool
isFailure test = not <| isSuccess test

runTests : List Test -> ()
runTests tests =
  let
      numSuccess = List.length <| List.filter isSuccess tests
      numFailures = List.length <| List.filter isFailure tests
      messages =
        List.filterMap (\test ->
          case test.result of
            Success -> Nothing
            Failure msg -> Just <| String.concat [test.name, ": ", msg])
          tests
      output = String.concat
          [ String.join "\n" messages
          , "\nPassed: "
          , toString numSuccess
          , "\nFailed: "
          , toString numFailures
          ]
  in
     Debug.log output ()
