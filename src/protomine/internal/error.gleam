import datamine/common/version_number

pub type Error {
  UnknownArgument(String)
  InvalidVersionNumber(String)
  UnknownVersionNumber(version_number.VersionNumber)
}

pub fn to_string(error: Error) -> String {
  case error {
    UnknownArgument(argument) ->
      "Error: Unknown argument \"" <> argument <> "\""
    InvalidVersionNumber(string) ->
      "Error: \"" <> string <> "\" is not a valid version number"
    UnknownVersionNumber(version_number) ->
      "Error: \""
      <> version_number.to_string(version_number)
      <> "\" is an unknown version number"
  }
}
